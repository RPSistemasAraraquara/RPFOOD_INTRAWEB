unit RPFood.DAO.ConfiguracaoFuncionamento;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  Data.DB,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOConfiguracaFuncionamento = class(TRPFoodDAOBase<TRPFoodEntityConfiguracaoAtendimento>)
  private
    procedure Select;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityConfiguracaoAtendimento; override;
  public
    function EmHorarioDeFuncionamento: Boolean;
    function Get(AIdEmpresa: Integer): TRPFoodEntityConfiguracaoAtendimento;
  end;

implementation

{ TRPFoodDAOConfiguracaFuncionamento }

function TRPFoodDAOConfiguracaFuncionamento.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityConfiguracaoAtendimento;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityConfiguracaoAtendimento.Create;
    try
      Result.Segunda          := ADataSet.FieldByName('dia_segunda').AsBoolean;
      Result.Terca            := ADataSet.FieldByName('dia_terca').AsBoolean;
      Result.Quarta           := ADataSet.FieldByName('dia_quarta').AsBoolean;
      Result.Quinta           := ADataSet.FieldByName('dia_quinta').AsBoolean;
      Result.Sexta            := ADataSet.FieldByName('dia_sexta').AsBoolean;
      Result.Sabado           := ADataSet.FieldByName('dia_sabado').AsBoolean;
      Result.Domingo          := ADataSet.FieldByName('dia_domingo').AsBoolean;
      Result.SegundaInicio    := ADataSet.FieldByName('segunda_inicio_atendimento').AsDateTime.GetTime;
      Result.SegundaFim       := ADataSet.FieldByName('segunda_fim_atendimento').AsDateTime.GetTime;
      Result.TercaInicio      := ADataSet.FieldByName('terca_inicio_atendimento').AsDateTime.GetTime;
      Result.TercaFim         := ADataSet.FieldByName('terca_fim_atendimento').AsDateTime.GetTime;
      Result.QuartaInicio     := ADataSet.FieldByName('quarta_inicio_atendimento').AsDateTime.GetTime;
      Result.QuartaFim        := ADataSet.FieldByName('quarta_fim_atendimento').AsDateTime.GetTime;
      Result.QuintaInicio     := ADataSet.FieldByName('quinta_inicio_atendimento').AsDateTime.GetTime;
      Result.QuintaFim        := ADataSet.FieldByName('quinta_fim_atendimento').AsDateTime.GetTime;
      Result.SextaInicio      := ADataSet.FieldByName('sexta_inicio_atendimento').AsDateTime.GetTime;
      Result.SextaFim         := ADataSet.FieldByName('sexta_fim_atendimento').AsDateTime.GetTime;
      Result.SabadoInicio     := ADataSet.FieldByName('sabado_inicio_atendimento').AsDateTime.GetTime;
      Result.SabadoFim        := ADataSet.FieldByName('sabado_fim_atendimento').AsDateTime.GetTime;
      Result.DomingoInicio    := ADataSet.FieldByName('domingo_inicio_atendimento').AsDateTime.GetTime;
      Result.DomingoFim       := ADataSet.FieldByName('domingo_fim_atendimento').AsDateTime.GetTime;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOConfiguracaFuncionamento.EmHorarioDeFuncionamento: Boolean;
var
  LDataSet: TDataSet;
begin
  Query.SQL('SELECT is_atendimento_disponivel();');
  LDataSet := Query.OpenDataSet;
  try
    Result := LDataSet.FieldByName('is_atendimento_disponivel').AsBoolean;
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOConfiguracaFuncionamento.Get(AIdEmpresa: Integer): TRPFoodEntityConfiguracaoAtendimento;
var
  LDataSet: TDataSet;
begin
  Select;
  LDataSet := Query.SQL('where id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOConfiguracaFuncionamento.Select;
begin
  Query.SQL('select id_empresa, dia_segunda, dia_terca, dia_quarta, dia_quinta,   ')
    .SQL('dia_sexta, dia_sabado, dia_domingo,                                     ')
    .SQL('segunda_inicio_atendimento, terca_inicio_atendimento,                   ')
    .SQL('quarta_inicio_atendimento, quinta_inicio_atendimento,                   ')
    .SQL('sexta_inicio_atendimento, sabado_inicio_atendimento,                    ')
    .SQL('domingo_inicio_atendimento,                                             ')
    .SQL('segunda_fim_atendimento, terca_fim_atendimento,                         ')
    .SQL('quarta_fim_atendimento, quinta_fim_atendimento,                         ')
    .SQL('sexta_fim_atendimento, sabado_fim_atendimento,                          ')
    .SQL('domingo_fim_atendimento                                                 ')
    .SQL('from configuracao_funcionamento                                         ');
end;

end.
