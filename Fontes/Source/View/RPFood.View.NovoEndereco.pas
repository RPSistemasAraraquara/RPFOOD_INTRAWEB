unit RPFood.View.NovoEndereco;

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
  System.Generics.Collections,
  RPFood.Entity.Classes,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,RPFood.View.Rotas,
  IWVCLBaseContainer,
  IWContainer,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  IWCompListbox,
  IWCompLabel,
  IWCompButton,
  IWCompGrids;

type
  TFrmNovoEndereco = class(TFrmPadrao)
    IWEDTENDERECO    : TIWEdit;
    IWEDTNUMERO      : TIWEdit;
    IWEDTCOMPLEMENTO : TIWEdit;
    IWEDTREFERENCIA  : TIWEdit;
    IWLBLTAXA        : TIWLabel;
    IWEDTTAXA        : TIWEdit;
    IWEDTBAIRROLISTA : TIWComboBox;
    IWLBLBAIRROLISTA : TIWLabelEx;
    IWLBLENDERECO    : TIWLabelEx;
    IWLBLPADRAO      : TIWLabelEx;
    IWLBLNUMERO      : TIWLabelEx;
    IWEDTCEP         : TIWEdit;
    IWEDTBAIRRO      : TIWEdit;
    IWLBLBAIRRO      : TIWLabel;
    IWBTSALVAR       : TIWButton;
    IWBTCANCELAR     : TIWButton;
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWEDTBAIRROLISTAAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWEDTCEPAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWBTSALVARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);
    procedure IWBTCANCELARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    FIdBairro         : Integer;
    FPreencheCEP      : Boolean;
    FConfiguracao     : TRPFoodEntityConfiguracaoRPFood;
    FEndereco         : TRPFoodEntityClienteEndereco;
    FBairros          : TObjectList<TRPFoodEntityBairro>;
    LBairroDesc       : TRPFoodEntityBairro;
    FidCidade         : Integer;
    FUF               : String;
    LBairroDescricao  : TRPFoodEntityBairro;
    procedure PreencheEnderecos;
    procedure OnBuscarCep(AParams: TStringList);
    procedure CarregarEndereco(ACep: string);
    procedure LimparFormulario;
    procedure BuscaNovoBairro;
    procedure LerFormulario;
    procedure CarregaEnderecoBairro;
    procedure VerificaNovaConfiguracao;
    procedure PreencheBairro;
    procedure ValidarELerFormulario;
  public
    { Public declarations }

end;

var
  FrmNovoEndereco: TFrmNovoEndereco;

implementation

{$R *.dfm}

{ TFrmNovoEndereco }

procedure TFrmNovoEndereco.IWAppFormAsyncPageLoaded(Sender: TObject;EventParams: TStringList);
begin
  inherited;
  PreencheEnderecos;
end;

procedure TFrmNovoEndereco.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  FreeAndNil(FEndereco);
  FEndereco := TRPFoodEntityClienteEndereco.Create;
  LimparFormulario;
  VerificaNovaConfiguracao;
  RegisterCallBack('BuscarCep', OnBuscarCep);
end;

procedure TFrmNovoEndereco.IWAppFormDestroy(Sender: TObject);
begin
  FreeAndNil(FEndereco);
  FreeAndNil(FConfiguracao);
  FreeAndNil(LBairroDesc);
  FreeAndNil(LBairroDescricao);
  FreeAndNil(FBairros);
  inherited;
end;

procedure TFrmNovoEndereco.IWAppFormShow(Sender: TObject);
begin
  inherited;
  LimparFormulario;
end;

procedure TFrmNovoEndereco.IWBTCANCELARAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  LimparFormulario;
  WebApplication.GoToURL(ROTA_INDEX);
end;

procedure TFrmNovoEndereco.IWBTSALVARAsyncClick(Sender: TObject; EventParams: TStringList);
var
  LCep: string;
begin
  if FIdBairro=0 then
  begin
    FSweetAlert.ShowBasicError('Uaiii', 'Preencha o Bairro.');
    exit;
  end;

  if  FPreencheCEP then
  begin
    LCep := trim(IWEDTCEP.Text);
    try
      CarregarEndereco(LCep);
      LerFormulario;
      ValidarELerFormulario;

      FController.Service.ClienteService
        .Cliente(FClienteLogado)
        .AdicionarEndereco(FEndereco);

      FSessaoCliente.RecarregarEnderecos;
      PreencheEnderecos;
      WebApplication.GoToURL(ROTA_INDEX);
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

      FController.Service.ClienteService
        .Cliente(FClienteLogado)
        .AdicionarEnderecoBairro(FEndereco);

      FSessaoCliente.RecarregarEnderecos;
      PreencheEnderecos;
      WebApplication.GoToURL(ROTA_INDEX);
    except
      on E:Exception do
      begin
        FSweetAlert.ShowBasicError('Uaiiii', E.Message);
      end;
    end;

  end;
