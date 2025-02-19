unit RPFood.Entity.Venda;

interface

uses
  RPFood.Entity.Cliente,
  RPFood.Entity.Endereco,
  RPFood.Entity.FormaPagamento,
  RPFood.Entity.Produto,
  RPFood.Entity.Opcional,
  RPFood.Entity.Types,
  RPFood.Entity.VendaStatusLog,
  System.SysUtils,
  System.Generics.Collections;

type
  TRPFoodEntityVendaItem = class;
  TRPFoodEntityVendaItemOpcional = class;

  TRPFoodEntityVenda = class
  private
    Fitens                : TObjectList<TRPFoodEntityVendaItem>;
    FtaxaEntrega          : Currency;
    FformaPagamento       : TRPFoodEntityFormaPagamento;
    Fdata                 : TDateTime;
    Fcliente              : TRPFoodEntityCliente;
    Fid                   : Integer;
    FidEmpresa            : Integer;
    FvalorAReceber        : Currency;
    Ftroco                : Currency;
    FvalorTotalProdutos   : Currency;
    FvalorTotal           : Currency;
    FvalorTotalOpcionais  : Currency;
    FtipoEntrega          : TRPTipoEntrega;
    FrecebidoLeCheff      : Boolean;
    Fobservacao           : string;
    FvendaEndereco        : TRPFoodEntityEndereco;
    FsituacaoPedido       : TRPSituacaoPedido;
    FlistaStatus: TObjectList<TRPFoodEntityVendaStatusLog>;
    FIDEndereco: Integer;
    procedure SetCliente(const AValue: TRPFoodEntityCliente);
    procedure SetFormaPagamento(const AValue: TRPFoodEntityFormaPagamento);
    procedure SetListaStatus(const AValue: TObjectList<TRPFoodEntityVendaStatusLog>);
    procedure SetItens(const AValue: TObjectList<TRPFoodEntityVendaItem>);
    function GetTipoEntregaDescription: string;
    function GetSituacaoDescription: string;
    function GetSituacaoDescriptionBtn: string;
  public
    constructor Create;
    destructor Destroy; override;
    property id                     : Integer                                  read Fid                            write Fid;
    property idEmpresa              : Integer                                  read FidEmpresa                     write FidEmpresa;
    property data                   : TDateTime                                read Fdata                          write Fdata;
    property cliente                : TRPFoodEntityCliente                     read Fcliente                       write SetCliente;
    property taxaEntrega            : Currency                                 read FtaxaEntrega                   write FtaxaEntrega;
    property formaPagamento         : TRPFoodEntityFormaPagamento              read FformaPagamento                write SetFormaPagamento;
    property valorTotalProdutos     : Currency                                 read FvalorTotalProdutos            write FvalorTotalProdutos;
    property valorTotal             : Currency                                 read FvalorTotal                    write FvalorTotal;
    property valorTotalOpcionais    : Currency                                 read FvalorTotalOpcionais           write FvalorTotalOpcionais;
    property valorAReceber          : Currency                                 read FvalorAReceber                 write FvalorAReceber;
    property troco                  : Currency                                 read Ftroco                         write Ftroco;
    property itens                  : TObjectList<TRPFoodEntityVendaItem>      read Fitens                         write SetItens;
    property recebidoLeCheff        : Boolean                                  read FrecebidoLeCheff               write FrecebidoLeCheff;
    property tipoEntrega            : TRPTipoEntrega                           read FtipoEntrega                   write FtipoEntrega;
    property observacao             : string                                   read Fobservacao                    write Fobservacao;
    property vendaEndereco          : TRPFoodEntityEndereco                    read FvendaEndereco                 write FvendaEndereco;
    property IDEndereco             : Integer                                  read FIDEndereco                    write FIDEndereco;
    property situacaoPedido         : TRPSituacaoPedido                        read FsituacaoPedido                write FsituacaoPedido;
    property listaStatus            : TObjectList<TRPFoodEntityVendaStatusLog> read FlistaStatus                   write SetListaStatus;
    property situacaoDescription    : string                                   read GetSituacaoDescription;
    property situacaoDescriptionBtn : string                                   read GetSituacaoDescriptionBtn;
    property tipoEntregaDescription : string                                   read GetTipoEntregaDescription;
  end;

  TRPFoodEntityVendaItem = class
  private
    Fquantidade         : Currency;
    Fproduto            : TRPFoodEntityProduto;
    Fopcionais          : TObjectList<TRPFoodEntityVendaItemOpcional>;
    Ftamanho            : string;
    Fobservacao         : string;
    FidVenda            : Integer;
    FnumeroItem         : Integer;
    FidEmpresa          : Integer;
    FvendaPorTamanho    : Boolean;
    FnumeroItemFracionado: Integer;
    FvalorUnitario      : Currency;
    FvalorTotalProduto  : Currency;
    FUtilizaHappyHour   : Boolean;
    procedure SetProduto(const AValue: TRPFoodEntityProduto);
    procedure SetOpcionais(const AValue: TObjectList<TRPFoodEntityVendaItemOpcional>);
    function GetIsFracao: Boolean;
    function GetIsFracionado: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function ValorTotal: Currency;
    function ValorTotalOpcionais: Currency;
    function DescricaoTamanhoSelecionado: string;
    function GetOpcional(ACodigo: Integer): TRPFoodEntityVendaItemOpcional;
    procedure AddOpcional(AOpcional: TRPFoodEntityOpcional);
    function QuantidadeFracoes(AVenda: TRPFoodEntityVenda): Integer;

    property idVenda              : Integer                                     read FidVenda               write FidVenda;
    property idEmpresa            : Integer                                     read FidEmpresa             write FidEmpresa;
    property numeroItem           : Integer                                     read FnumeroItem            write FnumeroItem;
    property numeroItemFracionado : Integer                                     read FnumeroItemFracionado  write FnumeroItemFracionado;
    property valorUnitario        : Currency                                    read FvalorUnitario         write FvalorUnitario;
    property valorTotalProduto    : Currency                                    read FvalorTotalProduto     write FvalorTotalProduto;
    property quantidade           : Currency                                    read Fquantidade            write Fquantidade;
    property tamanho              : string                                      read Ftamanho               write Ftamanho;
    property vendaPorTamanho      : Boolean                                     read FvendaPorTamanho       write FvendaPorTamanho;
    property observacao           : string                                      read Fobservacao            write Fobservacao;
    property produto              : TRPFoodEntityProduto                        read Fproduto               write SetProduto;
    property opcionais            : TObjectList<TRPFoodEntityVendaItemOpcional> read Fopcionais             write SetOpcionais;
    property isFracionado         : Boolean                                     read GetIsFracionado;
    property isFracao             : Boolean                                     read GetIsFracao;
    property UtilizaHappyHour     : Boolean                                     read FUtilizaHappyHour      write FUtilizaHappyHour;
  end;

  TRPFoodEntityVendaItemOpcional = class
  private
    Fquantidade         : Integer;
    Fopcional           : TRPFoodEntityOpcional;
    FidVenda            : Integer;
    FidEmpresa          : Integer;
    FidNumeroItem       : Integer;
    FvalorUnitario      : Currency;
    FvalorTotal         : Currency;
    Fquantidade_replicar: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property idVenda              : Integer               read FidVenda             write FidVenda;
    property idEmpresa            : Integer               read FidEmpresa           write FidEmpresa;
    property idNumeroItem         : Integer               read FidNumeroItem        write FidNumeroItem;
    property quantidade           : Integer               read Fquantidade          write Fquantidade;
    property valorUnitario        : Currency              read FvalorUnitario       write FvalorUnitario;
    property valorTotal           : Currency              read FvalorTotal          write FvalorTotal;
    property opcional             : TRPFoodEntityOpcional read Fopcional;
    property quantidade_replicar  : Double                read Fquantidade_replicar write Fquantidade_replicar;
  end;

