unit RPFood.View.Padrao;

interface

uses
  Classes,
  SysUtils,
  IWAppForm,
  IWApplication,
  IWColor,
  IWTypes,
  Vcl.Controls,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompButton,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  System.Generics.Collections,
  System.JSON,
  SweetAlert4D.Dialog.Interfaces,
  SweetAlert4D.Dialog.IW,
  RPFood.View.Rotas,
  RPFood.Entity.Classes,
  RPFood.Controller,
  RPFood.Resources,
  IWHTMLControls,
  IWCompEdit,
  IWHTMLTag,
  IWLayoutMgrHTML,
  Vcl.Forms,
  IWVCLBaseContainer,
  IWContainer,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  UserSessionUnitCliente,
  RTTI,
  TypInfo,
  Growl4D.Interfaces,
  Growl4D.Types,
  Growl4D.IW,
  HoldOn4D.Interfaces,
  HoldOn4D.Types,
  HoldOn4D.IW;

type
  TFrmPadrao = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
  private
    procedure OnSair(AParams: TStringList);
    procedure OnPadraoClickCategoria(AParams: TStringList);
    procedure OnPadraoClickDestaque(AParams: TStringList);
  protected
    FSweetAlert: ISweetAlert4DDialog;
    FGrowl: IGrowl4D;
    FHoldOn: IHoldOn4D;
    FController: TRPFoodController;
    FSessaoCliente: TRPFoodViewSessionCliente;
    FClienteLogado: TRPFoodEntityCliente;

    procedure RecarregarPagina;
    procedure RecarregarTag(ATagId: string);
    procedure CloseModal(AIdModal: string);

    procedure MensagemErro(ATitulo, AMensagem: string);
    procedure MensagemErroGrowl(ATitulo, AMensagem: string);
    procedure MensagemSucesso(ATitulo, AMensagem, AOnConfirm: string);
    procedure MensagemSucessoGrowl(ATitulo, AMensagem: string);
    procedure ExecutaJavaScript(AComando: string); overload;
    procedure ExecutaJavaScript(AComando: string; const Args: array of const); overload;

    function ObjectToJSON(AObject: TObject): string;
    function ListToJSON<T: class, constructor>(AList: TObjectList<T>): string;
    procedure SetVersao;
  public
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  ServerController;

procedure TFrmPadrao.CloseModal(AIdModal: string);
var
  LComando: string;
begin
  LComando := Format('$(''#%s'').modal(''hide'');', [AIdModal]);
  ExecutaJavaScript(LComando);
end;

destructor TFrmPadrao.Destroy;
begin
  FController.Free;
  inherited;
end;

procedure TFrmPadrao.ExecutaJavaScript(AComando: string; const Args: array of const);
begin
  ExecutaJavaScript(Format(AComando, Args));
end;

procedure TFrmPadrao.ExecutaJavaScript(AComando: string);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute(AComando);
end;

procedure TFrmPadrao.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  if not Assigned(FClienteLogado) then
    ExecutaJavaScript('ConfigurarMenuUsuario(false)')
  else
    ExecutaJavaScript('ConfigurarMenuUsuario(true)');
  SetVersao;
end;

procedure TFrmPadrao.IWAppFormCreate(Sender: TObject);
begin
  FSweetAlert := TSweetAlert4DDialogIW.New(Self);
  FGrowl := TGrow4DIW.New(Self).&Type(gtInfo).Icon(giLineconsFood)
    .Title('RPFood');

  FHoldOn := THoldOn4DIW.New(Self).Theme(htCircle);
  FController := TRPFoodController.Create;
  FSessaoCliente := UserSession.SessaoCliente;
  FClienteLogado := FSessaoCliente.ClienteLogado;

  RegisterCallBack('OnPadraoClickCategoria', OnPadraoClickCategoria);
  RegisterCallBack('OnPadraoClickDestaque', OnPadraoClickDestaque);
  RegisterCallBack('OnSair', OnSair);
end;

procedure TFrmPadrao.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  FClienteLogado := FSessaoCliente.ClienteLogado;
  if Assigned(FClienteLogado) then
  begin
    if AName = 'UsuarioLogado' then
      AValue := FClienteLogado.nome;
  end;
end;

function TFrmPadrao.ListToJSON<T>(AList: TObjectList<T>): string;
begin
  Result := FController.Components.JSON.ToJSONString<T>(AList);
end;

procedure TFrmPadrao.MensagemErro(ATitulo, AMensagem: string);
begin
  FSweetAlert.ShowBasicError(ATitulo, AMensagem);
end;

procedure TFrmPadrao.MensagemErroGrowl(ATitulo, AMensagem: string);
begin
  FGrowl.&Type(gtError).Title(ATitulo)
    .Text(AMensagem)
    .Icon(giLineconsFood)
    .Show(False);
end;

procedure TFrmPadrao.MensagemSucesso(ATitulo, AMensagem, AOnConfirm: string);
var
  LOnConfirm: string;
begin
  LOnConfirm := Format('ajaxCall(''%s'', '''');', [AOnConfirm]);
  FSweetAlert.OnClickOK(LOnConfirm)
    .ShowBasicSuccess(ATitulo, AMensagem);
end;

procedure TFrmPadrao.MensagemSucessoGrowl(ATitulo, AMensagem: string);
begin
  FGrowl.&Type(gtSuccess).Title(ATitulo)
    .Text(AMensagem)
    .Icon(giLineconsFood)
    .Show(False);
end;

procedure TFrmPadrao.OnPadraoClickCategoria(AParams: TStringList);
var
  LIdCategoria: Integer;
begin
  LIdCategoria := AParams.Values['idCategoria'].ToInteger;
  FSessaoCliente.IdCategoria := LIdCategoria;
  WebApplication.GoToURL(ROTA_PRODUTO_POR_CATEGORIA);
end;

procedure TFrmPadrao.OnPadraoClickDestaque(AParams: TStringList);
var
  LIdProduto: Integer;
begin
  LIdProduto := AParams.Values['idProduto'].ToInteger;
  FSessaoCliente.PedidoSessao.AdicionarProduto(LIdProduto, WebApplication);
end;

function TFrmPadrao.ObjectToJSON(AObject: TObject): string;
begin
  Result := FController.Components.JSON.ToJSONString(AObject);
end;

procedure TFrmPadrao.OnSair(AParams: TStringList);
begin
 WebApplication.TerminateAndRedirect('login.html');
end;

procedure TFrmPadrao.RecarregarTag(ATagId: string);
var
  LComando: string;
begin
  LComando := Format('$( "#%0:s" ).load(" #%0:s > *" );', [ATagId]);
  WebApplication.CallBackResponse
    .AddJavaScriptToExecuteAsCDATA(LComando);
end;

procedure TFrmPadrao.SetVersao;
var
  LComando: string;
begin
  LComando := Format('AtualizaVersao(''%s'')', [APP_RESOURCES.VersaoSistema]);
  WebApplication.CallBackResponse.AddJavaScriptToExecute(LComando);
end;

procedure TFrmPadrao.RecarregarPagina;
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecuteAsCDATA('location.reload();');
end;

end.
