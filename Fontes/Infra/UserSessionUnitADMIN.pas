unit UserSessionUnitADMIN;

interface

uses
  System.SysUtils,
  RPFood.Controller,
  RPFood.Entity.Classes;

type
  TRPFoodViewSessionADMIN = class
  private
    FController: TRPFoodController;
    FADMINLogado: TRPFoodEntityADMINUsuario;
    procedure SetADMINLogado(const Value: TRPFoodEntityADMINUsuario);
  public
    constructor Create;
    destructor Destroy; override;

    property ADMINLogado: TRPFoodEntityADMINUsuario read FADMINLogado write SetADMINLogado;
  end;

implementation

{ TRPFoodViewSessionADMIN }

constructor TRPFoodViewSessionADMIN.Create;
begin
  FController := TRPFoodController.Create;
end;

destructor TRPFoodViewSessionADMIN.Destroy;
begin
  FreeAndNil(FController);
  FreeAndNil(FADMINLogado);
  inherited;
end;

procedure TRPFoodViewSessionADMIN.SetADMINLogado(const Value: TRPFoodEntityADMINUsuario);
begin
  FreeAndNil(FADMINLogado);
  FADMINLogado := Value;
end;

end.
