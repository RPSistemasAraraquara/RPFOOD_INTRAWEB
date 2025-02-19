unit RPFood.View.EsqueciMinhaSenha;

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
  SweetAlert4D.Dialog.Interfaces,
  SweetAlert4D.Dialog.IW,
  RPFood.View.Rotas,
  RPFood.Entity.Classes,
  RPFood.Controller;

type
  TFrmEsqueciMinhaSenha = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    IWEDTEMAIL: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
  private
    FSweetAlert: ISweetAlert4DDialog;
    FController: TRPFoodController;
    procedure GerarNovaSenha(AParams: TStringList);
  public
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

destructor TFrmEsqueciMinhaSenha.Destroy;
begin
  FController.Free;
  inherited;
end;

procedure TFrmEsqueciMinhaSenha.GerarNovaSenha(AParams: TStringList);
var
  LEmail: string;
begin
  try
    LEmail := IWEDTEMAIL.Text;
    FController.Service.EsqueciMinhaSenha
      .Email(LEmail)
      .Execute;
    WebApplication.GoToURL(ROTA_LOGIN);
  except
    on E: Exception do
      FSweetAlert.ShowBasicError('Erro', E.Message.Replace('"', ''));
  end;
end;

procedure TFrmEsqueciMinhaSenha.IWAppFormCreate(Sender: TObject);
begin
  FSweetAlert := TSweetAlert4DDialogIW.New(Self);
  FController := TRPFoodController.Create;
  RegisterCallBack('GerarNovaSenha', GerarNovaSenha);
end;

initialization
  TFrmEsqueciMinhaSenha.SetURL('', 'esqueci-minha-senha.html');

end.
