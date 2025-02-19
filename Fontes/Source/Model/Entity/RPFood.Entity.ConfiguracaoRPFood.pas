unit RPFood.Entity.ConfiguracaoRPFood;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TRPFoodEntityConfiguracaoRPFood =class
  private
    FIdEmpresa               : Integer;
    FUtilizarCEP             : Boolean;
    FTempoRetiradaRPFood     : Integer;
    FTempoEntregaRPFood      : Integer;
    FPermiteRetiradanoLocal  : boolean;
    Fmodoacougue             : Boolean;
    FpedidoMinimo            : Currency;
    Futilizacontroleopcionais: Boolean;
  public
    constructor Create;

    property IdEmpresa                : Integer   read FIdEmpresa                 write FIdEmpresa;
    property UtilizarCEP              : Boolean   read FUtilizarCEP               write FUtilizarCEP;
    property TempoRetiradaRPFood      : Integer   read FTempoRetiradaRPFood       write FTempoRetiradaRPFood;
    property TempoEntregaRPFood       : Integer   read FTempoEntregaRPFood        write FTempoEntregaRPFood;
    property PermiteRetiradanoLocal   : Boolean   read FPermiteRetiradanoLocal    write FPermiteRetiradanoLocal;
    property modoacougue              : Boolean   read Fmodoacougue               write Fmodoacougue;
    property pedidoMinimo             : Currency  read Fpedidominimo              write Fpedidominimo;
    property utilizacontroleopcionais : Boolean   read Futilizacontroleopcionais  write Futilizacontroleopcionais;

  end;

implementation

{ TRPFoodEntityConfiguracaoRPFood }

constructor TRPFoodEntityConfiguracaoRPFood.Create;
begin
  FUtilizarCEP             := true;
  FPermiteRetiradanoLocal  := True;
end;

end.
