unit RPFood.DAO.Configuracao.PagamentoMercadoPago;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

  type
  TRPFoodDAOConfiguracaoPagamentoMercadoPago = class(TRPFoodDAOBase<TRPFoodEntityConfiguracaoPagamentoMercadoPago>)
  private
    procedure Select;
  protected
    function DataSetToEntity(ADataset:TDataSet):TRPFoodEntityConfiguracaoPagamentoMercadoPago;override;
  public
    function Buscar(AIdEmpresa:Integer):TRPFoodEntityConfiguracaoPagamentoMercadoPago;
  end;

implementation

{ TRPFoodDAOConfiguracaoPagamentoMercadoPago }

function TRPFoodDAOConfiguracaoPagamentoMercadoPago.Buscar(AIdEmpresa: Integer): TRPFoodEntityConfiguracaoPagamentoMercadoPago;
var
  LDataSet: TDataSet;
begin
  Select;
  Query.SQL(' where id_situacao=4 and  id_situacao =:id_situacao')
  .ParamAsInteger('id_situacao',AIdEmpresa);
  LDataSet:=Query.OpenDataSet;
  try
    Result:= DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOConfiguracaoPagamentoMercadoPago.DataSetToEntity(ADataset: TDataSet): TRPFoodEntityConfiguracaoPagamentoMercadoPago;
begin
  Result:=nil;
  if ADataset.RecordCount>0 then
  begin
    Result:=TRPFoodEntityConfiguracaoPagamentoMercadoPago.Create;
    try
      Result.Id             := ADataset.FieldByName('id').AsInteger;
      Result.AcessToken     := ADataset.FieldByName('acessToken').AsString;
      Result.Key            := ADataset.FieldByName('publicKey').AsString;
      Result.IdSituacao     := ADataset.FieldByName('id_situacao').AsInteger;
      Result.IdEmpresa      := ADataset.FieldByName('id_Empresa').AsInteger;

    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOConfiguracaoPagamentoMercadoPago.Select;
begin
  Query.SQL('select id, acessToken,publicKey, id_situacao, id_Empresa ')
    .SQL('from configuracaopagamentomercadopago');
end;

end.
