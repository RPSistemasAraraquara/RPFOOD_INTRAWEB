unit RPFood.View.ClienteEndereco;

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
  IWCompLabel, IWCompButton, IWCompGrids;

type
  TFrmClienteEndereco = class(TFrmPadrao)
    IWEDTENDERECO     : TIWEdit;
    IWEDTNUMERO       : TIWEdit;
    IWEDTCOMPLEMENTO  : TIWEdit;
    IWEDTREFERENCIA   : TIWEdit;
    IWLBLBAIRROLISTA  : TIWLabel;
    IWLBLTAXA         : TIWLabel;
    IWEDTTAXA         : TIWEdit;
    IWEDTBAIRROLISTA  : TIWComboBox;
    IWBTNOVOENDERECO  : TIWButton;
    IWLBLENDERECO     : TIWLabelEx;
    IWLBLPADRAO       : TIWLabelEx;
    IWLBLNUMERO       : TIWLabelEx;
    IWEDTCEP          : TIWEdit;
    IWLBLCEP          : TIWLabelEx;
    IWEDTBAIRRO       : TIWEdit;
    IWLBLBAIRRO       : TIWLabel;
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWEDTCEPAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWEDTBAIRROLISTAAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWBTNOVOENDERECOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);
    procedure IWEDTCEPAsyncClick(Sender: TObject;  EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWEDTCANCELAAsyncClick(Sender: TObject; EventParams: TStringList);

  private
    FEndereco         : TRPFoodEntityClienteEndereco;
    FBairros          : TObjectList<TRPFoodEntityBairro>;
    FConfiguracao     : TRPFoodEntityConfiguracaoRPFood;
    LBairroDescricao  : TRPFoodEntityBairro;
    FPreencheCEP      : Boolean;
    FIdBairro         : Integer;
    FidCidade         : Integer;
    FUF               : String;
    LBairroDesc       : TRPFoodEntityBairro;
    procedure VerificaConfiguracao;
    procedure PreencheListaBairros;
    procedure PreencheEnderecos;
    procedure PreencheFormulario;
    procedure LerFormulario;
    procedure CarregarEndereco(ACep: string);
    procedure CarregaEnderecoBairro;
    procedure OnBuscarCep(AParams: TStringList);
    procedure OnClickAlterarEndereco(AParams: TStringList);
    procedure OnClickSalvar(AParams: TStringList);
    procedure BuscaBairro;
    procedure BuscaNovoBairro;
    procedure Limpar;
    { Private declarations }
  end;

implementation

uses
  System.DateUtils,
  IWApplication;

{$R *.dfm}

procedure TFrmClienteEndereco.OnBuscarCep(AParams: TStringList);
begin
  if IWEDTCEP.Text <> EmptyStr then
  begin
    try
      CarregarEndereco(IWEDTCEP.Text);
    except
      on E: Exception do
      begin
        MensagemErro('CEP inválido', E.Message);
      end;
    end;
  end
  else
  FIdBairro:=0;
end;

procedure TFrmClienteEndereco.BuscaBairro;
begin
  if not FPreencheCEP then
  begin
    if IWEDTBAIRROLISTA.ItemIndex <> -1 then
    begin
      try
        LBairroDesc := FController.DAO.BairroDAO.CarregaDescricaoBairro
          (IWEDTBAIRROLISTA.Text, FSessaoCliente.IdEmpresa);

        try
          FIdBairro := LBairroDesc.IdBairro;
          IWEDTTAXA.AsFloat := LBairroDesc.taxa;
        finally
         LBairroDesc.Free;
        end;
      except
        on E: Exception do
        begin
          MensagemErro('Erro ao buscar o bairro', E.Message);
        end;
      end;
    end
    else
    begin
      FIdBairro:=0;
      MensagemErro('Uaiiii','Selecione um bairro') ;
      exit ;
    end;


  end
  else
  begin
    if IWEDTBAIRRO.Text<>EmptyStr then
    begin
      try
        LBairroDesc := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRRO.Text, FSessaoCliente.IdEmpresa);
        try
          FIdBairro := LBairroDesc.IdBairro;
          CarregaEnderecoBairro;
          IWEDTTAXA.AsFloat := LBairroDesc.taxa;
        finally
          LBairroDesc.Free;
        end;
      except
        on E: Exception do
        begin
          MensagemErro('Erro ao buscar o bairro', E.Message);
        end;
      end;
    end;
  end;
