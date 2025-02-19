  unit RPFood.View.ClienteCadastro;

interface

uses
  System.Generics.Collections,
  Classes,
  SysUtils,
  ServerController,
  IWAppForm,
  IWApplication,
  IWColor,
  IWTypes,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  IW.Content.Form,
  IW.Content.Handlers,
  Vcl.Controls,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  IWCompButton,
  SweetAlert4D.Dialog.Interfaces,
  SweetAlert4D.Dialog.IW,
  RPFood.Entity.Classes,
  RPFood.Controller,
  RPFood.View.Rotas,
  IWCompListbox,
  UserSessionUnitCliente,
  RPFood.Utils,
  IWHTMLTag,
  RPFood.Resources,
  Data.DB,
  IWCompLabel;

type
  TFrmClienteCadastro = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
    IWEDTNOME: TIWEdit;
    IWEDTEMAIL: TIWEdit;
    IWEDTSENHA: TIWEdit;
    IWEDTENDERECO: TIWEdit;
    IWEDTNUMERO: TIWEdit;
    IWEDTCOMPLEMENTO: TIWEdit;
    IWEDTBAIRRO: TIWEdit;
    IWEDTREFERENCIA: TIWEdit;
    IWEDTCELULAR: TIWEdit;
    IWEDTTELEFONE: TIWEdit;
    IWEDTCEP: TIWEdit;
    IWEDTBAIRRO_LISTA: TIWComboBox;
    IWEDTTAXA: TIWEdit;
    IWLblCep: TIWLabelEx;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWEDTCEPAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWEDTBAIRRO_LISTAAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    FController       : TRPFoodController;
    FSessaoCliente    : TRPFoodViewSessionCliente;
    FSweetAlert       : ISweetAlert4DDialog;
    FBairros          : TObjectList<TRPFoodEntityBairro>;
    FCliente          : TRPFoodEntityCliente;
    FConfiguracao     : TRPFoodEntityConfiguracaoRPFood;
    LPreencheCEP      : Boolean;
    FIdBairro         : Integer;
    FidCidade         : Integer;
    FUF               : String;
    FEndereco         : TRPFoodEntityClienteEndereco;
    LBairroDescricao  : TRPFoodEntityBairro;

    procedure PreencheFormulario;
    procedure LerFormulario;
    procedure CarregarEndereco(ACep: string);
    procedure Cadastrar(AParams: TStringList);
    procedure RealizarLogin(AEmail, ASenha: string);
    procedure LimparFormulario;
    procedure OnBuscarCep(AParams: TStringList);
    procedure VerificaConfiguracao;
    procedure PreencheListaBairros;
    procedure BuscaBairro;
    procedure CarregaEnderecoBairro;
    procedure ValidarELerFormulario;
  public

  end;

implementation

{$R *.dfm}

{ TFrmClienteCadastro }

procedure TFrmClienteCadastro.OnBuscarCep(AParams: TStringList);
begin
  CarregarEndereco(IWEDTCEP.Text);
end;

procedure TFrmClienteCadastro.BuscaBairro;
begin
  if ( LPreencheCEP) and (IWEDTBAIRRO.Text<>EmptyStr) then
  begin
    try
      LBairroDescricao := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRRO.Text, FSessaoCliente.IdEmpresa);
      try
        FIdBairro        := LBairroDescricao.idBairro;
        CarregaEnderecoBairro;
        IWEDTTAXA.AsFloat := LBairroDescricao.taxa;
      finally
        LBairroDescricao.Free;
      end;
    except
      on E: Exception do
      begin
        FSweetAlert.ShowBasicError('Erro ao buscar o bairro', E.Message);
      end;
    end;
  end
  else
  begin
    if IWEDTBAIRRO_LISTA.ItemIndex <> -1 then
    begin
      try
        LBairroDescricao := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRRO_LISTA.Text, FSessaoCliente.IdEmpresa);
        try
          FIdBairro := LBairroDescricao.idBairro;
          CarregaEnderecoBairro;
          IWEDTTAXA.AsFloat := LBairroDescricao.taxa;
        finally
          LBairroDescricao.Free;
        end;
      except
        on E: Exception do
        begin
          FSweetAlert.ShowBasicError('Erro ao buscar o bairro', E.Message);
        end;
      end;
    end
    else
    FIdBairro:=0;
  end;
