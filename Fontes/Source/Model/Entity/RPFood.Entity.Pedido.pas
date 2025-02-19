unit RPFood.Entity.Pedido;

interface

uses
  RPFood.Entity.Cliente,
  RPFood.Entity.Endereco,
  RPFood.Entity.FormaPagamento,
  RPFood.Entity.Produto,
  RPFood.Entity.Opcional,
  RPFood.Entity.Types,
  RPFood.Entity.Empresa,
  RPFood.Entity.Bairro,
  RPFood.Entity.ConfiguracaoRPFood,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TRPFoodEntityPedidoItem         = class;
  TRPFoodEntityPedidoItemFracao   = class;
  TRPFoodEntityPedidoItemOpcional = class;

  TRPFoodEntityPedido             = class
  private
    FidEmpresa              : Integer;
    FformaPagamento         : TRPFoodEntityFormaPagamento;
    FtaxaEntrega            : Currency;
    Fcliente                : TRPFoodEntityCliente;
    Fdata                   : TDateTime;
    Fitens                  : TObjectList<TRPFoodEntityPedidoItem>;
    FvalorAReceber          : Currency;
    FtipoEntrega            : TRPTipoEntrega;
    Fobservacao             : string;
    Fendereco               : TRPFoodEntityClienteEndereco;
    Futilizou_happy_hour    : Boolean;
    Futilizou_promocao      : Boolean;
    procedure SetCliente(const AValue: TRPFoodEntityCliente);
    procedure SetFormaPagamento(const AValue: TRPFoodEntityFormaPagamento);
    function GetValorTotal: Currency;
    function GetValorTroco: Currency;
    function GetQuantidadeItensVendidos: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function ValorTotalProdutos: Currency;
    function ValorTotalOpcionais: Currency;
    procedure SetTipoEntrega(AValue: string);

    property idEmpresa                : Integer                               read FidEmpresa                  write FidEmpresa;
    property data                     : TDateTime                             read Fdata                       write Fdata;
    property cliente                  : TRPFoodEntityCliente                  read Fcliente                    write SetCliente;
    property taxaEntrega              : Currency                              read FtaxaEntrega                write FtaxaEntrega;
    property formaPagamento           : TRPFoodEntityFormaPagamento           read FformaPagamento             write SetFormaPagamento;
    property valorAReceber            : Currency                              read FvalorAReceber              write FvalorAReceber;
    property valorTotal               : Currency                              read GetValorTotal;
    property valorTroco               : Currency                              read GetValorTroco;
    property itens                    : TObjectList<TRPFoodEntityPedidoItem>  read Fitens                      write Fitens;
    property tipoEntrega              : TRPTipoEntrega                        read FtipoEntrega                write FtipoEntrega;
    property observacao               : string                                read Fobservacao                 write Fobservacao;
    property endereco                 : TRPFoodEntityClienteEndereco          read Fendereco                   write Fendereco;
    property quantidadeItensVendidos  : Integer                               read GetQuantidadeItensVendidos;
    property utilizou_happy_hour      : boolean                               read Futilizou_happy_hour         write Futilizou_happy_hour;
    property utilizou_promocao        : Boolean                               read Futilizou_promocao           write Futilizou_promocao;

  end;

  TRPFoodEntityPedidoItem = class
  private
    FItemConfirmado         : Boolean;
    Fquantidade             : Integer;
    Fproduto                : TRPFoodEntityProduto;
    Fopcionais              : TObjectList<TRPFoodEntityPedidoItemOpcional>;
    Ftamanho                : string;
    Fobservacao             : string;
    Ffracoes                : TObjectList<TRPFoodEntityPedidoItemFracao>;
    FidVenda                : Integer;
    FnumeroItem             : Integer;
    FidEmpresa              : Integer;
    FvendaPorTamanho        : Boolean;
    FnumeroItemFracionado   : Integer;
    FUtilizaHappyHour       : Boolean;
    FConfiguracaoRPFOOD     : TRPFoodEntityConfiguracaoRPFood;
    function GetvalorUnitario: Currency;
    function GetValorTotalProduto: Currency;
    procedure VerificaHappyHour(const AValue:TRPFoodEntityProduto);
  public
    constructor Create;
    destructor Destroy; override;

    function ValorTotal: Currency;
    function ValorTotalOpcionais: Currency;
    function ValorMaiorFracao: Currency;
    function DescricaoTamanhoSelecionado: string;
    function QuantidadeFracaoPrincipal: Integer;
    function QuantidadeOpcionais: Integer;
    function ItemConfirmado(AValue: Boolean): TRPFoodEntityPedidoItem; overload;
    function ItemConfirmado: Boolean; overload;
    function GetOpcional(ACodigo: Integer): TRPFoodEntityPedidoItemOpcional;
    function GetFracao(ACodigo: Integer): TRPFoodEntityPedidoItemFracao;
    procedure AddOpcional(AOpcional: TRPFoodEntityOpcional);
    procedure AddFracao(AProdutoFracao: TRPFoodEntityProduto);
    procedure SetProduto(const AValue: TRPFoodEntityProduto);
    function GetHappHour:Boolean;

    property idVenda              : Integer                                       read FidVenda               write FidVenda;
    property idEmpresa            : Integer                                       read FidEmpresa             write FidEmpresa;
    property numeroItem           : Integer                                       read FnumeroItem            write FnumeroItem;
    property numeroItemFracionado : Integer                                       read FnumeroItemFracionado  write FnumeroItemFracionado;
    property valorUnitario        : Currency                                      read GetvalorUnitario;
    property quantidade           : Integer                                       read Fquantidade            write Fquantidade;
    property tamanho              : string                                        read Ftamanho               write Ftamanho;
    property vendaPorTamanho      : Boolean                                       read FvendaPorTamanho       write FvendaPorTamanho;
    property observacao           : string                                        read Fobservacao            write Fobservacao;
    property valorTotalProduto    : Currency                                      read GetValorTotalProduto;
    property produto              : TRPFoodEntityProduto                          read Fproduto               write SetProduto;
    property opcionais            : TObjectList<TRPFoodEntityPedidoItemOpcional>  read Fopcionais             write Fopcionais;
    property fracoes              : TObjectList<TRPFoodEntityPedidoItemFracao>    read Ffracoes               write Ffracoes;
    property UtilizaHappyHour     : Boolean                                       read FUtilizaHappyHour      write FUtilizaHappyHour;
  end;

  TRPFoodEntityPedidoItemOpcional = class
  private
    Fquantidade           : Integer;
    Fopcional             : TRPFoodEntityOpcional;
    FvalorUnitario        : Currency;
    FItemPedido           : TRPFoodEntityPedidoItem;
    FquantidadeTotal: integer;
    procedure SetOpcional(const AValue: TRPFoodEntityOpcional);
    function GetValorTotal: Currency;
  public
    constructor Create(AItemPedido: TRPFoodEntityPedidoItem);
    destructor Destroy; override;

    property quantidade   : Integer               read Fquantidade    write Fquantidade;
    property valorUnitario: Currency              read FvalorUnitario write FvalorUnitario;
    property valorTotal   : Currency              read GetValorTotal;
    property opcional     : TRPFoodEntityOpcional read FOpcional      write SetOpcional;
    property quantidadeTotal: integer read FquantidadeTotal write FquantidadeTotal;

  end;

  TRPFoodEntityPedidoItemFracao = class
  private
    Fquantidade : Integer;
    Fproduto    : TRPFoodEntityProduto;
    procedure SetProduto(const AValue: TRPFoodEntityProduto);
  public
    constructor Create;
    destructor Destroy; override;

    property quantidade : Integer               read Fquantidade  write Fquantidade;
    property produto    : TRPFoodEntityProduto  read Fproduto     write SetProduto;
  end;