end;

procedure TFrmClienteEndereco.BuscaNovoBairro;
begin
 if not FPreencheCEP then
  begin
    if IWEDTBAIRROLISTA.ItemIndex <> -1 then
    begin
      try
        LBairroDescricao := FController.DAO.BairroDAO.CarregaDescricaoBairro(IWEDTBAIRROLISTA.Text, FSessaoCliente.IdEmpresa);
        if not Assigned(LBairroDescricao) then
        LBairroDescricao:= TRPFoodEntityBairro.Create;
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
          MensagemErro('Erro ao buscar o bairro', E.Message);
        end;
      end;
    end;
  end
  else
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
          LBairroDescricao.Free;
        end;
      except
        on E: Exception do
        begin
          MensagemErro('Erro ao buscar o bairro', E.Message);
        end;
      end;
    end;
  end;
end;

procedure TFrmClienteEndereco.CarregaEnderecoBairro;
var
  LEnderecoBairro :TRPFoodEntityBairro;
begin
  LEnderecoBairro := FController.DAO.BairroDAO.CarregaBairro(FIdBairro);
  if not Assigned(LEnderecoBairro) then
    LEnderecoBairro := TRPFoodEntityBairro.Create;

  if FPreencheCEP then
  begin
    try
      if Assigned(LEnderecoBairro) then
      begin
        IWEDTBAIRROLISTA.Text   := LEnderecoBairro.Descricao;
        IWEDTTAXA.AsFloat       := LEnderecoBairro.taxa;
        FIdBairro               := LEnderecoBairro.IdBairro

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

procedure TFrmClienteEndereco.CarregarEndereco(ACep: string);
var
  LEndereco: TRPFoodEntityEndereco;
begin
  if not FPreencheCEP then
    Exit;

  LEndereco := FController.DAO.EnderecoDAO.Busca(ACep);
  try
    if Assigned(LEndereco) then
    begin
      FEndereco.idBairro      := LEndereco.idBairro;
      IWEDTENDERECO.Text      := LEndereco.endereco;
      IWEDTBAIRRO.Text        := LEndereco.bairro;
      IWEDTTAXA.AsFloat       := LEndereco.taxaEntrega;
      IWEDTCEP.Text           := LEndereco.cep;
      FidCidade               := LEndereco.idCidade;
      FUF                     := LEndereco.UF;
    end
    else
    begin
      FEndereco.idBairro := 0;
      IWEDTCEP.Text      := EmptyStr;
      IWEDTTAXA.AsFloat  := 0;
      FidCidade          :=0;
      FUF                :='';
      IWEDTBAIRROLISTA.Items.Clear;
      IWEDTCEP.SetFocus;
      MensagemErro('Puxaaa','Não atendemos na sua região, desculpe.') ;
    end;
  finally
    LEndereco.Free;
  end;
end;


procedure TFrmClienteEndereco.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  PreencheEnderecos;
end;

procedure TFrmClienteEndereco.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  VerificaConfiguracao;
  RegisterCallBack('BuscarCep', OnBuscarCep);
  RegisterCallBack('OnClickAlterarEndereco', OnClickAlterarEndereco);
  RegisterCallBack('OnClickSalvar', OnClickSalvar);
end;

procedure TFrmClienteEndereco.IWAppFormDestroy(Sender: TObject);
begin
  FreeAndNil(FEndereco);
  FreeAndNil(FBairros);
  FreeAndNil(FConfiguracao);
  inherited;
end;

procedure TFrmClienteEndereco.IWAppFormShow(Sender: TObject);
begin
  inherited;
  PreencheEnderecos;
end;

procedure TFrmClienteEndereco.IWBTNOVOENDERECOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  WebApplication.GoToURL(ROTA_NOVO_ENDERECO);
end;

