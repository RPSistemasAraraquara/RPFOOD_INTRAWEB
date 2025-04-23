unit RPFood.View.Pedido.Pagamento;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.DateUtils,
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
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompExtCtrls,
  IWCompButton,
  RPFood.Entity.Classes,
  IWCompEdit,
  Vcl.Imaging.pngimage,
  IWCompLabel,
  RPFood.View.Rotas, Vcl.ExtCtrls, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component;

type
  TStatusPagamento = (spAguardando, spAprovado, spExpirado, spCancelado);

  TFrmPedidoPagamentoOnline = class(TFrmPadrao)
    IWBTN_CONFIRMAR_TROCO: TIWButton;
    IWBTN_CANCELAR: TIWButton;
    IWCODIGOQRCODE: TIWEdit;
    IWQRCODEURL: TIWEdit;
    IWQRCODE: TIWImage;
    TmrAguardaPagamento: TIWTimer;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormShow(Sender: TObject);
    procedure TmrAguardaPagamentoAsyncTimer(Sender: TObject;
      EventParams: TStringList);
  private
    FStatus: TStatusPagamento;

    FQrCodeGerado: Boolean;
    FPedido: TRPFoodEntityPedido;
    FConfiguracaoRPFOOD: TRPFoodEntityConfiguracaoRPFood;
    FConfiguracaoPagamentoMercadoPago: TRPFoodEntityConfiguracaoPagamentoMercadoPago;
    LConfiguracaoFOOD: TRPFoodEntityConfiguracaoRPFood;
    procedure OnFinalizarPedido(AParams: TStringList);
    procedure OnAfterFinalizarPedido(AParams: TStringList);
    procedure VerificaMercadoPago;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmPedidoPagamentoOnline.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if not Assigned(FClienteLogado) then
  begin
    WebApplication.GoToURL(ROTA_LOGIN);
    Exit;
  end;

  FStatus := spAguardando;
  FQrCodeGerado := False;
  FPedido                             := FSessaoCliente.PedidoSessao.Pedido;
  FConfiguracaoRPFOOD                 := FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);
  FConfiguracaoPagamentoMercadoPago   := FController.DAO.ConfiguracaoPagamentoMercadoPagoDAO.Buscar(FSessaoCliente.IdEmpresa);
  LConfiguracaoFOOD                   :=FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);
  RegisterCallBack('OnAfterFinalizarPedido', OnAfterFinalizarPedido);
end;



procedure TFrmPedidoPagamentoOnline.VerificaMercadoPago;
var
  LQrCodeText, LUrlPagamento: string;
begin
  if FQrCodeGerado then
    Exit;

  if FConfiguracaoRPFOOD.IntegracaoMercadoPago then
  begin
    if FPedido.formaPagamento.UtilizaPIX then
    begin
      FController.Service.PagamentoService
        .ValorPedido(FPedido.valorTotal)
        .CarregarConfiguracoesMercadoPago(FPedido.cliente.nome,FPedido.cliente.email)
        .GerarQRCode(IWQRCODE)
        .LeQRCOdeDigitavel(LQrCodeText, LUrlPagamento);
        IWCODIGOQRCODE.Text:=LQrCodeText;
        IWQRCODEURL.Text:=LUrlPagamento;
      FQrCodeGerado := True;
      TmrAguardaPagamento.Enabled := True;
    end;
  end;
end;

procedure TFrmPedidoPagamentoOnline.IWAppFormShow(Sender: TObject);
begin
  inherited;
  IWQRCODE.RenderSize := True;
  IWQRCODE.AutoSize := False;
  VerificaMercadoPago;
end;

procedure TFrmPedidoPagamentoOnline.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
    inherited;
  if not Assigned(FClienteLogado) then
    Exit;

   if AName = 'VALOR_PEDIDO' then
    AValue := FormatCurr(',0.00', FPedido.ValorTotal);
end;

procedure TFrmPedidoPagamentoOnline.TmrAguardaPagamentoAsyncTimer(Sender: TObject;
  EventParams: TStringList);
var
  LStatusPagamento: string;
begin
  inherited;
  TmrAguardaPagamento.Enabled := False;
  try
    FController.Service.PagamentoService.ConsultarStatusPIX(LStatusPagamento);
    if LStatusPagamento.ToLower.Equals('aprovado') then
      FStatus := spAprovado;
  finally
    if FStatus = spAprovado then
      OnFinalizarPedido(nil)
    else
      TmrAguardaPagamento.Enabled := True;
  end;
end;

procedure TFrmPedidoPagamentoOnline.OnAfterFinalizarPedido(AParams: TStringList);
begin
  try
    Sleep(3000);
    FController.Service.VendaService.Pedido(FPedido).Salvar;
    FSessaoCliente.PedidoSessao.InicializarPedido;
    FPedido := FSessaoCliente.PedidoSessao.Pedido;
    FHoldOn.Close(True);
    WebApplication.GoToURL(ROTA_PEDIDO_ACOMPANHAMENTO);
  except
    on E: Exception do
    begin
      FHoldOn.Close(True);
      MensagemErro('Erro ao salvar venda', E.Message);
    end;
  end;
end;

procedure TFrmPedidoPagamentoOnline.OnFinalizarPedido(AParams: TStringList);
begin
    FHoldOn.Text('Confirmando Pedido...')
      .Callback('OnAfterFinalizarPedido')
      .Show;

end;


initialization
  TFrmPedidoPagamentoOnline.SetURL('', 'pedido-pagamento.html');

end.
