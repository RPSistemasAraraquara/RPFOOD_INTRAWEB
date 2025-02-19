unit RPFood.View.Pedido.Finalizar;

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
  IWLayoutMgrHTML,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  IWCompEdit,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWHTMLControls,
  RPFood.Entity.Classes,
  RPFood.View.Rotas,
  System.Generics.Collections,
  IWHTMLTag,
  IWBaseComponent,
  IWBaseHTMLComponent,
  IWBaseHTML40Component,
  IWCompExtCtrls,
  IWCompButton,
  IWCompListbox,
  IWCompMemo,
  IWVCLBaseContainer,
  IWContainer,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  IWCompTabControl,
  IWCompLabel;

type
  TFrmPedidoFinalizar = class(TFrmPadrao)
    IWEDT_VALOR_PAGO        : TIWEdit;
    IWBTN_CONFIRMAR_TROCO   : TIWButton;
    IWBTN_CANCELAR_TROCO    : TIWButton;
    IWEDTCEP                : TIWEdit;
    IWEDTENDERECO           : TIWEdit;
    IWEDTNUMERO             : TIWEdit;
    IWEDTCOMPLEMENTO        : TIWEdit;
    IWEDTBAIRRO             : TIWEdit;
    IWEDTREFERENCIA         : TIWEdit;
    IWOBSERVACAO            : TIWMemo;
    IWEDTSELECIONAENDERECOS : TIWButton;
    IWLBLRETIRADA           : TIWLabel;
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWBTN_CONFIRMAR_TROCOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWBTN_CANCELAR_TROCOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWOBSERVACAOAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormAsyncPageUnloaded(Sender: TObject;EventParams: TStringList; AIsCurrent: Boolean);
    procedure IWAppFormShow(Sender: TObject);
    procedure IWEDTSELECIONAENDERECOSAsyncClick(Sender: TObject;
      EventParams: TStringList);
  private
    FEnderecoCadastro    : TRPFoodEntityClienteEndereco;
    FPedido              : TRPFoodEntityPedido;
    FFormasPagamento     : TObjectList<TRPFoodEntityFormaPagamento>;
    LConfiguracaoFOOD    : TRPFoodEntityConfiguracaoRPFood;
    procedure PreencheEnderecosCliente;
    procedure PreencheFormasPagamento;
    procedure PreencheDadosPedido;
    procedure EnderecoLerFormulario;
    procedure TrocoConfirmar;
    procedure TrocoCancelar;
    procedure RecarregarTagValores;
    procedure AtualizaPedido;
    procedure BuscarCep(AParams: TStringList);
    procedure OnSelecionarPagamento(AParams: TStringList);
    procedure OnFinalizarPedido(AParams: TStringList);
    procedure OnAfterFinalizarPedido(AParams: TStringList);
    procedure OnSelecionarTipoEntrega(AParams: TStringList);
    procedure OnCancelarPedido(AParams: TStringList);
    procedure VerificaRetirada;
    { Private declarations }
  public
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmPedidoFinalizar.BuscarCep(AParams: TStringList);
var
  LEndereco: TRPFoodEntityEndereco;
begin
  LEndereco := FController.DAO.EnderecoDAO.Busca(IWEDTCEP.Text);
  try
    if Assigned(LEndereco) then
    begin
      IWEDTENDERECO.Text            := LEndereco.endereco;
      IWEDTBAIRRO.Text              := LEndereco.bairro;
      FEnderecoCadastro.idBairro    := LEndereco.idBairro;
      FEnderecoCadastro.bairro      := LEndereco.bairro;
      FEnderecoCadastro.taxaEntrega := LEndereco.taxaEntrega;
    end
    else
    begin
      FEnderecoCadastro.idBairro   := 0;
      FEnderecoCadastro.bairro     :='';
      FEnderecoCadastro.taxaEntrega:=0;
      MensagemErro('CEP inválido', 'CEP não existe ou não está na nossa área de cobertura!');
      IWEDTCEP.Text := EmptyStr;
      IWEDTCEP.SetFocus;
    end;
  finally
    LEndereco.Free;
  end;
