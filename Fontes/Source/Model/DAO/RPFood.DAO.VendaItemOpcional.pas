unit RPFood.DAO.VendaItemOpcional;

interface

uses
  FireDAC.Stan.Param,
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  System.Generics.Collections,
  System.SysUtils,
  Data.DB;

type
  TRPFoodDAOVendaItemOpcional = class(TRPFoodDAOBase<TRPFoodEntityVendaItemOpcional>)
  private
    procedure SelectVendaItemOpcional;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaItemOpcional; override;
  public
    procedure Insert(AValue: TRPFoodEntityVendaItemOpcional);
    function Listar(AIdVenda, ANumeroItem: Integer): TObjectList<TRPFoodEntityVendaItemOpcional>;
  end;
implementation

{ TRPFoodDAOVendaItemOpcional }

function TRPFoodDAOVendaItemOpcional.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaItemOpcional;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityVendaItemOpcional.Create;
    try
      Result.idVenda            := ADataSet.FieldByName('id_venda').AsInteger;
      Result.idEmpresa          := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.idNumeroItem       := ADataSet.FieldByName('id_numero_item').AsInteger;
      Result.quantidade         := ADataSet.FieldByName('quantidade').AsInteger;
      Result.valorUnitario      := ADataSet.FieldByName('valorUnitario').AsCurrency;
      Result.valorTotal         := ADataSet.FieldByName('valorTotal').AsCurrency;
      Result.opcional.codigo    := ADataSet.FieldByName('id_opcional').AsInteger;
      Result.opcional.idEmpresa := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.opcional.descricao := ADataSet.FieldByName('opcional_descricao').AsString;
      Result.opcional.valor     := ADataSet.FieldByName('opcional_valor').AsCurrency;
      Result.quantidade_replicar:= ADataSet.FieldByName('quantidade_replicar').AsFloat;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOVendaItemOpcional.Insert(AValue: TRPFoodEntityVendaItemOpcional);
begin
  StartTransaction;
  try
    Query.SQL('insert into vendaitemopcional (                             ')
    .SQL(' id_venda, id_empresa, id_numero_item, id_opcional,              ')
    .SQL(' quantidade, quantidade_replicar, valorUnitario, valorTotal)     ')
    .SQL('values (                                                         ')
    .SQL(' :id_venda, :id_empresa, :id_numero_item, :id_opcional,          ')
    .SQL(' :quantidade, :quantidade_replicar, :valorUnitario, :valorTotal) ')
    .ParamAsInteger('id_venda', AValue.idVenda)
    .ParamAsInteger('id_empresa', AValue.idEmpresa)
    .ParamAsInteger('id_numero_item', AValue.idNumeroItem)
    .ParamAsInteger('id_opcional', AValue.opcional.codigo)
    .ParamAsCurrency('quantidade', AValue.quantidade)
    .ParamAsCurrency('quantidade_replicar', AValue.quantidade_replicar)
    .ParamAsCurrency('valorUnitario', AValue.valorUnitario)
    .ParamAsCurrency('valorTotal', AValue.ValorTotal)
    .ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TRPFoodDAOVendaItemOpcional.Listar(AIdVenda, ANumeroItem: Integer): TObjectList<TRPFoodEntityVendaItemOpcional>;
var
  LDataSet: TDataSet;
begin
  SelectVendaItemOpcional;
  Query.SQL('where vendaitemopcional.id_venda = :idVenda')
    .SQL('and vendaitemopcional.id_numero_item = :numeroItem')
    .ParamAsInteger('idVenda', AIdVenda)
    .ParamAsInteger('numeroItem', ANumeroItem);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOVendaItemOpcional.SelectVendaItemOpcional;
begin
  Query.SQL('select vendaitemopcional.id_venda, vendaitemopcional.id_empresa,                            ')
  .SQL('  vendaitemopcional.id_numero_item, vendaitemopcional.id_opcional, vendaitemopcional.quantidade, ')
  .SQL('  vendaitemopcional.valorUnitario, vendaitemopcional.valorTotal,                                 ')
  .SQL('  opcional.descricao as opcional_descricao, opcional.valor as opcional_valor,quantidade_replicar ')
  .SQL('  from vendaitemopcional                                                                         ')
  .SQL('  join opcional on vendaitemopcional.id_opcional = opcional.codigo                               ')
  .SQL('  and vendaitemopcional.id_empresa = opcional.id_empresa                                         ');
end;

end.


