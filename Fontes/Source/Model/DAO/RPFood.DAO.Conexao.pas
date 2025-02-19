unit RPFood.DAO.Conexao;

interface

uses
  ADRConn.Model.Interfaces,
  RPFood.Resources;

type
  IADRConnection = ADRConn.Model.Interfaces.IADRConnection;
  IADRQuery = ADRConn.Model.Interfaces.IADRQuery;

function GetConnection: IADRConnection;

implementation

function GetConnection: IADRConnection;
begin
  Result := ADRConn.Model.Interfaces.CreateConnection;
  Result.Params
    .Driver(adrPostgres)
    .Server(APP_RESOURCES.DATABASE_HOST)
    .Database(APP_RESOURCES.DATABASE_ALIAS)
    .UserName(APP_RESOURCES.DATABASE_USERNAME)
    .Password(APP_RESOURCES.DATABASE_PASSWORD)
    .Schema(APP_RESOURCES.DATABASE_SCHEMA)
    .Port(APP_RESOURCES.DATABASE_PORT);

  Result.Connect;
end;

end.
