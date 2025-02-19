unit RPFood.DAO.TransferenciaImagens;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB,
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  System.Generics.Collections;

type
  TRPFoodDAOTransferenciaImagens = class(TRPFoodDAOBase<TRPFoodEntityTransferenciaImagens>)
  private
    procedure Select;
    function Busca(AIdEmpresa, AIdRegistro: Integer; ATipo: string): TRPFoodEntityTransferenciaImagens;
    procedure Delete(AIdEmpresa, AIdRegistro: Integer; ATipo: string);
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityTransferenciaImagens;
  public
    function BuscaPorProduto(AIdEmpresa, AIdProduto: Integer): TRPFoodEntityTransferenciaImagens;
    function BuscaPorCategoria(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityTransferenciaImagens;
    function BuscaPorOpcional(AIdEmpresa, AIdOpcional: Integer): TRPFoodEntityTransferenciaImagens;

    procedure DeletePorProduto(AIdEmpresa, AIdProduto: Integer);
    procedure DeletePorCategoria(AIdEmpresa, AIdCategoria: Integer);
    procedure DeletePorOpcional(AIdEmpresa, AIdOpcional: Integer);
  end;

implementation

{ TRPFoodDAOTransferenciaImagens }

function TRPFoodDAOTransferenciaImagens.Busca(AIdEmpresa, AIdRegistro: Integer;
  ATipo: string): TRPFoodEntityTransferenciaImagens;
var
  LDataSet: TDataSet;
begin
  Select;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and id_registro = :idRegistro')
    .SQL('and tipo = :tipo ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idRegistro', AIdRegistro)
    .ParamAsString('tipo', ATipo);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOTransferenciaImagens.BuscaPorCategoria(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityTransferenciaImagens;
begin
  Result := Busca(AIdEmpresa, AIdCategoria, 'GRUPOS');
end;

function TRPFoodDAOTransferenciaImagens.BuscaPorOpcional(AIdEmpresa,AIdOpcional: Integer): TRPFoodEntityTransferenciaImagens;
begin
   Result := Busca(AIdEmpresa, AIdOpcional, 'OPCIONAL');
end;

function TRPFoodDAOTransferenciaImagens.BuscaPorProduto(AIdEmpresa, AIdProduto: Integer): TRPFoodEntityTransferenciaImagens;
begin
  Result := Busca(AIdEmpresa, AIdProduto, 'PRODUTOS');
end;

function TRPFoodDAOTransferenciaImagens.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityTransferenciaImagens;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityTransferenciaImagens.Create;
    try
      Result.id         := ADataSet.FieldByName('id').AsInteger;
      Result.idEmpresa  := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.tipo       := ADataSet.FieldByName('tipo').AsString;
      Result.idRegistro := ADataSet.FieldByName('id_registro').AsInteger;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOTransferenciaImagens.Delete(AIdEmpresa, AIdRegistro: Integer; ATipo: string);
begin
  StartTransaction;
  try
    Query.SQL('delete from transferencia_imagens')
      .SQL('where id_empresa = :idEmpresa       ')
      .SQL('and id_registro = :idRegistro       ')
      .SQL('and tipo = :tipo                    ')
      .ParamAsInteger('idEmpresa', AIdEmpresa)
      .ParamAsInteger('idRegistro', AIdRegistro)
      .ParamAsString('tipo', ATipo)
      .ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TRPFoodDAOTransferenciaImagens.DeletePorCategoria(AIdEmpresa, AIdCategoria: Integer);
begin
  Delete(AIdEmpresa, AIdCategoria, 'GRUPOS');
end;

procedure TRPFoodDAOTransferenciaImagens.DeletePorOpcional(AIdEmpresa, AIdOpcional: Integer);
begin
   Delete(AIdEmpresa, AIdOpcional, 'OPCIONAL');
end;

procedure TRPFoodDAOTransferenciaImagens.DeletePorProduto(AIdEmpresa, AIdProduto: Integer);
begin
  Delete(AIdEmpresa, AIdProduto, 'PRODUTOS');
end;

procedure TRPFoodDAOTransferenciaImagens.Select;
begin
  Query.SQL('select id, id_empresa, id_registro, tipo')
    .SQL('from transferencia_imagens                 ');
end;

end.





