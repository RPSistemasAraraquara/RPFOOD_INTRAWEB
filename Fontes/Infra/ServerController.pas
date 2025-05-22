unit ServerController;

interface

uses
  SysUtils,
  Classes,
  IWServerControllerBase,
  IWBaseForm,
  HTTPApp,
  UserSessionUnit,
  IWApplication,
  IWAppForm,
  IW.Browser.Browser,
  IW.HTTP.Request,
  IW.HTTP.Reply,
  RPFood.View.Rotas,
  RPFood.Resources, IWException,
  IWExceptionRenderer,
  IW.Content.Base;

type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);
    procedure IWServerControllerBaseConfig(Sender: TObject);
    procedure IWServerControllerBaseBeforeRender(ASession: TIWApplication; AForm: TIWBaseForm; var ANewForm: TIWBaseForm);
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure IWServerControllerBaseAfterDispatch(Request: THttpRequest; aReply: THttpReply);
    procedure IWServerControllerBaseSessionRestarted(aSession: TIWApplication);
    procedure IWServerControllerBaseAuthFailed(aReply: THttpReply; aSession: TIWApplication);
  private
    procedure RedirecionarPaginaInicial(AFormAtual: TIWBaseForm);
    procedure RedirecionarRota(AFormAtual: TIWBaseForm; ARotaDestino: string);
  end;

  TIWExceptionRendererEx = class(TIWExceptionRenderer)
  public
    class function RenderHTML(AException: Exception; ARequest: THttpRequest): string; override;
  end;

  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;

implementation

{$R *.dfm}

uses
  IWInit,
  IWGlobal,
  IWTypes,
  IW.Content.Handlers,
  IW.Content.Redirect,
  IW.Content.Form,
  RPFood.View.Erro404,
  RPFood.View.Erro500,
  RPFood.View.ADMIN.Login,
  RPFood.View.ADMIN.Index,
  RPFood.View.ADMIN.Index2,
  RPFood.View.Login,
  RPFood.View.ClienteCadastro,
  RPFood.View.ClienteDados,
  RPFood.View.ClienteEndereco,
  RPFood.View.EsqueciMinhaSenha,
  RPFood.View.Index,
  RPFood.View.Pedido.Acompanhamento,
  RPFood.View.PedidoDetalheItem,
  RPFood.View.Pedido.Finalizar,
  RPFood.View.ProdutosPorCategoria,
  RPFood.View.VendaHistorico,
  RPFood.View.VendaHistoricoAdm,
  RPFood.View.ProdutosTodasCategoria,
  RPFood.View.Sobre,
  RPFood.View.NovoEndereco,
  RPFood.View.BuscarEndereco,
  RPFood.View.Pedido.Pagamento,
  Winapi.Windows;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
begin
  Self.Port := APP_RESOURCES.PORT;
  Self.DisplayName := APP_RESOURCES.SERVICE_TITLE;
  Self.Description := APP_RESOURCES.SERVICE_DESCRIPTION;
end;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

{ TIWServerController }

procedure TIWServerController.IWServerControllerBaseAfterDispatch(Request: THttpRequest;
  aReply: THttpReply);
begin
  if aReply.Code = 404 then
  begin
    aReply.ResetReplyType;
    aReply.SendRedirect(ROTA_ERROR_404);
  end;
end;

procedure TIWServerController.IWServerControllerBaseAuthFailed(aReply: THttpReply; aSession: TIWApplication);
begin
  WebApplication.TerminateAndRedirect(ROTA_LOGIN);
end;

procedure TIWServerController.IWServerControllerBaseBeforeRender(ASession: TIWApplication;
  AForm: TIWBaseForm; var ANewForm: TIWBaseForm);
var
  LUrl: string;
  LUrlBase: string;
  LTentandoAcessarAdmin: Boolean;
  LTentandoAcessarCliente: Boolean;
  LTentandoLoginOuCadastro: Boolean;
begin
  inherited;

  LUrlBase := ASession.SessionUrlBase.ToLower;
  LUrl := ASession.MappedURL.ToLower;
  LUrl := LUrl.Replace(LUrlBase, EmptyStr);
  if LUrl.IsEmpty then
    Exit;
  if not LUrl.StartsWith('/') then
    LUrl := '/' + LUrl;

  LTentandoAcessarAdmin := LUrl.StartsWith('/admin.html');
  LTentandoAcessarCliente := not LTentandoAcessarAdmin;
  LTentandoLoginOuCadastro := (LUrl.StartsWith('/admin/login.html')) or
    (LUrl.StartsWith('/login.html')) or (LUrl.StartsWith('/cliente-cadastro.html')) or
    (LUrl.StartsWith('/esqueci-minha-senha.html'));

  if (not LTentandoLoginOuCadastro) and (not UserSession.EstaLogado) then
  begin
    if LTentandoAcessarAdmin then
      RedirecionarRota(AForm, ROTA_ADMIN_LOGIN);
  end;

  if LTentandoLoginOuCadastro and UserSession.EstaLogado then
    RedirecionarPaginaInicial(AForm);

  if LTentandoAcessarAdmin and UserSession.LogadoComoCliente then
    RedirecionarRota(AForm, ROTA_INDEX)
  else
  if LTentandoAcessarCliente and UserSession.LogadoComoAdmin then
    RedirecionarRota(AForm, ROTA_ADMIN_INDEX)
