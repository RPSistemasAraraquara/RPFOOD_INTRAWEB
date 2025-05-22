unit RPFood.DAO.FormaPagamento;

interface

uses

  Data.DB,
  FireDAC.Stan.Param,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOFormaPagamento = class(TRPFoodDAOBase<TRPFoodEntityFormaPagamento>)
  private
    procedure SelectFormaPagamento;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityFormaPagamento; override;
  public
    function Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityFormaPagamento>;
    function BuscarPeloCodigo(AIdEmpresa, AIdPagamento: Integer): TRPFoodEntityFormaPagamento;
  end;

implementation

{ TRPFoodDAOFormaPagamento }

function TRPFoodDAOFormaPagamento.BuscarPeloCodigo(AIdEmpresa, AIdPagamento: Integer): TRPFoodEntityFormaPagamento;
var
  LDataSet: TDataSet;
begin
  SelectFormaPagamento;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and id = :id')
    .SQL('and b_venda_web = true')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('id', AIdPagamento);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOFormaPagamento.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityFormaPagamento;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityFormaPagamento.Create;
    try
      Result.id              := ADataSet.FieldByName('id').AsInteger;
      Result.idEmpresa       := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.sfiCodigo       := ADataSet.FieldByName('sfi_codigo').AsInteger;
      Result.descricao       := ADataSet.FieldByName('descricao').AsString;
      Result.permiteVendaWeb := ADataSet.FieldByName('b_venda_web').AsBoolean;
      Result.PagamentoOnline := ADataSet.FieldByName('utiliza_integracao_pix').AsBoolean;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOFormaPagamento.Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityFormaPagamento>;
var
  LDataSet: TDataSet;
begin
  SelectFormaPagamento;
    Query.SQL('where id_empresa = :idEmpresa')
      .SQL('and b_venda_web = true')
      .SQL('order by descricao')
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOFormaPagamento.SelectFormaPagamento;
begin
  Query.SQL('select id, id_empresa, descricao, id_situacao, ')
    .SQL('b_venda_web, sfi_codigo,utiliza_integracao_pix    ')
    .SQL('from formapgto                                    ');
end;

end.


