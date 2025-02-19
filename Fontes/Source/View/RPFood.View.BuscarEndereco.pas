unit RPFood.View.BuscarEndereco;

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
  IWCompLabel,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  System.Generics.Collections,
  RPFood.Entity.Classes,
  RPFood.View.Rotas;

type
  TFrmBuscarEndereco = class(TFrmPadrao)
    IWEDTENDERECO        : TIWEdit;
    IWLBLENDERECO        : TIWLabelEx;
    IWEDTNUMERO          : TIWEdit;
    IWLBLNUMERO          : TIWLabelEx;
    IWEDTBAIRRO          : TIWEdit;
    IWLBLBAIRRO          : TIWLabel;
    IWEDTTAXA            : TIWEdit;
    IWLBLTAXA            : TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
  private
     FEndereco          : TRPFoodEntityClienteEndereco;
     LEnderecoDoPedido  : TRPFoodEntityClienteEndereco;
     LBairro            : TRPFoodEntityBairro;
     procedure PreencheEnderecos;
     procedure OnClickSelecionaEndereco(AParams:TStringList);
     procedure PreencheFormulario;
  public
    { Public declarations }
  end;

var
  FrmBuscarEndereco: TFrmBuscarEndereco;

implementation

{$R *.dfm}

procedure TFrmBuscarEndereco.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  PreencheEnderecos;
end;

procedure TFrmBuscarEndereco.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  FreeAndNil(FEndereco);
  FEndereco := TRPFoodEntityClienteEndereco.Create;
  RegisterCallBack('OnClickSelecionaEndereco', OnClickSelecionaEndereco);
end;

procedure TFrmBuscarEndereco.IWAppFormDestroy(Sender: TObject);
begin
  FEndereco.Free;
  inherited;
end;

procedure TFrmBuscarEndereco.OnClickSelecionaEndereco(AParams: TStringList);
var
  LIdEnderecoSelecionado: Integer;
begin
  LEnderecoDoPedido       := FSessaoCliente.PedidoSessao.Pedido.endereco;
  LIdEnderecoSelecionado := StrToIntDef(AParams.Values['idEndereco'], 0);

  LEnderecoDoPedido.Assign(FClienteLogado.GetEndereco(LIdEnderecoSelecionado));
  LBairro:=FController.DAO.BairroDAO.CarregaBairro(LEnderecoDoPedido.idBairro);
  try
    FClienteLogado.enderecoPadrao.taxaEntrega:=LBairro.taxa;
  finally
    LBairro.Free;
  end;
  WebApplication.GoToURL(ROTA_PEDIDO_FINALIZAR);
end;

procedure TFrmBuscarEndereco.PreencheEnderecos;
var
  LEnderecos: TObjectList<TRPFoodEntityClienteEndereco>;
  LComando: string;
begin
  LEnderecos := FClienteLogado.enderecos;
  LComando   := Format('PreencheEnderecos(%s);', [ListToJSON<TRPFoodEntityClienteEndereco>(LEnderecos)]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmBuscarEndereco.PreencheFormulario;
begin
  IWEDTENDERECO.Text           := FEndereco.endereco;
  IWEDTNUMERO.Text             := FEndereco.numero;
  IWEDTBAIRRO.Text             := FEndereco.bairro;
  IWEDTTAXA.AsFloat            := FEndereco.taxaEntrega;
end;

initialization
  TFrmBuscarEndereco.SetURL('','cliente.enderecos.html') ;

end.
