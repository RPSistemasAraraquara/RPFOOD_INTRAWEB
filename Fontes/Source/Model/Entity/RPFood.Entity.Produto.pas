unit RPFood.Entity.Produto;

interface

uses
  System.Classes,
  System.SysUtils,
  RPFood.Utils,
  System.DateUtils,
  RPFood.Entity.Types,
  RPFood.Entity.RestricaoVenda,
  RPFood.Entity.ConfiguracaoRPFood,
  RPFood.Entity.Happy_Hour;

type
  TRPFoodEntityPromocao =class;

  TRPFoodEntityProduto = class
  private
    Fcodigo            : Integer;
    FidGrupo           : Integer;
    Fdescricao         : string;
    Fobservacao        : string;
    FvalFinal          : Currency;
    FidEmpresa         : Integer;
    FvendaPorTamanho   : Boolean;
    FvalorTamanhoP     : Currency;
    FvalorTamanhoM     : Currency;
    FvalorTamanhoG     : Currency;
    FvalorTamanhoGG    : Currency;
    FvalorTamanhoExtra : Currency;
    FdestaqueWeb       : Boolean;
    FPromocao          : TRPFoodEntityPromocao;
    FtamanhoP          : string;
    FtamanhoM          : string;
    FtamanhoG          : string;
    FtamanhoGG         : string;
    FtamanhoExtra      : string;
    FtamanhoPadrao     : string;
    FpermiteFrac       : Boolean;
    FCarrosel          : Boolean;
    FhappyHourAtivar   : Boolean;
    FhappyHour         : TRPFoodEntityHappy_Hour;
    FConfiguracaoRPFOOD:TRPFoodEntityConfiguracaoRPFood;
    FrestringirVenda   : Boolean;
    Frestricao         : TRPFoodEntityRestricaoVenda;
    Frestricaovenda: boolean;
    FOpcionalMinimo: Integer;
    FOpcionalMaximo: Integer;
     procedure SetRestricao(const AValue:TRPFoodEntityRestricaoVenda);
    procedure SetHappyHour(const AValue: TRPFoodEntityHappy_Hour);
    function GetCaminhoHtmlImagem: string;
    function GetDescricao: string;
    procedure SetPromocao(const AValue: TRPFoodEntityPromocao);

  public
    constructor Create;
    destructor Destroy ;override;
    procedure Assign(ASource: TRPFoodEntityProduto);
    function CaminhoWWWRootImagem:string;
    procedure SalvarImagem(AImagem: TMemoryStream);
    function UsaHappyHour: Boolean;
    function DescricaoTamanhoPadrao: string;
    function ValorPorTamanho(ATamanho: string): Currency;
    property codigo             : Integer                      read Fcodigo             write Fcodigo;
    property idEmpresa          : Integer                      read FidEmpresa          write FidEmpresa;
    property idGrupo            : Integer                      read FidGrupo            write FidGrupo;
    property descricao          : string                       read GetDescricao        write Fdescricao;
    property observacao         : string                       read Fobservacao         write Fobservacao;
    property valFinal           : Currency                     read FvalFinal           write FvalFinal;
    property destaqueWeb        : Boolean                      read FdestaqueWeb        write FdestaqueWeb;
    property vendaPorTamanho    : Boolean                      read FvendaPorTamanho    write FvendaPorTamanho;
    property permiteFrac        : Boolean                      read FpermiteFrac        write FpermiteFrac;
    property valorTamanhoP      : Currency                     read FvalorTamanhoP      write FvalorTamanhoP;
    property valorTamanhoM      : Currency                     read FvalorTamanhoM      write FvalorTamanhoM;
    property valorTamanhoG      : Currency                     read FvalorTamanhoG      write FvalorTamanhoG;
    property valorTamanhoGG     : Currency                     read FvalorTamanhoGG     write FvalorTamanhoGG;
    property valorTamanhoExtra  : Currency                     read FvalorTamanhoExtra  write FvalorTamanhoExtra;
    property tamanhoP           : string                       read FtamanhoP           write FtamanhoP;
    property tamanhoM           : string                       read FtamanhoM           write FtamanhoM;
    property tamanhoG           : string                       read FtamanhoG           write FtamanhoG;
    property tamanhoGG          : string                       read FtamanhoGG          write FtamanhoGG;
    property tamanhoExtra       : string                       read FtamanhoExtra       write FtamanhoExtra;
    property tamanhoPadrao      : string                       read FtamanhoPadrao      write FtamanhoPadrao;
    property utiliza_carrossel  : Boolean                      read FCarrosel           write FCarrosel;
    property caminhoHtmlImagem  : string                       read GetCaminhoHtmlImagem;
    property happyHourAtivar    : Boolean                      read FhappyHourAtivar     write FhappyHourAtivar;
    property happyHour          : TRPFoodEntityHappy_Hour      read FhappyHour           write SetHappyHour;
    property OpcionalMinimo     : Integer                      read FOpcionalMinimo      write FOpcionalMinimo;
    property OpcionalMaximo     : Integer                      read FOpcionalMaximo      write FOpcionalMaximo;

    property restringirVenda    : boolean                      read Frestricaovenda      write Frestricaovenda;
    property restricao          : TRPFoodEntityRestricaoVenda  read Frestricao           write SetRestricao;


  end;

  TRPFoodEntityPromocao =class
  private
    FidEmpresa                    : Integer;
    FidProduto                    : Integer;
    FtipoDesconto                 : TRPFoodTipoDesconto;
    FquintaFeira                  : Boolean;
    Fsabado                       : Boolean;
    FsegundaFeira                 : Boolean;
    Fdomingo                      : Boolean;
    FtercaFeira                   : Boolean;
    FsextaFeira                   : Boolean;
    FquartaFeira                  : Boolean;
    FtipoMesa                     : Boolean;
    FtipoComanda                  : Boolean;
    FdescontoSegundaPadrao        : Currency;
    FdescontoSegundaTamanhoP      : Currency;
    FdescontoSegundaTamanhoM      : Currency;
    FdescontoSegundaTamanhoG      : Currency;
    FdescontoSegundaTamanhoGG     : Currency;
    FdescontoSegundaTamanhoExtra  : Currency;
    FdescontoTercaTamanhoG        : Currency;
    FdescontoTercaPadrao          : Currency;
    FdescontoTercaTamanhoGG       : Currency;
    FdescontoTercaTamanhoP        : Currency;
    FdescontoTercaTamanhoExtra    : Currency;
    FdescontoTercaTamanhoM        : Currency;
    FdescontoQuartaTamanhoM       : Currency;
    FdescontoQuartaTamanhoG       : Currency;
    FdescontoQuartaPadrao         : Currency;
    FdescontoQuartaTamanhoGG      : Currency;
    FdescontoQuartaTamanhoP       : Currency;
    FdescontoQuartaTamanhoExtra   : Currency;
    FdescontoQuintaTamanhoExtra   : Currency;
    FdescontoQuintaTamanhoM       : Currency;
    FdescontoQuintaTamanhoG       : Currency;
    FdescontoQuintaPadrao         : Currency;
    FdescontoQuintaTamanhoGG      : Currency;
    FdescontoQuintaTamanhoP       : Currency;
    FdescontoSextaTamanhoM        : Currency;
    FdescontoSextaTamanhoG        : Currency;
    FdescontoSextaPadrao          : Currency;
    FdescontoSextaTamanhoGG       : Currency;
    FdescontoSextaTamanhoP        : Currency;
    FdescontoSextaTamanhoExtra    : Currency;
    FdescontoSabadoTamanhoExtra   : Currency;
    FdescontoSabadoTamanhoM       : Currency;
    FdescontoSabadoTamanhoG       : Currency;
    FdescontoSabadoPadrao         : Currency;
    FdescontoSabadoTamanhoGG      : Currency;
    FdescontoSabadoTamanhoP       : Currency;
    FdescontoDomingoPadrao        : Currency;
    FdescontoDomingoTamanhoGG     : Currency;
    FdescontoDomingoTamanhoP      : Currency;
    FdescontoDomingoTamanhoExtra  : Currency;
    FdescontoDomingoTamanhoM      : Currency;
    FdescontoDomingoTamanhoG      : Currency;
  public
    function DiaDePromocao:Boolean;
    property idEmpresa                             : Integer read FidEmpresa                      write FidEmpresa;
    property idProduto                             : Integer read FidProduto                      write FidProduto;
    property tipoDesconto                          : TRPFoodTipoDesconto read FtipoDesconto       write FtipoDesconto;
    property segundaFeira                          : Boolean read FsegundaFeira                   write FsegundaFeira;
    property tercaFeira                            : Boolean read FtercaFeira                     write FtercaFeira;
    property quartaFeira                           : Boolean read FquartaFeira                    write FquartaFeira;
    property quintaFeira                           : Boolean read FquintaFeira                    write FquintaFeira;
    property sextaFeira                            : Boolean read FsextaFeira                     write FsextaFeira;
    property sabado                                : Boolean read Fsabado                         write Fsabado;
    property domingo                               : Boolean read Fdomingo                        write Fdomingo;
    property tipoMesa                              : Boolean read FtipoMesa                       write FtipoMesa;
    property tipoComanda                           : Boolean read FtipoComanda                    write FtipoComanda;
    property descontoSegundaPadrao                 : Currency read FdescontoSegundaPadrao         write FdescontoSegundaPadrao;
    property descontoSegundaTamanhoP               : Currency read FdescontoSegundaTamanhoP       write FdescontoSegundaTamanhoP;
    property descontoSegundaTamanhoM               : Currency read FdescontoSegundaTamanhoM       write FdescontoSegundaTamanhoM;
    property descontoSegundaTamanhoG               : Currency read FdescontoSegundaTamanhoG       write FdescontoSegundaTamanhoG;
    property descontoSegundaTamanhoGG              : Currency read FdescontoSegundaTamanhoGG      write FdescontoSegundaTamanhoGG;
    property descontoSegundaTamanhoExtra           : Currency read FdescontoSegundaTamanhoExtra   write FdescontoSegundaTamanhoExtra;
    property descontoTercaPadrao                   : Currency read FdescontoTercaPadrao           write FdescontoTercaPadrao;
    property descontoTercaTamanhoP                 : Currency read FdescontoTercaTamanhoP         write FdescontoTercaTamanhoP;
    property descontoTercaTamanhoM                 : Currency read FdescontoTercaTamanhoM         write FdescontoTercaTamanhoM;
    property descontoTercaTamanhoG                 : Currency read FdescontoTercaTamanhoG         write FdescontoTercaTamanhoG;
    property descontoTercaTamanhoGG                : Currency read FdescontoTercaTamanhoGG        write FdescontoTercaTamanhoGG;
    property descontoTercaTamanhoExtra             : Currency read FdescontoTercaTamanhoExtra     write FdescontoTercaTamanhoExtra;
    property descontoQuartaPadrao                  : Currency read FdescontoQuartaPadrao          write FdescontoQuartaPadrao;
    property descontoQuartaTamanhoP                : Currency read FdescontoQuartaTamanhoP        write FdescontoQuartaTamanhoP;
    property descontoQuartaTamanhoM                : Currency read FdescontoQuartaTamanhoM        write FdescontoQuartaTamanhoM;
    property descontoQuartaTamanhoG                : Currency read FdescontoQuartaTamanhoG        write FdescontoQuartaTamanhoG;
    property descontoQuartaTamanhoGG               : Currency read FdescontoQuartaTamanhoGG       write FdescontoQuartaTamanhoGG;
    property descontoQuartaTamanhoExtra            : Currency read FdescontoQuartaTamanhoExtra    write FdescontoQuartaTamanhoExtra;
    property descontoQuintaPadrao                  : Currency read FdescontoQuintaPadrao          write FdescontoQuintaPadrao;
    property descontoQuintaTamanhoP                : Currency read FdescontoQuintaTamanhoP        write FdescontoQuintaTamanhoP;
    property descontoQuintaTamanhoM                : Currency read FdescontoQuintaTamanhoM        write FdescontoQuintaTamanhoM;
    property descontoQuintaTamanhoG                : Currency read FdescontoQuintaTamanhoG        write FdescontoQuintaTamanhoG;
    property descontoQuintaTamanhoGG               : Currency read FdescontoQuintaTamanhoGG       write FdescontoQuintaTamanhoGG;
    property descontoQuintaTamanhoExtra            : Currency read FdescontoQuintaTamanhoExtra    write FdescontoQuintaTamanhoExtra;
    property descontoSextaPadrao                   : Currency read FdescontoSextaPadrao           write FdescontoSextaPadrao;
    property descontoSextaTamanhoP                 : Currency read FdescontoSextaTamanhoP         write FdescontoSextaTamanhoP;
    property descontoSextaTamanhoM                 : Currency read FdescontoSextaTamanhoM         write FdescontoSextaTamanhoM;
    property descontoSextaTamanhoG                 : Currency read FdescontoSextaTamanhoG         write FdescontoSextaTamanhoG;
    property descontoSextaTamanhoGG                : Currency read FdescontoSextaTamanhoGG        write FdescontoSextaTamanhoGG;
    property descontoSextaTamanhoExtra             : Currency read FdescontoSextaTamanhoExtra     write FdescontoSextaTamanhoExtra;
    property descontoSabadoPadrao                  : Currency read FdescontoSabadoPadrao          write FdescontoSabadoPadrao;
    property descontoSabadoTamanhoP                : Currency read FdescontoSabadoTamanhoP        write FdescontoSabadoTamanhoP;
    property descontoSabadoTamanhoM                : Currency read FdescontoSabadoTamanhoM        write FdescontoSabadoTamanhoM;
    property descontoSabadoTamanhoG                : Currency read FdescontoSabadoTamanhoG        write FdescontoSabadoTamanhoG;
    property descontoSabadoTamanhoGG               : Currency read FdescontoSabadoTamanhoGG       write FdescontoSabadoTamanhoGG;
    property descontoSabadoTamanhoExtra            : Currency read FdescontoSabadoTamanhoExtra    write FdescontoSabadoTamanhoExtra;
    property descontoDomingoPadrao                 : Currency read FdescontoDomingoPadrao         write FdescontoDomingoPadrao;
    property descontoDomingoTamanhoP               : Currency read FdescontoDomingoTamanhoP       write FdescontoDomingoTamanhoP;
    property descontoDomingoTamanhoM               : Currency read FdescontoDomingoTamanhoM       write FdescontoDomingoTamanhoM;
    property descontoDomingoTamanhoG               : Currency read FdescontoDomingoTamanhoG       write FdescontoDomingoTamanhoG;
    property descontoDomingoTamanhoGG              : Currency read FdescontoDomingoTamanhoGG      write FdescontoDomingoTamanhoGG;
    property descontoDomingoTamanhoExtra           : Currency read FdescontoDomingoTamanhoExtra   write FdescontoDomingoTamanhoExtra;
  end;