end;

procedure TFrmClienteCadastro.Cadastrar(AParams: TStringList);
var
  LCep: string;
begin
  if FIdBairro=0 then
  begin
   FSweetAlert.ShowBasicError('Uaiiii ','Vocêee esqueceu de preencher o Bairro');
   exit
  end;

  if  LPreencheCEP then
  begin
    try
      LCep := trim(IWEDTCEP.Text);
      CarregarEndereco(LCep);
      LerFormulario;
      ValidarELerFormulario;

      FCliente.idEmpresa := FSessaoCliente.IdEmpresa;
      FController.Service.ClienteService.Cliente(FCliente).Salvar;
      RealizarLogin(FCliente.email, FCliente.senha);

    except
      on E: Exception do
      begin
        FSweetAlert.ShowBasicError('Uaiiii', E.Message);
      end;
    end;
  end
  else
  begin
    try
      CarregaEnderecoBairro;
      LerFormulario;
      ValidarELerFormulario;

      FCliente.idEmpresa := FSessaoCliente.IdEmpresa;
      FController.Service.ClienteService.Cliente(FCliente).Salvar;
      RealizarLogin(FCliente.email, FCliente.senha);

    except
      on E:Exception do
      begin
        FSweetAlert.ShowBasicError('Uaiii', E.Message);
      end;
    end;
  end;
end;

procedure TFrmClienteCadastro.CarregaEnderecoBairro;
var
  LEnderecoBairro :TRPFoodEntityBairro;
begin
   LEnderecoBairro := FController.DAO.BairroDAO.CarregaBairro(FIdBairro);
  if not Assigned(LEnderecoBairro) then
    LEnderecoBairro := TRPFoodEntityBairro.Create;

  if LPreencheCEP then
  begin
    try
      if Assigned(LEnderecoBairro) then
      begin
        IWEDTBAIRRO_LISTA.Text  := LEnderecoBairro.Descricao;
        IWEDTTAXA.AsFloat       := LEnderecoBairro.taxa;
        FIdBairro               :=LEnderecoBairro.IdBairro

      end
      else
      begin
        FEndereco.idBairro := 0;
        IWEDTCEP.Text := EmptyStr;
        IWEDTCEP.SetFocus;
      end;
    finally
      LEnderecoBairro.Free;
    end;

  end
  else
  begin
    try
      if Assigned(LEnderecoBairro) then
      begin
        IWEDTBAIRRO.Text  := LEnderecoBairro.Descricao;
        IWEDTTAXA.AsFloat := LEnderecoBairro.taxa;
        FIdBairro         :=LEnderecoBairro.IdBairro;
      end
      else
      begin
        FEndereco.idBairro := 0;
        IWEDTCEP.Text := EmptyStr;
        IWEDTCEP.SetFocus;
      end;
    finally
      LEnderecoBairro.Free;
    end;

  end;
end;

procedure TFrmClienteCadastro.CarregarEndereco(ACep: string);
var
  LEndereco: TRPFoodEntityEndereco;
begin
  LEndereco := FController.DAO.EnderecoDAO.Busca(ACep);
  try
    if Assigned(LEndereco) then
    begin
      IWEDTENDERECO.Text               := LEndereco.endereco;
      IWEDTBAIRRO.Text                 := LEndereco.bairro;
      FIdBairro                        := LEndereco.idBairro;
      FidCidade                        := LEndereco.idCidade;
      FUF                              := LEndereco.UF;
    end
    else
    begin
      FCliente.enderecoPadrao.idBairro := 0;
      FIdBairro:=0;
      FidCidade:=0;
      FUF      :='';
      IWEDTCEP.SetFocus;
    end;
  finally
    LEndereco.Free;
  end;

end;

procedure TFrmClienteCadastro.IWAppFormCreate(Sender: TObject);
begin
  FController    := TRPFoodController.Create;
  FSessaoCliente := UserSession.SessaoCliente;
  FSweetAlert    := TSweetAlert4DDialogIW.New(Self);

  FCliente       := TRPFoodEntityCliente.Create;
  FCliente.enderecos.Add(TRPFoodEntityClienteEndereco.Create);
  FCliente.enderecos.Last.enderecoPadrao := True;

  LimparFormulario;
  VerificaConfiguracao;
  PreencheFormulario;

  RegisterCallBack('Cadastrar', Cadastrar);
  RegisterCallBack('BuscarCep', OnBuscarCep);
