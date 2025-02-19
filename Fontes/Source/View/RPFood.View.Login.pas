unit RPFood.View.Login;

interface

uses
  Classes,
  SysUtils,
  IWAppForm,
  IWApplication,
  IWColor,
  IWTypes,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  Vcl.Controls,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  IWCompButton,
  ServerController,
  RPFood.Entity.Classes,
  RPFood.Controller,
  RPFood.Resources,
  Data.DB,
  Vcl.Forms,
  IWVCLBaseContainer,
  IWContainer,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  IWCompLabel,
  IW.Content.Form,
  IW.Content.Handlers,
  SweetAlert4D.Dialog.Interfaces,
  SweetAlert4D.Dialog.IW,
  RPFood.View.Rotas,
  UserSessionUnitCliente,
  IWHTMLTag,
  RPFood.View.Padrao;

type
  TFrmLogin = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    IWEDTLOGIN: TIWEdit;
    IWEDTSENHA: TIWEdit;
    IWBTNLOGIN: TIWButton;
    procedure IWBTNLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWEDTSENHAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDTLOGINHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    FController: TRPFoodController;
    FSessao: TRPFoodViewSessionCliente;
    FSweetAlert: ISweetAlert4DDialog;

    procedure EfetuarLogin;
    procedure SetVersao;
  public
    destructor Destroy; override;
  end;

implementation

uses
  Winapi.Windows,
  RPFood.View.Index;

{$R *.dfm}

procedure TFrmLogin.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  SetVersao;
end;

procedure TFrmLogin.IWAppFormCreate(Sender: TObject);
begin
  FreeAndNil(FController);
  FController := TRPFoodController.Create;
{$IFDEF DEBUG}
  IWEDTLOGIN.Text := 'jussara@rpsistema.com.br';
  IWEDTSENHA.Text := '1234';
{$ELSE}
  IWEDTLOGIN.Text := EmptyStr;
  IWEDTSENHA.Text := EmptyStr;
{$ENDIF}
  FSessao     := UserSession.SessaoCliente;
  FSweetAlert := TSweetAlert4DDialogIW.New(Self);
end;

procedure TFrmLogin.IWBTNLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  EfetuarLogin;
end;

procedure TFrmLogin.IWEDTLOGINHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add('placeholder="Digite seu login"');
end;

procedure TFrmLogin.IWEDTSENHAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add('placeholder="Digite sua senha"');
end;

procedure TFrmLogin.SetVersao;
var
  LComando: string;
begin
  LComando := Format('AtualizaVersao(''%s'')', [APP_RESOURCES.VersaoSistema]);
  WebApplication.CallBackResponse.AddJavaScriptToExecute(LComando);
end;

destructor TFrmLogin.Destroy;
begin
  FreeAndNil(FController);
  inherited;
end;

procedure TFrmLogin.EfetuarLogin;
var
  LCliente: TRPFoodEntityCliente;
  LLogin: string;
  LSenha: string;
begin
  try
    FSessao.ClienteLogado:=nil;

    LLogin := IWEDTLOGIN.Text;
    LSenha := IWEDTSENHA.Text;
    LCliente := FController.Service.LoginClienteService
      .Login(LLogin)
      .Senha(LSenha)
      .IdEmpresa(FSessao.IdEmpresa)
      .Entrar;

      FSessao.ClienteLogado := LCliente;
      TIWAppForm(WebApplication.ActiveForm).Release;
      WebApplication.GoToURL(ROTA_INDEX);


  except
    on E: Exception do
    begin
      FSweetAlert.ShowBasicError('Uaiii', E.Message);
    end;

  end;
end;

initialization
  TFrmLogin.SetURL('', 'login.html');

end.