implementation

{ TRPFoodEntityProduto }

procedure TRPFoodEntityProduto.Assign(ASource: TRPFoodEntityProduto);
begin
    Self.codigo                  := ASource.codigo;
    Self.idGrupo                 := ASource.idGrupo;
    Self.descricao               := ASource.descricao;
    Self.observacao              := ASource.observacao;
    Self.valFinal                := ASource.valFinal;
    Self.idEmpresa               := ASource.idEmpresa;
    Self.vendaPorTamanho         := ASource.vendaPorTamanho;
    Self.valorTamanhoP           := ASource.valorTamanhoP;
    Self.valorTamanhoM           := ASource.valorTamanhoM;
    Self.valorTamanhoG           := ASource.valorTamanhoG;
    Self.valorTamanhoGG          := ASource.valorTamanhoGG;
    Self.valorTamanhoExtra       := ASource.valorTamanhoExtra;
    Self.destaqueWeb             := ASource.destaqueWeb;
    Self.tamanhoP                := ASource.tamanhoP;
    Self.tamanhoM                := ASource.tamanhoM;
    Self.tamanhoG                := ASource.tamanhoG;
    Self.tamanhoGG               := ASource.tamanhoGG;
    Self.tamanhoExtra            := ASource.tamanhoExtra;
    Self.tamanhoPadrao           := ASource.tamanhoPadrao;
    Self.permiteFrac             := ASource.permiteFrac;
    Self.utiliza_carrossel       := ASource.utiliza_carrossel;
    Self.happyHourAtivar         := ASource.happyHourAtivar;

    Self.OpcionalMinimo          := ASource.OpcionalMinimo;
    Self.OpcionalMaximo          := ASource.OpcionalMaximo;
    Self.restricao.Assign(ASource.restricao);
    Self.restringirVenda         := ASource.restringirVenda;
