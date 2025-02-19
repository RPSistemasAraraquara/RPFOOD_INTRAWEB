unit RPFood.View.Pedido.Acompanhamento;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  RPFood.View.Padrao,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  System.Generics.Collections,
  RPFood.Entity.Classes;

type
  TFrmPedidoAcompanhamento = class(TFrmPadrao)
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);

  private
    FVenda: TRPFoodEntityVenda;

    procedure CarregarVenda;
    procedure OnRefreshVenda(AParams: TStrings; out AResult: string);
  public
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmPedidoAcompanhamento.CarregarVenda;
begin
 FreeAndNil(FVenda);
  if (FClienteLogado=nil) or (FClienteLogado.idCliente=0) then
    exit;
 FVenda := FController.DAO.VendaDAO.UltimaVenda(FClienteLogado.idCliente, FClienteLogado.idEmpresa);
end;

destructor TFrmPedidoAcompanhamento.Destroy;
begin
  FreeAndNil(FVenda);
  inherited;
end;

procedure TFrmPedidoAcompanhamento.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('OnRefreshVenda', OnRefreshVenda);
end;


procedure TFrmPedidoAcompanhamento.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  inherited;
  if AName = 'venda_taxa_entrega' then
    AValue := FormatCurr('R$0.00',FVenda.taxaEntrega)
  else
  if AName = 'venda_forma_pagamento' then
    AValue :=FVenda.formaPagamento.descricao;
end;

procedure TFrmPedidoAcompanhamento.OnRefreshVenda(AParams: TStrings; out AResult: string);
begin
  AResult := EmptyStr;
    CarregarVenda;
  if Assigned(FVenda) then
  AResult := ObjectToJSON(FVenda);
end;

initialization
  TFrmPedidoAcompanhamento.SetURL('', 'pedido-acompanhamento.html');

end.