end;

procedure TFrmNovoEndereco.IWEDTBAIRROLISTAAsyncChange(Sender: TObject;EventParams: TStringList);
begin
  inherited;
  BuscaNovoBairro;
end;

procedure TFrmNovoEndereco.IWEDTCEPAsyncChange(Sender: TObject;EventParams: TStringList);
begin
  if IWEDTCEP.Text<>'' then
  begin
    if Length(IWEDTCEP.Text)>7 then
    begin
      CarregarEndereco(IWEDTCEP.Text);
      BuscaNovoBairro;
    end
    else
      FIdBairro:=0;
  end
  else
  FIdBairro:=0;
end;

procedure TFrmNovoEndereco.LerFormulario;
begin
 if  FPreencheCEP then
  begin
    FEndereco.idBairro        := FIdBairro;
    FEndereco.bairro          := IWEDTBAIRRO.Text;
    FEndereco.cep             := IWEDTCEP.Text;
  end
  else
  begin
    FEndereco.bairro          := IWEDTBAIRROLISTA.Text;
    FEndereco.idBairro        := FIdBairro;
    FEndereco.cep             :='';
  end;
  FEndereco.complemento       := IWEDTCOMPLEMENTO.Text;
  FEndereco.endereco          := IWEDTENDERECO.Text;
  FEndereco.numero            := IWEDTNUMERO.Text;
  FEndereco.taxaEntrega       := IWEDTTAXA.AsFloat;
  FEndereco.pontoReferencia   := IWEDTREFERENCIA.Text;
  FEndereco.IdCidade          := FidCidade;
  FEndereco.UF                := FUF;
end;

procedure TFrmNovoEndereco.LimparFormulario;
begin
  IWEDTENDERECO.Text           := '';
  IWEDTNUMERO.Text             := '';
  IWEDTCOMPLEMENTO.Text        := '';
  IWEDTREFERENCIA.Text         := '';
  IWEDTBAIRROLISTA.ItemIndex   := -1;
  IWEDTBAIRRO.Text             :='';
  IWEDTTAXA.AsFloat            :=0;
  IWEDTCEP.Text                :='';
  FidCidade                    :=0;
  FUF                          :='';
end;

procedure TFrmNovoEndereco.OnBuscarCep(AParams: TStringList);
begin
  try
    CarregarEndereco(IWEDTCEP.Text);
  except
    on E: Exception do
    begin
      FSweetAlert.ShowBasicError('CEP inválido', E.Message);
    end;
  end;
end;

procedure TFrmNovoEndereco.ValidarELerFormulario;
begin
  if FIdBairro=0 then
  begin
    raise Exception.Create('Preencha o Bairro');
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

  if  FPreencheCEP then
  begin
    if IWEDTCEP.Text=EmptyStr then
    begin
      IWEDTNUMERO.SetFocus;
      raise Exception.Create('Faltou preencher numero.');
    end;
  end;

end;

procedure TFrmNovoEndereco.VerificaNovaConfiguracao;
begin
  if not Assigned(FConfiguracao) then
    FConfiguracao := FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);

  if not Assigned(FConfiguracao) then
    FConfiguracao := TRPFoodEntityConfiguracaoRPFood.Create;

  FPreencheCEP                := FConfiguracao.UtilizarCEP ;

  if FPreencheCEP then
  begin
    IWEDTCEP.Visible            := true;
    IWEDTBAIRROLISTA.Visible   := false;
    IWEDTBAIRRO.Visible         := true;
    IWEDTCEP.Visible            := true;
    IWEDTENDERECO.Enabled       := false;
    IWEDTBAIRRO.Enabled         := false;
  end
  else
  begin
    IWEDTCEP.Visible            := false;
    IWEDTBAIRRO.Visible         := false;
    IWEDTBAIRROLISTA.Visible    := true;
    IWEDTBAIRRO.Visible         := false;
    IWEDTCEP.Visible            := false;
    IWEDTENDERECO.Enabled       := true;
    IWEDTBAIRRO.Enabled         := true;
    PreencheBairro;
  end;


