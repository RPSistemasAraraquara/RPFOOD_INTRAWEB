unit RPFood.View.PedidoDetalheItem;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  RPFood.View.Padrao,
  RPFood.View.Rotas,
  IWHTMLTag,
  System.Generics.Collections,
  System.StrUtils,
  RPFood.Entity.Classes,
  IWCompExtCtrls,
  IWCompEdit,
  IWLayoutMgrHTML,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  IWVCLBaseContainer,
  IWContainer,
  IWHTMLContainer,
  IWHTML40Container,
  IWRegion,
  IWHTMLControls,
  IWCompLabel,
  IWCompButton;


type
  TFrmPedidoDetalheItem = class(TFrmPadrao)
    IWIMAGEM_PRODUTO                  : TIWImage;
    IWEDTOBSERVACAO                   : TIWEdit;
    IWEDT_FRACAO_PRINCIPAL_QUANTIDADE : TIWEdit;
    IWEDT_QUANTIDADE_ITEM             : TIWEdit;
    IWIMAGEM_TESTE                    : TIWEdit;
    procedure IWTemplateUnknownTag(const AName: string; var AValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
    procedure IWEDT_QUANTIDADE_ITEMAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure IWTAMANHO_SELECIONADOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDT_FRACAO_PRINCIPAL_QUANTIDADEAsyncClick(Sender: TObject;  EventParams: TStringList);
  private
    FPedido             : TRPFoodEntityPedido;
    FItemPedido         : TRPFoodEntityPedidoItem;
    FOpcionais          : TObjectList<TRPFoodEntityProdutoOpcional>;
    FProdutosFracao     : TObjectList<TRPFoodEntityProduto>;
    FConfiguracaoRPFood : TRPFoodEntityConfiguracaoRPFood;

    procedure PreencheFracoes;
    procedure PreencheOpcionais;
    procedure PreencheTamanhos;

    function GetQuantidadeOpcional(ACodigo: Integer): Integer;
    function GetValorOpcional(AOpcional: TRPFoodEntityOpcional): Currency;

    // Opcionais
    procedure OnAdicionarOpcional(AParams: TStrings; out AResult: string);
    procedure OnSubtrairOpcional(AParams: TStrings; out AResult: string);

    // Fracoes
    procedure OnAdicionarFracao(AParams: TStrings; out AResult: string);
    procedure OnSubtrairFracao(AParams: TStrings; out AResult: string);

    procedure OnClickConfirmar(AParams: TStringList);
    procedure OnClickDescartar(AParams: TStringList);
    procedure OnClickTamanho(AParams: TStringList);

    procedure AtualizarDivPreco;
    procedure AtualizarItensComponente;
    procedure CarregaImagemDoItem;

    { Private declarations }
  public
    destructor Destroy; override;
    procedure SetPedido(AValue: TRPFoodEntityPedido);
    procedure SetItemPedido(AValue: TRPFoodEntityPedidoItem);

    { Public declarations }
  end;

var
  FrmPedidoDetalheItem: TFrmPedidoDetalheItem;

implementation

{$R *.dfm}

function TFrmPedidoDetalheItem.GetQuantidadeOpcional(ACodigo: Integer): Integer;
var
  LItemOpcional: TRPFoodEntityPedidoItemOpcional;
begin
  Result        := 0;
  LItemOpcional := FItemPedido.GetOpcional(ACodigo);
  if Assigned(LItemOpcional) then
    Result := LItemOpcional.quantidade;
end;

function TFrmPedidoDetalheItem.GetValorOpcional(AOpcional: TRPFoodEntityOpcional): Currency;
begin
  Result := AOpcional.Valor;
//  if (FItemPedido.produto.vendaPorTamanho) and (FItemPedido.tamanho <> EmptyStr) then
//    Result := AOpcional.ValorPorTamanho(FItemPedido.tamanho);
end;

procedure TFrmPedidoDetalheItem.IWAppFormAsyncPageLoaded(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  PreencheTamanhos;
  PreencheOpcionais;
  PreencheFracoes;
end;

procedure TFrmPedidoDetalheItem.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  RegisterCallBack('OnAdicionarFracao', OnAdicionarFracao);
  RegisterCallBack('OnSubtrairFracao', OnSubtrairFracao);
  RegisterCallBack('OnAdicionarOpcional', OnAdicionarOpcional);
  RegisterCallBack('OnSubtrairOpcional', OnSubtrairOpcional);
  RegisterCallBack('OnClickConfirmar', OnClickConfirmar);
  RegisterCallBack('OnClickDescartar', OnClickDescartar);
  RegisterCallBack('OnClickTamanho', OnClickTamanho);

end;

procedure TFrmPedidoDetalheItem.IWEDT_FRACAO_PRINCIPAL_QUANTIDADEAsyncClick(Sender: TObject; EventParams: TStringList);
var
  LQuantidade: Integer;
begin
  inherited;
  LQuantidade := StrToIntDef(IWEDT_FRACAO_PRINCIPAL_QUANTIDADE.Text,1);
  if LQuantidade > 0 then
    IWEDT_FRACAO_PRINCIPAL_QUANTIDADE.Text := '1';
end;

procedure TFrmPedidoDetalheItem.IWEDT_QUANTIDADE_ITEMAsyncChange(Sender: TObject; EventParams: TStringList);
var
  LQuantidade: Integer;
begin
  inherited;
  LQuantidade := StrToIntDef(IWEDT_QUANTIDADE_ITEM.Text, 1);
  if LQuantidade <= 0 then
  begin
    LQuantidade := 1;
    IWEDT_QUANTIDADE_ITEM.Text := '1';
  end;
  FItemPedido.quantidade := LQuantidade;
  AtualizarDivPreco;
end;

procedure TFrmPedidoDetalheItem.IWTAMANHO_SELECIONADOAsyncClick(Sender: TObject;EventParams: TStringList);
begin
  inherited;
   WebApplication.GoToURL(ROTA_INDEX);
end;

procedure TFrmPedidoDetalheItem.IWTemplateUnknownTag(const AName: string; var AValue: string);
begin
  inherited;
  if AName = 'TITULO_PRODUTO' then
    AValue := FItemPedido.produto.descricao
  else if AName = 'OBSERVACAO' then
    AValue := FItemPedido.produto.observacao
  else  if AName = 'VALOR_TOTAL' then
    AValue := FormatCurr('R$ ,0.00', FItemPedido.ValorTotal)
  else if AName = 'QTDEITENS' then
    AValue := FormatCurr('0',  FPedido.quantidadeItensVendidos);
end;

procedure TFrmPedidoDetalheItem.OnAdicionarFracao(AParams: TStrings; out AResult: string);
var
  LCodigoFracao : Integer;
  LItemFracao   : TRPFoodEntityPedidoItemFracao;
  LProdutoFracao: TRPFoodEntityProduto;
begin
  AResult := '0';
  LCodigoFracao := AParams.Values['IdProduto'].ToInteger;
  LItemFracao := FItemPedido.GetFracao(LCodigoFracao);
  if (Assigned(LItemFracao)) then
    AResult := '1'
  else
  begin
    if FItemPedido.fracoes.Count < 3 then
    begin
      LProdutoFracao := FController.DAO.ProdutoDAO.Buscar(FSessaoCliente.IdEmpresa, LCodigoFracao);
      try
        FItemPedido.AddFracao(LProdutoFracao);
        IWEDT_FRACAO_PRINCIPAL_QUANTIDADE.Text := FItemPedido.QuantidadeFracaoPrincipal.ToString;
        AResult := '1';
      finally
        LProdutoFracao.Free;
      end;
    end;
  end;
    AtualizarDivPreco;
end;

procedure TFrmPedidoDetalheItem.OnAdicionarOpcional(AParams: TStrings; out AResult: string);
var
  LCodigoOpcional: Integer;
  LItemOpcional  : TRPFoodEntityPedidoItemOpcional;
  LOpcional      : TRPFoodEntityOpcional;
  LQuantidadeOPC:Integer;
begin
  LCodigoOpcional := AParams.Values['IdProduto'].ToInteger;
  LItemOpcional := FItemPedido.GetOpcional(LCodigoOpcional);
  FConfiguracaoRPFood:=FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);

  if (FConfiguracaoRPFood.utilizacontroleopcionais) and (FItemPedido.produto.OpcionalMaximo>0) then
  begin
    LQuantidadeOPC:= FItemPedido.QuantidadeOpcionais+1;
     if LQuantidadeOPC> FItemPedido.produto.OpcionalMaximo then
     begin
      MensagemErro('Erro', 'Quantidade de opcional excedido.');
      Exit;
     end;
  end;

  if Assigned(LItemOpcional) then
  begin
    LItemOpcional.quantidade := LItemOpcional.quantidade + 1;
    AResult                  := LItemOpcional.quantidade.ToString;
  end
  else
  begin
    LOpcional := FController.DAO.OpcionalDAO.Buscar(FSessaoCliente.IdEmpresa, LCodigoOpcional);
    try
      FItemPedido.AddOpcional(LOpcional);
      LItemOpcional := FItemPedido.opcionais.Last;
      AResult       := LItemOpcional.quantidade.ToString;
    finally
      LOpcional.Free;
    end;
  end;
end;

procedure TFrmPedidoDetalheItem.OnClickConfirmar(AParams: TStringList);
begin
  if not Assigned(FConfiguracaoRPFood)  then
    FConfiguracaoRPFood:=FController.DAO.ConfiguracaoRPFoodDAO.Get(FSessaoCliente.IdEmpresa);

  if (FConfiguracaoRPFood.utilizacontroleopcionais) and  (FItemPedido.produto.OpcionalMinimo>0) then
  begin
     if FItemPedido.QuantidadeOpcionais<FItemPedido.produto.OpcionalMinimo  then
     begin
        MensagemErro('A quantidade minima a ser preenchido é: ',  FItemPedido.produto.OpcionalMinimo.ToString+ '   Opcionais.');
      Exit;
     end;
  end;
  FItemPedido.observacao := IWEDTOBSERVACAO.Text;

  if not FItemPedido.ItemConfirmado then
  begin
    FItemPedido.ItemConfirmado(True);
    FPedido.itens.Add(FItemPedido);
  end;
  WebApplication.GoToURL(ROTA_INDEX);
end;

procedure TFrmPedidoDetalheItem.OnClickDescartar(AParams: TStringList);
begin
  if FItemPedido.ItemConfirmado then
    FPedido.itens.Extract(FItemPedido).Free;
  Release;
end;

procedure TFrmPedidoDetalheItem.OnSubtrairFracao(AParams: TStrings; out AResult: string);
var
  LCodigoFracao: Integer;
  LItemFracao: TRPFoodEntityPedidoItemFracao;
begin
  AResult       := '0';
  LCodigoFracao := AParams.Values['IdProduto'].ToInteger;
  LItemFracao   := FItemPedido.GetFracao(LCodigoFracao);
  if (Assigned(LItemFracao)) then
  begin
    LItemFracao.quantidade := LItemFracao.quantidade - 1;
    AResult                := LItemFracao.quantidade.ToString;
    if LItemFracao.quantidade <= 0 then
      FItemPedido.fracoes.Extract(LItemFracao).Free;
    IWEDT_FRACAO_PRINCIPAL_QUANTIDADE.Text := FItemPedido.QuantidadeFracaoPrincipal.ToString;
  end;
end;

procedure TFrmPedidoDetalheItem.OnSubtrairOpcional(AParams: TStrings; out AResult: string);
var
  LCodigoOpcional: Integer;
  LItemOpcional  : TRPFoodEntityPedidoItemOpcional;
begin
  AResult         := '0';
  LCodigoOpcional := AParams.Values['IdProduto'].ToInteger;
  LItemOpcional   := FItemPedido.GetOpcional(LCodigoOpcional);
  if Assigned(LItemOpcional) then
  begin
    LItemOpcional.quantidade := LItemOpcional.quantidade - 1;
    if LItemOpcional.quantidade <= 0 then
      FItemPedido.opcionais.Extract(LItemOpcional).Free
    else
      AResult := LItemOpcional.quantidade.ToString;
  end;
end;

procedure TFrmPedidoDetalheItem.OnClickTamanho(AParams: TStringList);
var
  LTamanhoSelecionado: string;
  LItemOpcional      : TRPFoodEntityPedidoItemOpcional;
begin

  LTamanhoSelecionado := AParams.Values['tamanho'];
  FItemPedido.tamanho := LTamanhoSelecionado;
  for LItemOpcional in FItemPedido.opcionais do
    LItemOpcional.valorUnitario := LItemOpcional.opcional.ValorPorTamanho(LTamanhoSelecionado);

  AtualizarDivPreco;
  PreencheOpcionais;
  PreencheFracoes;
  AtualizarItensComponente;
end;

procedure TFrmPedidoDetalheItem.PreencheTamanhos;
begin
  if not FItemPedido.produto.vendaPorTamanho then
  begin
    ExecutaJavaScript('OcultarDivTamanho()');
    Exit;
  end;

  if FItemPedido.produto.valorTamanhoP > 0 then
  begin
    ExecutaJavaScript('PreencheTamanho(''%s'', %s)',[FItemPedido.produto.tamanhoP,BoolToStr(FItemPedido.tamanho = 'P', True).ToLower]);
  end;

  if FItemPedido.produto.valorTamanhoM > 0 then
  begin
    ExecutaJavaScript('PreencheTamanho(''%s'', %s)', [FItemPedido.produto.tamanhoM,BoolToStr(FItemPedido.tamanho = 'M', True).ToLower]);
  end;

  if FItemPedido.produto.valorTamanhoG > 0 then
  begin
     ExecutaJavaScript('PreencheTamanho(''%s'', %s)',[FItemPedido.produto.tamanhoG,BoolToStr(FItemPedido.tamanho = 'GG', True).ToLower]);
  end;

  if FItemPedido.produto.valorTamanhoGG > 0 then
  begin
    ExecutaJavaScript('PreencheTamanho(''%s'', %s)',[FItemPedido.produto.tamanhoGG, BoolToStr(FItemPedido.tamanho = 'GG', True).ToLower]);
  end;

  if FItemPedido.produto.valorTamanhoExtra > 0 then
  begin
    ExecutaJavaScript('PreencheTamanho(''%s'', %s)',[FItemPedido.produto.tamanhoExtra, BoolToStr(FItemPedido.tamanho = 'XG', True).ToLower]);
  end;

end;

procedure TFrmPedidoDetalheItem.SetPedido(AValue: TRPFoodEntityPedido);
begin
  FPedido := AValue;
end;

procedure TFrmPedidoDetalheItem.SetItemPedido(AValue: TRPFoodEntityPedidoItem);
begin
  FItemPedido := AValue;

  CarregaImagemDoItem;
  PreencheTamanhos;
  AtualizarItensComponente;

  FreeAndNil(FProdutosFracao);
  FreeAndNil(FOpcionais);
end;

procedure TFrmPedidoDetalheItem.PreencheFracoes;
var
  LProduto      : TRPFoodEntityProduto;
  LItemFracao   : TRPFoodEntityPedidoItemFracao;
  LQuantidade   : Integer;
  LValor        : Currency;
  LComando      : string;
  LOcultaFracao : Boolean;
begin
  LOcultaFracao := True;
  if FItemPedido.produto.permiteFrac then
  begin

    FreeAndNil(FProdutosFracao);
    ExecutaJavaScript('LimparFracoes()');
    FProdutosFracao := FController.DAO.ProdutoDAO.ProdutosQuePermitemFracao(FSessaoCliente.IdEmpresa, FItemPedido.produto.idGrupo,FItemPedido.tamanho);

    IWEDT_FRACAO_PRINCIPAL_QUANTIDADE.Text := FItemPedido.QuantidadeFracaoPrincipal.ToString;
    for LProduto in FProdutosFracao do
    begin
      if LProduto.codigo = FItemPedido.produto.codigo then
        Continue;
      LQuantidade := 0;

      LValor      := LProduto.ValorPorTamanho(FItemPedido.tamanho)  ;


      if LValor > 0 then
      begin
        LItemFracao := FItemPedido.GetFracao(LProduto.codigo);
        if Assigned(LItemFracao) then
          LQuantidade := LItemFracao.quantidade;

        LComando := 'PreencheFracoes(''%d'', ''%s'', ''%d'', ''%s'')';
        LComando := Format(LComando, [LProduto.codigo, LProduto.descricao,
          LQuantidade, FormatCurr('R$ ,0.00', LValor)]);

        ExecutaJavaScript(LComando);
        LOcultaFracao := False;
      end;
    end;
  end;

  if LOcultaFracao then
    ExecutaJavaScript('OcultarTabFracao()');
end;

procedure TFrmPedidoDetalheItem.PreencheOpcionais;
var
  LOpcional: TRPFoodEntityProdutoOpcional;
  LComando: string;
begin
  FreeAndNil(FOpcionais);
  ExecutaJavaScript('LimparOpcionais()');
  FOpcionais := FController.DAO.ProdutoOpcionalDAO.Listar(FSessaoCliente.IdEmpresa,FItemPedido.produto.codigo,FItemPedido.tamanho,False);
  for LOpcional in FOpcionais do
  begin
    LComando := 'PreencheListaOpcionais(''%d'', ''%s'', ''%d'', ''%s'')';
    LComando := Format(LComando, [LOpcional.opcional.codigo, LOpcional.opcional.descricao,GetQuantidadeOpcional(LOpcional.opcional.codigo),
    FormatCurr('R$ 0.00', GetValorOpcional(LOpcional.opcional))]);
    ExecutaJavaScript(LComando);
  end;
end;

destructor TFrmPedidoDetalheItem.Destroy;
begin
  FreeAndNil(FProdutosFracao);
  FreeAndNil(FOpcionais);

  if not FItemPedido.ItemConfirmado then
    FreeAndNil(FItemPedido);

  FreeAndNil(FConfiguracaoRPFood);
  inherited;
end;

procedure TFrmPedidoDetalheItem.AtualizarDivPreco;
begin
  RecarregarTag('divPreco');
end;

procedure TFrmPedidoDetalheItem.AtualizarItensComponente;
begin
  IWEDTOBSERVACAO.Text       := FItemPedido.observacao;
  IWEDT_QUANTIDADE_ITEM.Text := FItemPedido.quantidade.ToString;
end;

procedure TFrmPedidoDetalheItem.CarregaImagemDoItem;
var
  LImage: TMemoryStream;
begin
  if FileExists(FItemPedido.produto.CaminhoWWWRootImagem) then
  begin
    LImage := TMemoryStream.Create;
    try
      LImage.LoadFromFile(FItemPedido.produto.CaminhoWWWRootImagem);
      LImage.Position := 0;
      IWIMAGEM_PRODUTO.Picture.LoadFromStream(LImage);
    finally
      LImage.Free;
    end;
  end;
end;

initialization
  TFrmPedidoDetalheItem.SetURL('', 'pedido-item.html');

end.
