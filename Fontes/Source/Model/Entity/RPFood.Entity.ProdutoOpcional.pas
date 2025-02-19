unit RPFood.Entity.ProdutoOpcional;

interface

uses
  RPFood.Entity.Opcional;

type
  TRPFoodEntityProdutoOpcional = class
  private
    FidEmpresa      : Integer;
    FcodigoProduto  : Integer;
    Fopcional       : TRPFoodEntityOpcional;
    FcodigoOpcional : Integer;
    procedure SetOpcional(const AValue: TRPFoodEntityOpcional);
  public
    constructor Create;
    destructor Destroy; override;
    property idEmpresa            : Integer               read FidEmpresa         write FidEmpresa;
    property codigoProduto        : Integer               read FcodigoProduto     write FcodigoProduto;
    property codigoOpcional       : Integer               read FcodigoOpcional    write FcodigoOpcional;
    property opcional             : TRPFoodEntityOpcional read Fopcional          write SetOpcional;
  end;

implementation

{ TRPFoodEntityProdutoOpcional }

constructor TRPFoodEntityProdutoOpcional.Create;
begin
  Fopcional := TRPFoodEntityOpcional.Create;
end;

destructor TRPFoodEntityProdutoOpcional.Destroy;
begin
  Fopcional.Free;
  inherited;
end;

procedure TRPFoodEntityProdutoOpcional.SetOpcional(const AValue: TRPFoodEntityOpcional);
begin
  if Assigned(AValue) then
    Fopcional.Assign(AValue);
end;

end.
