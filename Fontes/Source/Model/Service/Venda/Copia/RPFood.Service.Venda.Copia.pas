unit RPFood.Service.Venda.Copia;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  RPFood.DAO.Factory,
  RPFood.Service.Venda,
  System.Math,
  System.SysUtils;

type
  TRPFoodServiceVendaCopia = class
  private
    FDAO          : TRPFoodDAOFactory;
    FIdVenda      : Integer;
    FPedido       : TRPFoodEntityPedido;
    FVendaOrigem  : TRPFoodEntityVenda;

    procedure CarregarVendaOrigem;
    procedure CopiarDadosVenda;
    procedure CopiarItensDaVenda;
  public
    destructor Destroy; override;
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVendaCopia;
    function IdVenda(AValue: Integer): TRPFoodServiceVendaCopia;
    function Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVendaCopia;
    procedure Execute;
  end;

implementation

{ TRPFoodServiceVendaCopia }

procedure TRPFoodServiceVendaCopia.CarregarVendaOrigem;
begin
  FreeAndNil(FVendaOrigem);
  FVendaOrigem := FDAO.VendaDAO.Buscar(FPedido.idEmpresa, FIdVenda);
  if not Assigned(FVendaOrigem) then
    raise Exception.CreateFmt('Venda %d não encontrada.', [FIdVenda]);

  FVendaOrigem.itens := FDAO.VendaItemDAO.Listar(FIdVenda, True);
end;

procedure TRPFoodServiceVendaCopia.CopiarDadosVenda;
begin
  FPedido.idEmpresa := FVendaOrigem.idEmpresa;
  FPedido.tipoEntrega := FVendaOrigem.tipoEntrega;
  FPedido.taxaEntrega := FVendaOrigem.taxaEntrega;
  FPedido.observacao := FVendaOrigem.observacao;
  FPedido.valorAReceber := FVendaOrigem.valorAReceber;
  FPedido.formaPagamento.Assign(FVendaOrigem.formaPagamento);
end;

procedure TRPFoodServiceVendaCopia.CopiarItensDaVenda;
var
  LItemVenda  : TRPFoodEntityVendaItem;
  LItemPedido : TRPFoodEntityPedidoItem;
  LOpcional   : TRPFoodEntityVendaItemOpcional;
begin
  for LItemVenda in FVendaOrigem.itens do
  begin
    if not LItemVenda.isFracao then
    begin
      LItemPedido                       := TRPFoodEntityPedidoItem.Create;
      FPedido.itens.Add(LItemPedido);
      LItemPedido.idEmpresa             := FPedido.idEmpresa;
      LItemPedido.numeroItem            := LItemVenda.numeroItem;
      LItemPedido.numeroItemFracionado  := LItemVenda.numeroItemFracionado;
      LItemPedido.quantidade            := Trunc(LItemVenda.quantidade);
      LItemPedido.tamanho               := LItemVenda.tamanho;
      LItemPedido.vendaPorTamanho       := LItemVenda.vendaPorTamanho;
      LItemPedido.observacao            := LItemVenda.observacao;
      LItemPedido.produto.Assign(LItemVenda.produto);

      for LOpcional in LItemVenda.opcionais do
      begin
        LItemPedido.AddOpcional(LOpcional.opcional);
        LItemPedido.opcionais.Last.quantidade := LOpcional.quantidade;
      end;

      if LItemVenda.isFracionado then
        LItemPedido.quantidade := 1;
    end
    else
    begin
      // Fração
      LItemPedido := FPedido.itens.Last;
      LItemPedido.AddFracao(LItemVenda.produto);
    end;
  end;
end;

function TRPFoodServiceVendaCopia.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceVendaCopia;
begin
  Result := Self;
  FDAO := AValue;
end;

destructor TRPFoodServiceVendaCopia.Destroy;
begin
  FreeAndNil(FVendaOrigem);
  inherited;
end;

procedure TRPFoodServiceVendaCopia.Execute;
begin
  try
    CarregarVendaOrigem;
    CopiarDadosVenda;
    CopiarItensDaVenda;
  except
    on E: Exception do
    begin
      E.Message := 'Erro ao copiar pedido: ' + E.Message;
      raise;
    end;
  end;
end;

function TRPFoodServiceVendaCopia.IdVenda(AValue: Integer): TRPFoodServiceVendaCopia;
begin
  Result    := Self;
  FIdVenda  := AValue;
end;

function TRPFoodServiceVendaCopia.Pedido(AValue: TRPFoodEntityPedido): TRPFoodServiceVendaCopia;
begin
  Result  := Self;
  FPedido := AValue;
end;

end.