implementation

{ TRPFoodEntityPedido }

constructor TRPFoodEntityPedido.Create;
begin
  Fcliente                  := TRPFoodEntityCliente.Create;
  Fendereco                 := TRPFoodEntityClienteEndereco.Create;
  FformaPagamento           := TRPFoodEntityFormaPagamento.Create;
  Fitens                    := TObjectList<TRPFoodEntityPedidoItem>.Create;
  FtipoEntrega              := teDelivery;
end;

destructor TRPFoodEntityPedido.Destroy;
begin
  Fcliente.Free;
  Fendereco.Free;
  FformaPagamento.Free;
  Fitens.Free;
  inherited;
end;

procedure TRPFoodEntityPedido.SetCliente(const AValue: TRPFoodEntityCliente);
begin
  if not Assigned(Fcliente) then
    Fcliente := TRPFoodEntityCliente.Create;

  if Assigned(AValue) then
  begin
    Fcliente.Assign(AValue);

    FtaxaEntrega := Fcliente.enderecoPadrao.taxaEntrega;
  end;
end;

procedure TRPFoodEntityPedido.SetFormaPagamento(const AValue: TRPFoodEntityFormaPagamento);
begin
  if not Assigned(FformaPagamento) then
    FformaPagamento := TRPFoodEntityFormaPagamento.Create;

  if Assigned(AValue) then
    FformaPagamento.Assign(AValue);
end;

