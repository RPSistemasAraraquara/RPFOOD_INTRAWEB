unit RPFood.Service.Login.Cliente;

interface

uses
  RPFood.DAO.Factory,
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceLoginCliente = class
  private
    FDAO      : TRPFoodDAOFactory;
    FIdEmpresa: Integer;
    FLogin    : string;
    FSenha    : string;

    procedure ValidarHorarioFuncionamento;
  public
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceLoginCliente;
    function IdEmpresa(AValue: Integer): TRPFoodServiceLoginCliente;
    function Login(AValue: string): TRPFoodServiceLoginCliente;
    function Senha(AValue: string): TRPFoodServiceLoginCliente;
    function Entrar: TRPFoodEntityCliente;
  end;

implementation

{ TRPFoodServiceLoginCliente }

function TRPFoodServiceLoginCliente.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceLoginCliente;
begin
  Result := Self;
  FDAO := AValue;
end;

function TRPFoodServiceLoginCliente.Entrar: TRPFoodEntityCliente;
begin
  ValidarHorarioFuncionamento;
  Result := FDAO.ClienteDAO.Login(FLogin, FSenha);
  try
    if not Assigned(Result) then
      raise Exception.Create('Usuário e/ou senha inválidos.');

    Result.enderecos := FDAO.ClienteEnderecoDAO.Listar(FIdEmpresa, Result.idCliente);
  except
    Result.Free;
    raise;
  end;
end;

function TRPFoodServiceLoginCliente.IdEmpresa(AValue: Integer): TRPFoodServiceLoginCliente;
begin
  Result := Self;
  FIdEmpresa := AValue;
end;

function TRPFoodServiceLoginCliente.Login(AValue: string): TRPFoodServiceLoginCliente;
begin
  Result := Self;
  FLogin := AValue;
end;

function TRPFoodServiceLoginCliente.Senha(AValue: string): TRPFoodServiceLoginCliente;
begin
  Result := Self;
  FSenha := AValue;
end;

procedure TRPFoodServiceLoginCliente.ValidarHorarioFuncionamento;
begin
  if not FDAO.ConfiguracaoFuncionamento.EmHorarioDeFuncionamento then
    raise Exception.Create('Desculpe estamos fechado.');
end;

end.
