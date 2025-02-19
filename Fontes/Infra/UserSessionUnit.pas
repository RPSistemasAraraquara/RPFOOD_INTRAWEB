unit UserSessionUnit;

interface

uses
  IWUserSessionBase,
  Classes,
  IWAppForm,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Conexao,
  RPFood.Entity.Classes,
  UserSessionUnitADMIN,
  UserSessionUnitCliente;

type
  // Essa classe representa a sessão do usuário, para cada usuário
  // acessando o portal, terá uma instancia dessa classe.
  TIWUserSession = class(TIWUserSessionBase)
  private
    FConnection: IADRConnection;
    FSessaoCliente: TRPFoodViewSessionCliente;
    FSessaoADMIN: TRPFoodViewSessionADMIN;

    function GetSessaoCliente: TRPFoodViewSessionCliente;
    function GetSessaoADMIN: TRPFoodViewSessionADMIN;
    function GetIdEmpresa: Integer;
  public
    destructor Destroy; override;
    function Connection: IADRConnection;
    function EstaLogado: Boolean;
    function LogadoComoAdmin: Boolean;
    function LogadoComoCliente: Boolean;

    property IdEmpresa: Integer read GetIdEmpresa;
    property SessaoADMIN: TRPFoodViewSessionADMIN read GetSessaoADMIN;
    property SessaoCliente: TRPFoodViewSessionCliente read GetSessaoCliente;
  end;

implementation

{$R *.dfm}

{ TIWUserSession }

function TIWUserSession.Connection: IADRConnection;
begin
  if not Assigned(FConnection) then
    FConnection := GetConnection;
  Result := FConnection;
end;

destructor TIWUserSession.Destroy;
begin
  FreeAndNil(FSessaoADMIN);
  FreeAndNil(FSessaoCliente);
  inherited;
end;

function TIWUserSession.EstaLogado: Boolean;
begin
  Result := (LogadoComoAdmin) or (LogadoComoCliente);
end;

function TIWUserSession.GetIdEmpresa: Integer;
begin
  Result := 1;
end;

function TIWUserSession.GetSessaoADMIN: TRPFoodViewSessionADMIN;
begin
  if not Assigned(FSessaoADMIN) then
    FSessaoADMIN := TRPFoodViewSessionADMIN.Create;
  Result := FSessaoADMIN;
end;

function TIWUserSession.GetSessaoCliente: TRPFoodViewSessionCliente;
begin
  if not Assigned(FSessaoCliente) then
    FSessaoCliente := TRPFoodViewSessionCliente.Create;
  Result := FSessaoCliente;
end;

function TIWUserSession.LogadoComoAdmin: Boolean;
begin
  Result := (Assigned(FSessaoADMIN)) and
    (FSessaoADMIN.ADMINLogado <> nil)
end;

function TIWUserSession.LogadoComoCliente: Boolean;
begin
  Result := (Assigned(FSessaoCliente)) and
    (FSessaoCliente.ClienteLogado <> nil);
end;

end.
