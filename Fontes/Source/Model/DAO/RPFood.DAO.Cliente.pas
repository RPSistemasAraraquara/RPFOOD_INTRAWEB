unit RPFood.DAO.Cliente;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.SysUtils;

type
  TRPFoodDAOCliente = class(TRPFoodDAOBase<TRPFoodEntityCliente>)
  private
    procedure SelectCliente;
    procedure CarregarDadosEndereco(ACliente: TRPFoodEntityCliente);
    procedure ValidarEmail(ACliente: TRPFoodEntityCliente);
    function ProximoId(AIdEmpresa: Integer): Integer;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityCliente; override;
  public
    procedure Gravar(ACliente: TRPFoodEntityCliente);
    procedure Alterar(ACliente: TRPFoodEntityCliente);
    procedure Inserir(ACliente: TRPFoodEntityCliente);
    function Login(AEmail, ASenha: string): TRPFoodEntityCliente;
    function Busca(AEmail: string): TRPFoodEntityCliente; overload;
  end;

implementation

{ TRPFoodDAOCliente }

uses
  RPFood.DAO.Factory;

procedure TRPFoodDAOCliente.Alterar(ACliente: TRPFoodEntityCliente);
begin
  ValidarEmail(ACliente);
   StartTransaction;
  try
    Query.SQL('update clientes set                                                ')
      .SQL(' cli_002 = :cli_002,                                                  ')
      .SQL(' sit_001 = :sit_001,                                                  ')
      .SQL(' senha_email = :senha_email, email = :email,                          ')
      .SQL(' tipo_pessoa = :tipo_pessoa, celular1 = :celular1, cli_012 = :cli_012 ')
      .SQL('where cli_001 = :cli_001                                              ')
      .SQL('and id_empresa = :id_empresa                                          ')
      .ParamAsInteger('cli_001', ACliente.idCliente)
      .ParamAsInteger('id_empresa', ACliente.idEmpresa)
      .ParamAsInteger('sit_001', 4)
      .ParamAsString('cli_002', ACliente.nome)
      .ParamAsString('email', ACliente.email)
      .ParamAsString('senha_email', ACliente.senha)
      .ParamAsString('celular1', ACliente.celular, True)
      .ParamAsString('cli_012', ACliente.telefone, True)
      .ParamAsString('tipo_pessoa', 'F')
      .ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TRPFoodDAOCliente.Busca(AEmail: string): TRPFoodEntityCliente;
var
  LDataSet: TDataSet;
begin
  SelectCliente;
  Query.SQL('where id_empresa = 1 and lower(email) = :email')
    .ParamAsString('email', AEmail.ToLower);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOCliente.CarregarDadosEndereco(ACliente: TRPFoodEntityCliente);
begin
  if (Assigned(ACliente)) then
  begin
    ACliente.enderecos := TRPFoodDAOFactory(FactoryDAO).ClienteEnderecoDAO
      .Listar(ACliente.idEmpresa, ACliente.idCliente);
  end;
end;

function TRPFoodDAOCliente.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityCliente;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityCliente.Create;
    try
      Result.idEmpresa                := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.idCliente                := ADataSet.FieldByName('cli_001').AsInteger;
      Result.nome                     := ADataSet.FieldByName('cli_002').AsString;
      Result.email                    := ADataSet.FieldByName('email').AsString;
      Result.senha                    := ADataSet.FieldByName('senha_email').AsString;
      Result.celular                  := ADataSet.FieldByName('celular1').AsString;
      Result.telefone                 := ADataSet.FieldByName('cli_012').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOCliente.Gravar(ACliente: TRPFoodEntityCliente);
begin
  if ACliente.idCliente = 0 then
    Inserir(ACliente)
  else
    Alterar(ACliente);
end;


procedure TRPFoodDAOCliente.Inserir(ACliente: TRPFoodEntityCliente);
begin
  ValidarEmail(ACliente);
  ACliente.idCliente := ProximoId(ACliente.idEmpresa);
  StartTransaction;
  try
    Query.SQL('insert into clientes                                   ')
      .SQL(' ( cli_001, id_empresa, cli_002,  sit_001,                ')
      .SQL(' senha_email, email, tipo_pessoa, celular1, cli_012 )     ')
      .SQL('values (                                                  ')
      .SQL(' :cli_001, :id_empresa, :cli_002, :sit_001,               ')
      .SQL(' :senha_email, :email, :tipo_pessoa, :celular1, :cli_012 )')
      .ParamAsInteger('cli_001', ACliente.idCliente)
      .ParamAsInteger('id_empresa', ACliente.idEmpresa)
      .ParamAsString('cli_002', ACliente.nome)
      .ParamAsInteger('sit_001', 4)
      .ParamAsString('senha_email', ACliente.senha)
      .ParamAsString('email', ACliente.email)
      .ParamAsString('tipo_pessoa', 'F')
      .ParamAsString('celular1', ACliente.celular)
      .ParamAsString('cli_012', ACliente.telefone, True)  ;
    Query.ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;
end;



function TRPFoodDAOCliente.Login(AEmail, ASenha: string): TRPFoodEntityCliente;
var
  LDataSet: TDataSet;
begin
  SelectCliente;
  Query.SQL('where id_empresa = 1 and lower(email) = :email')
    .SQL('and senha_email = :senha')
    .ParamAsString('email', AEmail.ToLower)
    .ParamAsString('senha', ASenha);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
    CarregarDadosEndereco(Result);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOCliente.ProximoId(AIdEmpresa: Integer): Integer;
begin
  Query.SQL('select (coalesce(max(cli_001),0) + 1) as proximoId ')
    .SQL('from clientes where id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .Open;
  Result := Query.DataSet.FieldByName('proximoId').AsInteger;
end;

procedure TRPFoodDAOCliente.SelectCliente;
begin
  Query.SQL('select id_empresa, cli_001, cli_002,          ')
    .SQL(' email, senha_email,  celular1, cli_012          ')
    .SQL('from clientes');
end;



procedure TRPFoodDAOCliente.ValidarEmail(ACliente: TRPFoodEntityCliente);
var
  LCliente: TRPFoodEntityCliente;
begin
  LCliente := Busca(ACliente.email);
  try
    if (Assigned(LCliente)) and (LCliente.idCliente <> ACliente.idCliente) then
      raise Exception.CreateFmt('Email %s já cadastrado.', [ACliente.email]);
  finally
    LCliente.Free;
  end;
end;

end.




