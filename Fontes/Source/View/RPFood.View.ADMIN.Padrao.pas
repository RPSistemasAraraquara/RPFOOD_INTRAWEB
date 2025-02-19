unit RPFood.View.ADMIN.Padrao;

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
  SweetAlert4D.Dialog.Interfaces,
  SweetAlert4D.Dialog.IW,
  UserSessionUnitAdmin;

type
  TFrmADMINPadrao = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
  private
    procedure OnSair(AParams: TStringList);
    protected
    FSweetAlert: ISweetAlert4DDialog;
    FController: TRPFoodController;
    FSessaoADMIN: TRPFoodViewSessionADMIN;
    FUsuarioLogado: TRPFoodEntityADMINUsuario;

    procedure MensagemErro(ATitulo, AMensagem: string);
    procedure MensagemSucesso(ATitulo, AMensagem, AOnConfirm: string);
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



destructor TFrmADMINPadrao.Destroy;
begin
  FController.Free;
  inherited;
end;

procedure TFrmADMINPadrao.ExecutaJavaScript(AComando: string; const Args: array of const);
begin
  ExecutaJavaScript(Format(AComando, Args));
end;

procedure TFrmADMINPadrao.ExecutaJavaScript(AComando: string);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute(AComando);
end;

procedure TFrmADMINPadrao.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  SetVersao;
end;

procedure TFrmADMINPadrao.IWAppFormCreate(Sender: TObject);
begin
  FSweetAlert := TSweetAlert4DDialogIW.New(Self);
  FController := TRPFoodController.Create;
  FSessaoADMIN := UserSession.SessaoADMIN;
  FUsuarioLogado := FSessaoADMIN.ADMINLogado;
  Self.Title := 'ADMIN RPFood - ' + Self.Title;

  RegisterCallBack('OnSair', OnSair);
end;

procedure TFrmADMINPadrao.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  if not Assigned(FUsuarioLogado) then
    Exit;

  if AName = 'UsuarioLogado' then
    AValue := FUsuarioLogado.nome;
end;

function TFrmADMINPadrao.ListToJSON<T>(AList: TObjectList<T>): string;
begin
  Result := FController.Components.JSON.ToJSONString<T>(AList);
end;

procedure TFrmADMINPadrao.MensagemErro(ATitulo, AMensagem: string);
begin
  FSweetAlert.ShowBasicError(ATitulo, AMensagem);
end;

procedure TFrmADMINPadrao.MensagemSucesso(ATitulo, AMensagem, AOnConfirm: string);
var
  LOnConfirm: string;
begin
  LOnConfirm := Format('ajaxCall(''%s'', '''');', [AOnConfirm]);
  FSweetAlert.OnClickOK(LOnConfirm)
    .ShowBasicSuccess(ATitulo, AMensagem);
end;

function TFrmADMINPadrao.ObjectToJSON(AObject: TObject): string;
begin
  Result := FController.Components.JSON.ToJSONString(AObject);
end;

procedure TFrmADMINPadrao.OnSair(AParams: TStringList);
begin
  WebApplication.TerminateAndRedirect(ROTA_ADMIN_LOGIN);
end;

procedure TFrmADMINPadrao.SetVersao;
var
  LComando: string;
begin
  LComando := Format('AtualizaVersao(''%s'')', [APP_RESOURCES.VersaoSistema]);
  WebApplication.CallBackResponse.AddJavaScriptToExecute(LComando);
end;

end.