procedure TRPFoodEntityPedido.SetTipoEntrega(AValue: string);
begin
  FtipoEntrega := teDelivery;
  FtaxaEntrega := Fcliente.enderecoPadrao.taxaEntrega;

  if AValue.ToUpper = 'R' then
  begin
    FtipoEntrega := teRetirada;
    FtaxaEntrega := 0;
  end;
end;

function TRPFoodEntityPedido.GetQuantidadeItensVendidos: Integer;
var
  I, J: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fitens.Count) do
  begin
    if Fitens[I].fracoes.Count > 0 then
      Result := Result + Fitens[I].QuantidadeFracaoPrincipal
    else
      Result := Result + Fitens[I].quantidade;

    for J := 0 to Pred(Fitens[I].opcionais.Count) do
      Result := Result + Fitens[I].opcionais[J].quantidade;
  end;
end;

function TRPFoodEntityPedido.GetValorTotal: Currency;
begin
  Result := ValorTotalProdutos + ValorTotalOpcionais + FtaxaEntrega;
end;

function TRPFoodEntityPedido.ValorTotalOpcionais: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fitens.Count) do
    Result := Result + Fitens[I].ValorTotalOpcionais;
end;

function TRPFoodEntityPedido.ValorTotalProdutos: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fitens.Count) do
    Result := Result + Fitens[I].ValorTotalProduto;
end;

function TRPFoodEntityPedido.GetValorTroco: Currency;
begin
  Result := 0;
  if (FvalorAReceber > 0) and (FvalorAReceber > GetValorTotal) then
    Result := FvalorAReceber - GetValorTotal;
end;

{ TRPFoodEntityPedidoItemOpcional }

constructor TRPFoodEntityPedidoItemOpcional.Create(AItemPedido: TRPFoodEntityPedidoItem);
begin
  Fopcional := TRPFoodEntityOpcional.Create;
  FItemPedido := AItemPedido;
end;

destructor TRPFoodEntityPedidoItemOpcional.Destroy;
begin
  Fopcional.Free;
  inherited;
end;

procedure TRPFoodEntityPedidoItemOpcional.SetOpcional(const AValue: TRPFoodEntityOpcional);
begin
  if not Assigned(Fopcional) then
    Fopcional := TRPFoodEntityOpcional.Create;
  FOpcional.Assign(AValue);
  FvalorUnitario := Fopcional.valor;

end;

function TRPFoodEntityPedidoItemOpcional.GetValorTotal: Currency;
begin
  Result := (Fquantidade * FItemPedido.quantidade) * FvalorUnitario;
end;


{ TRPFoodEntityPedidoItemFracao }

constructor TRPFoodEntityPedidoItemFracao.Create;
begin
  Fproduto := TRPFoodEntityProduto.Create;
end;

destructor TRPFoodEntityPedidoItemFracao.Destroy;
begin
  Fproduto.Free;
  inherited;
end;

procedure TRPFoodEntityPedidoItemFracao.SetProduto(const AValue: TRPFoodEntityProduto);
begin
  if not Assigned(Fproduto) then
    Fproduto := TRPFoodEntityProduto.Create;
  Fproduto.Assign(AValue);
end;

{ TRPFoodEntityPedidoItem }

procedure TRPFoodEntityPedidoItem.AddFracao(AProdutoFracao: TRPFoodEntityProduto);
begin
  Ffracoes.Add(TRPFoodEntityPedidoItemFracao.Create);
  Ffracoes.Last.quantidade := 1;
  Ffracoes.Last.produto := AProdutoFracao;
end;

procedure TRPFoodEntityPedidoItem.AddOpcional(AOpcional: TRPFoodEntityOpcional);
var
  LItemOpcional: TRPFoodEntityPedidoItemOpcional;
begin
  LItemOpcional := TRPFoodEntityPedidoItemOpcional.Create(Self);
  LItemOpcional.opcional := AOpcional;
  LItemOpcional.quantidade := 1;

  LItemOpcional.valorUnitario := AOpcional.ValorPorTamanho(Self.tamanho);
  Fopcionais.Add(LItemOpcional);
end;

constructor TRPFoodEntityPedidoItem.Create;
begin
  FItemConfirmado           := True;
  Fquantidade               := 1;
  Fproduto                  := TRPFoodEntityProduto.Create;
  Fopcionais                := TObjectList<TRPFoodEntityPedidoItemOpcional>.Create;
  Ffracoes                  := TObjectList<TRPFoodEntityPedidoItemFracao>.Create;
end;

