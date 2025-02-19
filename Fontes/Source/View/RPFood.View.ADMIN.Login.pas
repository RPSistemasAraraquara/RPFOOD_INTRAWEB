unit RPFood.View.ADMIN.Login;

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
  RPFood.Resources,
  UserSessionUnitAdmin;

type
  TFrmADMINLogin = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    IWEDTLOGIN: TIWEdit;
    IWEDTSENHA: TIWEdit;
    IWBTNLOGIN: TIWButton;
    procedure IWBTNLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
  private
    FSweetAlert: ISweetAlert4DDialog;
    // É pelo Controller que os Forms vão enxergar toda a parte
    // da camada Model, seguindo a ideia do MVC
    FController: TRPFoodController;
    FSessao: TRPFoodViewSessionADMIN;

    procedure EfetuarLogin;
    procedure SetVersao;
  public
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TFrmADMINLogin.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  SetVersao;
end;

procedure TFrmADMINLogin.IWAppFormCreate(Sender: TObject);
begin
  FSweetAlert := TSweetAlert4DDialogIW.New(Self);
  FController := TRPFoodController.Create;
  FSessao := UserSession.SessaoADMIN;
  IWEDTLOGIN.Text := '1';
end;

procedure TFrmADMINLogin.IWBTNLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  EfetuarLogin;
end;

procedure TFrmADMINLogin.SetVersao;
var
  LComando: string;
begin
  LComando := Format('AtualizaVersao(''%s'')', [APP_RESOURCES.VersaoSistema]);
  WebApplication.CallBackResponse.AddJavaScriptToExecute(LComando);
end;

destructor TFrmADMINLogin.Destroy;
begin
  FController.Free;
  inherited;
end;

procedure TFrmADMINLogin.EfetuarLogin;
var
  LLogin: string;
  LSenha: string;
  LUsuario: TRPFoodEntityADMINUsuario;
begin
  LLogin := IWEDTLOGIN.Text;
  LSenha := IWEDTSENHA.Text;
  LUsuario := FController.DAO.ADMINUsuarioDAO.Login(LLogin, LSenha);

  if Assigned(LUsuario) then
  begin
    // Seta o cliente logado na sessão da aplicação, para recuperar o
    // os dados do cliente nas demais telas.
    FSessao.ADMINLogado := LUsuario;
    TIWAppForm(WebApplication.ActiveForm).Release; // Fechar Form/Tela atual
    WebApplication.GoToURL(ROTA_ADMIN_INDEX);
  end
  else
    FSweetAlert.ShowBasicError('Erro de login', 'Usuário e/ou senha inválidos.');
end;

initialization
  TFrmADMINLogin.SetURL('', '/admin/login');

end.