implementation

{ TRPFoodEntityVendaItem }

procedure TRPFoodEntityVendaItem.AddOpcional(AOpcional: TRPFoodEntityOpcional);
var
  LItemOpcional: TRPFoodEntityVendaItemOpcional;
begin
  LItemOpcional := TRPFoodEntityVendaItemOpcional.Create;
  LItemOpcional.opcional.Assign(AOpcional);
  LItemOpcional.quantidade := 1;
  Fopcionais.Add(LItemOpcional);
end;

constructor TRPFoodEntityVendaItem.Create;
begin
  Fquantidade := 1;
  Fproduto := TRPFoodEntityProduto.Create;
  Fopcionais := TObjectList<TRPFoodEntityVendaItemOpcional>.Create;
end;

function TRPFoodEntityVendaItem.DescricaoTamanhoSelecionado: string;
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
    if Ftamanho = 'Extra' then
      Result := Fproduto.tamanhoExtra;
  end;
end;

destructor TRPFoodEntityVendaItem.Destroy;
begin
  Fproduto.Free;
  Fopcionais.Free;
  inherited;
end;

function TRPFoodEntityVendaItem.GetIsFracao: Boolean;
begin
  Result := (FnumeroItemFracionado > 0) and (FnumeroItemFracionado <> FnumeroItem);
end;

function TRPFoodEntityVendaItem.GetIsFracionado: Boolean;
begin
  Result := (FnumeroItemFracionado > 0) and (FnumeroItemFracionado = FnumeroItem);
end;

