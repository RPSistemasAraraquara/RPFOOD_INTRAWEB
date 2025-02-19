unit RPFood.View.ClienteDados;

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
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  RPFood.Entity.Classes,
  RPFood.Controller,
  RPFood.Resources,
  RPFood.Utils,
  RPFood.View.Rotas,
  IWCompButton;

type
  TFrmClienteMeusDados = class(TFrmPadrao)
    IWEDTNOME     : TIWEdit;
    IWEDTEMAIL    : TIWEdit;
    IWEDTSENHA    : TIWEdit;
    IWEDTCELULAR  : TIWEdit;
    IWEDTTELEFONE : TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
  private
    procedure PreencheFormulario;
    procedure LerFormulario;

    procedure Gravar(AParams: TStringList);
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrmClienteMeusDados }

procedure TFrmClienteMeusDados.Gravar(AParams: TStringList);
var
utils:TUtils;
begin

  utils:=TUtils.Create;
  try
    if Length(IWEDTSENHA.Text) < 4  then
    begin
      FSweetAlert.ShowBasicError('Erro','Faltou preencher a senha.');
      exit
    end;
    if not utils.ValidarCelular(IWEDTCELULAR.Text)then
    begin
      FSweetAlert.ShowBasicError('Erro','Faltou preencher celular.');
      exit
    end;

    if IWEDTNOME.Text= EmptyStr then
    begin
     FSweetAlert.ShowBasicError('Erro','Faltou preencher nome.');
      IWEDTNOME.Text           := FClienteLogado.nome;
      exit
    end;
  finally
    utils.Free;
  end;
  LerFormulario;

  try
    FController.Service.ClienteService
      .Cliente(FClienteLogado).Alterar;

    WebApplication.GoToURL(ROTA_INDEX);
  except
    on E: Exception do
      FSweetAlert.ShowBasicError('Erro de cadastro', E.Message.Replace('"', ''''));
  end;
end;

procedure TFrmClienteMeusDados.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if not Assigned(FClienteLogado) then
    Exit;

  PreencheFormulario;
  RegisterCallBack('Gravar', Gravar);
end;

procedure TFrmClienteMeusDados.LerFormulario;
begin
  FClienteLogado.nome      := IWEDTNOME.Text;
  FClienteLogado.email     := LowerCase(IWEDTEMAIL.Text);
  FClienteLogado.senha     := IWEDTSENHA.Text;
  FClienteLogado.celular   := IWEDTCELULAR.Text;
  FClienteLogado.telefone  := IWEDTTELEFONE.Text;
end;

procedure TFrmClienteMeusDados.PreencheFormulario;
begin
  IWEDTNOME.Text           := FClienteLogado.nome;
  IWEDTEMAIL.Text          := FClienteLogado.email;
  IWEDTSENHA.Text          := FClienteLogado.senha;
  IWEDTCELULAR.Text        := FClienteLogado.celular;
  IWEDTTELEFONE.Text       := FClienteLogado.telefone;
end;

initialization
  TFrmClienteMeusDados.SetURL('', 'cliente-dados.html');

end.
