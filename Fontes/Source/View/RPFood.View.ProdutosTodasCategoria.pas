unit RPFood.View.ProdutosTodasCategoria;

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
  IWCompEdit,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompButton,
  RPFood.Entity.Classes,
  RPFood.View.Rotas,
  System.Generics.Collections,
  System.Generics.Defaults;


  type
  TFrmProdutostodascategoria = class(TFrmPadrao)
    IWBTN_VOLTAR: TIWButton;
    IWEDT_FILTRO: TIWEdit;
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWBTN_VOLTARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDT_FILTROAsyncKeyDown(Sender: TObject;EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
  private
    FProdutos: TObjectList<TRPFoodEntityProduto>;
    FCategoriasFiltradas: TObjectList<TRPFoodEntityCategoria>;
    FCategorias: TObjectList<TRPFoodEntityCategoria>;
    FProdutosFiltrados: TObjectList<TRPFoodEntityProduto>;
    procedure PreencheCategoria;
    procedure CarregarCategoria;
    procedure FiltrarCategoria;
    procedure OnClickCategoria(AParams: TStringList);
    procedure OnClickProduto(AParams: TStringList);
    procedure PreencheProdutos;

    procedure CarregarProdutos;
    procedure FiltrarProdutos;
  public
   destructor Destroy; override;
    { Public declarations }
  end;

var
  FrmProdutostodascategoria: TFrmProdutostodascategoria;

implementation

{$R *.dfm}

{ TFrmProdutosTodasCategoria }

procedure TFrmProdutostodascategoria.CarregarCategoria;
var
  LCategoria: TRPFoodEntityCategoria;
begin
  FreeAndNil(FCategorias);
  FCategorias := FController.DAO.CategoriaDAO.Listar(FSessaoCliente.IdEmpresa);

  for LCategoria in FCategorias do
  begin
    FController.Service.ImagemService
      .Objeto(LCategoria)
      .IdEmpresa(FSessaoCliente.IdEmpresa)
      .Carregar;
  end;
  FiltrarCategoria;
end;

procedure TFrmProdutostodascategoria.CarregarProdutos;
var
  LProduto: TRPFoodEntityProduto;
begin
 if not Assigned(FProdutos) then
  FProdutos := FController.DAO.ProdutoDAO.BuscarTodosProdutos(FSessaoCliente.IdEmpresa);

  for LProduto in FProdutos do
  begin
    FController.Service.ImagemService
      .Objeto(LProduto)
      .IdEmpresa(FSessaoCliente.IdEmpresa)
      .Carregar;
  end;
  FiltrarProdutos;
end;

destructor TFrmProdutostodascategoria.Destroy;
begin
  FreeAndNil(FProdutos);
  FreeAndNil(FCategoriasFiltradas);
  FreeAndNil(FCategorias);
  FreeAndNil(FProdutosFiltrados);
  inherited;
end;

procedure TFrmProdutostodascategoria.FiltrarCategoria;
var
  LFiltro: string;
  LCategoria: TRPFoodEntityCategoria;
begin
   if not Assigned(FCategoriasFiltradas) then
    FCategoriasFiltradas := TObjectList<TRPFoodEntityCategoria>.Create(False);
  FCategoriasFiltradas.Clear;
  LFiltro := Trim(IWEDT_FILTRO.Text);
  for LCategoria in FCategorias do
  begin
    if (LFiltro = EmptyStr) or
      (LCategoria.descricao.ToLower.Contains(LFiltro.ToLower)) then
      FCategoriasFiltradas.Add(LCategoria);
  end;
end;

procedure TFrmProdutostodascategoria.FiltrarProdutos;
var
  LFiltro: string;
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

procedure TFrmProdutostodascategoria.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  CarregarCategoria;
  PreencheCategoria;
  CarregarProdutos;
  PreencheProdutos;
end;

procedure TFrmProdutostodascategoria.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('OnClickCategoria', OnClickCategoria);
  RegisterCallBack('OnClickProduto', OnClickProduto);
end;

procedure TFrmProdutostodascategoria.IWBTN_VOLTARAsyncClick(Sender: TObject;EventParams: TStringList);
begin
  inherited;
  Release;
end;

procedure TFrmProdutostodascategoria.IWEDT_FILTROAsyncKeyDown(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  FiltrarCategoria;
  PreencheCategoria;
  FiltrarProdutos;
  PreencheProdutos;
end;

procedure TFrmProdutostodascategoria.OnClickCategoria(AParams: TStringList);
var
  LIdCategoria: Integer;
begin
  LIdCategoria                := AParams.Values['idCategoria'].ToInteger;
  FSessaoCliente.IdCategoria  := LIdCategoria;
  WebApplication.GoToURL(ROTA_PRODUTO_POR_CATEGORIA);
end;

procedure TFrmProdutostodascategoria.OnClickProduto(AParams: TStringList);
var
  LIdProduto: Integer;
begin
  LIdProduto := AParams.Values['idProduto'].ToInteger;
  FSessaoCliente.PedidoSessao.AdicionarProduto(LIdProduto, WebApplication);
  Release;
end;

procedure TFrmProdutostodascategoria.PreencheCategoria;
var
  LComando: string;
  LJSON: string;
begin
  LJSON := '[]';
  if Assigned(FCategoriasFiltradas) then
  LJSON := FController.Components.JSON
    .ToJSONString<TRPFoodEntityCategoria>(FCategoriasFiltradas);

  LComando := Format('AdicionarCategoria(%s);', [LJSON]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmProdutostodascategoria.PreencheProdutos;
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
  TFrmProdutostodascategoria.SetURL('', 'produtostodascategoria.html')

end.
