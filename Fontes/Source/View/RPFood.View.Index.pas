 unit RPFood.View.Index;

interface

uses
  System.Classes,
  System.JSON,
  Vcl.Controls,
  Vcl.Forms,
  RPFood.View.Padrao,
  RPFood.Entity.Classes,
  RPFood.View.PedidoDetalheItem,
  RPFood.View.Rotas,
  System.Generics.Collections,
  IWLayoutMgrHTML,
  IWVCLBaseContainer,
  IWContainer,
  IWVCLComponent,
  IW.Content.Form,
  IW.Content.Handlers,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompExtCtrls,
  IWCompEdit,
  IWCompLabel,
  IWCompButton,
  IWHTMLControls,
  IWHTMLTag;

type
  TFrmIndex = class(TFrmPadrao)
    IWEDT_FILTRO: TIWEdit;

    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    FPedido: TRPFoodEntityPedido;
    FProdutosFiltrados: TObjectList<TRPFoodEntityProduto>;
    FProdutos: TObjectList<TRPFoodEntityProduto>;
    LConfiguracaoFOOD    : TRPFoodEntityConfiguracaoRPFood;
    procedure PreencheCategorias;
    procedure PreencheItens;
    procedure PreencheProdutosDestaque;
    procedure OnClickCategoria(AParams: TStringList);
    procedure OnClickDestaque(AParams: TStringList);
    procedure OnEditarItemPedido(AParams: TStringList);
    procedure OnFinalizarPedido(AParams: TStringList);
    procedure OnAfterFinalizarPedido(AParams: TStringList);
    procedure OnClickProd(AParams: TStringList);

    // Quantidades
    procedure OnItemSubtrairQuantidade(AParams: TStrings; out AResult: string);
    procedure OnItemAdicionarQuantidade(AParams: TStrings; out AResult: string);
    procedure OnOpcionalSubtrairQuantidade(AParams: TStrings; out AResult: string);
    procedure OnOpcionalAdicionarQuantidade(AParams: TStrings; out AResult: string);
    procedure InicializarNovaVenda;

    procedure CarregarProdutos;
    procedure PreencheProdutos;
    procedure FiltrarProdutos;

  end;

implementation

uses
  System.SysUtils;

{$R *.dfm}

{ TFrmVenda }

procedure TFrmIndex.OnFinalizarPedido(AParams: TStringList);
begin
  if FPedido.itens.Count <= 0 then
    MensagemErroGrowl('Uaii!', 'Bora procurar um item.')
  else
  begin
    if Assigned(FClienteLogado) then
      FSessaoCliente.PedidoSessao.Cliente(FClienteLogado);
    WebApplication.GoToURL(ROTA_PEDIDO_FINALIZAR);
  end;
end;

procedure TFrmIndex.InicializarNovaVenda;
begin
  FSessaoCliente.PedidoSessao.InicializarPedido;
end;

procedure TFrmIndex.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  PreencheCategorias;
  PreencheItens;
  PreencheProdutosDestaque;
  CarregarProdutos;
  PreencheProdutos;
  FPedido := FSessaoCliente.PedidoSessao.Pedido;
end;

procedure TFrmIndex.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  FPedido := FSessaoCliente.PedidoSessao.Pedido;
  LConfiguracaoFOOD     :=FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);
  RegisterCallBack('OnClickCategoria', OnClickCategoria);
  RegisterCallBack('OnClickDestaque', OnClickDestaque);
  RegisterCallBack('OnEditarItemPedido', OnEditarItemPedido);
  RegisterCallBack('OnFinalizarPedido', OnFinalizarPedido);
  RegisterCallBack('OnAfterFinalizarPedido', OnAfterFinalizarPedido);
  RegisterCallBack('OnItemAdicionarQuantidade', OnItemAdicionarQuantidade);
  RegisterCallBack('OnItemSubtrairQuantidade', OnItemSubtrairQuantidade);
  RegisterCallBack('OnOpcionalAdicionarQuantidade', OnOpcionalAdicionarQuantidade);
  RegisterCallBack('OnOpcionalSubtrairQuantidade', OnOpcionalSubtrairQuantidade);
  RegisterCallBack('OnClickProd', OnClickProd);
