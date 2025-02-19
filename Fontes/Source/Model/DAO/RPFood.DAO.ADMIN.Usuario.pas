unit RPFood.DAO.ADMIN.Usuario;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Generics.Collections,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOADMINUsuario = class(TRPFoodDAOBase<TRPFoodEntityADMINUsuario>)
  private
    procedure SelectUsuario;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityADMINUsuario; override;
  public
    function Login(AEmail, ASenha: string): TRPFoodEntityADMINUsuario;
  end;

implementation

{ TRPFoodDAOADMINUsuario }

function TRPFoodDAOADMINUsuario.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityADMINUsuario;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityADMINUsuario.Create;
    try
      Result.codigo := ADataSet.FieldByName('codigo').AsInteger;
      Result.email  := ADataSet.FieldByName('email').AsString;
      Result.senha  := ADataSet.FieldByName('senha').AsString;
      Result.nome   := ADataSet.FieldByName('nome').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOADMINUsuario.Login(AEmail, ASenha: string): TRPFoodEntityADMINUsuario;
var
  LDataSet: TDataSet;
begin
  SelectUsuario;
  Query.SQL('where lower(email) = :email')
    .SQL('and senha = :senha')
    .SQL('and id_situacao=4 and b_acesso_web=true and b_admin_web=true')
    .ParamAsString('email', AEmail.ToLower)
    .ParamAsString('senha', ASenha);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOADMINUsuario.SelectUsuario;
begin
  Query.SQL('select usuarios.codigo, usuarios.nome, usuarios.email, usuarios.senha                           ')
    .SQL('from usuarios                                                                                      ')
    .SQL('left join usuarios_empresa on  usuarios_empresa.codigo_usuario=usuarios.codigo                     ')
    .SQL('left join usuarios_permissoes on usuarios_permissoes.codigo_usuario=usuarios_empresa.codigo_usuario');
end;

end.

