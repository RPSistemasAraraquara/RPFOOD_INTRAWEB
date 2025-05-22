unit RPFood.Service;

interface

uses
  System.SysUtils,
  RPFood.Components,
  RPFood.DAO.Factory,
  RPFood.Service.Cliente,
  RPFood.Service.EsqueciMinhaSenha,
  RPFood.Service.Imagem,
  RPFood.Service.Login.Cliente,
  RPFood.Service.Venda,
  RPFood.Service.Venda.Copia,
  RPFood.Service.Pagamento;


type
  TRPFoodService = class
  private
    FComponents         : TRPFoodComponents;
    FDAO                : TRPFoodDAOFactory;
    FClienteService     : TRPFoodServiceCliente;
    FEsqueciMinhaSenha  : TRPFoodServiceEsqueciMinhaSenha;
    FImagemService      : TRPFoodServiceImagem;
    FLoginClienteService: TRPFoodServiceLoginCliente;
    FVendaService       : TRPFoodServiceVenda;
    FVendaCopiaService  : TRPFoodServiceVendaCopia;
    FPagamentoService   : TRPFoodServicePagamento;

  public
    destructor Destroy; override;
    function ClienteService                       : TRPFoodServiceCliente;
    function EsqueciMinhaSenha                    : TRPFoodServiceEsqueciMinhaSenha;
    function ImagemService                        : TRPFoodServiceImagem;
    function LoginClienteService                  : TRPFoodServiceLoginCliente;
    function VendaService                         : TRPFoodServiceVenda;
    function VendaCopiaService                    : TRPFoodServiceVendaCopia;
    function PagamentoService                     : TRPFoodServicePagamento;
    function Components(AValue: TRPFoodComponents): TRPFoodService;
    function DAO(AValue: TRPFoodDAOFactory)       : TRPFoodService;
  end;

implementation

{ TRPFoodService }

function TRPFoodService.ClienteService: TRPFoodServiceCliente;
begin
  if not Assigned(FClienteService) then
    FClienteService := TRPFoodServiceCliente.Create;
  Result := FClienteService;
  Result.DAO(FDAO);
end;

function TRPFoodService.Components(AValue: TRPFoodComponents): TRPFoodService;
begin
  Result      := Self;
  FComponents := AValue;
end;

function TRPFoodService.DAO(AValue: TRPFoodDAOFactory): TRPFoodService;
begin
  Result  := Self;
  FDAO    := AValue;
end;

destructor TRPFoodService.Destroy;
begin
  FreeAndNil(FClienteService);
  FreeAndNil(FEsqueciMinhaSenha);
  FreeAndNil(FImagemService);
  FreeAndNil(FLoginClienteService);
  FreeAndNil(FVendaService);
  FreeAndNil(FVendaCopiaService);
  FreeAndNil(FPagamentoService);
  inherited;
end;

function TRPFoodService.EsqueciMinhaSenha: TRPFoodServiceEsqueciMinhaSenha;
begin
  if not Assigned(FEsqueciMinhaSenha) then
    FEsqueciMinhaSenha := TRPFoodServiceEsqueciMinhaSenha.Create;
  FEsqueciMinhaSenha.Components(FComponents)
    .DAO(FDAO);
  Result := FEsqueciMinhaSenha;
end;

function TRPFoodService.ImagemService: TRPFoodServiceImagem;
begin
  if not Assigned(FImagemService) then
  begin
    FImagemService := TRPFoodServiceImagem.Create;
    FImagemService.DAO(FDAO);
  end;
  Result := FImagemService;
end;

function TRPFoodService.LoginClienteService: TRPFoodServiceLoginCliente;
begin
  if not Assigned(FLoginClienteService) then
  begin
    FLoginClienteService := TRPFoodServiceLoginCliente.Create;
    FLoginClienteService.DAO(FDAO);
  end;
  Result := FLoginClienteService;
end;

function TRPFoodService.PagamentoService: TRPFoodServicePagamento;
begin
  if not Assigned(FPagamentoService) then
  begin
    FPagamentoService:=TRPFoodServicePagamento.Create;
    FPagamentoService.DAO(FDAO);
  end;
  Result:=FPagamentoService;
end;

function TRPFoodService.VendaCopiaService: TRPFoodServiceVendaCopia;
begin
  if not Assigned(FVendaCopiaService) then
  begin
    FVendaCopiaService := TRPFoodServiceVendaCopia.Create;
    FVendaCopiaService.DAO(FDAO);
  end;
  Result := FVendaCopiaService;
end;

function TRPFoodService.VendaService: TRPFoodServiceVenda;
begin
  if not Assigned(FVendaService) then
  begin
    FVendaService := TRPFoodServiceVenda.Create;
    FVendaService.DAO(FDAO);
  end;
  Result := FVendaService;
end;

end.