end;

procedure TFrmIndex.IWAppFormDestroy(Sender: TObject);
begin
  FreeAndNil(FProdutos);
  FreeAndNil(FProdutosFiltrados);
  FreeAndNil(LConfiguracaoFOOD);
  inherited;
end;

procedure TFrmIndex.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  inherited;
  if not Assigned(FClienteLogado) then
    Exit;

  if AName = 'ENDERECO_BAIRRO' then
    AValue := FSessaoCliente.ClienteLogado.enderecoPadrao.bairro
  else if AName = 'ENDERECO_LOGRADOURO' then
    AValue := FSessaoCliente.ClienteLogado.enderecoPadrao.enderecoCompleto
  else if AName = 'TAXA_ENTREGA' then
    AValue := FormatCurr('R$ ,0.00', FPedido.taxaEntrega)
  else if AName = 'PEDIDO_VALOR_TOTAL' then
    AValue := FormatCurr('R$ ,0.00', FPedido.ValorTotal)
  else if AName='ENDERECO_CEP' then
    AValue:=FPedido.endereco.cep
  else if AName='ENDERECO_bairro' then
    AValue:=FPedido.endereco.bairro
  else   if AName = 'QTDEITENS' then
    AValue :=FormatCurr('0',  FPedido.quantidadeItensVendidos);
end;

procedure TFrmIndex.OnItemAdicionarQuantidade(AParams: TStrings; out AResult: string);
var
  LIndex: Integer;
  LItem: TRPFoodEntityPedidoItem;
begin
  LIndex := AParams.Values['Index'].ToInteger;
  LItem := FPedido.itens[LIndex];
  LItem.quantidade := LItem.quantidade + 1;
  AResult := ObjectToJSON(FPedido);
end;

procedure TFrmIndex.OnOpcionalAdicionarQuantidade(AParams: TStrings; out AResult: string);
var
  LIndexItem: Integer;
  LIndexOpcional: Integer;
begin
  LIndexItem := AParams.Values['IndexItem'].ToInteger;
  LIndexOpcional := AParams.Values['IndexOpcional'].ToInteger;

  FPedido.itens[LIndexItem].opcionais[LIndexOpcional].quantidade :=
    FPedido.itens[LIndexItem].opcionais[LIndexOpcional].quantidade + 1;

  AResult := ObjectToJSON(FPedido);
end;

procedure TFrmIndex.OnAfterFinalizarPedido(AParams: TStringList);
begin
  FreeAndNil(FPedido);
  InicializarNovaVenda;
  RecarregarPagina;
end;

procedure TFrmIndex.OnClickCategoria(AParams: TStringList);
var
  LCategoria: Integer;
begin
  LCategoria := AParams.Values['idCategoria'].ToInteger;
  FSessaoCliente.IdCategoria := LCategoria;
  WebApplication.GoToURL(ROTA_PRODUTO_POR_CATEGORIA);
end;

procedure TFrmIndex.OnClickDestaque(AParams: TStringList);
var
  LIdProduto: Integer;
begin
  LIdProduto := AParams.Values['idProduto'].ToInteger;
  FSessaoCliente.PedidoSessao.AdicionarProduto(LIdProduto, WebApplication);
end;

procedure TFrmIndex.OnClickProd(AParams: TStringList);
var
  LIdProduto: Integer;
begin
  LIdProduto := AParams.Values['idProduto'].ToInteger;
  FSessaoCliente.PedidoSessao.AdicionarProduto(LIdProduto, WebApplication);
end;

