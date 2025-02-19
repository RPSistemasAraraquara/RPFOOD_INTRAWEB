unit UserSessionUnitCliente;

interface

uses
  System.SysUtils,
  RPFood.Controller,
  RPFood.Entity.Classes,
  RPFood.View.Pedido.Sessao;

type
  TRPFoodViewSessionCliente = class
  private
    FController: TRPFoodController;
    FPedidoSessao: TRPFoodViewPedidoSessao;
    FEmpresa: TRPFoodEntityEmpresa;
    FClienteLogado: TRPFoodEntityCliente;
    FIdCategoria: Integer;
    function GetEmpresa: TRPFoodEntityEmpresa;
    function GetIdEmpresa: Integer;
    procedure SetClienteLogado(const AValue: TRPFoodEntityCliente);
  public
    constructor Create;
    destructor Destroy; override;

    function PedidoSessao: TRPFoodViewPedidoSessao;
    procedure RecarregarEnderecos;
    property ClienteLogado: TRPFoodEntityCliente read FClienteLogado write SetClienteLogado;
    property Empresa: TRPFoodEntityEmpresa read GetEmpresa;
    property IdEmpresa: Integer read GetIdEmpresa;
    property IdCategoria: Integer read FIdCategoria write FIdCategoria;
  end;

implementation

{ TRPFoodViewSessionCliente }

constructor TRPFoodViewSessionCliente.Create;
begin
  FController := TRPFoodController.Create;
end;

destructor TRPFoodViewSessionCliente.Destroy;
begin
  FreeAndNil(FController);
  FreeAndNil(FClienteLogado);
  FreeAndNil(FEmpresa);
  FreeAndNil(FPedidoSessao);
  inherited;
end;

function TRPFoodViewSessionCliente.GetEmpresa: TRPFoodEntityEmpresa;
begin
  if not Assigned(FEmpresa) then
    FEmpresa := FController.DAO.EmpresaDAO.Buscar(IdEmpresa);
  Result := FEmpresa;
end;

function TRPFoodViewSessionCliente.GetIdEmpresa: Integer;
begin
  Result := 1;
end;

function TRPFoodViewSessionCliente.PedidoSessao: TRPFoodViewPedidoSessao;
begin
  if not Assigned(FPedidoSessao) then
  begin
    FPedidoSessao := TRPFoodViewPedidoSessao.Create;
    FPedidoSessao.IdEmpresa(GetIdEmpresa).Cliente(FClienteLogado);
  end;
  Result := FPedidoSessao;
end;

procedure TRPFoodViewSessionCliente.RecarregarEnderecos;
begin
  FClienteLogado.enderecos := FController.DAO.ClienteEnderecoDAO
    .Listar(IdEmpresa, FClienteLogado.idCliente);
end;

procedure TRPFoodViewSessionCliente.SetClienteLogado(const AValue: TRPFoodEntityCliente);
begin
  FreeAndNil(FClienteLogado);
  FClienteLogado := AValue;
  if Assigned(FPedidoSessao) then
    FPedidoSessao.Cliente(AValue);
end;

end.
