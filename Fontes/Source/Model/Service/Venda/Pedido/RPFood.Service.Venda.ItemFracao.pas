unit RPFood.Service.Venda.ItemFracao;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  RPFood.DAO.Factory,
  System.SysUtils,
  System.Generics.Collections;

type
  TRPFoodServiceVendaItemFracao = class
  private
    FDAO                  : TRPFoodDAOFactory;
    FDAOVendaItem         : TRPFoodDAOVendaItem;
    FDAOVendaItem1         : TRPFoodDAOVendaItem;
    FDAOVendaItemOpcional : TRPFoodDAOVendaItemOpcional;
    FPedido               : TRPFoodEntityPedido;
    FPedidoItem           : TRPFoodEntityPedidoItem;
    FVenda                : TRPFoodEntityVenda;
    LUltimoItemFracionado : Integer;
    procedure SalvarOutrasFracoes(AItemPrincipal: TRPFoodEntityVendaItem);
    procedure SalvarOpcionais(AItemPrincipal: TRPFoodEntityVendaItem);
  public
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVendaItemFracao;
    function Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVendaItemFracao;
    function PedidoItem(AValue: TRPFoodEntityPedidoItem): TRPFoodServiceVendaItemFracao;
    function Venda(AValue: TRPFoodEntityVenda): TRPFoodServiceVendaItemFracao;
    procedure Salvar;
  end;

implementation

{ TRPFoodServiceVendaItemFracao }

function TRPFoodServiceVendaItemFracao.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVendaItemFracao;
begin
  Result                := Self;
  FDAO                  := AValue;
  FDAOVendaItem         := FDAO.VendaItemDAO;
  FDAOVendaItem1         := FDAO.VendaItemDAO;
  FDAOVendaItemOpcional := FDAO.VendaItemOpcionalDAO;
  FDAOVendaItem.ManagerTransaction(False);
  FDAOVendaItemOpcional.ManagerTransaction(False);
end;

function TRPFoodServiceVendaItemFracao.Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVendaItemFracao;
begin
  Result  := Self;
  FPedido := AValue;
end;

function TRPFoodServiceVendaItemFracao.PedidoItem(AValue: TRPFoodEntityPedidoItem): TRPFoodServiceVendaItemFracao;
begin
  Result := Self;
  FPedidoItem := AValue;
end;

procedure TRPFoodServiceVendaItemFracao.Salvar;
var
  I: Integer;
  LItemVenda: TRPFoodEntityVendaItem;

begin
  LUltimoItemFracionado:=FDAOVendaItem1.BuscarUltimoItemfracionado(FVenda.id);

  for I := 1 to FPedidoItem.quantidade do
  begin
    LItemVenda := TRPFoodEntityVendaItem.Create;
    FVenda.itens.Add(LItemVenda);
    LItemVenda.idVenda         := FVenda.id;
    LItemVenda.idEmpresa       := FVenda.idEmpresa;
    LItemVenda.produto         := FPedidoItem.produto;
    LItemVenda.numeroItem      := FVenda.itens.Count;
    FPedidoItem.numeroItem     := LItemVenda.numeroItem;
    LItemVenda.tamanho         := FPedidoItem.tamanho;
    LItemVenda.vendaPorTamanho := FPedidoItem.produto.vendaPorTamanho;
    LItemVenda.observacao      := FPedidoItem.observacao;
    if LItemVenda.tamanho = EmptyStr then
        LItemVenda.tamanho := 'M';


    LItemVenda.numeroItemFracionado := LUltimoItemFracionado;
    LItemVenda.quantidade        := 1 / (FPedidoItem.fracoes.Count + 1);
    LItemVenda.valorUnitario     := FPedidoItem.valorUnitario;
    LItemVenda.valorTotalProduto := FPedidoItem.valorUnitario * LItemVenda.quantidade;

    FDAOVendaItem.Insert(LItemVenda);
    SalvarOutrasFracoes(LItemVenda);
    SalvarOpcionais(LItemVenda);
  end;
end;

procedure TRPFoodServiceVendaItemFracao.SalvarOpcionais(AItemPrincipal: TRPFoodEntityVendaItem);
var
  I: Integer;
  LOpcional: TRPFoodEntityVendaItemOpcional;

begin
  for I := 0 to Pred(FPedidoItem.opcionais.Count) do
  begin
    LOpcional                    := TRPFoodEntityVendaItemOpcional.Create;
    LOpcional.idVenda            := AItemPrincipal.idVenda;
    LOpcional.idEmpresa          := AItemPrincipal.idEmpresa;
    LOpcional.idNumeroItem       := AItemPrincipal.numeroItem;

    LOpcional.opcional.Assign(FPedidoItem.opcionais[I].opcional);
    LOpcional.valorUnitario       := FPedidoItem.opcionais[I].valorUnitario;
    LOpcional.quantidade          := FPedidoItem.opcionais[I].quantidade;
    LOpcional.ValorTotal          := LOpcional.quantidade * LOpcional.valorUnitario;
    LOpcional.quantidade_replicar := LOpcional.quantidade;

    AItemPrincipal.opcionais.Add(LOpcional);
    FDAOVendaItemOpcional.Insert(LOpcional);
  end;
end;

procedure TRPFoodServiceVendaItemFracao.SalvarOutrasFracoes(AItemPrincipal: TRPFoodEntityVendaItem);
var
  LFracao: TRPFoodEntityPedidoItemFracao;
  LItem: TRPFoodEntityVendaItem;
begin
  for LFracao in FPedidoItem.fracoes do
  begin
    LItem := TRPFoodEntityVendaItem.Create;
    FVenda.itens.Add(LItem);
    LItem.idVenda              := FVenda.id;
    LItem.idEmpresa            := FVenda.idEmpresa;
    LItem.produto              := LFracao.produto;
    LItem.numeroItem           := FVenda.itens.Count;
    LItem.quantidade           := 1 / (FPedidoItem.fracoes.Count + 1);
    LItem.valorUnitario        := AItemPrincipal.valorUnitario;
    LItem.valorTotalProduto    := LItem.quantidade * LItem.valorUnitario;
    LItem.tamanho              := AItemPrincipal.tamanho;
    LItem.numeroItemFracionado := LUltimoItemFracionado; //AItemPrincipal.numeroItem;
    LItem.vendaPorTamanho      := FPedidoItem.produto.vendaPorTamanho;
    if LItem.tamanho = EmptyStr then
    begin
      LItem.vendaPorTamanho := False;
      LItem.tamanho := 'M';
    end;
    FDAOVendaItem.Insert(LItem);
  end;
end;

function TRPFoodServiceVendaItemFracao.Venda(AValue: TRPFoodEntityVenda): TRPFoodServiceVendaItemFracao;
begin
  Result := Self;
  FVenda := AValue;
end;

end.