procedure TFrmIndex.OnEditarItemPedido(AParams: TStringList);
var
  LIndex      : Integer;
  LItemPedido : TRPFoodEntityPedidoItem;
  LForm       : TFrmPedidoDetalheItem;
begin
  LIndex      := AParams.Values['index'].ToInteger;
  LItemPedido := FPedido.itens[LIndex];
  LForm       := TFrmPedidoDetalheItem.Create(WebApplication);
  LForm.SetPedido(FPedido);
  LForm.SetItemPedido(LItemPedido);
  WebApplication.GoToURL(ROTA_PEDIDO_DETALHE_ITEM);
end;

procedure TFrmIndex.OnItemSubtrairQuantidade(AParams: TStrings; out AResult: string);
var
  LIndex: Integer;
begin
  LIndex := AParams.Values['index'].ToInteger;
  FPedido.itens[LIndex].quantidade := FPedido.itens[LIndex].quantidade - 1;
  if FPedido.itens[LIndex].quantidade <= 0 then
    FPedido.itens.ExtractAt(LIndex).Free;
  AResult := ObjectToJSON(FPedido);
end;

procedure TFrmIndex.OnOpcionalSubtrairQuantidade(AParams: TStrings; out AResult: string);
var
  LIndexItem: Integer;
  LIndexOpcional: Integer;
begin
  LIndexItem := AParams.Values['IndexItem'].ToInteger;
  LIndexOpcional := AParams.Values['IndexOpcional'].ToInteger;

  FPedido.itens[LIndexItem].opcionais[LIndexOpcional].quantidade :=
    FPedido.itens[LIndexItem].opcionais[LIndexOpcional].quantidade - 1;

  // Remover o opcional da lista caso não tenha quantidade
  if FPedido.itens[LIndexItem].opcionais[LIndexOpcional].quantidade <= 0 then
    FPedido.itens[LIndexItem].opcionais.ExtractAt(LIndexOpcional).Free;

  AResult := ObjectToJSON(FPedido);
end;

procedure TFrmIndex.PreencheCategorias;
var
  LCategorias: TObjectList<TRPFoodEntityCategoria>;
  LComando: string;
begin
  LCategorias := FSessaoCliente.PedidoSessao.Categorias;
  LComando := Format('AdicionarCategoria(%s)',
    [ListToJSON<TRPFoodEntityCategoria>(LCategorias)]);
  ExecutaJavaScript(LComando);
end;

procedure TFrmIndex.PreencheProdutos;
var
  LComando: string;
  LJSON: string;
  LCategoria: TRPFoodEntityCategoria;
  LProduto: TRPFoodEntityProduto;
  LCategorias: TObjectList<TRPFoodEntityCategoria>;
  LJSONCategorias: TJSONArray;
  LJSONCategoria: TJSONObject;
  LJSONProduto: TJSONObject;
  LJSONProdutos: TJSONArray;
begin
  LJSONCategorias := TJSONArray.Create;
  try
    LCategorias := TObjectList<TRPFoodEntityCategoria>.Create(False);
    try
      for LCategoria in FSessaoCliente.PedidoSessao.Categorias do
      begin
        for LProduto in FProdutosFiltrados do
        begin
          if LProduto.idGrupo = LCategoria.codigo then
          begin
            LCategorias.Add(LCategoria);
            Break;
          end;
        end;
      end;

      for LCategoria in LCategorias do
      begin
        LJSONProdutos := nil;
        LJSONCategoria := TJSONObject.Create;
        LJSONCategoria.AddPair('codigo', TJSONNumber.Create(LCategoria.codigo))
          .AddPair('descricao', LCategoria.descricao);
        LJSONCategorias.AddElement(LJSONCategoria);
        for LProduto in FProdutosFiltrados do
        begin
          if LProduto.idGrupo = LCategoria.codigo then
          begin
            if not Assigned(LJSONProdutos) then
            begin
              LJSONProdutos := TJSONArray.Create;
              LJSONCategoria.AddPair('produtos', LJSONProdutos);
            end;
            LJSONProduto := FController.Components.JSON.ToJSONObject(LProduto);
            LJSONProdutos.AddElement(LJSONProduto);
          end;
        end;
      end;
    finally
      LCategorias.Free;
    end;

    LJSON := LJSONCategorias.ToString;
    LComando := Format('AdicionarProduto(%s);', [LJSON]);
    ExecutaJavaScript(LComando);
  finally
    LJSONCategorias.Free;
  end;
