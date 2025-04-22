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
  RPFood.View.Rotas;

type
  TFrmPedidoPagamentoOnline = class(TFrmPadrao)
    IWBTN_CONFIRMAR_TROCO: TIWButton;
    IWBTN_CANCELAR: TIWButton;
    IWCODIGOQRCODE: TIWEdit;
    IWQRCODEURL: TIWEdit;
    IWQRCODE: TIWImage;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageUnloaded(Sender: TObject;EventParams: TStringList; AIsCurrent: Boolean);
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormShow(Sender: TObject);
  private
   FPedido                          : TRPFoodEntityPedido;
    FConfiguracaoRPFOOD              : TRPFoodEntityConfiguracaoRPFood;
    FConfiguracaoPagamentoMercadoPago: TRPFoodEntityConfiguracaoPagamentoMercadoPago;
    LConfiguracaoFOOD                : TRPFoodEntityConfiguracaoRPFood;
    procedure OnFinalizarPedido(AParams: TStringList);
    procedure OnAfterFinalizarPedido(AParams: TStringList);
    procedure AguardandoPagamento;
    procedure VerificaMercadoPago;
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

procedure TFrmPedidoPagamentoOnline.AguardandoPagamento;
const
  TEMPO_MAXIMO_SEGUNDOS = 300;
  INTERVALO_CONSULTA_MS = 3000;
var
  StartTime: TDateTime;
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      LStatusPagamento: string;
    begin
      StartTime := Now;

      while SecondsBetween(Now, StartTime) < TEMPO_MAXIMO_SEGUNDOS do
      begin
          FController.Service.PagamentoService.ConsultarStatusPIX(LStatusPagamento);

        if LStatusPagamento = 'Aprovado' then
        begin
          TThread.Synchronize(nil,
            procedure
            var
              Params: TStringList;
            begin
              Params := TStringList.Create;
              try
                OnFinalizarPedido(Params);
              finally
                Params.Free;
              end;
            end);
          Exit;
        end;

        Sleep(INTERVALO_CONSULTA_MS);
      end;

      TThread.Synchronize(nil,
        procedure
        begin
          ShowMessage('Tempo de espera esgotado. Pagamento Expirado em 5 minutos.');
        end);
    end).Start;
end;



procedure TFrmPedidoPagamentoOnline.IWAppFormAsyncPageUnloaded( Sender: TObject; EventParams: TStringList; AIsCurrent: Boolean);
begin
//
end;

procedure TFrmPedidoPagamentoOnline.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if not Assigned(FClienteLogado) then
  begin
    WebApplication.GoToURL(ROTA_LOGIN);
    Exit;
  end;

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
   if FConfiguracaoRPFOOD.IntegracaoMercadoPago then
  begin
    if FPedido.formaPagamento.UtilizaPIX then
    begin
      FController.Service.PagamentoService
        .ValorPedido(FPedido.valorTotal)
        .CarregarConfiguracoesMercadoPago(FPedido.cliente.nome,FPedido.cliente.email)
        .GerarQRCode(IWQRCODE)
        .LeQRCOdeDigitavel(LQrCodeText,LUrlPagamento);
        IWCODIGOQRCODE.Text:=LQrCodeText;
        IWQRCODEURL.Text:=LUrlPagamento;
       // AguardandoPagamento;
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
var
  LEmFuncionamento: Boolean;
begin
 if (LConfiguracaoFOOD.pedidoMinimo > 0) and
     ((FPedido.valorTotal - FPedido.taxaEntrega) < LConfiguracaoFOOD.pedidoMinimo) then
  begin
    MensagemErro('Opa, houve um erro',  Format('Pedido mínimo não atingido. Valor mínimo: %f', [LConfiguracaoFOOD.pedidoMinimo]));
    Exit;
  end;

  LEmFuncionamento := FController.DAO.ConfiguracaoFuncionamento.EmHorarioDeFuncionamento;
  if not LEmFuncionamento then
    FHoldOn.Text('ixee estamos fechado agora...')
      .Callback('OnCancelarPedido')
      .Show
  else
    FHoldOn.Text('Confirmando Pedido...')
      .Callback('OnAfterFinalizarPedido')
      .Show;

end;


initialization
  TFrmPedidoPagamentoOnline.SetURL('', 'pedido-pagamento.html');

end.
