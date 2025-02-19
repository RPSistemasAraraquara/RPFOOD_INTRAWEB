unit RPFood.DAO.Opcional;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

type
  TRPFoodDAOOpcional = class(TRPFoodDAOBase<TRPFoodEntityOpcional>)
  private
    procedure SelectOpcional;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityOpcional; override;
  public
    function Buscar(AIdEmpresa, ACodigo: Integer): TRPFoodEntityOpcional;
    function GetImagem(AIdEmpresa, ACodigo: Integer):TMemoryStream;overload;
    function GetImagem(AOpcional: TRPFoodEntityOpcional):TMemoryStream;overload;
  end;

implementation

{ TRPFoodDAOOpcional }

function TRPFoodDAOOpcional.Buscar(AIdEmpresa, ACodigo: Integer): TRPFoodEntityOpcional;
var
  LDataSet: TDataSet;
begin
  SelectOpcional;
  Query.SQL('where id_empresa = :idEmpresa')
    .SQL('and codigo = :codigo')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', ACodigo);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOOpcional.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityOpcional;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityOpcional.Create;
    try
      Result.codigo            := ADataSet.FieldByName('codigo').AsInteger;
      Result.idEmpresa         := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.descricao         := ADataSet.FieldByName('descricao').AsString;
      Result.valor             := ADataSet.FieldByName('valor').AsCurrency;
      Result.tamanhoP          := ADataSet.FieldByName('opc_p').AsString;
      Result.tamanhoM          := ADataSet.FieldByName('opc_m').AsString;
      Result.tamanhoG          := ADataSet.FieldByName('opc_g').AsString;
      Result.tamanhoGG         := ADataSet.FieldByName('opc_gg').AsString;
      Result.tamanhoExtra      := ADataSet.FieldByName('opc_extra').AsString;
      Result.valorTamanhoP     := ADataSet.FieldByName('valor_opc_p').AsCurrency;
      Result.valorTamanhoM     := ADataSet.FieldByName('valor_opc_m').AsCurrency;
      Result.valorTamanhoG     := ADataSet.FieldByName('valor_opc_g').AsCurrency;
      Result.valorTamanhoGG    := ADataSet.FieldByName('valor_opc_gg').AsCurrency;
      Result.valorTamanhoExtra := ADataSet.FieldByName('valor_opc_extra').AsCurrency;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOOpcional.GetImagem(AOpcional: TRPFoodEntityOpcional): TMemoryStream;
begin
  Result := GetImagem(AOpcional.idEmpresa, AOpcional.codigo);
end;

function TRPFoodDAOOpcional.GetImagem(AIdEmpresa,ACodigo: Integer): TMemoryStream;
var
  LDataSet: TDataSet;
begin
    Result := nil;
  Query.SQL('select produtos.imagem_db from opcional')
    .SQL('where opcional.codigo = :codigo')
    .SQL('and opcional.id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', ACodigo);
    LDataSet := Query.OpenDataSet;
   try
      if not LDataSet.IsEmpty then
      begin
        LDataSet.First;
        if not LDataSet.FieldByName('imagem_db').IsNull then
        begin
          Result := TMemoryStream.Create;
          try
            TBlobField(LDataSet.FieldByName('imagem_db')).SaveToStream(Result);
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

procedure TRPFoodDAOOpcional.SelectOpcional;
begin
  Query.SQL('select codigo, id_empresa, descricao, valor, opc_p, opc_m,')
    .SQL('opc_g, opc_gg, opc_extra, valor_opc_p, valor_opc_m,          ')
    .SQL('valor_opc_g, valor_opc_gg, valor_opc_extra                   ')
    .SQL('from opcional                                                ');
end;

end.