end;

function TRPFoodEntityProduto.GetCaminhoHtmlImagem: string;
begin
  Result := Format('images/rpfood/produtos/%d_%d.png',
    [idEmpresa, codigo]);
end;

function TRPFoodEntityProduto.GetDescricao: string;
begin
  Result := Fdescricao.Replace('&', 'E').Replace('.','').Replace('/','').Replace('$','');
end;

function TRPFoodEntityProduto.CaminhoWWWRootImagem: string;
begin
  Result := Format('%s\wwwroot\images\rpfood\produtos\%d_%d.png',
    [ExtractFilePath(GetModuleName(HInstance)), idEmpresa, codigo]);
end;

constructor TRPFoodEntityProduto.Create;
begin
  inherited Create;
  FhappyHour        := TRPFoodEntityHappy_Hour.Create;
  Frestricao        := TRPFoodEntityRestricaoVenda.Create;
end;

destructor TRPFoodEntityProduto.destroy;
begin
  FhappyHour.Free;
   Frestricao.free;
  inherited ;
end;

function TRPFoodEntityProduto.DescricaoTamanhoPadrao: string;
begin
  Result := EmptyStr;
    if FtamanhoPadrao = 'P' then
    Result := FtamanhoP
  else
  if FtamanhoPadrao = 'M' then
    Result := FtamanhoM
  else
  if FtamanhoPadrao = 'G' then
    Result := FtamanhoG
  else
  if FtamanhoPadrao = 'GG' then
    Result := FtamanhoGG
  else
    Result := FtamanhoExtra;