end;

destructor TFrmPedidoFinalizar.Destroy;
begin
  freeAndNil(FEnderecoCadastro);
  freeAndNil(LConfiguracaoFOOD);
  inherited;
end;

procedure TFrmPedidoFinalizar.EnderecoLerFormulario;
begin
  FEnderecoCadastro.cep             := IWEDTCEP.Text;
  FEnderecoCadastro.endereco        := IWEDTENDERECO.Text;
  FEnderecoCadastro.numero          := IWEDTNUMERO.Text;
  FEnderecoCadastro.complemento     := IWEDTCOMPLEMENTO.Text;
  FEnderecoCadastro.bairro          := IWEDTBAIRRO.Text;
  FEnderecoCadastro.pontoReferencia := IWEDTREFERENCIA.Text;
end;

procedure TFrmPedidoFinalizar.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  PreencheFormasPagamento;
  PreencheDadosPedido;
  PreencheEnderecosCliente;
  VerificaRetirada;
end;

procedure TFrmPedidoFinalizar.IWAppFormAsyncPageUnloaded(Sender: TObject;EventParams: TStringList; AIsCurrent: Boolean);
begin
  inherited;
  if not AIsCurrent then
  begin
    FPedido.endereco.Assign(FClienteLogado.enderecoPadrao);
    FPedido.taxaEntrega := FClienteLogado.enderecoPadrao.taxaEntrega;
    AtualizaPedido;
  end;
end;

procedure TFrmPedidoFinalizar.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('BuscarCep', BuscarCep);
  RegisterCallBack('OnSelecionarPagamento', OnSelecionarPagamento);
  RegisterCallBack('OnFinalizarPedido', OnFinalizarPedido);
  RegisterCallBack('OnAfterFinalizarPedido', OnAfterFinalizarPedido);
  RegisterCallBack('OnSelecionarTipoEntrega', OnSelecionarTipoEntrega);
  RegisterCallBack('OnCancelarPedido', OnCancelarPedido);

  FreeAndNil(FEnderecoCadastro);
  FEnderecoCadastro     := TRPFoodEntityClienteEndereco.Create;
  FPedido               := FSessaoCliente.PedidoSessao.Pedido;
  LConfiguracaoFOOD     :=FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);
  if not Assigned(FClienteLogado) then
  begin
    WebApplication.GoToURL(ROTA_LOGIN);
    Exit;
  end;
end;

procedure TFrmPedidoFinalizar.IWAppFormShow(Sender: TObject);
begin
  inherited;
  if Assigned(FClienteLogado) then
  begin
     FPedido.taxaEntrega := FClienteLogado.enderecoPadrao.taxaEntrega;
    AtualizaPedido;
  end;
end;

procedure TFrmPedidoFinalizar.IWBTN_CANCELAR_TROCOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  TrocoCancelar;
end;

procedure TFrmPedidoFinalizar.IWBTN_CONFIRMAR_TROCOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  TrocoConfirmar;
end;

procedure TFrmPedidoFinalizar.IWEDTSELECIONAENDERECOSAsyncClick(
  Sender: TObject; EventParams: TStringList);
begin
  inherited;
    WebApplication.GoToURL(ROTA_SELECIONA_ENDERECOS);
end;

procedure TFrmPedidoFinalizar.IWOBSERVACAOAsyncChange(Sender: TObject;  EventParams: TStringList);
begin
  inherited;
  if Length(IWOBSERVACAO.Text)>100 then
  begin
    MensagemErro('Erro', 'Permitido apenas 100 caracteres!' );
    IWOBSERVACAO.Text := '';
  end;
end;

procedure TFrmPedidoFinalizar.AtualizaPedido;
var
  LComando:string;