function TRPFoodEntityPedidoItem.DescricaoTamanhoSelecionado: string;
begin
  Result := EmptyStr;
  if Assigned(Fproduto) then
  begin
    if Ftamanho = 'P' then
      Result := Fproduto.tamanhoP
    else
    if Ftamanho = 'M' then
      Result := Fproduto.tamanhoM
    else
    if Ftamanho = 'G' then
      Result := Fproduto.tamanhoG
    else
    if Ftamanho = 'GG' then
      Result := Fproduto.tamanhoGG
    else
    if Ftamanho = 'EXTRA' then
      Result := Fproduto.tamanhoExtra;
  end;
end;

destructor TRPFoodEntityPedidoItem.Destroy;
begin
  Fproduto.Free;
  Fopcionais.Free;
  Ffracoes.Free;
  inherited;
end;

function TRPFoodEntityPedidoItem.GetFracao(ACodigo: Integer): TRPFoodEntityPedidoItemFracao;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Ffracoes.Count) do
  begin
    if Ffracoes[I].produto.codigo = ACodigo then
      Exit(Ffracoes[I]);
  end;
end;

function TRPFoodEntityPedidoItem.GetHappHour: Boolean;
begin
  Result:=  FUtilizaHappyHour;
end;

function TRPFoodEntityPedidoItem.GetOpcional(ACodigo: Integer): TRPFoodEntityPedidoItemOpcional;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Fopcionais.Count) do
  begin
    if Fopcionais[I].opcional.codigo = ACodigo then
      Exit(Fopcionais[I]);
  end;
end;

function TRPFoodEntityPedidoItem.GetvalorUnitario: Currency;
var
  LMaiorFracao: Currency;
  LValorFracao: Currency;
  I: Integer;
begin
  Result := 0;
  if Assigned(Fproduto) and not Fproduto.happyHourAtivar then
    Result := Fproduto.ValorPorTamanho(Ftamanho)
  else
  Result:=Fproduto.valFinal;


  LMaiorFracao := 0;
  for I := 0 to Pred(Ffracoes.Count) do
  begin
    if Result=Fproduto.valFinal then
    begin
      LValorFracao := Ffracoes[I].produto.valFinal;
      if LValorFracao > LMaiorFracao then
        LMaiorFracao := LValorFracao;

    end
    else
    begin
      LValorFracao := Ffracoes[I].produto.ValorPorTamanho(Ftamanho);
      if LValorFracao > LMaiorFracao then
        LMaiorFracao := LValorFracao;
    end;



  end;

  if Result < LMaiorFracao then
    Result := LMaiorFracao;
end;

function TRPFoodEntityPedidoItem.ItemConfirmado: Boolean;
begin
  Result := FItemConfirmado;
end;

function TRPFoodEntityPedidoItem.ItemConfirmado(AValue: Boolean): TRPFoodEntityPedidoItem;
begin
  Result := Self;
  FItemConfirmado := AValue;
end;

function TRPFoodEntityPedidoItem.QuantidadeFracaoPrincipal: Integer;
var
  LTotalFracoes: Integer;
  I: Integer;
begin
  LTotalFracoes := 0;
  for I := 0 to Pred(Ffracoes.Count) do
    Inc(LTotalFracoes, Ffracoes[I].quantidade);
  Result := 4 - LTotalFracoes;
end;

function TRPFoodEntityPedidoItem.QuantidadeOpcionais: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fopcionais.Count) do
    Result := Result + Fopcionais[I].quantidade;
end;

procedure TRPFoodEntityPedidoItem.SetProduto(const AValue: TRPFoodEntityProduto);
begin
  if not Assigned(Fproduto) then
    Fproduto := TRPFoodEntityProduto.Create;
  Fproduto.Assign(AValue);
  if (Fproduto.vendaPorTamanho) and (Fproduto.tamanhoPadrao <> EmptyStr) then
    Ftamanho := Fproduto.tamanhoPadrao;
end;

function TRPFoodEntityPedidoItem.ValorMaiorFracao: Currency;
begin
  Result := ValorTotalProduto + ValorTotalOpcionais;
end;

function TRPFoodEntityPedidoItem.ValorTotal: Currency;
begin
  Result := ValorTotalProduto + ValorTotalOpcionais;
end;

function TRPFoodEntityPedidoItem.ValorTotalOpcionais: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fopcionais.Count) do
    Result := Result + Fopcionais[I].ValorTotal;
end;

procedure TRPFoodEntityPedidoItem.VerificaHappyHour(const AValue: TRPFoodEntityProduto);
begin
  if not Assigned(FProduto) then
   FProduto:=TRPFoodEntityProduto.Create;

  Fproduto.Assign(AValue);
  FUtilizaHappyHour:=Fproduto.happyHourAtivar;

end;

function TRPFoodEntityPedidoItem.GetValorTotalProduto: Currency;
begin
  Result := valorUnitario * Fquantidade;
end;

end.
