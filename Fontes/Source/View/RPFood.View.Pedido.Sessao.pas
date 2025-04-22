unit RPFood.View.Pedido.Sessao;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Controller,
  RPFood.View.Rotas,
  IWApplication,
  System.Generics.Collections,
  System.SysUtils,
  System.Classes;

type
  TRPFoodViewPedidoSessao = class
  private
    FController       : TRPFoodController;
    FPedido           : TRPFoodEntityPedido;
    FIdEmpresa        : Integer;
    FCliente          : TRPFoodEntityCliente;
    FCategorias       : TObjectList<TRPFoodEntityCategoria>;
    FDestaques        : TObjectList<TRPFoodEntityProduto>;
    FFormasDePagamento: TObjectList<TRPFoodEntityFormaPagamento>;
    FProdutosTodos    : TObjectList<TRPFoodEntityProduto>;
    FBairro           : TRPFoodEntityBairro;
    procedure SetarDadosDoCliente;
  public
    constructor Create;
    destructor Destroy; override;
    function Pedido: TRPFoodEntityPedido;
    procedure InicializarPedido;

    function IdEmpresa(AValue: Integer): TRPFoodViewPedidoSessao;
    function Cliente(AValue: TRPFoodEntityCliente): TRPFoodViewPedidoSessao;
    function Categorias: TObjectList<TRPFoodEntityCategoria>;
    function FormasDePagamento: TObjectList<TRPFoodEntityFormaPagamento>;
    procedure AdicionarProduto(AIdProduto: Integer; AApp: TIWApplication);
    function TodosProdutos: TObjectList<TRPFoodEntityProduto>;
  end;

implementation

{ TRPFoodViewPedidoSessao }

uses
  RPFood.View.PedidoDetalheItem;

procedure TRPFoodViewPedidoSessao.AdicionarProduto(AIdProduto: Integer; AApp: TIWApplication);
var
  LProduto: TRPFoodEntityProduto;
  LForm: TFrmPedidoDetalheItem;
  LItemPedido: TRPFoodEntityPedidoItem;
begin
  LProduto := FController.DAO.ProdutoDAO.Buscar(FIdEmpresa, AIdProduto);
  try
    LItemPedido := TRPFoodEntityPedidoItem.Create;
    LItemPedido.produto := LProduto;
    // Pra adicionar o item no pedido apenas quando o usuario clicar em confirmar
    // na tela de detalheItem
    LItemPedido.ItemConfirmado(False);

    LForm := TFrmPedidoDetalheItem.Create(AApp);
    LForm.SetPedido(FPedido);
    LForm.SetItemPedido(LItemPedido);
    AApp.GoToURL(ROTA_PEDIDO_DETALHE_ITEM);
  finally
    LProduto.Free;
  end;
end;


function TRPFoodViewPedidoSessao.Categorias: TObjectList<TRPFoodEntityCategoria>;
var
  LCategoria: TRPFoodEntityCategoria;
  LProduto : TRPFoodEntityProduto;
begin
  if not Assigned(FCategorias) then
  begin
    FCategorias := FController.DAO.CategoriaDAO.Listar(FIdEmpresa);

    for LCategoria in FCategorias do
    try
      FController.Service.ImagemService
        .IdEmpresa(FIdEmpresa)
        .Objeto(LCategoria)
        .Carregar;
    except
    end;
  end;
  Result := FCategorias;
end;


function TRPFoodViewPedidoSessao.TodosProdutos: TObjectList<TRPFoodEntityProduto>;
var
  LProduto : TRPFoodEntityProduto;
begin
  if not Assigned(FProdutosTodos) then
  begin
    FDestaques := FController.DAO.ProdutoDAO.BuscarTodosProdutos(FIdEmpresa);
    for LProduto in FDestaques do
    try
      if not LProduto.restricao.DiaDeRestricao then
      begin
        FController.Service.ImagemService
          .IdEmpresa(FIdEmpresa)
          .Objeto(LProduto)
          .Carregar;
      end
    except
    end;
  end;
  Result := FDestaques;
end;

function TRPFoodViewPedidoSessao.Cliente(AValue: TRPFoodEntityCliente): TRPFoodViewPedidoSessao;
begin
  Result := Self;
  FCliente := AValue;
  SetarDadosDoCliente;
end;

constructor TRPFoodViewPedidoSessao.Create;
begin
  FController := TRPFoodController.Create;
end;

destructor TRPFoodViewPedidoSessao.Destroy;
begin
  FCategorias.Free;
  FController.Free;
  FDestaques.Free;
  FFormasDePagamento.Free;
  FPedido.Free;
  inherited;
end;

function TRPFoodViewPedidoSessao.FormasDePagamento: TObjectList<TRPFoodEntityFormaPagamento>;
begin
  if not Assigned(FFormasDePagamento) then
    FFormasDePagamento := FController.DAO.FormaPagamentoDAO.Listar(FIdEmpresa);
  Result := FFormasDePagamento;
end;

function TRPFoodViewPedidoSessao.IdEmpresa(AValue: Integer): TRPFoodViewPedidoSessao;
begin
  Result := Self;
  FIdEmpresa := AValue;
end;

procedure TRPFoodViewPedidoSessao.InicializarPedido;
begin
  FreeAndNil(FPedido);
  FPedido := TRPFoodEntityPedido.Create;
  FPedido.idEmpresa := FIdEmpresa;
  FPedido.data := Now;

  SetarDadosDoCliente;

  if FormasDePagamento.Count > 0 then
    FPedido.formaPagamento.Assign(FFormasDePagamento[0]);
end;

function TRPFoodViewPedidoSessao.Pedido: TRPFoodEntityPedido;
begin
  if not Assigned(FPedido) then
    InicializarPedido;
  Result := FPedido;
end;

procedure TRPFoodViewPedidoSessao.SetarDadosDoCliente;
begin
  if (Assigned(FCliente)) and (Assigned(FPedido)) then
  begin
    FPedido.cliente.Assign(FCliente);
    FBairro:=FController.DAO.BairroDAO.CarregaBairro(FCliente.enderecoPadrao.idBairro);
    try
      FPedido.endereco.Assign(FCliente.enderecoPadrao);
      FCliente.enderecoPadrao.taxaEntrega:=FBairro.taxa;
      FPedido.taxaEntrega                := FBairro.taxa;
    finally
     FBairro.Free;
    end;
  end;
end;

end.
