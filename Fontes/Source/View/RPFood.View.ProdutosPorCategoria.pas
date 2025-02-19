unit RPFood.View.ProdutosPorCategoria;

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
  RPFood.View.Rotas,
  System.Generics.Collections,
  System.Generics.Defaults,
  IWLayoutMgrHTML,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  IWCompButton,
  IWHTMLControls;

type
  TFrmProdutosPorCategoria = class(TFrmPadrao)
    IWEDT_FILTRO: TIWEdit;
    IWBTN_VOLTAR: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWEDT_FILTROAsyncKeyDown(Sender: TObject; EventParams: TStringList);
    procedure IWBTN_VOLTARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
  private
    FProdutos: TObjectList<TRPFoodEntityProduto>;
    FProdutosFiltrados: TObjectList<TRPFoodEntityProduto>;
    procedure PreencheProdutos;
    procedure CarregarProdutos;
    procedure FiltrarProdutos;
    procedure OnClickProduto(AParams: TStringList);
  public
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrmProdutosPorCategoria }

procedure TFrmProdutosPorCategoria.CarregarProdutos;
var
  LProduto: TRPFoodEntityProduto;
  I: Integer;
begin
  FreeAndNil(FProdutos);
  FProdutos := FController.DAO.ProdutoDAO.Listar(FSessaoCliente.IdEmpresa, FSessaoCliente.idCategoria);

  for I := Pred(FProdutos.Count) downto 0 do
  begin
    LProduto:=FProdutos[I];
    if LProduto.restricao.DiaDeRestricao then
     FProdutos.ExtractAt(I).Free
     else
      FController.Service.ImagemService
      .Objeto(LProduto)
      .IdEmpresa(FSessaoCliente.IdEmpresa)
      .Carregar;
  end;
  FiltrarProdutos;
end;

destructor TFrmProdutosPorCategoria.Destroy;
begin
  FreeAndNil(FProdutos);
  FreeAndNil(FProdutosFiltrados);
  inherited;
end;

procedure TFrmProdutosPorCategoria.FiltrarProdutos;
var
  LFiltro : string;
  LProduto: TRPFoodEntityProduto;
begin
  if not Assigned(FProdutosFiltrados) then
    FProdutosFiltrados := TObjectList<TRPFoodEntityProduto>.Create(False);
  FProdutosFiltrados.Clear;
  LFiltro := Trim(IWEDT_FILTRO.Text);
  for LProduto in FProdutos do
  begin
    if (LFiltro = EmptyStr) or
      (LProduto.descricao.ToLower.Contains(LFiltro.ToLower)) then
      FProdutosFiltrados.Add(LProduto);
  end;
end;

procedure TFrmProdutosPorCategoria.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  CarregarProdutos;
  PreencheProdutos;
end;

procedure TFrmProdutosPorCategoria.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('OnClickProduto', OnClickProduto);
end;

procedure TFrmProdutosPorCategoria.IWBTN_VOLTARAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  Release;
end;

procedure TFrmProdutosPorCategoria.IWEDT_FILTROAsyncKeyDown(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  FiltrarProdutos;
  PreencheProdutos;
end;

procedure TFrmProdutosPorCategoria.OnClickProduto(AParams: TStringList);
var
  LIdProduto: Integer;
begin
  LIdProduto := AParams.Values['idProduto'].ToInteger;

  if LIdProduto>0 then
  FSessaoCliente.PedidoSessao.AdicionarProduto(LIdProduto, WebApplication);
  Release;
end;

procedure TFrmProdutosPorCategoria.PreencheProdutos;
var
  LComando: string;
  LJSON: string;
begin
  LJSON := '[]';
  if Assigned(FProdutosFiltrados) then
    LJSON := FController.Components.JSON
      .ToJSONString<TRPFoodEntityProduto>(FProdutosFiltrados);

  LComando := Format('AdicionarProduto(%s);', [LJSON]);
  ExecutaJavaScript(LComando);
end;

initialization
  TFrmProdutosPorCategoria.SetURL('', 'produto-por-categoria.html')

end.
