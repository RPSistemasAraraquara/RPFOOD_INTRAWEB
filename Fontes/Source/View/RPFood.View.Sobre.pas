unit RPFood.View.Sobre;

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
  RPFood.Entity.Classes,
  System.JSON,
  System.Generics.Collections;

type
  TFrmSobre = class(TFrmPadrao)
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject;
      EventParams: TStringList);
  private

    procedure CarregarPagamentos;
    procedure CarregarHorarios;
    procedure TempoEntregaRetirada;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmSobre.TempoEntregaRetirada;
var
  LConfiguracao: TRPFoodEntityConfiguracaoRPFood;
  LComando: string;
begin
  LConfiguracao := FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);
  try
    LComando := Format('PreencheTempoEntrega("%d", %d);',
      [LConfiguracao.TempoRetiradaRPFood, LConfiguracao.TempoEntregaRPFood]);
    ExecutaJavaScript(LComando);
  finally
    LConfiguracao.Free;
  end;
end;

procedure TFrmSobre.CarregarHorarios;
var
  LAtendimento: TRPFoodEntityConfiguracaoAtendimento;
  LComando: string;
  LJSON: string;
begin
  LAtendimento := FController.DAO.ConfiguracaoFuncionamento.Get(FSessaoCliente.IdEmpresa);
  try
    LJSON := LAtendimento.JSONString;
    LComando := Format('PreencheHorarios(%s)', [LJSON]);
    ExecutaJavaScript(LComando);
  finally
    LAtendimento.Free;
  end;
end;

procedure TFrmSobre.CarregarPagamentos;
var
  LPagamentos: TObjectList<TRPFoodEntityFormaPagamento>;
  LComando: string;
  LJSON: string;
begin
  LPagamentos := FSessaoCliente.PedidoSessao.FormasDePagamento;
  LJSON := FController.Components.JSON
    .ToJSONString<TRPFoodEntityFormaPagamento>(LPagamentos);
  LComando := Format('PreenchePagamentos(%s)', [LJSON]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmSobre.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  CarregarPagamentos;
  CarregarHorarios;
  TempoEntregaRetirada;
end;

procedure TFrmSobre.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  inherited;
  if AName = 'EMPRESA_NOME' then
    AValue := FSessaoCliente.Empresa.nome
  else
  if AName = 'ENDERECO_EMPRESA_LOGRADOURO' then
    AValue := FSessaoCliente.Empresa.endereco.endereco
  else
  if AName = 'ENDERECO_EMPRESA_NUMERO' then
    AValue := FSessaoCliente.Empresa.endereco.numero
  else
  if AName = 'ENDERECO_EMPRESA_BAIRRO' then
    AValue := FSessaoCliente.Empresa.endereco.bairro
  else
  if AName = 'ENDERECO_EMPRESA_COMPLEMENTO' then
    AValue := FSessaoCliente.Empresa.endereco.complemento
  else
  if AName = 'ENDERECO_EMPRESA_FONE1' then
    AValue := FSessaoCliente.Empresa.fone1;
end;

initialization
  TFrmSobre.SetURL('', 'sobre.html')

end.
