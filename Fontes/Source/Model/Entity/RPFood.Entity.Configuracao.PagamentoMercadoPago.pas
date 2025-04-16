unit RPFood.Entity.Configuracao.PagamentoMercadoPago;

interface


uses
  System.Classes,
  System.SysUtils,
  RPFood.Utils,
  System.DateUtils,
  RPFood.Entity.Types;

  type
  TRPFoodEntityConfiguracaoPagamentoMercadoPago = class

  private
    FId: Integer;
    FAcessToken: string;
    FKey: string;
    FIdSituacao: Integer;
    FIdEmpresa: Integer;
  public
    property Id: Integer read FId write FId;
    property AcessToken: string read FAcessToken write FAcessToken;
    property Key: string read FKey write FKey;
    property IdSituacao: Integer read FIdSituacao write FIdSituacao;
    property IdEmpresa: Integer read FIdEmpresa write FIdEmpresa;
  end;

implementation

end.
