unit RPFood.Migrations.M0000002.AddFormaPagamentoOnline;

interface

uses
  System.SysUtils,
  System.DateUtils,
  M4D.RegistryMigrations,
  RPFood.Migrations.Init;

  type
  TRPFoodMigrationsM0000002AddFormaPagamentoOnline = class(TMigrations)
  public
    procedure Setup; override;
    procedure Up; override;
  end;

implementation

{ TRPFoodMigrationsM0000002AddFormaPagamentoOnline }

procedure TRPFoodMigrationsM0000002AddFormaPagamentoOnline.Setup;
begin
  Self.Version := 'ADD Tabela FormaPGTO Column de PagamentoOnline ';
  Self.SeqVersion := 2;
  Self.DateTime := StrToDateTime('20/04/2025 11:40:10');

end;

procedure TRPFoodMigrationsM0000002AddFormaPagamentoOnline.Up;
begin
  FQueryMigration
  .SQL('alter table formapgto add column utilizapagamentoonline boolean default false')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_rpfood add column integracaomercadopago boolean default false')
  .ExecSQL;
end;

initialization
  TM4DRegistryMigrations.GetInstance.Add(TRPFoodMigrationsM0000002AddFormaPagamentoOnline);

end.
