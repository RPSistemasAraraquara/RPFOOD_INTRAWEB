unit RPFood.DAO.Categoria;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

type
  TRPFoodDAOCategoria = class(TRPFoodDAOBase<TRPFoodEntityCategoria>)
  private
    procedure SelectCategoria;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityCategoria; override;
  public
    function Buscar(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityCategoria;
    function Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityCategoria>;
    function AtualizaCategoria(AIdEmpresa,AIdCategoria: Integer): TObjectList<TRPFoodEntityCategoria>;
    function GetImagem(AIdEmpresa, ACodigo: Integer): TMemoryStream; overload;
    function GetImagem(ACategoria: TRPFoodEntityCategoria): TMemoryStream; overload;
    function Buscar1(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityCategoria;
  end;

implementation

{ TRPFoodDAOCategoria }

function TRPFoodDAOCategoria.Buscar(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityCategoria;
var
  LDataSet: TDataSet;
begin
  SelectCategoria;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and codigo = :codigo')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', AIdCategoria);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOCategoria.Buscar1(AIdEmpresa, AIdCategoria: Integer): TRPFoodEntityCategoria;
var
  LDataSet: TDataSet;
begin
  SelectCategoria;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and codigo = :codigo')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', AIdCategoria);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;


function TRPFoodDAOCategoria.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityCategoria;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityCategoria.Create;
    try
      Result.codigo    := ADataSet.FieldByName('codigo').AsInteger;
      Result.idEmpresa := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.descricao := ADataSet.FieldByName('descricao').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOCategoria.AtualizaCategoria(AIdEmpresa,AIdCategoria: Integer): TObjectList<TRPFoodEntityCategoria>;
var
  LDataSet: TDataSet;
begin
 SelectCategoria;
  Query.SQL('where grupos.id_situacao = 4 and grupos.b_exibir_web = true')
    .SQL('and exists (select produtos.codigrupo from produtos where produtos.codigrupo = grupos.codigo)')
    .SQL('and grupos.id_empresa = :idEmpresa and grupos.codigo = :codigo')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo,', AIdCategoria);

  LDataSet := Query.OpenDataSet;
  try

    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOCategoria.GetImagem(AIdEmpresa, ACodigo: Integer): TMemoryStream;
var
  LDataSet: TDataSet;
begin
  Result := nil;
  Query.SQL('select grupos.img from grupos')
    .SQL('where grupos.codigo = :codigo')
    .SQL('and grupos.id_empresa = :idEmpresa')
    .ParamAsInteger('codigo', ACodigo)
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
 try
    if not LDataSet.IsEmpty then
    begin
      LDataSet.First;
      if not LDataSet.FieldByName('img').IsNull then
      begin
        Result := TMemoryStream.Create;
        try
          TBlobField(LDataSet.FieldByName('img')).SaveToStream(Result);
          Result.Position := 0;
        except
          Result.Free;
          Result := nil;
        end;
      end;
    end;
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOCategoria.GetImagem(ACategoria: TRPFoodEntityCategoria): TMemoryStream;
begin
  Result := GetImagem(ACategoria.idEmpresa, ACategoria.codigo);
end;

function TRPFoodDAOCategoria.Listar(AIdEmpresa: Integer): TObjectList<TRPFoodEntityCategoria>;
var
  LDataSet: TDataSet;
begin
  SelectCategoria;
  Query.SQL('where grupos.id_situacao = 4 and grupos.b_exibir_web = true')
    .SQL('and exists (select produtos.codigrupo from produtos where produtos.codigrupo = grupos.codigo limit 1)')
    .SQL('and grupos.id_empresa = :idEmpresa')
    .SQL('order by grupos.descricao ')
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOCategoria.SelectCategoria;
begin
  Query.SQL('select grupos.codigo, grupos.id_empresa, grupos.descricao ')
    .SQL('from grupos')
end;

end.






