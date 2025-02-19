unit RPFood.Entity.FormaPagamento;

interface

type
  TRPFoodEntityFormaPagamento = class
  private
    Fid             : Integer;
    FidEmpresa      : Integer;
    Fdescricao      : string;
    FpermiteVendaWeb: Boolean;
    FsfiCodigo      : Integer;
    function GetPermiteTroco: Boolean;
  public
    constructor Create;
    procedure Assign(ASource: TRPFoodEntityFormaPagamento);

    property id                 : Integer     read Fid              write Fid;
    property idEmpresa          : Integer     read FidEmpresa       write FidEmpresa;
    property descricao          : string      read Fdescricao       write Fdescricao;
    property permiteVendaWeb    : Boolean     read FpermiteVendaWeb write FpermiteVendaWeb;
    property sfiCodigo          : Integer     read FsfiCodigo       write FsfiCodigo;
    property permiteTroco       : Boolean     read GetPermiteTroco;
  end;

implementation

{ TRPFoodEntityFormaPagamento }

procedure TRPFoodEntityFormaPagamento.Assign(ASource: TRPFoodEntityFormaPagamento);
begin
  Self.id              := ASource.id;
  Self.idEmpresa       := ASource.idEmpresa;
  Self.descricao       := ASource.descricao;
  Self.permiteVendaWeb := ASource.permiteVendaWeb;
  Self.sfiCodigo       := ASource.sfiCodigo;
end;

constructor TRPFoodEntityFormaPagamento.Create;
begin
  FpermiteVendaWeb := True;
end;

function TRPFoodEntityFormaPagamento.GetPermiteTroco: Boolean;
begin
  Result := FsfiCodigo = 1;
end;

end.
