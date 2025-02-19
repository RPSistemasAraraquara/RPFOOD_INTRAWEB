unit RPFood.DAO.Endereco;

interface

uses
  Data.DB,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Base,
  RPFood.Utils,
  RPFood.Entity.Classes;

type
  TRPFoodDAOEndereco = class(TRPFoodDAOBase<TRPFoodEntityEndereco>)
  private
    procedure SelectEndereco;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityEndereco; override;
  public
    function GetTaxaEntrega(ACep: string): Currency;
    function Busca(ACep: string): TRPFoodEntityEndereco;
    function BuscaBairro(AIdBairro:Integer):TRPFoodEntityEndereco;
  end;

implementation

{ TRPFoodDAOEndereco }

function TRPFoodDAOEndereco.Busca(ACep: string): TRPFoodEntityEndereco;
var utils:TUtils;
begin
  utils:=TUtils.Create;
  try
    SelectEndereco;
    ACep := utils.ApenasNumeros(ACep);
    Query.SQL('where bairro_ceps.cep = :cep and  bairro.sit_001=4')
    .ParamAsString('cep', ACep)
    .Open;

    Result := DataSetToEntity(Query.DataSet);
  finally
    utils.Free;
  end;

end;

function TRPFoodDAOEndereco.BuscaBairro( AIdBairro: Integer): TRPFoodEntityEndereco;
var
LDataSet: TDataSet;
begin
  Query.SQL('  select bai_001,bai_003,emp_001,bai_002  from bairro b            ')
    .SQL('     where bai_001=:bai_001 and sit_001=4                             ')
    .ParamAsInteger('bai_001',AIdBairro);
    LDataSet:=Query.OpenDataSet;

  try
    Result := DataSetToEntity(Query.DataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOEndereco.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityEndereco;
var
  Fieldcep: TField;
begin
  Result :=nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityEndereco.Create;
    try
      Fieldcep := ADataSet.FindField('cep');
      if Assigned(Fieldcep) then
        Result.cep := Fieldcep.AsString;

      Result.endereco     := ADataSet.FieldByName('logradouro').AsString;
      Result.idBairro     := ADataSet.FieldByName('bai_001').AsInteger;
      Result.bairro       := ADataSet.FieldByName('bai_002').AsString;
      Result.taxaEntrega  := ADataSet.FieldByName('bai_003').AsCurrency;
      Result.idCidade     := ADataSet.FieldByName('id_cidade').AsInteger;
      Result.UF           := ADataSet.FieldByName('uf_sigla').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;


function TRPFoodDAOEndereco.GetTaxaEntrega(ACep: string): Currency;
var
  LEndereco: TRPFoodEntityEndereco;
begin
  Result := 0;
  LEndereco := Busca(ACep);
  try
    if Assigned(LEndereco) then
      Result := LEndereco.taxaEntrega;
  finally
    LEndereco.Free;
  end;
end;

procedure TRPFoodDAOEndereco.SelectEndereco;
begin
  Query.SQL('select bairro_ceps.cep, bairro.bai_001, bairro.bai_002,       ')
  .SQL('  bairro.bai_003,bairro_ceps.logradouro,bairro_ceps.id_cidade,     ')
  .SQL('  bairro_ceps.uf_sigla                                             ')
  .SQL(' from bairro_ceps                                                  ')
  .SQL(' left join bairro on bairro.bai_001 = bairro_ceps.bai_001          ')
  .SQL(' and bairro.emp_001 = bairro_ceps.emp_001                          ');
end;

end.
