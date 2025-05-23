unit RPFood.Entity.ConfiguracaoAtendimento;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.DateUtils,
  System.JSON,
  RPFood.Entity.Types;

type
  TRPFoodEntityHorarioFuncionamento = class;

  TRPFoodEntityConfiguracaAtendimento = class
  private
    FSegunda       : Boolean;
    FTerca         : Boolean;
    FQuarta        : Boolean;
    FQuinta        : Boolean;
    FSexta         : Boolean;
    FSabado        : Boolean;
    FDomingo       : Boolean;
    FSegundaInicio : TTime;
    FSegundaFim    : TTime;
    FTercaInicio   : TTime;
    FTercaFim      : TTime;
    FQuartaInicio  : TTime;
    FQuartaFim     : TTime;
    FQuintaInicio  : TTime;
    FQuintaFim     : TTime;
    FSextaInicio   : TTime;
    FSextaFim      : TTime;
    FSabadoInicio  : TTime;
    FSabadoFim     : TTime;
    FDomingoInicio : TTime;
    FDomingoFim    : TTime;

    FSegundaInicio2 : TTime;
    FSegundaFim2    : TTime;
    FTercaInicio2   : TTime;
    FTercaFim2      : TTime;
    FQuartaInicio2  : TTime;
    FQuartaFim2     : TTime;
    FQuintaInicio2  : TTime;
    FQuintaFim2     : TTime;
    FSextaInicio2   : TTime;
    FSextaFim2      : TTime;
    FSabadoInicio2  : TTime;
    FSabadoFim2     : TTime;
    FDomingoInicio2 : TTime;
    FDomingoFim2    : TTime;
    FHorarios: TObjectList<TRPFoodEntityHorarioFuncionamento>;
    function GetHorarios: TObjectList<TRPFoodEntityHorarioFuncionamento>;
  public
    destructor Destroy; override;
    function JSONString: string;
    property Segunda      : Boolean           read FSegunda             write FSegunda;
    property Terca        : Boolean           read FTerca               write FTerca;
    property Quarta       : Boolean           read FQuarta              write FQuarta;
    property Quinta       : Boolean           read FQuinta              write FQuinta;
    property Sexta        : Boolean           read FSexta               write FSexta;
    property Sabado       : Boolean           read FSabado              write FSabado;
    property Domingo      : Boolean           read FDomingo             write FDomingo;
    property SegundaInicio: TTime             read FSegundaInicio       write FSegundaInicio;
    property SegundaFim   : TTime             read FSegundaFim          write FSegundaFim;
    property TercaInicio  : TTime             read FTercaInicio         write FTercaInicio;
    property TercaFim     : TTime             read FTercaFim            write FTercaFim;
    property QuartaInicio : TTime             read FQuartaInicio        write FQuartaInicio;
    property QuartaFim    : TTime             read FQuartaFim           write FQuartaFim;
    property QuintaInicio : TTime             read FQuintaInicio        write FQuintaInicio;
    property QuintaFim    : TTime             read FQuintaFim           write FQuintaFim;
    property SextaInicio  : TTime             read FSextaInicio         write FSextaInicio;
    property SextaFim     : TTime             read FSextaFim            write FSextaFim;
    property SabadoInicio : TTime             read FSabadoInicio        write FSabadoInicio;
    property SabadoFim    : TTime             read FSabadoFim           write FSabadoFim;
    property DomingoInicio: TTime             read FDomingoInicio       write FDomingoInicio;
    property DomingoFim   : TTime             read FDomingoFim          write FDomingoFim;



    property SegundaInicio2: TTime             read FSegundaInicio2       write FSegundaInicio2;
    property SegundaFim2   : TTime             read FSegundaFim2          write FSegundaFim2;
    property TercaInicio2  : TTime             read FTercaInicio2         write FTercaInicio2;
    property TercaFim2     : TTime             read FTercaFim2            write FTercaFim2;
    property QuartaInicio2 : TTime             read FQuartaInicio2        write FQuartaInicio2;
    property QuartaFim2    : TTime             read FQuartaFim2           write FQuartaFim2;
    property QuintaInicio2 : TTime             read FQuintaInicio2        write FQuintaInicio2;
    property QuintaFim2    : TTime             read FQuintaFim2           write FQuintaFim2;
    property SextaInicio2  : TTime             read FSextaInicio2         write FSextaInicio2;
    property SextaFim2     : TTime             read FSextaFim2            write FSextaFim2;
    property SabadoInicio2 : TTime             read FSabadoInicio2        write FSabadoInicio2;
    property SabadoFim2    : TTime             read FSabadoFim2           write FSabadoFim2;
    property DomingoInicio2: TTime             read FDomingoInicio2       write FDomingoInicio2;
    property DomingoFim2   : TTime             read FDomingoFim2          write FDomingoFim2;

    property Horarios     : TObjectList<TRPFoodEntityHorarioFuncionamento> read GetHorarios;
  end;

  TRPFoodEntityHorarioFuncionamento = class
  private
    FDia              : string;
    FHoraAbertura     : TTime;
    FHoraFechamento   : TTime;
    FHoraAbertura2    : TTime;
    FHoraFechamento2  : TTime;
  public
    property Dia             : string  read FDia             write FDia;
    property HoraAbertura    : TTime   read FHoraAbertura    write FHoraAbertura;
    property HoraFechamento  : TTime   read FHoraFechamento  write FHoraFechamento;
    property HoraAbertura2   : TTime   read FHoraAbertura2   write FHoraAbertura2;
    property HoraFechamento2 : TTime   read FHoraFechamento2 write FHoraFechamento2;
  end;

