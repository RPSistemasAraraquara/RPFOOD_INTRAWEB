unit RPFood.DAO.VendaStatusLog;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  RPFood.DAO.Base;

type
  TRPFoodDAOVendaStatusLog = class(TRPFoodDAOBase<TRPFoodEntityVendaStatusLog>)
  private
    procedure SelectLog;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaStatusLog; override;
  public
    function Listar(AIdEmpresa, AIdVenda: Integer): TObjectList<TRPFoodEntityVendaStatusLog>;
    procedure SalvarStatus(AVenda: TRPFoodEntityVenda; ASituacao: TRPSituacaoPedido);
  end;

implementation

{ TRPFoodDAOVendaStatusLog }

function TRPFoodDAOVendaStatusLog.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaStatusLog;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityVendaStatusLog.Create;
    try
      Result.idVenda   := ADataSet.FieldByName('id_venda').AsInteger;
      Result.idEmpresa := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.data      := ADataSet.FieldByName('data').AsDateTime;
      Result.situacao.FromDBValue(ADataSet.FieldByName('id_situacao').AsInteger);
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOVendaStatusLog.Listar(AIdEmpresa, AIdVenda: Integer): TObjectList<TRPFoodEntityVendaStatusLog>;
var
  LDataSet: TDataSet;
begin
  SelectLog;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and id_venda = :idVenda         ')
    .SQL('order by data desc              ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idVenda', AIdVenda);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOVendaStatusLog.SalvarStatus(AVenda: TRPFoodEntityVenda; ASituacao: TRPSituacaoPedido);
begin
  StartTransaction;
  try
    Query.SQL('insert into vendas_status_log (')
      .SQL('  id_venda, id_empresa, id_situacao, data)')
      .SQL('values (')
      .SQL('  :id_venda, :id_empresa, :id_situacao, :data)')
      .ParamAsInteger('id_venda', AVenda.id)
      .ParamAsInteger('id_empresa', AVenda.idEmpresa)
      .ParamAsInteger('id_situacao', ASituacao.DBValue)
      .ParamAsDateTime('data', Now)
      .ExecSQL;

    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TRPFoodDAOVendaStatusLog.SelectLog;
begin
  Query.SQL('select id_venda, id_empresa, data, id_situacao')
    .SQL('from vendas_status_log');
end;

end.