function TRPFoodEntityVendaItem.GetOpcional(ACodigo: Integer): TRPFoodEntityVendaItemOpcional;
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

function TRPFoodEntityVendaItem.QuantidadeFracoes(AVenda: TRPFoodEntityVenda): Integer;
var
  LItem: TRPFoodEntityVendaItem;
begin
  if Self.numeroItemFracionado = 0 then
    Exit(0);

  Result := 0;
  for LItem in AVenda.itens do
  begin
    if LItem.numeroItemFracionado = Self.numeroItemFracionado  then
      Result := Result + 1;
  end;
end;

procedure TRPFoodEntityVendaItem.SetOpcionais(const AValue: TObjectList<TRPFoodEntityVendaItemOpcional>);
begin
  FreeAndNil(Fopcionais);
  Fopcionais := AValue;
end;

procedure TRPFoodEntityVendaItem.SetProduto(const AValue: TRPFoodEntityProduto);
begin
  if not Assigned(Fproduto) then
    Fproduto := TRPFoodEntityProduto.Create;

  if (Assigned(AValue)) then
  begin
    Fproduto.Assign(AValue);
    if (Fproduto.vendaPorTamanho) and (Fproduto.tamanhoPadrao <> EmptyStr) then
      Ftamanho := Fproduto.tamanhoPadrao;
  end;
end;

function TRPFoodEntityVendaItem.ValorTotal: Currency;
begin
  Result := ValorTotalProduto + ValorTotalOpcionais;
end;

function TRPFoodEntityVendaItem.ValorTotalOpcionais: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Fopcionais.Count) do
    Result := Result + Fopcionais[I].ValorTotal;
end;

{ TRPFoodEntityVenda }

constructor TRPFoodEntityVenda.Create;
begin
  Fcliente         := TRPFoodEntityCliente.Create;
  Fitens           := TObjectList<TRPFoodEntityVendaItem>.Create;
  FlistaStatus     := TObjectList<TRPFoodEntityVendaStatusLog>.Create;
  FformaPagamento  := TRPFoodEntityFormaPagamento.Create;
  FvendaEndereco   := TRPFoodEntityEndereco.Create;
  FtipoEntrega     := teDelivery;
  FsituacaoPedido  := spEnviado;
  FrecebidoLeCheff := False;
end;

destructor TRPFoodEntityVenda.Destroy;
begin
  Fcliente.Free;
  Fitens.Free;
  FlistaStatus.Free;
  FformaPagamento.Free;
  FvendaEndereco.Free;
  inherited;
end;

function TRPFoodEntityVenda.GetSituacaoDescription: string;
begin
  Result := FsituacaoPedido.Descricao;
end;

function TRPFoodEntityVenda.GetSituacaoDescriptionBtn: string;
begin
  case FsituacaoPedido of
    spEnviado: Result := 'btn-outline-primary bgl-success';
    spRejeitado: Result := 'btn-outline-success bgl-warning';
    spAceito: Result := 'btn-outline-primary bgl-primary';
    spEmPreparo: Result := 'btn-outline-dark bgl-primary-light';
    spSaiuParaEntrega: Result := 'btn-outline-success bgl-success';
    spProntoParaRetirar: Result := 'btn-outline-danger';
    spFinalizado: Result := 'btn-outline-success bgl-success';
    spCanceladoEstabelecimento: Result := 'btn-outline-danger';
  else
    Result := 'btn-outline-success bgl-warning';
  end;
end;

function TRPFoodEntityVenda.GetTipoEntregaDescription: string;
begin
  Result := FtipoEntrega.Descricao;
end;

procedure TRPFoodEntityVenda.SetCliente(const AValue: TRPFoodEntityCliente);
begin
  if Assigned(AValue) then
    Fcliente.Assign(AValue);
end;

procedure TRPFoodEntityVenda.SetFormaPagamento(const AValue: TRPFoodEntityFormaPagamento);
begin
  if Assigned(AValue) then
    FformaPagamento.Assign(AValue);
end;

procedure TRPFoodEntityVenda.SetItens(const AValue: TObjectList<TRPFoodEntityVendaItem>);
begin
  FreeAndNil(Fitens);
  Fitens := AValue;
end;

procedure TRPFoodEntityVenda.SetListaStatus(const AValue: TObjectList<TRPFoodEntityVendaStatusLog>);
begin
  FreeAndNil(FlistaStatus);
  FlistaStatus := AValue;
end;

{ TRPFoodEntityVendaItemOpcional }

constructor TRPFoodEntityVendaItemOpcional.Create;
begin
  Fquantidade := 1;
  Fopcional := TRPFoodEntityOpcional.Create;
end;

destructor TRPFoodEntityVendaItemOpcional.Destroy;
begin
  Fopcional.Free;
  inherited;
end;

end.