end;

procedure TRPFoodEntityProduto.SalvarImagem(AImagem: TMemoryStream);
var
  LPath: string;
begin
  try
    if (Assigned(AImagem)) and (AImagem.Size > 0) then
    begin
      LPath := CaminhoWWWRootImagem;
      ForceDirectories(ExtractFilePath(LPath));
      AImagem.Position := 0;
      AImagem.SaveToFile(LPath);
    end;
  except
  end;
end;

procedure TRPFoodEntityProduto.SetHappyHour(const AValue: TRPFoodEntityHappy_Hour);
begin
  FreeAndNil( FhappyHour);
  FhappyHour:=AValue;
end;

procedure TRPFoodEntityProduto.SetPromocao(const AValue: TRPFoodEntityPromocao);
begin
  FreeAndNil(FPromocao);
  FPromocao:=AValue;
end;

procedure TRPFoodEntityProduto.SetRestricao(const AValue: TRPFoodEntityRestricaoVenda);
begin
  FreeAndNil(Frestricao);
  Frestricao:=AValue;
end;

function TRPFoodEntityProduto.UsaHappyHour: Boolean;
begin
  Result := (FhappyHourAtivar) and (FhappyHour.HoraDeHappyHour);
end;

function TRPFoodEntityProduto.ValorPorTamanho(ATamanho: string): Currency;
begin
  Result := FvalFinal;

 if UsaHappyHour  then
    Result := happyHour.valor
  else
  begin
    if ATamanho = FtamanhoP then
      Result := FvalorTamanhoP
    else if ATamanho = FtamanhoM then
      Result := FvalorTamanhoM
    else if ATamanho = FtamanhoG then
      Result := FvalorTamanhoG
    else if ATamanho = FtamanhoGG then
      Result := FvalorTamanhoGG
    else if ATamanho = FtamanhoExtra then
      Result := FvalorTamanhoExtra;
  end;

  if Result = 0 then
    Result := FvalFinal;
end;

{ TRPFoodEntityPromocao }
function TRPFoodEntityPromocao.DiaDePromocao: Boolean;
var
  LDiaDeHoje: Integer;
begin
  Result     := False;
  LDiaDeHoje := DayOfTheWeek(Now);
  case LDiaDeHoje of
    DayMonday     : Result := FsegundaFeira;
    DayTuesday    : Result := FtercaFeira;
    DayWednesday  : Result := FquartaFeira;
    DayThursday   : Result := FquintaFeira;
    DayFriday     : Result := FsextaFeira;
    DaySaturday   : Result := Fsabado;
    DaySunday     : Result := Fdomingo;
  end;
end;

end.
