unit RPFood.DAO.Empresa;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOEmpresa = class(TRPFoodDAOBase<TRPFoodEntityEmpresa>)
  private
    procedure SelectEmpresa;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityEmpresa; override;
  public
    function Buscar(AIdEmpresa: Integer): TRPFoodEntityEmpresa;
  end;

implementation

{ TRPFoodDAOEmpresa }

function TRPFoodDAOEmpresa.Buscar(AIdEmpresa: Integer): TRPFoodEntityEmpresa;
begin
  SelectEmpresa;
  Query.SQL('where id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .Open;

  Result := DataSetToEntity(Query.DataSet);
end;

function TRPFoodDAOEmpresa.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityEmpresa;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityEmpresa.Create;
    try
      Result.idEmpresa            := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.nome                 := ADataSet.FieldByName('nome').AsString;
      Result.razaoSocial          := ADataSet.FieldByName('razSoc').AsString;
      Result.cnpj                 := ADataSet.FieldByName('cnpj').AsString;
      Result.email                := ADataSet.FieldByName('email').AsString;
      Result.fone1                := ADataSet.FieldByName('fone1').AsString;
      Result.endereco.endereco    := ADataSet.FieldByName('endereco').AsString;
      Result.endereco.cep         := ADataSet.FieldByName('cep').AsString;
      Result.endereco.bairro      := ADataSet.FieldByName('bairro').AsString;
      Result.endereco.numero      := ADataSet.FieldByName('numero').AsString;
      Result.endereco.complemento := ADataSet.FieldByName('complemento').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOEmpresa.SelectEmpresa;
begin
  Query.SQL('select id_empresa, nome, razsoc, cnpj, uf, cidade, bairro,')
    .SQL('endereco, cep, numero, complemento, email, fone1             ')
    .SQL('from empresas                                                ');
end;

end.


