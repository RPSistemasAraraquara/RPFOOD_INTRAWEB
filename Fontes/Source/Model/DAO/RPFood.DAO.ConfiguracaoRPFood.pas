unit RPFood.DAO.ConfiguracaoRPFood;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  Data.DB,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOConfiguracaoRPFood =class (TRPFoodDAOBase<TRPFoodEntityConfiguracaoRPFood>)
  private
    procedure Select;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityConfiguracaoRPFood; override;
  public
    function Get(AIdEmpresa: Integer): TRPFoodEntityConfiguracaoRPFood;
  end;

implementation

{ TRPFoodDAOConfiguracaoRPFood }

function TRPFoodDAOConfiguracaoRPFood.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityConfiguracaoRPFood;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityConfiguracaoRPFood.Create;
    try
      Result.IdEmpresa                  := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.UtilizarCEP                := ADataSet.FieldByName('utiliza_controle_ceps').AsBoolean;
      Result.TempoRetiradaRPFood        := ADataSet.FieldByName('tempo_retirada_rpfood').AsInteger;
      Result.TempoEntregaRPFood         := ADataSet.FieldByName('tempo_entrega_rpfood').AsInteger;
      Result.PermiteRetiradanoLocal     := ADataSet.FieldByName('utiliza_tipo_entrega_retirada').AsBoolean;
      Result.modoacougue                := ADataSet.FieldByName('modo_acougue').AsBoolean;
      Result.pedidominimo               := ADataSet.FieldByName('pedido_minimo').AsCurrency;
      Result.utilizacontroleopcionais   := ADataSet.FieldByName('utiliza_controle_opcionais').AsBoolean;
      Result.IntegracaoMercadoPago      := ADataSet.FieldByName('integracaomercadopago').AsBoolean;
    except
      Result.Free;
      raise
    end;
  end;
end;

function TRPFoodDAOConfiguracaoRPFood.Get(AIdEmpresa: Integer): TRPFoodEntityConfiguracaoRPFood;
var
  LDataSet: TDataset;
begin
  Select;
  LDataSet := Query.SQL('where id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOConfiguracaoRPFood.Select;
begin
  Query.SQL('select id_empresa,                        ')
    .SQL('utiliza_controle_ceps, tempo_retirada_rpfood,')
    .SQL('tempo_entrega_rpfood,                        ')
    .SQL('utiliza_tipo_entrega_retirada,               ')
    .SQl('modo_acougue,pedido_minimo,                  ')
    .SQL('utiliza_controle_opcionais,                  ')
    .SQL('integracaomercadopago                        ')
    .SQL('from configuracao_rpfood                     ');
end;

end.

