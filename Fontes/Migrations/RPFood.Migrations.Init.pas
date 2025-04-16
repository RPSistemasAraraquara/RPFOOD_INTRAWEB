unit RPFood.Migrations.Init;

interface

uses
  M4D.RegistryMigrations,
  M4D.RegistryMigrations.ADRConnection,
  ADRConn.Model.Interfaces,
  RPFood.DAO.Conexao;

var
  FConnectionMigration: IADRConnection;
  FQueryMigration: IADRQuery;

procedure StartMigration;

implementation

procedure StartMigration;
begin
  FConnectionMigration := GetConnection;
  FQueryMigration := CreateQuery(FConnectionMigration);
  try
    TM4DRegistryMigrations.GetInstance
      .History(TM4DMigrationsHistoryADRConnection.New(FConnectionMigration))
      .ExecutePending;
  finally
    FConnectionMigration := nil;
    FQueryMigration := nil;
  end;
end;

end.