end;

procedure TIWServerController.IWServerControllerBaseConfig(Sender: TObject);
begin
{$IFNDEF APACHE}
  Self.URLBase := '/';
{$ENDIF}

  IWExceptionRenderer.SetExceptionRendererClass(TIWExceptionRendererEx);
  THandlers.Add(ROTA_ADMIN_LOGIN, TContentForm.Create(TFrmADMINLogin));
  THandlers.Add(ROTA_ADMIN_INDEX, TContentForm.Create(TFrmADMINIndex));
  THandlers.Add(ROTA_ADMIN_INDEX2, TContentForm.Create(TFrmADMINIndex2));
  THandlers.Add(ROTA_INDEX, TContentForm.Create(TFrmIndex));
  THandlers.Add(ROTA_LOGIN, TContentForm.Create(TFrmLogin));
  THandlers.Add(ROTA_ESQUECI_MINHA_SENHA, TContentForm.Create(TFrmEsqueciMinhaSenha));
  THandlers.Add(ROTA_CLIENTE_CADASTRO, TContentForm.Create(TFrmClienteCadastro));
  THandlers.Add(ROTA_CLIENTE_DADOS, TContentForm.Create(TFrmClienteMeusDados));
  THandlers.Add(ROTA_CLIENTE_ENDERECO, TContentForm.Create(TFrmClienteEndereco));
  THandlers.Add(ROTA_PEDIDO_ACOMPANHAMENTO, TContentForm.Create(TFrmPedidoAcompanhamento));
  THandlers.Add(ROTA_PEDIDO_FINALIZAR, TContentForm.Create(TFrmPedidoFinalizar));
  THandlers.Add(ROTA_PEDIDO_DETALHE_ITEM, TContentForm.Create(TFrmPedidoDetalheItem));
  THandlers.Add(ROTA_PRODUTO_POR_CATEGORIA, TContentForm.Create(TFrmProdutosPorCategoria));
  THandlers.Add(ROTA_SOBRE, TContentForm.Create(TFrmSobre));
  THandlers.Add(ROTA_VENDA_HISTORICO, TContentForm.Create(TFrmVendaHistorico));
  THandlers.Add(ROTA_VENDA_HISTORICO_ADM, TContentForm.Create(TFrmVendaHistoricoAdm));
  THandlers.Add(ROTA_NOVO_ENDERECO, TContentForm.Create(TFrmNovoEndereco));
  THandlers.Add(ROTA_ERROR_404, TContentForm.Create(TFrmErro404));
  THandlers.Add(ROTA_ERROR_500, TContentForm.Create(TIWException));
  THandlers.Add(ROTA_PRODUTO_TODAS_CATEGORIA, TContentForm.Create(TFrmProdutosTodasCategoria));
  THandlers.Add(ROTA_SELECIONA_ENDERECOS, TContentForm.Create(TFrmBuscarEndereco));
  THandlers.Add(ROTA_PEDIDO_PAGAMENTO,TContentForm.Create(TFrmPedidoPagamentoOnline));
end;

procedure TIWServerController.IWServerControllerBaseNewSession(ASession: TIWApplication);
begin
 // WebApplication.GoToURL(ROTA_INDEX);
  ASession.Data := TIWUserSession.Create(nil, ASession);
end;

procedure TIWServerController.IWServerControllerBaseSessionRestarted(aSession: TIWApplication);
begin
  WebApplication.TerminateAndRedirect(ROTA_LOGIN);
end;

procedure TIWServerController.RedirecionarPaginaInicial(AFormAtual: TIWBaseForm);
begin
  if UserSession.LogadoComoAdmin then
    RedirecionarRota(AFormAtual, ROTA_ADMIN_INDEX)
  else
    RedirecionarRota(AFormAtual, ROTA_INDEX);
end;

procedure TIWServerController.RedirecionarRota(AFormAtual: TIWBaseForm; ARotaDestino: string);
begin
  AFormAtual.Release;
  WebApplication.GoToURL(ARotaDestino);
end;

{ TIWExceptionRendererEx }

class function TIWExceptionRendererEx.RenderHTML(AException: Exception; ARequest: THttpRequest): string;
var
  Addr: string;
begin
  if AException is EInvalidSession then
  begin
    Addr := #39 + TIWApplication.FullApplicationURL(ARequest) + '/login.html' + #39;
    Result := '<!DOCTYPE html>' +
              '<html>' +
              '<head>' +
              '<script type="text/javascript">' +
              'setTimeout("window.location=' + Addr + '", 1);' +
              '</script>' +
              '</head>' +
              '<body>' +
              '</body>' +
              '</html>';
  end
  else
    Result := inherited;
end;

initialization
  TIWServerController.SetServerControllerClass;

  with THandlers.Add(EmptyStr, ROTA_INDEX, TContentForm.Create(TFrmIndex)) do
  begin
    CanStartSession := True;
    RequiresSessionStart := False;
  end;

end.

