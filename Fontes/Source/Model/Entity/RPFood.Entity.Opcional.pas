unit RPFood.Entity.Opcional;

interface

uses
  System.SysUtils;

type
  TRPFoodEntityOpcional = class
  private
    Fcodigo             : Integer;
    Fdescricao          : string;
    Fvalor              : Currency;
    FidEmpresa          : Integer;
    FvalorTamanhoExtra  : Currency;
    FtamanhoM           : string;
    FvalorTamanhoM      : Currency;
    FtamanhoG           : string;
    FvalorTamanhoG      : Currency;
    FtamanhoGG          : string;
    FtamanhoP           : string;
    FtamanhoExtra       : string;
    FvalorTamanhoGG     : Currency;
    FvalorTamanhoP      : Currency;
  public
    procedure Assign(AOpcional: TRPFoodEntityOpcional);
    function ValorPorTamanho(ATamanho: string): Currency;
    property codigo           : Integer       read Fcodigo            write Fcodigo;
    property idEmpresa        : Integer       read FidEmpresa         write FidEmpresa;
    property descricao        : string        read Fdescricao         write Fdescricao;
    property valor            : Currency      read Fvalor             write Fvalor;
    property valorTamanhoP    : Currency      read FvalorTamanhoP     write FvalorTamanhoP;
    property valorTamanhoM    : Currency      read FvalorTamanhoM     write FvalorTamanhoM;
    property valorTamanhoG    : Currency      read FvalorTamanhoG     write FvalorTamanhoG;
    property valorTamanhoGG   : Currency      read FvalorTamanhoGG    write FvalorTamanhoGG;
    property valorTamanhoExtra: Currency      read FvalorTamanhoExtra write FvalorTamanhoExtra;
    property tamanhoP         : string        read FtamanhoP          write FtamanhoP;
    property tamanhoM         : string        read FtamanhoM          write FtamanhoM;
    property tamanhoG         : string        read FtamanhoG          write FtamanhoG;
    property tamanhoGG        : string        read FtamanhoGG         write FtamanhoGG;
    property tamanhoExtra     : string        read FtamanhoExtra      write FtamanhoExtra;
  end;

implementation

{ TRPFoodEntityOpcional }

procedure TRPFoodEntityOpcional.Assign(AOpcional: TRPFoodEntityOpcional);
begin
  Self.codigo            := AOpcional.codigo;
  Self.descricao         := AOpcional.descricao;
  Self.valor             := AOpcional.valor;
  Self.idEmpresa         := AOpcional.idEmpresa;
  Self.tamanhoP          := AOpcional.tamanhoP;
  Self.tamanhoM          := AOpcional.tamanhoM;
  Self.tamanhoG          := AOpcional.tamanhoG;
  Self.tamanhoGG         := AOpcional.tamanhoGG;
  Self.tamanhoExtra      := AOpcional.tamanhoExtra;
  Self.valorTamanhoP     := AOpcional.valorTamanhoP;
  Self.valorTamanhoM     := AOpcional.valorTamanhoM;
  Self.valorTamanhoG     := AOpcional.valorTamanhoG;
  Self.valorTamanhoGG    := AOpcional.valorTamanhoGG;
  Self.valorTamanhoExtra := AOpcional.valorTamanhoExtra;
end;

function TRPFoodEntityOpcional.ValorPorTamanho(ATamanho: string): Currency;
begin
  Result := Fvalor;
  if ATamanho.ToUpper = 'P' then
    Result := FvalorTamanhoP
  else
  if ATamanho.ToUpper = 'M' then
    Result := FvalorTamanhoM
  else
  if ATamanho.ToUpper = 'G' then
    Result := FvalorTamanhoG
  else
  if ATamanho.ToUpper = 'GG' then
    Result := FvalorTamanhoGG
  else
  if ATamanho.ToUpper = 'EXTRA' then
    Result := FvalorTamanhoExtra;

end;

end.
