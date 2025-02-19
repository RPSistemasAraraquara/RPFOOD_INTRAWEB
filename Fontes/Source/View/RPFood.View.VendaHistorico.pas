unit RPFood.View.VendaHistorico;

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
  Data.DB,
  Vcl.Dialogs,
  RPFood.View.Padrao,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  RPFood.Entity.Classes,
  ServerController,
  System.DateUtils,
  System.Generics.Collections,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  RPFood.View.Rotas,
  IWControl,
  IWCompGrids,
  IWLayoutMgrHTML,
  IWCompEdit,
  IWCompLabel,
  SweetAlert4D.Interfaces,
  System.JSON;

type
  TFrmVendaHistorico = class(TFrmPadrao)
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
  private
    FIdVenda: Integer;
    procedure CarregarPedidos;
    procedure PedirNovamente(AParams: TStringList);
    procedure OnPedirNovamente(AParams: TStringList);
    procedure OnAfterPedirNovamente(AParams: TStringList);
  public
  end;

implementation

{$R *.dfm}

procedure TFrmVendaHistorico.CarregarPedidos;
var
  I: Integer;
  LVendas: TObjectList<TRPFoodEntityVenda>;
  LJsonVendas: string;
  LComando: string;
begin
   if (FClienteLogado = nil) or (FClienteLogado.idCliente = 0) then
      Exit;

  LVendas := FController.DAO.VendaDAO.Listar(FSessaoCliente.IdEmpresa, FClienteLogado.idCliente);
  try
    for I := 0 to Pred(LVendas.Count) do
      LVendas[I].itens := FController.DAO.VendaItemDAO.Listar(LVendas[I].id);

    LJsonVendas := FController.Components.JSON
      .ToJSONString<TRPFoodEntityVenda>(LVendas);
    LComando := Format('AdicionarVenda(%s)', [LJsonVendas]);
    ExecutaJavaScript(LComando);
  finally
    LVendas.Free;
  end;
end;

procedure TFrmVendaHistorico.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
 inherited;
  CarregarPedidos;
end;

procedure TFrmVendaHistorico.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('OnPedirNovamente', OnPedirNovamente);
  RegisterCallBack('PedirNovamente', PedirNovamente);
  RegisterCallBack('OnAfterPedirNovamente', OnAfterPedirNovamente);
end;

procedure TFrmVendaHistorico.OnAfterPedirNovamente(AParams: TStringList);
begin
  try
    FSessaoCliente.PedidoSessao.InicializarPedido;
    FSessaoCliente.PedidoSessao.Cliente(FClienteLogado);
    FController.Service.VendaCopiaService
      .IdVenda(FIdVenda)
      .Pedido(FSessaoCliente.PedidoSessao.Pedido)
      .Execute;
    FHoldOn.Close(True);
    WebApplication.GoToURL(ROTA_INDEX);
  except
    on E: Exception do
    begin
      FHoldOn.Close(True);
      MensagemErro('Erro ao copiar dados do pedido.', E.Message);
    end;
  end;
end;

procedure TFrmVendaHistorico.OnPedirNovamente(AParams: TStringList);
begin
  FHoldOn.Text('Confirmando Pedido...')
   .Callback('OnAfterPedirNovamente')
   .Show;
end;

procedure TFrmVendaHistorico.PedirNovamente(AParams: TStringList);
begin
  FIdVenda := AParams.Values['idVenda'].ToInteger;
  FSweetAlert
    .OnClickOK('ajaxCall(''OnPedirNovamente'')')
    .Arguments
      .Title('Pedir novamente?')
      .Text('Confirma repetir esse pedido?')
      .Icon(TSweetIcon.siQuestion)
      .Buttons
        .CancelButtonText('Não')
        .ShowCancelButton(True);

  FSweetAlert.Show;
end;

initialization
  TFrmVendaHistorico.SetURL('', 'venda-historico');
end.
