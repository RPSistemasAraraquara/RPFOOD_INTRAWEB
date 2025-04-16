unit RPFood.Migrations.M0000001.EmpresaCriarTabela;

interface

uses
  System.SysUtils,
  System.DateUtils,
  M4D.RegistryMigrations,
  RPFood.Migrations.Init;

type
  TRPFoodMigrationsM0000001EmpresaCriarTabela = class(TMigrations)
  public
    procedure Setup; override;
    procedure Up; override;
  end;

implementation

{ TRPFoodMigrationsM0000001EmpresaCriarTabela }

procedure TRPFoodMigrationsM0000001EmpresaCriarTabela.Setup;
begin
  Self.Version := 'Empresa Criar Tabela';
  Self.SeqVersion := 1;
  Self.DateTime := EncodeDateTime(2025, 4, 16, 17, 2, 35, 0);
end;

procedure TRPFoodMigrationsM0000001EmpresaCriarTabela.Up;
begin
  FQueryMigration
    .SQL('create table if not exists empresas (')
    .SQL('  id_empresa integer)')
    .ExecSQL;
end;

initialization
  TM4DRegistryMigrations.GetInstance.Add(TRPFoodMigrationsM0000001EmpresaCriarTabela);

end.