end;



procedure TFrmIndex.PreencheProdutosDestaque;
var
  LDestaque : TRPFoodEntityProduto;
  LComando  : string;
  I:Integer;
begin
  FreeAndNil(FProdutos);

  if not Assigned(FProdutos) then
    FProdutos := FController.DAO.ProdutoDAO.ListaDestaques(FSessaoCliente.IdEmpresa);

  for I := Pred(FProdutos.Count) downto 0 do
  begin
    LDestaque:=FProdutos[I];
    if LDestaque.restricao.DiaDeRestricao then
      FProdutos.ExtractAt(I).Free
    else
    begin
      LComando := 'AdicionarProdutoDestaque(''%d'', ''%s'', ''%s'')';
      LComando := Format(LComando, [LDestaque.codigo,LDestaque.descricao,LDestaque.caminhoHtmlImagem]);
      ExecutaJavaScript(LComando);
    end;
  end;
end;

procedure TFrmIndex.CarregarProdutos;
var
  LProduto: TRPFoodEntityProduto;
  LCategoria: TRPFoodEntityCategoria;
  LProdutosCategoria: TObjectList<TRPFoodEntityProduto>;
  LCategorias: TObjectList<TRPFoodEntityCategoria>;
  I: Integer;
begin
  FreeAndNil(FProdutos);
  FProdutos := TObjectList<TRPFoodEntityProduto>.Create(True);

  LCategorias := FController.DAO.CategoriaDAO.Listar(FSessaoCliente.IdEmpresa);
  try
    for LCategoria in LCategorias do
    begin
      LProdutosCategoria := FController.DAO.ProdutoDAO.Listar(FSessaoCliente.IdEmpresa, LCategoria.codigo);
      try
        for I := Pred(LProdutosCategoria.Count) downto 0 do
        begin
          LProduto := LProdutosCategoria[I];
          if LProduto.restricao.DiaDeRestricao then
            LProdutosCategoria.ExtractAt(I).Free
          else
          begin
            FController.Service.ImagemService
              .Objeto(LProduto)
              .IdEmpresa(FSessaoCliente.IdEmpresa)
              .Carregar;

            // Move o produto para FProdutos
            FProdutos.Add(LProdutosCategoria.ExtractAt(I));
          end;
        end;
      finally
        FreeAndNil(LProdutosCategoria);
      end;
    end;
  finally
    FreeAndNil(LCategorias);
  end;
  FiltrarProdutos;
end;

procedure TFrmIndex.FiltrarProdutos;
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
    if (LFiltro = EmptyStr) or (LProduto.descricao.ToLower.Contains(LFiltro.ToLower)) then
      FProdutosFiltrados.Add(LProduto);
  end;
end;

procedure TFrmIndex.PreencheItens;
var
  LComando: string;
begin
  if FPedido.itens.Count > 0 then
  begin
    LComando := Format('AdicionarItensDoPedido(%s)',
      [ListToJSON<TRPFoodEntityPedidoItem>(FPedido.itens)]);
    ExecutaJavaScript(LComando);
  end;
end;

initialization
  TFrmIndex.SetAsMainForm;
  TFrmIndex.SetURL('', 'index.html');
  THandlers.AddStartHandler('', 'index.html', TContentForm.Create(TFrmIndex));
  THandlers.AddRootHandler('', 'index.html', TContentForm.Create(TFrmIndex));

end.