end;

procedure TFrmClienteCadastro.IWAppFormDestroy(Sender: TObject);
begin
  FreeAndNil(FController);
  FreeAndNil(FCliente);
  FreeAndNil(FConfiguracao);
  FreeAndNil(FBairros);
  inherited;
end;

procedure TFrmClienteCadastro.IWEDTBAIRRO_LISTAAsyncChange(Sender: TObject; EventParams: TStringList);
begin
 BuscaBairro;
end;

procedure TFrmClienteCadastro.IWEDTCEPAsyncChange(Sender: TObject; EventParams: TStringList);
begin
  if IWEDTCEP.Text<>EmptyStr then
  begin
    if length(IWEDTCEP.Text)>7 then
    begin
      CarregarEndereco(IWEDTCEP.Text);
      BuscaBairro;
    end
    else
     FIdBairro:=0;
  end
  else
   FIdBairro:=0;
end;

procedure TFrmClienteCadastro.LerFormulario;
var
  LIndex: Integer;
begin
  FCliente.idEmpresa                      := FSessaoCliente.IdEmpresa;
  FCliente.nome                           := IWEDTNOME.Text;
  FCliente.email                          := LowerCase(IWEDTEMAIL.Text);
  FCliente.senha                          := IWEDTSENHA.Text;
  FCliente.enderecoPadrao.cep             := IWEDTCEP.Text;
  FCliente.enderecoPadrao.endereco        := IWEDTENDERECO.Text;
  FCliente.enderecoPadrao.numero          := IWEDTNUMERO.Text;
  FCliente.enderecoPadrao.complemento     := IWEDTCOMPLEMENTO.Text;
  FCliente.enderecoPadrao.bairro          := IWEDTBAIRRO.Text;
  FCliente.enderecoPadrao.pontoReferencia := IWEDTREFERENCIA.Text;
  FCliente.enderecoPadrao.IdCidade        := FidCidade;
  FCliente.enderecoPadrao.UF              := FUF;

  FCliente.celular                        := IWEDTCELULAR.Text;
  FCliente.telefone                       := IWEDTTELEFONE.Text;
  FCliente.enderecoPadrao.idBairro        := FIdBairro;

  if IWEDTBAIRRO_LISTA.Visible then
  begin
    LIndex := IWEDTBAIRRO_LISTA.ItemIndex;
    FCliente.enderecoPadrao.bairro         := IWEDTBAIRRO_LISTA.Text;
    FCliente.enderecoPadrao.idBairro       := FIdBairro;
    FCliente.enderecoPadrao.taxaEntrega    :=FBairros[LIndex].taxa;
  end
  else
   FCliente.enderecoPadrao.taxaEntrega     :=IWEDTTAXA.AsFloat;
end;

procedure TFrmClienteCadastro.LimparFormulario;
begin
  IWEDTENDERECO.Text           := '';
  IWEDTNUMERO.Text             := '';
  IWEDTCOMPLEMENTO.Text        := '';
  IWEDTREFERENCIA.Text         := '';
  IWEDTBAIRRO.Text             := '';
  IWEDTCELULAR.Text            := '';
  IWEDTTELEFONE.Text           := '';
  IWEDTEMAIL.Text              := '';
  IWEDTSENHA.Text              := '';
  IWEDTBAIRRO_LISTA.ItemIndex  := -1;
  IWEDTTAXA.AsFloat            :=0;
  IWEDTCEP.Text                :='';
  FidCidade                    :=0;
  FUF                          :='';
end;

