unit RPFood.DAO.VendaItem;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Data.DB;

type
  TRPFoodDAOVendaItem = class(TRPFoodDAOBase<TRPFoodEntityVendaItem>)
  private
    procedure SelectVendaItem;
    procedure CarregarOpcionais(AVendaItem: TRPFoodEntityVendaItem);
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaItem; override;
  public
    procedure Insert(AValue: TRPFoodEntityVendaItem);
    function Listar(AIdVenda: Integer; AListaOpcionais: Boolean = False): TObjectList<TRPFoodEntityVendaItem>;
    function BuscarUltimoItemfracionado(AidVenda:Integer):Integer;
  end;

implementation

{ TRPFoodDAOVendaItem }

uses
  RPFood.DAO.Factory;

function TRPFoodDAOVendaItem.BuscarUltimoItemfracionado(AidVenda:Integer):Integer;
var
  LDataSet: TDataSet;
begin
   Query.SQL('SELECT COALESCE(MAX(item_fracionado), 0) +1 AS item_fracionado   ')
     .SQL(' FROM vendaitem where id_venda =:id_venda and id_empresa =:id_empresa')
      .ParamAsInteger('id_venda', AIdVenda)
      .ParamAsInteger('id_empresa', FIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result :=LDataSet.FieldByName('item_fracionado').AsInteger;
  finally
    LDataSet.Free;

  end;
end;



procedure TRPFoodDAOVendaItem.CarregarOpcionais(AVendaItem: TRPFoodEntityVendaItem);
begin
  if Assigned(AVendaItem) then
    AVendaItem.opcionais := TRPFoodDAOFactory(FactoryDAO).VendaItemOpcionalDAO
      .Listar(AVendaItem.idVenda, AVendaItem.numeroItem);
end;




function TRPFoodDAOVendaItem.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaItem;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityVendaItem.Create;
    try
      Result.idVenda                    := ADataSet.FieldByName('id_venda').AsInteger;
      Result.idEmpresa                  := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.numeroItem                 := ADataSet.FieldByName('numero_item').AsInteger;
      Result.numeroItemFracionado       := ADataSet.FieldByName('item_fracionado').AsInteger;
      Result.valorUnitario              := ADataSet.FieldByName('valor_unit_product').AsCurrency;
      Result.valorTotalProduto          := ADataSet.FieldByName('totals_products').AsCurrency;
      Result.quantidade                 := ADataSet.FieldByName('quantidade').AsCurrency;
      Result.tamanho                    := ADataSet.FieldByName('tamanho').AsString;
      Result.vendaPorTamanho            := ADataSet.FieldByName('b_venda_tamanho').AsBoolean;
      Result.observacao                 := ADataSet.FieldByName('observacao').AsString;
      Result.UtilizaHappyHour           := ADataSet.FieldByName('utilizou_happy_hour').AsBoolean;
{$REGION 'PRODUTO'}
      Result.produto.codigo             := ADataSet.FieldByName('id_product').AsInteger;
      Result.produto.idEmpresa          := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.produto.descricao          := ADataSet.FieldByName('produto_descricao').AsString;
      Result.produto.idGrupo            := ADataSet.FieldByName('codigrupo').AsInteger;
      Result.produto.observacao         := ADataSet.FieldByName('produto_observacao').AsString;
      Result.produto.valFinal           := ADataSet.FieldByName('valFinal').AsCurrency;
      Result.produto.destaqueWeb        := ADataSet.FieldByName('b_destaque_web').AsBoolean;
      Result.produto.vendaPorTamanho    := ADataSet.FieldByName('b_venda_tamanho').AsBoolean;
      Result.produto.permiteFrac        := ADataSet.FieldByName('b_permite_frac').AsBoolean;
      Result.produto.valorTamanhoP      := ADataSet.FieldByName('valor_tam_p').AsCurrency;
      Result.produto.valorTamanhoM      := ADataSet.FieldByName('valor_tam_m').AsCurrency;
      Result.produto.valorTamanhoG      := ADataSet.FieldByName('valor_tam_g').AsCurrency;
      Result.produto.valorTamanhoGG     := ADataSet.FieldByName('valor_tam_gg').AsCurrency;
      Result.produto.valorTamanhoExtra  := ADataSet.FieldByName('valor_tam_extra').AsCurrency;
      Result.produto.tamanhoP           := ADataSet.FieldByName('tamanho_p').AsString;
      Result.produto.tamanhoM           := ADataSet.FieldByName('tamanho_m').AsString;
      Result.produto.tamanhoG           := ADataSet.FieldByName('tamanho_g').AsString;
      Result.produto.tamanhoGG          := ADataSet.FieldByName('tamanho_gg').AsString;
      Result.produto.tamanhoExtra       := ADataSet.FieldByName('tamanho_extra').AsString;
      Result.produto.tamanhoPadrao      := ADataSet.FieldByName('tamanho_padrao').AsString;
      Result.UtilizaHappyHour           := ADataSet.FieldByName('utilizou_happy_hour').AsBoolean;
{$ENDREGION}
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOVendaItem.Insert(AValue: TRPFoodEntityVendaItem);
begin
  StartTransaction;
  try
    Query.SQL('insert into vendaitem (                                                                      ')
      .SQL(' id_venda, id_empresa, id_product, numero_item,                                                 ')
      .SQL(' quantidade, valor_unit_product, totals_products,                                               ')
      .SQL(' id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao,utilizou_happy_hour )       ')
      .SQL('values (                                                                                        ')
      .SQL(' :id_venda, :id_empresa, :id_product, :numero_item,                                             ')
      .SQL(' :quantidade, :valor_unit_product, :totals_products,                                            ')
      .SQL(' :id_situacao, :tamanho, :b_venda_tamanho, :item_fracionado, :observacao,:utilizou_happy_hour ) ')
      .ParamAsInteger('id_venda', AValue.idVenda)
      .ParamAsInteger('id_empresa', AValue.idEmpresa)
      .ParamAsInteger('id_product', AValue.produto.codigo)
      .ParamAsInteger('numero_item', AValue.numeroItem)
      .ParamAsInteger('id_situacao', 4)
      .ParamAsCurrency('quantidade', AValue.quantidade)
      .ParamAsCurrency('valor_unit_product', AValue.valorUnitario)
      .ParamAsCurrency('totals_products', AValue.ValorTotal)
      .ParamAsString('tamanho', AValue.tamanho, True)
      .ParamAsBoolean('b_venda_tamanho', AValue.vendaPorTamanho)
      .ParamAsInteger('item_fracionado', AValue.numeroItemFracionado, True)
      .ParamAsString('observacao', AValue.observacao, True)
      .ParamAsBoolean('utilizou_happy_hour',AValue.UtilizaHappyHour)
      .ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TRPFoodDAOVendaItem.Listar(AIdVenda: Integer; AListaOpcionais: Boolean): TObjectList<TRPFoodEntityVendaItem>;
var
  LDataSet: TDataSet;
  LVendaItem: TRPFoodEntityVendaItem;
begin
  SelectVendaItem;
  Query.SQL('where vendaitem.id_venda = :idVenda')
       .SQL('order by vendaitem.numero_item')
    .ParamAsInteger('idVenda', AIdVenda);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
    for LVendaItem in Result do
      CarregarOpcionais(LVendaItem);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOVendaItem.SelectVendaItem;
begin
  Query.SQL('select vendaitem.id_venda, vendaitem.id_empresa,                                                     ')
    .SQL('  vendaitem.id_product, vendaitem.numero_item, vendaitem.quantidade,                                    ')
    .SQL('  vendaitem.valor_unit_product, vendaitem.totals_products,                                              ')
    .SQL('  vendaitem.id_situacao, vendaitem.tamanho, vendaitem.b_venda_tamanho,                                  ')
    .SQL('  vendaitem.item_fracionado, vendaitem.observacao,                                                      ')
    .SQL('  produtos.descricao as produto_descricao, produtos.observacao as produto_observacao, produtos.valfinal,')
    .SQL('  produtos.tamanho_p, produtos.tamanho_m, produtos.tamanho_g, produtos.codigrupo,                       ')
    .SQL('  produtos.tamanho_gg, produtos.tamanho_extra, produtos.tamanho_padrao,                                 ')
    .SQL('  produtos.valor_tam_p, produtos.valor_tam_m, produtos.valor_tam_g,                                     ')
    .SQL('  produtos.valor_tam_gg, produtos.valor_tam_extra, produtos.b_venda_tamanho,                            ')
    .SQL('  produtos.b_destaque_web, produtos.b_permite_frac, vendaitem.utilizou_happy_hour                       ')
    .SQL('  from vendaitem                                                                                        ')
    .SQL('  join produtos on vendaitem.id_product = produtos.codigo                                               ')
    .SQL('  and vendaitem.id_empresa = produtos.id_empresa                                                        ');
end;

end.