end;

procedure TFrmNovoEndereco.PreencheBairro;
var
  I:Integer;
begin
  IWEDTBAIRROLISTA.Items.Clear;
  FreeAndNil(FBairros);
  FBairros := FController.DAO.BairroDAO.Listar(FSessaoCliente.IdEmpresa);
  for I := 0 to Pred(FBairros.Count) do
    IWEDTBAIRROLISTA.Items.Add(FBairros[I].Descricao);
end;

procedure TFrmNovoEndereco.PreencheEnderecos;
var
  LEnderecos: TObjectList<TRPFoodEntityClienteEndereco>;
  LComando: string;
begin
  LEnderecos := FClienteLogado.enderecos;
  LComando   := Format('PreencheEnderecos(%s);', [ListToJSON<TRPFoodEntityClienteEndereco>(LEnderecos)]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmNovoEndereco.BuscaNovoBairro;
begin
  if FPreencheCEP then
  begin
    if IWEDTBAIRRO.Text<>EmptyStr  then
    begin
      try
        LBairroDescricao := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRRO.Text, FSessaoCliente.IdEmpresa);
        try
          FIdBairro := LBairroDescricao.idBairro;
          CarregaEnderecoBairro;
          IWEDTTAXA.AsFloat := LBairroDescricao.taxa;
        finally
          LBairroDesc.Free;
        end;
      except
        on E: Exception do
        begin
          FSweetAlert.ShowBasicError('Opa houve um erro:', E.Message);
        end;
      end;
    end;
  end
  else
  begin
    if IWEDTBAIRROLISTA.ItemIndex <> -1 then
    begin
      try
        LBairroDescricao := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRROLISTA.Text, FSessaoCliente.IdEmpresa);
        try
          FIdBairro := LBairroDescricao.idBairro;
          CarregaEnderecoBairro;
          IWEDTTAXA.AsFloat := LBairroDescricao.taxa;
        finally
          LBairroDesc.Free;
        end;
      except
        on E: Exception do
        begin
          FSweetAlert.ShowBasicError('Opa houve um erro:', E.Message);
        end;
      end;
    end
    else
    begin
       FIdBairro:=0;
      MensagemErro('Uaiiii','Selecione um bairro') ;
      exit ;
    end;

  end;
end;

procedure TFrmNovoEndereco.CarregaEnderecoBairro;
var
  LEnderecoBairro: TRPFoodEntityBairro;
begin
  LEnderecoBairro := FController.DAO.BairroDAO.CarregaBairro(FIdBairro);
  if not Assigned(LEnderecoBairro) then
    LEnderecoBairro := TRPFoodEntityBairro.Create;

  if FPreencheCEP then
  begin
    try
      if Assigned(LEnderecoBairro) then
      begin
        IWEDTBAIRROLISTA.Text := LEnderecoBairro.Descricao;
        IWEDTTAXA.AsFloat := LEnderecoBairro.taxa;
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
        IWEDTBAIRRO.Text := LEnderecoBairro.Descricao;
        IWEDTTAXA.AsFloat := LEnderecoBairro.taxa;
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

procedure TFrmNovoEndereco.CarregarEndereco(ACep: string);
var
  LEndereco: TRPFoodEntityEndereco;
begin
  LEndereco := FController.DAO.EnderecoDAO.Busca(ACep);
  try
    if Assigned(LEndereco) then
    begin
      IWEDTENDERECO.Text                     := LEndereco.endereco;
      FIdBairro                              := LEndereco.idBairro;
      IWEDTBAIRRO.Text                       := LEndereco.bairro;
      IWEDTTAXA.AsFloat                      := LEndereco.taxaEntrega;
      FidCidade                              := LEndereco.idCidade;
      FUF                                    := LEndereco.UF;
    end
    else
    begin
      IWEDTENDERECO.Text                     :='';
      FIdBairro                              :=0;
      IWEDTBAIRRO.Text                       :='';
      IWEDTTAXA.AsFloat                      :=0;
      FidCidade                              :=0;
      FUF                                    :='';
      IWEDTCEP.SetFocus;
    end;
  finally
    LEndereco.Free;
  end;
end;

initialization
  TFrmNovoEndereco.SetURL('','novo-endereco.html')

end.
