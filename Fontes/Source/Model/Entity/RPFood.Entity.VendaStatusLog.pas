unit RPFood.Entity.VendaStatusLog;

interface

uses
  RPFood.Entity.Types;

type
  TRPFoodEntityVendaStatusLog = class
  private
    FidVenda: Integer;
    FidEmpresa: Integer;
    Fdata: TDateTime;
    Fsituacao: TRPSituacaoPedido;
    function GetSituacaoDescricao: string;
    function GetSituacaoFinal: Boolean;
  public
    property idVenda: Integer read FidVenda write FidVenda;
    property idEmpresa: Integer read FidEmpresa write FidEmpresa;
    property data: TDateTime read Fdata write Fdata;
    property situacao: TRPSituacaoPedido read Fsituacao write Fsituacao;
    property situacaoDescricao: string read GetSituacaoDescricao;
    property situacaoFinal: Boolean read GetSituacaoFinal;
  end;

implementation

{ TRPFoodEntityVendaStatusLog }

function TRPFoodEntityVendaStatusLog.GetSituacaoDescricao: string;
begin
  Result := Fsituacao.Descricao;
end;

function TRPFoodEntityVendaStatusLog.GetSituacaoFinal: Boolean;
begin
  Result := Fsituacao.StatusFinal;
end;

end.
