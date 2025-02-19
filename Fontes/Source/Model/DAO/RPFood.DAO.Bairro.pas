unit RPFood.DAO.Bairro;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.SysUtils,
  System.Generics.Collections;

type
  TRPFoodDAOBairro = class(TRPFoodDAOBase<TRPFoodEntityBairro>)
  private
    procedure Select;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityBairro; override;
  public
    function Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityBairro>;
    function CarregaBairro(AidBairro: Integer): TRPFoodEntityBairro;
    function CarregaDescricaoBairro(ADescricao:string;AidEmpresa:Integer):TRPFoodEntityBairro;
  end;

implementation

{ TRPFoodDAOBairro }

function TRPFoodDAOBairro.CarregaBairro(AidBairro: Integer): TRPFoodEntityBairro;
var
  LDataSet:TDataSet;
begin
  Select;
  LDataSet := FQuery.SQL('where  bai_001 =:bairro')
    .SQL('order by bai_002')
    .ParamAsInteger('bairro',AidBairro)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOBairro.CarregaDescricaoBairro(ADescricao: string; AidEmpresa: Integer): TRPFoodEntityBairro;
var
  LDataSet:TDataSet;
begin
   Select;
  LDataSet := FQuery.SQL('where  bai_002 =:bairro and emp_001 =:idEmpresa and sit_001=4 and b_restricao_entrega=false  ')
    .ParamAsString('bairro',ADescricao)
    .ParamAsInteger('idEmpresa',AidEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOBairro.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityBairro;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityBairro.Create;
    try
      Result.IdEmpresa        := ADataSet.FieldByName('emp_001').AsInteger;
      Result.IdBairro         := ADataSet.FieldByName('bai_001').AsInteger;
      Result.Descricao        := ADataSet.FieldByName('bai_002').AsString;
      Result.taxa             := ADataSet.FieldByName('bai_003').AsCurrency;
      Result.Situacao         := ADataSet.FieldByName('sit_001').AsInteger;
      Result.RestricaoEntrega := ADataSet.FieldByName('b_restricao_entrega').AsBoolean;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOBairro.Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityBairro>;
var
  LDataSet: TDataSet;
begin
  Select;
  LDataSet := FQuery.SQL('where emp_001 = :idEmpresa and sit_001=4 and b_restricao_entrega=false ')
    .SQL('order by bai_001')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOBairro.Select;
begin
  FQuery.SQL('select bai_001, emp_001, bai_002,bai_003, sit_001,b_restricao_entrega from bairro');
end;

end.