procedure TFrmClienteEndereco.IWEDTBAIRROLISTAAsyncChange(Sender: TObject;   EventParams: TStringList);
begin
  inherited;
  BuscaBairro;
end;

procedure TFrmClienteEndereco.IWEDTCANCELAAsyncClick(Sender: TObject;EventParams: TStringList);
begin
  inherited;
  WebApplication.GoToURL(ROTA_INDEX);
end;

procedure TFrmClienteEndereco.IWEDTCEPAsyncChange(Sender: TObject; EventParams: TStringList);
begin

  if trim(IWEDTCEP.Text)<>'' then
  begin
    if Length(IWEDTCEP.Text)=8 then
    try
      CarregarEndereco(IWEDTCEP.Text);
      BuscaNovoBairro;
    except
    on E: Exception do
      MensagemErro('CEP inválido', E.Message);
    end;
  end
  else
  FIdBairro:=0;

end;

procedure TFrmClienteEndereco.IWEDTCEPAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
 CarregarEndereco(IWEDTCEP.Text);
end;

procedure TFrmClienteEndereco.OnClickAlterarEndereco(AParams: TStringList);
var
  i          : Integer;
  LIdEndereco: Integer;
begin
  Limpar;
  VerificaConfiguracao;

  if not FPreencheCEP then
  begin
    IWEDTBAIRROLISTA.Items.Clear;
    FreeAndNil(FBairros);
    FBairros := FController.DAO.BairroDAO.Listar(FSessaoCliente.IdEmpresa);
    for I := 0 to Pred(FBairros.Count) do
    IWEDTBAIRROLISTA.Items.Add(FBairros[I].Descricao);
  end;

  LIdEndereco := StrToIntDef(AParams.Values['idEndereco'], 0);
  FreeAndNil(FEndereco);
  FEndereco := TRPFoodEntityClienteEndereco.Create;
  FEndereco.Assign(FClienteLogado.GetEndereco(LIdEndereco));
  PreencheFormulario;

  if FPreencheCEP then
    CarregarEndereco(trim(IWEDTCEP.Text))
  else
   BuscaBairro;
end;

procedure TFrmClienteEndereco.PreencheFormulario;
begin
  if  FPreencheCEP then
  begin
    IWEDTCEP.Text                := FEndereco.cep;
    IWEDTENDERECO.Text           := FEndereco.endereco;
    IWEDTNUMERO.Text             := FEndereco.numero;
    IWEDTCOMPLEMENTO.Text        := FEndereco.complemento;
    IWEDTREFERENCIA.Text         := FEndereco.pontoReferencia;
    IWEDTBAIRRO.Text             := FEndereco.bairro;
    IWEDTTAXA.AsFloat            := FEndereco.taxaEntrega;
    IWEDTCEP.Visible             := true;
    IWLBLCEP.Visible             := true;
    IWEDTBAIRRO.Visible          := true;
    IWLBLBAIRRO.Visible          := true;
  end
  else
  begin
    IWEDTENDERECO.Text           := FEndereco.endereco;
    IWEDTNUMERO.Text             := FEndereco.numero;
    IWEDTCEP.Visible             := false;
    IWLBLCEP.Visible             := false;
    IWEDTBAIRROLISTA.ItemIndex   := IWEDTBAIRROLISTA.Items.IndexOf(FEndereco.bairro);
    IWEDTBAIRRO.Visible          := false;
    IWLBLBAIRRO.Visible          := false;
    IWEDTCOMPLEMENTO.Text        := FEndereco.complemento;
    IWEDTREFERENCIA.Text         := FEndereco.pontoReferencia;
  end;
  FidCidade                      := FEndereco.IdCidade;
  FUF                            := FEndereco.UF;


end;


procedure TFrmClienteEndereco.OnClickSalvar(AParams: TStringList);
var
  LCep: string;
