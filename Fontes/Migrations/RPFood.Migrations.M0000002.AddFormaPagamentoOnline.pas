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
  Self.Version    := 'ADD Tabela FormaPGTO Column de PagamentoOnline ';
  Self.SeqVersion := 2;
  Self.DateTime   := StrToDateTime('20/04/2025 11:40:10');
end;

procedure TRPFoodMigrationsM0000002AddFormaPagamentoOnline.Up;
begin
  FQueryMigration
  .SQL('alter table formapgto add column utiliza_integracao_pix boolean default false')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_rpfood add column integracaomercadopago boolean default false')
  .ExecSQL;

   FQueryMigration
   .SQL(' alter table formapgto add column utilizapagamentoonline boolean not null default false')
   .ExecSQL;

  FQueryMigration
  .SQL(' create table configuracaopagamentomercadopago (     ')
  .SQL(' id integer not null,                                ')
  .SQL('  acessToken varchar(255),                           ')
  .SQL(' publicKey varchar(255),                             ')
  .SQL(' id_situacao integer not null,                       ')
  .SQL(' id_Empresa integer not null  )                      ')
  .ExecSQL;

  FQueryMigration
   .SQL(' alter table configuracao_funcionamento add column segunda_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
   .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column terca_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column quarta_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column quinta_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column sexta_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column sabado_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column domingo_inicio_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column segunda_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column terca_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column quarta_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column quinta_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column sexta_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column sabado_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('alter table configuracao_funcionamento add column domingo_fim_atendimento_p2 time without time zone NOT NULL DEFAULT ''00:00:00''')
  .ExecSQL;

  FQueryMigration
  .SQL('CREATE OR REPLACE FUNCTION public.is_atendimento_disponivel( )                ')
  .SQL('   RETURNS boolean                                                            ')
  .SQL('  LANGUAGE ''plpgsql''                                                        ')
  .SQL('  COST 100                                                                    ')
  .SQL(' VOLATILE PARALLEL UNSAFE                                                     ')
  .SQL(' AS $BODY$                                                                    ')
  .SQL('  DECLARE                                                                     ')
  .SQL('  atendimento_disponivel BOOLEAN := false;                                    ')
  .SQL('  config configuracao_funcionamento%ROWTYPE;                                  ')
  .SQL('  current_day_of_week INTEGER;                                                ')
  .SQL('  current_local_time TIME;                                                    ')
  .SQL(' BEGIN                                                                        ')
  .SQL('  current_day_of_week := EXTRACT(DOW FROM CURRENT_DATE)::INTEGER;             ')


  .SQL(' current_local_time := (SELECT Current_Time at time zone ''America/Sao_Paulo''); ')
  .SQL(' SELECT * INTO config FROM configuracao_funcionamento LIMIT 1;           ')
  .SQL(' CASE current_day_of_week                                                ')
  .SQL('    WHEN 1 THEN                                                          ')
  .SQL('       atendimento_disponivel := (config.dia_segunda) AND                ')
  .SQL('          ((current_local_time >= config.segunda_inicio_atendimento AND  ')
  .SQL('            current_local_time <= config.segunda_fim_atendimento) OR     ')
  .SQL('   (current_local_time >= config.segunda_inicio_atendimento_p2 AND       ')
  .SQL('            current_local_time <= config.segunda_fim_atendimento_p2));   ')
  .SQL('  WHEN 2 THEN                                                            ')
  .SQL('     atendimento_disponivel := (config.dia_terca) AND                    ')
  .SQL('        ((current_local_time >= config.terca_inicio_atendimento AND      ')
  .SQL('         current_local_time <= config.terca_fim_atendimento) OR          ')
  .SQL('   (current_local_time >= config.terca_inicio_atendimento_p2 AND         ')
  .SQL('           current_local_time <= config.terca_fim_atendimento_p2));      ')
  .SQL('  WHEN 3 THEN                                                            ')
  .SQL('      atendimento_disponivel := (config.dia_quarta) AND                  ')
  .SQL('        ((current_local_time >= config.quarta_inicio_atendimento AND     ')
  .SQL('          current_local_time <= config.quarta_fim_atendimento) OR        ')
  .SQL('  (current_local_time >= config.quarta_inicio_atendimento_p2 AND         ')
  .SQL('            current_local_time <= config.quarta_fim_atendimento_p2));    ')
  .SQL('   WHEN 4 THEN                                                           ')
  .SQL('      atendimento_disponivel := (config.dia_quinta) AND                  ')
  .SQL('         ((current_local_time >= config.quinta_inicio_atendimento AND    ')
  .SQL('        current_local_time <= config.quinta_fim_atendimento) OR          ')
  .SQL('   (current_local_time >= config.quinta_inicio_atendimento_p2 AND        ')
  .SQL('         current_local_time <= config.quinta_fim_atendimento_p2));       ')
  .SQL('  WHEN 5 THEN                                                            ')
  .SQL('      atendimento_disponivel := (config.dia_sexta) AND                   ')
  .SQL('         ((current_local_time >= config.sexta_inicio_atendimento AND     ')
  .SQL('           current_local_time <= config.sexta_fim_atendimento) OR        ')
  .SQL('  (current_local_time >= config.sexta_inicio_atendimento_p2 AND          ')
  .SQL('           current_local_time <= config.sexta_fim_atendimento_p2));      ')
  .SQL('  WHEN 6 THEN                                                            ')
  .SQL('      atendimento_disponivel := (config.dia_sabado) AND                  ')
  .SQL('        ((current_local_time >= config.sabado_inicio_atendimento AND     ')
  .SQL('           current_local_time <= config.sabado_fim_atendimento) OR       ')
  .SQL('  (current_local_time >= config.sabado_inicio_atendimento_p2 AND         ')
  .SQL('          current_local_time <= config.sabado_fim_atendimento_p2));      ')
  .SQL('  WHEN 0 THEN                                                            ')
  .SQL('     atendimento_disponivel := (config.dia_domingo) AND                  ')
  .SQL('       ((current_local_time >= config.domingo_inicio_atendimento AND     ')
  .SQL('          current_local_time <= config.domingo_fim_atendimento) OR       ')
  .SQL('  (current_local_time >= config.domingo_inicio_atendimento_p2 AND        ')
  .SQL('            current_local_time <= config.domingo_fim_atendimento_p2));   ')
  .SQL(' END CASE;                                                               ')
  .SQL('                                                                         ')
  .SQL('  RETURN atendimento_disponivel;                                         ')
  .SQL(' END;  $BODY$;                                                           ')

  .SQL(' ALTER FUNCTION public.is_atendimento_disponivel()                       ')
  .SQL('  OWNER TO postgres                                                      ')
  .ExecSQL;





end;

initialization
  TM4DRegistryMigrations.GetInstance.Add(TRPFoodMigrationsM0000002AddFormaPagamentoOnline);

end.
