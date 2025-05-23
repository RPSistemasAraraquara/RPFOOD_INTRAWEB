unit RPFood.Entity.Happy_Hour;

interface

uses
  system.Classes,
  System.DateUtils,
  System.SysUtils,
  RPFood.Utils;

  type
    TRPFoodEntityHappy_Hour= class
  private
    Fidproduto       : Integer;
    Fidempresa       : Integer;
    Fhorainicial     : TDateTime;
    Fhorafinal       : Tdatetime;
    FsegundaFeira    : Boolean;
    FtercaFeira      : Boolean;
    FquartaFeira     : Boolean;
    FquintaFeira     : Boolean;
    FsextaFeira      : Boolean;
    Fsabado          : Boolean;
    Fdomingo         : Boolean;
    Fvalor           : Currency;
    FutilizaPDV      : Boolean;
    FutilizaDelivery : Boolean;

  public
    procedure Assign(ASource:TRPFoodEntityHappy_Hour);
    property idproduto        : Integer     read Fidproduto         write Fidproduto ;
    property idempresa        : Integer     read Fidempresa         write Fidempresa ;
    property horainicial      : TDateTime   read Fhorainicial       write Fhorainicial;
    property horafinal        : Tdatetime   read Fhorafinal         write Fhorafinal;
    property segundaFeira     : Boolean     read FsegundaFeira      write FsegundaFeira ;
    property tercaFeira       : Boolean     read FtercaFeira        write FtercaFeira ;
    property quartaFeira      : Boolean     read FquartaFeira       write FquartaFeira ;
    property quintaFeira      : Boolean     read FquintaFeira       write FquintaFeira ;
    property sextaFeira       : Boolean     read FsextaFeira        write FsextaFeira ;
    property sabado           : Boolean     read Fsabado            write Fsabado ;
    property domingo          : Boolean     read Fdomingo           write Fdomingo ;
    property valor            : Currency    read Fvalor             write Fvalor;
    property utilizaPDV       : Boolean     read FutilizaPDV        write FutilizaPDV;
    property utilizaDelivery  : Boolean     read FutilizaDelivery   write FutilizaDelivery;
    function HoraDeHappyHour: Boolean;
    function ValorHappyHour:Currency;
  end;

implementation

{ TRPFoodEntityHappy_Hour }

procedure TRPFoodEntityHappy_Hour.Assign(ASource: TRPFoodEntityHappy_Hour);
begin
  Self.idproduto                    := ASource.idproduto;
  Self.idempresa                    := ASource.idempresa;
  Self.horainicial                  := ASource.horainicial;
  Self.horafinal                    := ASource.horafinal;
  Self.segundaFeira                 := ASource.segundaFeira;
  Self.tercaFeira                   := ASource.tercaFeira;
  Self.quartaFeira                  := ASource.quartaFeira;
  Self.quintaFeira                  := ASource.quintaFeira;
  Self.sextaFeira                   := ASource.sextaFeira;
  Self.sabado                       := ASource.sabado;
  Self.domingo                      := ASource.domingo;
  Self.valor                        := ASource.valor;
  Self.utilizaDelivery              := ASource.utilizaDelivery;
end;

function TRPFoodEntityHappy_Hour.HoraDeHappyHour: Boolean;
var
  LDiaDeHoje     : Integer;
  LDiaDeHappyHour: Boolean;
  LHora          : TTime;
begin
  Result := False;
  LDiaDeHappyHour := False;
  LDiaDeHoje := DayOfTheWeek(Now);
  case LDiaDeHoje of
    DayMonday    : LDiaDeHappyHour := segundaFeira;
    DayTuesday   : LDiaDeHappyHour :=tercaFeira;
    DayWednesday : LDiaDeHappyHour := quartaFeira;
    DayThursday  : LDiaDeHappyHour := quintaFeira;
    DayFriday    : LDiaDeHappyHour := sextaFeira;
    DaySaturday  : LDiaDeHappyHour := sabado;
    DaySunday    : LDiaDeHappyHour := domingo;
  end;

  if LDiaDeHappyHour then
  begin
    LHora := Now.GetTime;
    Result := (FhoraFinal >= LHora) and
      (FhoraInicial <= LHora);
  end;
end;

function TRPFoodEntityHappy_Hour.ValorHappyHour: Currency;
begin
  Result:= valor;
end;

end.