begin
  if  FPreencheCEP then
  begin
     LCep := trim(IWEDTCEP.Text);
    if LCep=EmptyStr then
    begin
      FSweetAlert.ShowBasicError('Uaiii', 'Preencha o cep.');
      exit;
    end;

    try
      CarregarEndereco(LCep);
      LerFormulario;

      if IWEDTNUMERO.Text = EmptyStr then
      begin
        FSweetAlert.ShowBasicError('Uaiiii', 'Faltou preencher número.');
        Exit
      end;

      if FEndereco.idEndereco > 0 then
      begin
        FController.Service.ClienteService
          .Cliente(FClienteLogado)
          .AlterarEndereco(FEndereco);
      end
      else
      begin
        FController.Service.ClienteService
          .Cliente(FClienteLogado)
          .AdicionarEndereco(FEndereco);
      end;
    except
      on E: Exception do
      begin
        FSweetAlert.ShowBasicError('Erro ao cadastrar endereço!', E.Message);
      end;
    end;
  end
  else
  begin

    try
      CarregaEnderecoBairro;
      LerFormulario;
      if FIdBairro=0 then
      begin
        FSweetAlert.ShowBasicError('Uaiii', 'Preencha o Bairro.');
        exit;
      end;

      if IWEDTENDERECO.Text=EmptyStr then
      begin
        FSweetAlert.ShowBasicError('Uaiii', 'Faltou preencher endereço.');
        exit
      end;

      if IWEDTNUMERO.Text=EmptyStr then
      begin
        FSweetAlert.ShowBasicError('Uaiii', 'Faltou preencher numero.');
        exit
      end;

      if FEndereco.idEndereco > 0 then
      begin
        FController.Service.ClienteService
        .Cliente(FClienteLogado)
        .AlterarEndereco(FEndereco);
      end
      else
      begin
      FController.Service.ClienteService
      .Cliente(FClienteLogado)
      .AdicionarEnderecoBairro(FEndereco);
      end;
    except
    on E:Exception do
      MensagemErro('Erro ao cadastrar endereço!', E.Message);
    end;
  end;

  FSessaoCliente.RecarregarEnderecos;
  PreencheEnderecos;
  WebApplication.GoToURL(ROTA_INDEX);

end;

procedure TFrmClienteEndereco.PreencheEnderecos;
var
  LEnderecos: TObjectList<TRPFoodEntityClienteEndereco>;
  LComando: string;
begin
  LEnderecos := FClienteLogado.enderecos;
  LComando   := Format('PreencheEnderecos(%s);', [ListToJSON<TRPFoodEntityClienteEndereco>(LEnderecos)]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmClienteEndereco.LerFormulario;
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

  FEndereco.complemento     := IWEDTCOMPLEMENTO.Text;
  FEndereco.endereco        := IWEDTENDERECO.Text;
  FEndereco.numero          := IWEDTNUMERO.Text;
  FEndereco.taxaEntrega     := IWEDTTAXA.AsFloat;
  FEndereco.pontoReferencia := IWEDTREFERENCIA.Text;
  FEndereco.IdCidade        := FidCidade;
  FEndereco.UF              := FUF;

end;


procedure TFrmClienteEndereco.Limpar;
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

procedure TFrmClienteEndereco.PreencheListaBairros;
begin
  IWEDTBAIRROLISTA.Items.Clear;
  IWEDTBAIRROLISTA.Items.Add(FClienteLogado.enderecoPadrao.bairro);
end;

procedure TFrmClienteEndereco.VerificaConfiguracao;
begin
  if not Assigned(FConfiguracao) then
    FConfiguracao := FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);

  if not Assigned(FConfiguracao) then
    FConfiguracao := TRPFoodEntityConfiguracaoRPFood.Create;

  FPreencheCEP                := FConfiguracao.UtilizarCEP ;
  IWLBLBAIRRO.Visible         := FPreencheCEP;
  IWEDTBAIRRO.Visible         := FPreencheCEP;
  IWEDTCEP.Visible            := FPreencheCEP;
  IWEDTBAIRROLISTA.Visible    := not FPreencheCEP;
  IWLBLBAIRROLISTA.Visible    := not FPreencheCEP;
  IWEDTENDERECO.Enabled       :=false;


  if not FPreencheCEP then
  begin
    IWEDTENDERECO.Enabled     :=true;
    PreencheListaBairros;
  end;

end;

initialization
  TFrmClienteEndereco.SetURL('', 'cliente-endereco.html');

end.
