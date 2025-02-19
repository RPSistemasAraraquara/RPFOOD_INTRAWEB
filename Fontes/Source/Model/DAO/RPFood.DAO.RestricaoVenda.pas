unit RPFood.DAO.RestricaoVenda;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;
  type
    TRPFoodDAORestricaoVenda=class(TRPFoodDAOBase<TRPFoodEntityRestricaoVenda>)
    private
    procedure Select;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityRestricaoVenda; override;
  public
    function Buscar(AIdProduto: Integer): TRPFoodEntityRestricaoVenda;
  end;

implementation

{ TRPFoodDAORestricaoVenda }

function TRPFoodDAORestricaoVenda.Buscar(AIdProduto: Integer): TRPFoodEntityRestricaoVenda;
var
  LDataSet:TDataSet;
begin
  Select;
  LDataSet := Query.SQL('where idproduto = :idProduto and idEmpresa = :idEmpresa')
    .ParamAsInteger('idProduto', AIdProduto)
    .ParamAsInteger('idEmpresa', FIdEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAORestricaoVenda.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityRestricaoVenda;
begin
    Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityRestricaoVenda.Create;
    try
      Result.idProduto         := ADataSet.FieldByName('idProduto').AsInteger;
      Result.idEmpresa         := ADataSet.FieldByName('idEmpresa').AsInteger;
      Result.segundaFeira      := ADataSet.FieldByName('segundaFeira').AsBoolean;
      Result.tercaFeira        := ADataSet.FieldByName('tercaFeira').AsBoolean;
      Result.quartaFeira       := ADataSet.FieldByName('quartaFeira').AsBoolean;
      Result.quintaFeira       := ADataSet.FieldByName('quintaFeira').AsBoolean;
      Result.sextaFeira        := ADataSet.FieldByName('sextaFeira').AsBoolean;
      Result.sabado            := ADataSet.FieldByName('sabado').AsBoolean;
      Result.domingo           := ADataSet.FieldByName('domingo').AsBoolean;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAORestricaoVenda.Select;
begin
  Query.SQL('select idEmpresa, idProduto, segundaFeira, tercaFeira,')
    .SQL('quartaFeira, quintaFeira, sextaFeira, sabado, domingo    ')
    .SQL('from restricoesVendas                                    ');
end;

end.
