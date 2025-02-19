unit RPFood.DAO.Happy_Hour;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

  type
  TRPFoodDAOHappy_Hour = class(TRPFoodDAOBase<TRPFoodEntityHappy_Hour>)
  private
    procedure select;
  protected
   function DataSetToEntity(ADataSet:TDataSet):TRPFoodEntityHappy_Hour;override;
  public
    function VerificaHappyHour(AidProduto,AidEmpresa:Integer):TRPFoodEntityHappy_Hour;
    function Buscar(AidProduto,AidEmpresa:Integer):TRPFoodEntityHappy_Hour;
    function ValorHappyHour(Entity: TRPFoodEntityHappy_Hour): Currency;
  end;

implementation

{ TRPFoodDAOHappy_Hour }



function TRPFoodDAOHappy_Hour.ValorHappyHour(Entity: TRPFoodEntityHappy_Hour): Currency;
begin
  Result := Entity.valor;
end;

function TRPFoodDAOHappy_Hour.VerificaHappyHour( AIdProduto,AidEmpresa: Integer): TRPFoodEntityHappy_Hour;
var
LDataset:TDataSet;
begin
  select;
  LDataset   := Query.SQL('where')
    .SQL(' (CASE EXTRACT(DOW FROM CURRENT_DATE)     ')
		.SQL(' WHEN ''0'' THEN domingo                  ')
		.SQL(' WHEN ''1'' THEN segundaFeira             ')
		.SQL(' WHEN ''2'' THEN tercaFeira               ')
		.SQL(' WHEN ''3'' THEN quartaFeira              ')
		.SQL(' WHEN ''4'' THEN quintaFeira              ')
		.SQL(' WHEN ''5'' THEN sextaFeira               ')
		.SQL(' WHEN ''6'' THEN sabado                   ')
		.SQL(' END) = TRUE                              ')
		.SQL(' AND CURRENT_TIME >= horainicial          ')
		.SQL(' AND CURRENT_TIME <= horafinal            ')
		.SQL(' AND idproduto = :idProduto               ')
		.SQL(' AND idempresa = :idEmpresa               ')
    .ParamAsInteger('idProduto', AIdProduto)
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .OpenDataSet;
    try
      Result   :=DataSetToEntity(LDataset);
    finally
      LDataset.Free;
    end;
end;

function TRPFoodDAOHappy_Hour.Buscar(AidProduto,AidEmpresa: Integer): TRPFoodEntityHappy_Hour;
var
  LDataSet: TDataSet;
begin
  Select;
  LDataSet := Query.SQL('where idproduto = :idProduto and idEmpresa = :idEmpresa and utiliza_Delivery=true')
    .ParamAsInteger('idProduto', AIdProduto)
    .ParamAsInteger('idEmpresa', AidEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOHappy_Hour.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityHappy_Hour;
begin
  Result :=nil;
  if ADataSet.RecordCount>0 then
  begin
    Result   :=TRPFoodEntityHappy_Hour.Create;
    try
      Result.idproduto               := ADataSet.FieldByName('idproduto').AsInteger;
      Result.idempresa               := ADataSet.FieldByName('idempresa').AsInteger;
      Result.horainicial             := ADataSet.FieldByName('horainicial').AsDateTime;
      Result.horafinal               := ADataSet.FieldByName('horafinal').AsDateTime;
      Result.segundaFeira            := ADataSet.FieldByName('segundaFeira').AsBoolean;
      Result.tercaFeira              := ADataSet.FieldByName('tercaFeira').AsBoolean;
      Result.quartaFeira             := ADataSet.FieldByName('quartaFeira').AsBoolean;
      Result.quintaFeira             := ADataSet.FieldByName('quintaFeira').AsBoolean;
      Result.sextaFeira              := ADataSet.FieldByName('sextaFeira').AsBoolean;
      Result.sabado                  := ADataSet.FieldByName('sabado').AsBoolean;
      Result.domingo                 := ADataSet.FieldByName('domingo').AsBoolean;
      Result.valor                   := ADataSet.FieldByName('valor').AsCurrency;
      Result.utilizaDelivery         := ADataSet.FieldByName('utiliza_Delivery').AsBoolean;
    except
      Result.Free;
      raise
    end;
  end;
end;

procedure TRPFoodDAOHappy_Hour.select;
begin
  Query.SQL('SELECT idproduto, idempresa, horainicial, horafinal, segundafeira, tercafeira,       ')
    .SQL(' quartafeira, quintafeira, sextafeira, sabado, domingo, valor,utiliza_Delivery           ')
    .SQL('FROM happy_hour                                                                         ');
end;

end.
