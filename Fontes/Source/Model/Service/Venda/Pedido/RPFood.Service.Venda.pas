unit RPFood.Service.Venda;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  RPFood.DAO.Factory,
  RPFood.Service.Venda.ItemFracao,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceVenda = class
  private
    FPedido     : TRPFoodEntityPedido;
    FVenda      : TRPFoodEntityVenda;
    FDAO        : TRPFoodDAOFactory;

    procedure SalvarVenda;
    procedure SalvarVendaEndereco;
    procedure SalvarVendaStatusLog;
    procedure SalvarItens;
    procedure SalvarItemFracionado(AItemPedido: TRPFoodEntityPedidoItem);
    procedure SalvarOpcional(AItem: TRPFoodEntityVendaItem; AItemPedido: TRPFoodEntityPedidoItem);
  public
    destructor Destroy; override;

    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVenda;
    function Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVenda;

    procedure Salvar;
  end;

implementation

{ TRPFoodServiceVenda }

function TRPFoodServiceVenda.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVenda;
begin
  Result := Self;
  FDAO := AValue;
end;

destructor TRPFoodServiceVenda.Destroy;
begin
  FVenda.Free;
  inherited;
end;

function TRPFoodServiceVenda.Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVenda;
begin
  Result := Self;
  FPedido := AValue;
end;

procedure TRPFoodServiceVenda.Salvar;
begin
  FDAO.StartTransaction;
  try
    SalvarVenda;
    SalvarVendaEndereco;
    SalvarVendaStatusLog;
    SalvarItens;
    FDAO.Commit;
  except
    FDAO.Rollback;
    raise;
  end;
end;

procedure TRPFoodServiceVenda.SalvarItemFracionado(AItemPedido: TRPFoodEntityPedidoItem);
var
  LServiceFracao: TRPFoodServiceVendaItemFracao;
begin
  LServiceFracao := TRPFoodServiceVendaItemFracao.Create;
  try
    LServiceFracao.DAO(FDAO)
      .Pedido(FPedido)
      .PedidoItem(AItemPedido)
      .Venda(FVenda);

    LServiceFracao.Salvar;
  finally
    LServiceFracao.Free;
  end;
end;

procedure TRPFoodServiceVenda.SalvarItens;
var
  LItem: TRPFoodEntityVendaItem;
  LPedidoItem: TRPFoodEntityPedidoItem;
  LDAO: TRPFoodDAOVendaItem;
begin
  for LPedidoItem in FPedido.itens do
  begin
    if LPedidoItem.fracoes.Count > 0 then
    begin
      SalvarItemFracionado(LPedidoItem);
      Continue;
    end;

    LItem := TRPFoodEntityVendaItem.Create;
    LItem.produto := TRPFoodEntityProduto.Create;
    LItem.produto.Assign(LPedidoItem.produto);

    FVenda.itens.Add(LItem);
    LItem.idVenda                := FVenda.id;
    LItem.idEmpresa              := FVenda.idEmpresa;
    LItem.produto                := LPedidoItem.produto;
    LItem.numeroItem             := FVenda.itens.Count;
    LPedidoItem.numeroItem       := LItem.numeroItem;
    LItem.quantidade             := LPedidoItem.quantidade;
    LItem.valorUnitario          := LPedidoItem.valorUnitario;
    LItem.valorTotalProduto      := LItem.quantidade * LItem.valorUnitario;
    LItem.tamanho                := LPedidoItem.tamanho;
    LItem.numeroItemFracionado   := 0;
    LItem.vendaPorTamanho        := LPedidoItem.produto.vendaPorTamanho;
    LItem.observacao             := LPedidoItem.observacao;
    LItem.UtilizaHappyHour       := LPedidoItem.produto.happyHourAtivar;
    if LItem.tamanho = EmptyStr then
      LItem.tamanho              := 'M';

    if LPedidoItem.fracoes.Count > 0 then
    begin
      LItem.numeroItemFracionado := LItem.numeroItem;
      LItem.quantidade           := LPedidoItem.QuantidadeFracaoPrincipal / 4;
      LItem.valorUnitario        := LItem.valorTotalProduto;
      LItem.valorTotalProduto    := LPedidoItem.valorUnitario * LItem.quantidade;
    end;

    LDAO := FDAO.VendaItemDAO;
    LDAO.ManagerTransaction(False); // Pra usar a mesma transação em andamento.
    LDAO.Insert(LItem);

    SalvarOpcional(LItem, LPedidoItem);
  end;