procedure TFrmClienteCadastro.PreencheFormulario;
begin
  IWEDTNOME.Text           := FCliente.nome;
  IWEDTEMAIL.Text          := FCliente.email;
  IWEDTSENHA.Text          := FCliente.senha;
  IWEDTCEP.Text            := FCliente.enderecoPadrao.cep;
  IWEDTENDERECO.Text       := FCliente.enderecoPadrao.endereco;
  IWEDTNUMERO.Text         := FCliente.enderecoPadrao.numero;
  IWEDTCOMPLEMENTO.Text    := FCliente.enderecoPadrao.complemento;
  IWEDTREFERENCIA.Text     := FCliente.enderecoPadrao.pontoReferencia;
  IWEDTBAIRRO.Text         := FCliente.enderecoPadrao.bairro;
  IWEDTBAIRRO_LISTA.Text   := FCliente.enderecoPadrao.bairro;
  IWEDTCELULAR.Text        := FCliente.celular;
  IWEDTTELEFONE.Text       := FCliente.telefone;
  FidCidade                := FCliente.enderecoPadrao.IdCidade;
  FUF                      :=FCliente.enderecoPadrao.UF;

end;

procedure TFrmClienteCadastro.PreencheListaBairros;
var
  I: Integer;
begin
  IWEDTBAIRRO_LISTA.Items.Clear;
  FreeAndNil(FBairros);
  FBairros := FController.DAO.BairroDAO.Listar(FSessaoCliente.IdEmpresa);
  for I := 0 to Pred(FBairros.Count) do
    IWEDTBAIRRO_LISTA.Items.Add(FBairros[I].Descricao);
end;

procedure TFrmClienteCadastro.RealizarLogin(AEmail, ASenha: string);
var
  LCliente: TRPFoodEntityCliente;
begin
  LCliente                      := FController.DAO.ClienteDAO.Login(AEmail, ASenha);
  FSessaoCliente.ClienteLogado  := LCliente;
  TIWAppForm(WebApplication.ActiveForm).Release;
  WebApplication.GoToURL(ROTA_INDEX);
end;

procedure TFrmClienteCadastro.ValidarELerFormulario;
begin
  if FIdBairro=0 then
  begin
    FSweetAlert.ShowBasicWarning('Uaiii', 'Preencha o Bairro ');
    Abort;
  end;

  if IWEDTENDERECO.Text=EmptyStr then
  begin
      IWEDTENDERECO.SetFocus;
    raise Exception.Create('Faltou preencher endereço.');

  end;

  if IWEDTNUMERO.Text=EmptyStr then
  begin
    IWEDTNUMERO.SetFocus;
    raise Exception.Create('Faltou preencher numero.');

  end;

  if IWEDTSENHA.Text=EmptyStr then
  begin
     IWEDTSENHA.SetFocus;
    raise Exception.Create('Faltou preencher senha.');

  end;

  if IWEDTCELULAR.Text=EmptyStr then
  begin
    IWEDTCELULAR.SetFocus;
    raise Exception.Create('Faltou preencher o telefone.');
  end;

  if IWEDTNOME.Text=EmptyStr then
  begin
    IWEDTCELULAR.SetFocus;
    raise Exception.Create('Faltou preencher o nome.');
  end;

  if  LPreencheCEP then
  begin
    if IWEDTCEP.Text=EmptyStr then
    begin
      IWEDTCEP.SetFocus;
     raise Exception.Create('Faltou preencher o CEP.');
    end;
  end;
end;

procedure TFrmClienteCadastro.VerificaConfiguracao;
begin
  if not Assigned(FConfiguracao) then
    FConfiguracao := FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);

  if not Assigned(FConfiguracao) then
    FConfiguracao := TRPFoodEntityConfiguracaoRPFood.Create;

  LPreencheCEP := FConfiguracao.UtilizarCEP;

  if LPreencheCEP then
  begin
    IWEDTCEP.Visible            := true;
    IWLblCep.Visible            := true;
    IWEDTBAIRRO_LISTA.Visible   := false;
    IWEDTBAIRRO.Visible         := true;
    IWEDTCEP.Visible            := true;
    IWEDTENDERECO.Enabled       := false;
    IWEDTBAIRRO.Enabled         := false;
  end
  else
  begin
    IWEDTCEP.Visible            := false;
    IWLblCep.Visible            := false;
    IWEDTBAIRRO.Visible         := false;
    IWEDTBAIRRO_LISTA.Visible   := true;
    IWEDTBAIRRO.Visible         := false;
    IWEDTCEP.Visible            := false;
    IWEDTENDERECO.Enabled       := true;
    IWEDTBAIRRO.Enabled         := true;
    PreencheListaBairros;
  end;

end;

initialization
  TFrmClienteCadastro.SetURL('', 'cliente-cadastro.html');

end.
