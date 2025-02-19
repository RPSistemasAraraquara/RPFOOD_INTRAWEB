unit RPFood.Service.EsqueciMinhaSenha;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Components,
  RPFood.DAO.Factory,
  System.SysUtils;

type
  TRPFoodServiceEsqueciMinhaSenha = class
  private
    FEmail: string;
    FCliente: TRPFoodEntityCliente;
    FComponents: TRPFoodComponents;
    FDAO: TRPFoodDAOFactory;

    procedure CarregarCliente;
    procedure AlterarSenha;
    procedure EnviarEmail;
  public
    destructor Destroy; override;

    function Email(AValue: string): TRPFoodServiceEsqueciMinhaSenha;
    function Components(AValue: TRPFoodComponents): TRPFoodServiceEsqueciMinhaSenha;
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceEsqueciMinhaSenha;
    procedure Execute;
  end;


implementation

{ TRPFoodServiceEsqueciMinhaSenha }

procedure TRPFoodServiceEsqueciMinhaSenha.CarregarCliente;
begin
  FreeAndNil(FCliente);
  FCliente := FDAO.ClienteDAO.Busca(FEmail);
  if not Assigned(FCliente) then
    raise Exception.CreateFmt('Email %s não encontrado.', [FEmail]);
end;

function TRPFoodServiceEsqueciMinhaSenha.Components(AValue: TRPFoodComponents): TRPFoodServiceEsqueciMinhaSenha;
begin
  Result := Self;
  FComponents := AValue;
end;

function TRPFoodServiceEsqueciMinhaSenha.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceEsqueciMinhaSenha;
begin
  Result := Self;
  FDAO := AValue;
end;

destructor TRPFoodServiceEsqueciMinhaSenha.Destroy;
begin
  FreeAndNil(FCliente);
  inherited;
end;

function TRPFoodServiceEsqueciMinhaSenha.Email(AValue: string): TRPFoodServiceEsqueciMinhaSenha;
begin
  Result := Self;
  FEmail := AValue;
end;

procedure TRPFoodServiceEsqueciMinhaSenha.EnviarEmail;
var
  LTextoEmail: string;
begin
  try
    LTextoEmail              := Format('Sua nova senha foi gerada, utilize essa senha %s para acessar o RP Food.', [FCliente.senha]);
    FComponents.Mail.Subject := 'Alteração de Senha';
    FComponents.Mail.AddAddress(FCliente.email, FCliente.nome);
    FComponents.Mail.AltBody.Text := LTextoEmail;
    FComponents.Mail.Send;
  except
    on E: Exception do
    begin
      E.Message := 'Erro no envio do Email: ' + E.Message;
      raise;
    end;
  end;
end;

procedure TRPFoodServiceEsqueciMinhaSenha.Execute;
begin
  CarregarCliente;
  AlterarSenha;
  EnviarEmail;
end;

procedure TRPFoodServiceEsqueciMinhaSenha.AlterarSenha;
var
  LNovaSenha: string;
begin
  LNovaSenha := FormatDateTime('hhmmsszzz', Now);
  FCliente.senha := LNovaSenha;
  FDAO.ClienteDAO.Alterar(FCliente);
end;

end.