implementation



function NovoHorario(ADia: string; AAbertura, AFechamento, AAbertura2, AFechamento2: TTime): TRPFoodEntityHorarioFuncionamento;
begin
  Result                  := TRPFoodEntityHorarioFuncionamento.Create;
  Result.Dia              := ADia;
  Result.HoraAbertura     := AAbertura;
  Result.HoraFechamento   := AFechamento;
  Result.HoraAbertura2    := AAbertura2;
  Result.HoraFechamento2  := AFechamento2;
end;

{ TRPFoodEntityConfiguracaAtendimento }

destructor TRPFoodEntityConfiguracaAtendimento.Destroy;
begin
  FHorarios.Free;
  inherited;
end;

function TRPFoodEntityConfiguracaAtendimento.GetHorarios: TObjectList<TRPFoodEntityHorarioFuncionamento>;
begin
  if not Assigned(FHorarios) then
  begin
    FHorarios := TObjectList<TRPFoodEntityHorarioFuncionamento>.Create;
    if FSegunda then
      FHorarios.Add(NovoHorario('Segunda', SegundaInicio, SegundaFim, SegundaInicio2, SegundaFim2));

    if FTerca then
      FHorarios.Add(NovoHorario('Terça', TercaInicio, TercaFim,TercaInicio2, TercaFim2));

    if FQuarta then
      FHorarios.Add(NovoHorario('Quarta', QuartaInicio, QuartaFim, QuartaInicio2, QuartaFim2));

    if FQuinta then
      FHorarios.Add(NovoHorario('Quinta', QuintaInicio, QuintaFim,QuintaInicio2, QuintaFim2));

    if FSexta then
      FHorarios.Add(NovoHorario('Sexta', SextaInicio, SextaFim, SextaInicio2, SextaFim2));

    if FSabado then
      FHorarios.Add(NovoHorario('Sábado', SabadoInicio, SabadoFim,SabadoInicio2, SabadoFim2));

    if FDomingo then
      FHorarios.Add(NovoHorario('Domingo', DomingoInicio, DomingoFim, DomingoInicio2, DomingoFim2));
  end;
  Result := FHorarios;
end;


function TRPFoodEntityConfiguracaAtendimento.JSONString: string;
var
  LJSONArray: TJSONArray;
  LJSON: TJSONObject;
  LHorario: TRPFoodEntityHorarioFuncionamento;
begin
  LJSONArray := TJSONArray.Create;
  try
    for LHorario in Horarios do
    begin
      LJSON := TJSONObject.Create
        .AddPair('Dia', LHorario.Dia)
        .AddPair('HoraAbertura', FormatDateTime('hh:mm', LHorario.HoraAbertura))
        .AddPair('HoraFechamento', FormatDateTime('hh:mm', LHorario.HoraFechamento))
        .AddPair('HoraAbertura2', FormatDateTime('hh:mm', LHorario.HoraAbertura2))
        .AddPair('HoraFechamento2', FormatDateTime('hh:mm', LHorario.HoraFechamento2));
      LJSONArray.Add(LJSON);
    end;
    Result := LJSONArray.ToJSON;
  finally
    LJSONArray.Free;
  end;
end;


end.
