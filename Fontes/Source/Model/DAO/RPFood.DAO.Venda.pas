unit RPFood.DAO.Venda;

interface

uses
  FireDAC.Stan.Param,
  System.DateUtils,
  System.SysUtils,
  Data.DB,
  System.Generics.Collections,
  RPFood.DAO.Base,
  RPFood.Entity.Types,
  RPFood.Entity.Classes;

type
  TRPFoodDAOVenda = class(TRPFoodDAOBase<TRPFoodEntityVenda>)
  private
    procedure SelectVenda;
    procedure CarregaItens(AVenda: TRPFoodEntityVenda);
    procedure CarregaLogs(AVenda: TRPFoodEntityVenda);
  protected
    function ProximoId(AIdEmpresa: Integer): Integer;
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVenda; override;
  public
    procedure Insert(AVenda: TRPFoodEntityVenda);
    function Buscar(AIdEmpresa, AIdVenda: Integer): TRPFoodEntityVenda;
    function Listar(AIdCliente: Integer; ADataInicio, ADataFim: TDateTime): TObjectList<TRPFoodEntityVenda>; overload;
    function Listar(AIdCliente, AIdEmpresa: Integer): TObjectList<TRPFoodEntityVenda>; overload;
    function UltimaVenda(AIdCliente, AIdEmpresa: Integer): TRPFoodEntityVenda;
  end;

implementation

{ TRPFoodDAOVenda }

uses
  RPFood.DAO.Factory;

function TRPFoodDAOVenda.Buscar(AIdEmpresa, AIdVenda: Integer): TRPFoodEntityVenda;
var
  LDataSet: TDataSet;
begin
  SelectVenda;
  Query.SQL('where venda.id_venda = :idVenda')
    .SQL('and venda.id_empresa = :idEmpresa')
    .SQL('order by venda.data_pedido desc')
    .ParamAsInteger('idVenda', AIdVenda)
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOVenda.CarregaItens(AVenda: TRPFoodEntityVenda);
begin
  if Assigned(AVenda) then
    AVenda.itens := TRPFoodDAOFactory(FactoryDAO).VendaItemDAO
      .Listar(AVenda.id, True);
end;

procedure TRPFoodDAOVenda.CarregaLogs(AVenda: TRPFoodEntityVenda);
begin
  if Assigned(AVenda) then
    AVenda.listaStatus := TRPFoodDAOFactory(FactoryDAO).VendaStatusLogDAO
      .Listar(AVenda.idEmpresa, AVenda.id);
end;

function TRPFoodDAOVenda.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVenda;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityVenda.Create;
    try
      Result.id                            := ADataSet.FieldByName('id_venda').AsInteger;
      Result.idEmpresa                     := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.formaPagamento.id             := ADataSet.FieldByName('id_formapgto').AsInteger;
      Result.formaPagamento.descricao      := ADataSet.FieldByName('pagamento_descricao').AsString;
      Result.cliente.idCliente             := ADataSet.FieldByName('id_cliente').AsInteger;
      Result.data                          := ADataSet.FieldByName('data_pedido').AsDateTime;
      Result.taxaEntrega                   := ADataSet.FieldByName('taxa_entrega').AsCurrency;
      Result.valorAReceber                 := ADataSet.FieldByName('valor_receber').AsCurrency;
      Result.troco                         := ADataSet.FieldByName('troco').AsCurrency;
      Result.valorTotalProdutos            := ADataSet.FieldByName('totals_products').AsCurrency;
      Result.valorTotal                    := ADataSet.FieldByName('sales').AsCurrency;
      Result.valorTotalOpcionais           := ADataSet.FieldByName('sub_total').AsCurrency;
      Result.recebidoLeCheff               := ADataSet.FieldByName('b_recebido_lecheff').AsBoolean;
      Result.observacao                    := ADataSet.FieldByName('observacao').AsString;
      Result.tipoEntrega.FromDBValue(ADataSet.FieldByName('tipo_entrega').AsString);
      Result.situacaoPedido.FromDBValue(ADataSet.FieldByName('id_situacao').AsInteger);


{$REGION 'ENDERECO - ESTA CARREGANDO OS DADOS DO ENDERECO'}
      Result.vendaEndereco.taxaEntrega     := Result.taxaEntrega;
      Result.vendaEndereco.cep             := ADataSet.FieldByName('end_cep').AsString;
      Result.vendaEndereco.endereco        := ADataSet.FieldByName('end_logradouro').AsString;
      Result.vendaEndereco.idBairro        := ADataSet.FieldByName('end_id_bairro').AsInteger;
      Result.vendaEndereco.bairro          := ADataSet.FieldByName('end_bairro').AsString;
      Result.vendaEndereco.numero          := ADataSet.FieldByName('end_numero').AsString;
      Result.vendaEndereco.complemento     := ADataSet.FieldByName('end_complemento').AsString;
      Result.vendaEndereco.pontoReferencia := ADataSet.FieldByName('end_ponto_referencia').AsString;