end;

procedure TRPFoodServiceVenda.SalvarOpcional(AItem: TRPFoodEntityVendaItem; AItemPedido: TRPFoodEntityPedidoItem);
var
  I: Integer;
  LOpcional: TRPFoodEntityVendaItemOpcional;
  LOpcionalDAO: TRPFoodDAOVendaItemOpcional;
begin
  for I := 0 to Pred(AItemPedido.opcionais.Count) do
  begin
    LOpcional                       := TRPFoodEntityVendaItemOpcional.Create;
    LOpcional.idVenda               := AItem.idVenda;
    LOpcional.idEmpresa             := AItem.idEmpresa;
    LOpcional.idNumeroItem          := AItem.numeroItem;

    LOpcional.opcional.Assign(AItemPedido.opcionais[I].opcional);
    LOpcional.valorUnitario         := AItemPedido.opcionais[I].valorUnitario;
    LOpcional.quantidade            := Round(AItemPedido.opcionais[I].quantidade * AItem.quantidade);
    LOpcional.quantidade_replicar   := Round(AItemPedido.opcionais[I].quantidade);
    LOpcional.ValorTotal            := AItemPedido.opcionais[I].ValorTotal;

    AItem.opcionais.Add(LOpcional);

    LOpcionalDAO := FDAO.VendaItemOpcionalDAO;
    LOpcionalDAO.ManagerTransaction(False);
    LOpcionalDAO.Insert(LOpcional);
  end;
end;

procedure TRPFoodServiceVenda.SalvarVenda;
var
  LVendaDAO: TRPFoodDAOVenda;
begin
  LVendaDAO := FDAO.VendaDAO;
  LVendaDAO.ManagerTransaction(False);

  FreeAndNil(FVenda);
  FVenda                     := TRPFoodEntityVenda.Create;
  FVenda.situacaoPedido      := spEnviado;
  FVenda.idEmpresa           := FPedido.idEmpresa;
  FVenda.data                := FPedido.data;
  FVenda.cliente             := FPedido.cliente;
  FVenda.taxaEntrega         := FPedido.taxaEntrega;
  FVenda.formaPagamento      := FPedido.formaPagamento;
  FVenda.valorTotalProdutos  := FPedido.ValorTotalProdutos;
  FVenda.valorTotal          := FPedido.ValorTotal;
  FVenda.valorTotalOpcionais := FPedido.ValorTotalOpcionais;
  FVenda.valorAReceber       := FPedido.valorAReceber;
  FVenda.observacao          := FPedido.observacao;
  FVenda.tipoEntrega         := FPedido.tipoEntrega;
  if (FVenda.valorAReceber > 0) and (FVenda.valorAReceber > FVenda.ValorTotal) then
    FVenda.troco := FVenda.valorAReceber - FVenda.ValorTotal;

  LVendaDAO.Insert(FVenda);
end;

procedure TRPFoodServiceVenda.SalvarVendaEndereco;
var
  LVendaEnderecoDAO: TRPFoodDAOVendaEndereco;
begin
 if FVenda.tipoEntrega = teDelivery then
  begin
    LVendaEnderecoDAO := FDAO.VendaEnderecoDAO;
    LVendaEnderecoDAO.ManagerTransaction(False);

    if FPedido.endereco is TRPFoodEntityClienteEndereco then
    begin
      FVenda.vendaEndereco.Assign(FPedido.endereco);
      FVenda.IDEndereco:= FPedido.endereco.idEndereco;
    end;
    LVendaEnderecoDAO.Salvar(FVenda);
  end;
end;

procedure TRPFoodServiceVenda.SalvarVendaStatusLog;
var
  LVendaLog: TRPFoodDAOVendaStatusLog;
begin
  LVendaLog := FDAO.VendaStatusLogDAO;
  LVendaLog.ManagerTransaction(False);
  LVendaLog.SalvarStatus(FVenda, spEnviado);
end;

end.
