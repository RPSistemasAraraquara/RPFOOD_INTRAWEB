unit RPFood.Entity.RestricaoVenda;

interface

uses
  RPFood.Entity.Types,
  System.DateUtils,
  System.SysUtils;

type
  TRPFoodEntityRestricaoVenda = class
  private
    FquintaFeira    : Boolean;
    Fsabado         : Boolean;
    FsegundaFeira   : Boolean;
    Fdomingo        : Boolean;
    FtercaFeira     : Boolean;
    FsextaFeira     : Boolean;
    FquartaFeira    : Boolean;
    FidEmpresa      : Integer;
    FidProduto      : Integer;
  public
    procedure Assign(ASource: TRPFoodEntityRestricaoVenda);
    function DiaDeRestricao: Boolean;

    property idEmpresa        : Integer read FidEmpresa       write FidEmpresa;
    property idProduto        : Integer read FidProduto       write FidProduto;
    property segundaFeira     : Boolean read FsegundaFeira    write FsegundaFeira;
    property tercaFeira       : Boolean read FtercaFeira      write FtercaFeira;
    property quartaFeira      : Boolean read FquartaFeira     write FquartaFeira;
    property quintaFeira      : Boolean read FquintaFeira     write FquintaFeira;
    property sextaFeira       : Boolean read FsextaFeira      write FsextaFeira;
    property sabado           : Boolean read Fsabado          write Fsabado;
    property domingo          : Boolean read Fdomingo         write Fdomingo;
  end;

implementation

{ TRPFoodEntityRestricaoVenda }

procedure TRPFoodEntityRestricaoVenda.Assign(ASource: TRPFoodEntityRestricaoVenda);
begin
  Self.idProduto      := ASource.idProduto;
  Self.idEmpresa      := ASource.idEmpresa;
  Self.segundaFeira   := ASource.segundaFeira;
  Self.tercaFeira     := ASource.tercaFeira;
  Self.quartaFeira    := ASource.quartaFeira;
  Self.quintaFeira    := ASource.quintaFeira;
  Self.sextaFeira     := ASource.sextaFeira;
  Self.sabado         := ASource.sabado;
  Self.domingo        := ASource.domingo;

end;

function TRPFoodEntityRestricaoVenda.DiaDeRestricao: Boolean;
var
  LDiaDeHoje: Integer;
begin
  Result := False;
  LDiaDeHoje := DayOfTheWeek(Now);
  case LDiaDeHoje of
    DayMonday: Result := FsegundaFeira;
    DayTuesday: Result := FtercaFeira;
    DayWednesday: Result := FquartaFeira;
    DayThursday: Result := FquintaFeira;
    DayFriday: Result := FsextaFeira;
    DaySaturday: Result := Fsabado;
    DaySunday: Result := Fdomingo;
  end;
end;

end.
