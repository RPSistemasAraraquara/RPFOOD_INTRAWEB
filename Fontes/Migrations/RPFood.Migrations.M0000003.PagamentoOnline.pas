unit RPFood.Migrations.M0000003.PagamentoOnline;

interface

uses
  System.SysUtils,
  System.DateUtils,
  M4D.RegistryMigrations,
  RPFood.Migrations.Init;
  type
  TRPFoodMigrationsM0000003PagamentoOnline = class(TMigrations)
   public
    procedure Setup; override;
    procedure Up; override;
  end;

implementation

{ TRPFoodMigrationsM0000003PagamentoOnline }

procedure TRPFoodMigrationsM0000003PagamentoOnline.Setup;
begin
  Self.Version    := 'Criação Tabela Pagamento Online ';
  Self.SeqVersion := 3;
  Self.DateTime   := StrToDateTime('23/04/2025 15:24:10');
end;

procedure TRPFoodMigrationsM0000003PagamentoOnline.Up;
begin
   FQueryMigration
   .SQL(' create table if not exists pagamentoonline( ')
   .SQL(' id serial,                                  ')
   .SQL(' idempresa integer not null,                 ')
   .SQL(' idVenda integer not null,                   ')
   .SQL(' idcliente integer ,                         ')
   .SQL(' integracaopagamento varchar(50),            ')
   .SQL(' urlqrcode varchar(155),                     ')
   .SQL(' valorpagamentoonline numeric (15,3),        ')
   .SQL(' status varchar(50))                         ')
   .ExecSQL;
end;

initialization
  TM4DRegistryMigrations.GetInstance.Add(TRPFoodMigrationsM0000003PagamentoOnline);

end.
