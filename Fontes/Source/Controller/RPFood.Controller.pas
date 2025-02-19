unit RPFood.Controller;

interface

uses
  RPFood.Components,
  RPFood.Service,
  RPFood.DAO.Factory;

type
  TRPFoodController = class
  private
    FComponents: TRPFoodComponents;
    FDAO: TRPFoodDAOFactory;
    FService: TRPFoodService;
  public
    destructor Destroy; override;

    function Components: TRPFoodComponents;
    function DAO: TRPFoodDAOFactory;
    function Service: TRPFoodService;
  end;

implementation

{ TRPFoodController }

uses
  ServerController;

destructor TRPFoodController.Destroy;
begin
  FComponents.Free;
  FDAO.Free;
  FService.Free;

  inherited;
end;

function TRPFoodController.Service: TRPFoodService;
begin
  if not Assigned(FService) then
  begin
    FService := TRPFoodService.Create;
    FService.Components(Components)
      .DAO(DAO);
  end;
  Result := FService;
end;

function TRPFoodController.Components: TRPFoodComponents;
begin
  if not Assigned(FComponents) then
    FComponents := TRPFoodComponents.Create;
  Result := FComponents;
end;

function TRPFoodController.DAO: TRPFoodDAOFactory;
begin
  if not Assigned(FDAO) then
    FDAO := TRPFoodDAOFactory.Create(UserSession.Connection);
  Result := FDAO;
end;

end.