{$ENDREGION}
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOVenda.Insert(AVenda: TRPFoodEntityVenda);
begin
  AVenda.id := ProximoId(AVenda.idEmpresa);
  StartTransaction;
  try
    Query.SQL('insert into venda (                                                    ')
      .SQL(' id_venda, id_empresa, id_situacao, id_formapgto, observacao,             ')
      .SQL(' id_cliente, totals_products, sub_total, taxa_entrega, tipo_entrega,      ')
      .SQL(' troco, valor_receber, sales, data_pedido, b_recebido_lecheff)            ')
      .SQL('values (                                                                  ')
      .SQL(' :id_venda, :id_empresa, :id_situacao, :id_formapgto, :observacao,        ')
      .SQL(' :id_cliente, :totals_products, :sub_total, :taxa_entrega, :tipo_entrega, ')
      .SQL(' :troco, :valor_receber, :sales, :data_pedido, :b_recebido_lecheff)       ')
      .ParamAsInteger('id_venda', AVenda.id)
      .ParamAsInteger('id_empresa', AVenda.idEmpresa)
      .ParamAsInteger('id_situacao', AVenda.situacaoPedido.DBValue)
      .ParamAsInteger('id_formapgto', AVenda.formaPagamento.id)
      .ParamAsString('observacao', AVenda.observacao, True)
      .ParamAsInteger('id_cliente', AVenda.cliente.idCliente)
      .ParamAsCurrency('sub_total', AVenda.valorTotalOpcionais)
      .ParamAsCurrency('totals_products', AVenda.valorTotalProdutos)
      .ParamAsCurrency('taxa_entrega', AVenda.taxaEntrega)
      .ParamAsString('tipo_entrega', AVenda.tipoEntrega.DBValue)
      .ParamAsCurrency('troco', AVenda.troco, True)
      .ParamAsCurrency('valor_receber', AVenda.valorAReceber, True)
      .ParamAsCurrency('sales', AVenda.ValorTotal)
      .ParamAsDateTime('data_pedido', AVenda.data)
      .ParamAsBoolean('b_recebido_lecheff',false)
      .ExecSQL;

    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TRPFoodDAOVenda.Listar(AIdCliente, AIdEmpresa: Integer): TObjectList<TRPFoodEntityVenda>;
var
  LDataSet: TDataSet;
begin
  SelectVenda;
  Query.SQL('where venda.id_cliente = :idCliente')
    .SQL('and venda.id_empresa = :idEmpresa     ')
    .SQL('order by venda.data_pedido desc       ')
    .ParamAsInteger('idCliente', AIdCliente)
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOVenda.Listar(AIdCliente: Integer; ADataInicio, ADataFim: TDateTime): TObjectList<TRPFoodEntityVenda>;
var
  LDataSet: TDataSet;
begin
  SelectVenda;
  Query.SQL('where venda.id_cliente = :idCliente                      ')
    .SQL('and venda.data_pedido::date between :dataInicio and :dataFim')
    .SQL('order by venda.data_pedido desc                             ')
    .ParamAsInteger('idCliente', AIdCliente)
    .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
    .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOVenda.ProximoId(AIdEmpresa: Integer): Integer;
begin
  Query.SQL('select (coalesce(max(id_venda),0) + 1) as proximoId ')
    .SQL('from venda where id_empresa = :idEmpresa               ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .Open;
  Result := Query.DataSet.FieldByName('proximoId').AsInteger;
end;

procedure TRPFoodDAOVenda.SelectVenda;
begin
  Query.SQL('select distinct(venda.id_venda), venda.id_empresa, venda.id_situacao,                             ')
    .SQL(' venda.id_formapgto, venda.observacao, venda.id_cliente, venda.totals_products,                      ')
    .SQL(' venda.sub_total, venda.taxa_entrega, venda.sales,                                                   ')
    .SQL(' venda.troco, venda.valor_receber, venda.data_pedido, venda.b_recebido_lecheff,                      ')
    .SQL(' venda.tipo_entrega, formapgto.descricao as pagamento_descricao,                                     ')
    .SQL(' venda_endereco.cep as end_cep, venda_endereco.logradouro as end_logradouro,                         ')
    .SQL(' venda_endereco.numero as end_numero, venda_endereco.complemento as end_complemento,                 ')
    .SQL(' venda_endereco.ponto_referencia as end_ponto_referencia, venda_endereco.id_bairro as end_id_bairro, ')
    .SQL(' bairro.bai_002 as end_bairro                                                                        ')
    .SQL('from venda                                                                                           ')
    .SQL('left join formapgto on venda.id_formapgto = formapgto.id and venda.id_empresa = formapgto.id_empresa ')
    .SQL('left join venda_endereco on venda.id_venda = venda_endereco.id_venda                                 ')
    .SQL('left join bairro on venda_endereco.id_bairro = bairro.bai_001                                        ');
end;

function TRPFoodDAOVenda.UltimaVenda(AIdCliente, AIdEmpresa: Integer): TRPFoodEntityVenda;
var
  LDataSet: TDataSet;
begin
  SelectVenda;
  Query.SQL('where venda.id_cliente = :idCliente')
    .SQL('and venda.id_empresa = :idEmpresa')
    .SQL('order by venda.data_pedido desc limit 1')
    .ParamAsInteger('idCliente', AIdCliente)
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
    try
      CarregaItens(Result);
      CarregaLogs(Result);
    except
      Result.Free;
      raise;
    end;
  finally
    LDataSet.Free;
  end;
end;

end.