begin
  LComando := Format('AtualizarPedido(%s)', [ObjectToJSON(FPedido)]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmPedidoFinalizar.OnSelecionarTipoEntrega(AParams: TStringList);
var
  LTipoEntrega: string;
begin
  PreencheEnderecosCliente;

  LTipoEntrega := AParams.Values['tipoRetirada'];
  FPedido.SetTipoEntrega(LTipoEntrega);

  if LTipoEntrega = 'D' then
    FPedido.endereco.Assign(FClienteLogado.enderecoPadrao);

  AtualizaPedido;
end;

procedure TFrmPedidoFinalizar.IWTemplateUnknownTag(const AName: string; var AValue: string);
var
  LValor: Currency;
begin
  inherited;
  if not Assigned(FClienteLogado) then
    Exit;
  if AName = 'ENDERECO_LOGRADOURO' then
    AValue := FPedido.endereco.enderecoCompleto
  else  if AName = 'ENDERECO_BAIRRO' then
    AValue := FPedido.endereco.bairro
  else  if AName = 'ENDERECO_EMPRESA_LOGRADOURO' then
    AValue := FSessaoCliente.Empresa.endereco.endereco
  else  if AName = 'ENDERECO_EMPRESA_NUMERO' then
    AValue := FSessaoCliente.Empresa.endereco.numero
  else  if AName = 'ENDERECO_EMPRESA_COMPLEMENTO' then
    AValue := FSessaoCliente.Empresa.endereco.complemento
  else  if AName = 'ENDERECO_EMPRESA_BAIRRO' then
    AValue := FSessaoCliente.Empresa.endereco.bairro
  else if AName = 'EMPRESA_NOME' then
    AValue := FSessaoCliente.Empresa.NOME
  else  if AName = 'EMPRESA_FONE1' then
    AValue := FSessaoCliente.Empresa.fone1
  else  if AName = 'TAXA_ENTREGA' then
    AValue := FormatCurr(',0.00', FPedido.taxaEntrega)
  else  if AName = 'VALOR_PEDIDO' then
    AValue := FormatCurr(',0.00', FPedido.ValorTotal)
  else if AName = 'VALOR_PAGO' then
  begin
    LValor   := FPedido.ValorTotal;
    if FPedido.valorAReceber > 0 then
      LValor := FPedido.valorAReceber;
    AValue   := FormatCurr(',0.00', LValor)
  end
  else
  if AName = 'VALOR_TROCO' then
    AValue := FormatCurr(',0.00', FPedido.valorTroco)
  else
  if AName = 'MODAL_VALOR_PEDIDO' then
    AValue := Format('Seu pedido deu R$ %s.', [FormatCurr(',0.00', FPedido.ValorTotal)]);
end;


procedure TFrmPedidoFinalizar.OnAfterFinalizarPedido(AParams: TStringList);
begin
  try
    Sleep(3000);
    FPedido.observacao := IWOBSERVACAO.Lines.Text.Trim;
    FController.Service.VendaService.Pedido(FPedido).Salvar;
    FSessaoCliente.PedidoSessao.InicializarPedido;
    FPedido := FSessaoCliente.PedidoSessao.Pedido;
    FHoldOn.Close(True);
    WebApplication.GoToURL(ROTA_PEDIDO_ACOMPANHAMENTO);
  except
    on E: Exception do
    begin
      FHoldOn.Close(True);
      MensagemErro('Erro ao salvar venda', E.Message);
    end;
  end;
end;

procedure TFrmPedidoFinalizar.VerificaRetirada;
begin
  if LConfiguracaoFOOD.PermiteRetiradanoLocal then
  begin
    IWLBLRETIRADA.text:='''
      <a class="nav-link" data-bs-toggle="tab" href="#tab_retirada"
      onclick="javascript:ajaxCall('OnSelecionarTipoEntrega', 'tipoRetirada=R')">
      <i class="la la-user me-2"></i>
      Retirada
      </a>

    ''' ;
  end;
end;


procedure TFrmPedidoFinalizar.OnCancelarPedido(AParams: TStringList);
begin
  Sleep(3000); // Pra simular uma demora de 3s no processamento
  FHoldOn.Close(true);
  FPedido := nil;
  FreeAndNil(FEnderecoCadastro);
  WebApplication.Terminate;
  WebApplication.GoToURL(ROTA_LOGIN);
end;

procedure TFrmPedidoFinalizar.OnFinalizarPedido(AParams: TStringList);
var
  LEmFuncionamento: Boolean;
begin
 if (LConfiguracaoFOOD.pedidoMinimo > 0) and
     ((FPedido.valorTotal - FPedido.taxaEntrega) < LConfiguracaoFOOD.pedidoMinimo) then
  begin
    MensagemErro('Opa, houve um erro',  Format('Pedido mínimo não atingido. Valor mínimo: %f', [LConfiguracaoFOOD.pedidoMinimo]));
    Exit;
  end;

  LEmFuncionamento := FController.DAO.ConfiguracaoFuncionamento.EmHorarioDeFuncionamento;
  if not LEmFuncionamento then
    FHoldOn.Text('ixee estamos fechado agora...')
      .Callback('OnCancelarPedido')
      .Show
  else
    FHoldOn.Text('Confirmando Pedido...')
      .Callback('OnAfterFinalizarPedido')
      .Show;
end;

procedure TFrmPedidoFinalizar.OnSelecionarPagamento(AParams: TStringList);
var
  LIdPagamentoSelecionado : Integer;
  LPagamento              : TRPFoodEntityFormaPagamento;
begin
  LIdPagamentoSelecionado := AParams.Values['idPagamento'].ToInteger;
  if LIdPagamentoSelecionado <> FPedido.formaPagamento.id then
  begin
    for LPagamento in FFormasPagamento do
    begin
      if LPagamento.id = LIdPagamentoSelecionado then
      begin
        FPedido.formaPagamento.Assign(LPagamento);
        IWEDT_VALOR_PAGO.Text := '0';
        FPedido.valorAReceber := 0;
        RecarregarTagValores;
        Exit;
      end;
    end;
  end;
end;

procedure TFrmPedidoFinalizar.PreencheDadosPedido;
var
  LComando: string;
begin
  LComando := Format('PreencherDadosPedido(%s)',
    [ObjectToJSON(FPedido)]);
  ExecutaJavaScript(LComando);
  IWOBSERVACAO.Lines.Text:=FPedido.observacao;
end;

procedure TFrmPedidoFinalizar.PreencheEnderecosCliente;
var
  LComando: string;
  LEnderecos: TObjectList<TRPFoodEntityClienteEndereco>;
begin
  LEnderecos := FClienteLogado.enderecos;
  LComando   := Format('AdicionarEnderecos(%s, %d)',
    [ListToJSON<TRPFoodEntityClienteEndereco>(LEnderecos), FPedido.endereco.idEndereco]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmPedidoFinalizar.PreencheFormasPagamento;
var
  LComando: string;
begin
  FFormasPagamento := FSessaoCliente.PedidoSessao.FormasDePagamento;
  LComando := Format('AdicionarPagamento(%s, %d)',
      [ListToJSON<TRPFoodEntityFormaPagamento>(FFormasPagamento), FPedido.formaPagamento.id]);

  ExecutaJavaScript(LComando);
end;

procedure TFrmPedidoFinalizar.RecarregarTagValores;
begin
  RecarregarTag('div_totais_pedido');
end;

procedure TFrmPedidoFinalizar.TrocoCancelar;
begin
  FPedido.valorAReceber := 0;
  RecarregarTagValores;
end;

procedure TFrmPedidoFinalizar.TrocoConfirmar;
var
  LValorAReceber: Currency;
begin
  LValorAReceber := StrToCurrDef(IWEDT_VALOR_PAGO.Text, 0);
  if LValorAReceber < FPedido.ValorTotal then
  begin
    MensagemErro('Ops!', 'Valor menor que o total do pedido.');
    Exit;
  end;
  FPedido.valorAReceber := LValorAReceber;
  CloseModal('modal_pede_troco');
  RecarregarTagValores;
end;

initialization
  TFrmPedidoFinalizar.SetURL('', 'pedido-finalizar.html');

end.
