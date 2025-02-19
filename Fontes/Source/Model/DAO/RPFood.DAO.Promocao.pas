unit RPFood.DAO.Promocao;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  RPFood.Entity.Types,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

type
  TRPfoodDAOPromocao = class(TRPFoodDAOBase<TRPFoodEntityPromocao>)
  private
    procedure Select;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityPromocao; override;
  public
    function Buscar(AIdProduto,AidEmpresa: Integer): TRPFoodEntityPromocao;
end;


implementation

{ TRPfoodDAOPromocao }

function TRPfoodDAOPromocao.Buscar(AIdProduto,AidEmpresa: Integer): TRPFoodEntityPromocao;
var
  LDataSet: TDataSet;
begin
  Select;
  LDataSet := Query.SQL('where idEmpresa = :idEmpresa')
    .SQL('and idProdutoApi = :idProduto              ')
    .ParamAsInteger('idEmpresa', AidEmpresa)
    .ParamAsInteger('idProduto', AIdProduto)
    .OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPfoodDAOPromocao.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityPromocao;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityPromocao.Create;
    try
      Result.idEmpresa                                 := ADataSet.FieldByName('idEmpresa').AsInteger;
      Result.idProduto                                 := ADataSet.FieldByName('idProduto').AsInteger;
      Result.tipoDesconto.FromDBValue                    (ADataSet.FieldByName('tipoDesconto').AsString);
      Result.segundaFeira                              := ADataSet.FieldByName('segundaFeira').AsBoolean;
      Result.tercaFeira                                := ADataSet.FieldByName('tercaFeira').AsBoolean;
      Result.quartaFeira                               := ADataSet.FieldByName('quartaFeira').AsBoolean;
      Result.quintaFeira                               := ADataSet.FieldByName('quintaFeira').AsBoolean;
      Result.sextaFeira                                := ADataSet.FieldByName('sextaFeira').AsBoolean;
      Result.sabado                                    := ADataSet.FieldByName('sabado').AsBoolean;
      Result.domingo                                   := ADataSet.FieldByName('domingo').AsBoolean;
      Result.tipoMesa                                  := ADataSet.FieldByName('tipoMesa').AsBoolean;
      Result.tipoComanda                               := ADataSet.FieldByName('tipoComanda').AsBoolean;
      Result.descontoSegundaPadrao                     := ADataSet.FieldByName('descontoSegundaPadrao').AsCurrency;
      Result.descontoSegundaTamanhoP                   := ADataSet.FieldByName('descontoSegundaTamanhoP').AsCurrency;
      Result.descontoSegundaTamanhoM                   := ADataSet.FieldByName('descontoSegundaTamanhoM').AsCurrency;
      Result.descontoSegundaTamanhoG                   := ADataSet.FieldByName('descontoSegundaTamanhoG').AsCurrency;
      Result.descontoSegundaTamanhoGG                  := ADataSet.FieldByName('descontoSegundaTamanhoGG').AsCurrency;
      Result.descontoSegundaTamanhoExtra               := ADataSet.FieldByName('descontoSegundaTamanhoExtra').AsCurrency;
      Result.descontoTercaPadrao                       := ADataSet.FieldByName('descontoTercaPadrao').AsCurrency;
      Result.descontoTercaTamanhoP                     := ADataSet.FieldByName('descontoTercaTamanhoP').AsCurrency;
      Result.descontoTercaTamanhoM                     := ADataSet.FieldByName('descontoTercaTamanhoM').AsCurrency;
      Result.descontoTercaTamanhoG                     := ADataSet.FieldByName('descontoTercaTamanhoG').AsCurrency;
      Result.descontoTercaTamanhoGG                    := ADataSet.FieldByName('descontoTercaTamanhoGG').AsCurrency;
      Result.descontoTercaTamanhoExtra                 := ADataSet.FieldByName('descontoTercaTamanhoExtra').AsCurrency;
      Result.descontoQuartaPadrao                      := ADataSet.FieldByName('descontoQuartaPadrao').AsCurrency;
      Result.descontoQuartaTamanhoP                    := ADataSet.FieldByName('descontoQuartaTamanhoP').AsCurrency;
      Result.descontoQuartaTamanhoM                    := ADataSet.FieldByName('descontoQuartaTamanhoM').AsCurrency;
      Result.descontoQuartaTamanhoG                    := ADataSet.FieldByName('descontoQuartaTamanhoG').AsCurrency;
      Result.descontoQuartaTamanhoGG                   := ADataSet.FieldByName('descontoQuartaTamanhoGG').AsCurrency;
      Result.descontoQuartaTamanhoExtra                := ADataSet.FieldByName('descontoQuartaTamanhoExtra').AsCurrency;
      Result.descontoQuintaPadrao                      := ADataSet.FieldByName('descontoQuintaPadrao').AsCurrency;
      Result.descontoQuintaTamanhoP                    := ADataSet.FieldByName('descontoQuintaTamanhoP').AsCurrency;
      Result.descontoQuintaTamanhoM                    := ADataSet.FieldByName('descontoQuintaTamanhoM').AsCurrency;
      Result.descontoQuintaTamanhoG                    := ADataSet.FieldByName('descontoQuintaTamanhoG').AsCurrency;
      Result.descontoQuintaTamanhoGG                   := ADataSet.FieldByName('descontoQuintaTamanhoGG').AsCurrency;
      Result.descontoQuintaTamanhoExtra                := ADataSet.FieldByName('descontoQuintaTamanhoExtra').AsCurrency;
      Result.descontoSextaPadrao                       := ADataSet.FieldByName('descontoSextaPadrao').AsCurrency;
      Result.descontoSextaTamanhoP                     := ADataSet.FieldByName('descontoSextaTamanhoP').AsCurrency;
      Result.descontoSextaTamanhoM                     := ADataSet.FieldByName('descontoSextaTamanhoM').AsCurrency;
      Result.descontoSextaTamanhoG                     := ADataSet.FieldByName('descontoSextaTamanhoG').AsCurrency;
      Result.descontoSextaTamanhoGG                    := ADataSet.FieldByName('descontoSextaTamanhoGG').AsCurrency;
      Result.descontoSextaTamanhoExtra                 := ADataSet.FieldByName('descontoSextaTamanhoExtra').AsCurrency;
      Result.descontoSabadoPadrao                      := ADataSet.FieldByName('descontoSabadoPadrao').AsCurrency;
      Result.descontoSabadoTamanhoP                    := ADataSet.FieldByName('descontoSabadoTamanhoP').AsCurrency;
      Result.descontoSabadoTamanhoM                    := ADataSet.FieldByName('descontoSabadoTamanhoM').AsCurrency;
      Result.descontoSabadoTamanhoG                    := ADataSet.FieldByName('descontoSabadoTamanhoG').AsCurrency;
      Result.descontoSabadoTamanhoGG                   := ADataSet.FieldByName('descontoSabadoTamanhoGG').AsCurrency;
      Result.descontoSabadoTamanhoExtra                := ADataSet.FieldByName('descontoSabadoTamanhoExtra').AsCurrency;
      Result.descontoDomingoPadrao                     := ADataSet.FieldByName('descontoDomingoPadrao').AsCurrency;
      Result.descontoDomingoTamanhoP                   := ADataSet.FieldByName('descontoDomingoTamanhoP').AsCurrency;
      Result.descontoDomingoTamanhoM                   := ADataSet.FieldByName('descontoDomingoTamanhoM').AsCurrency;
      Result.descontoDomingoTamanhoG                   := ADataSet.FieldByName('descontoDomingoTamanhoG').AsCurrency;
      Result.descontoDomingoTamanhoGG                  := ADataSet.FieldByName('descontoDomingoTamanhoGG').AsCurrency;
      Result.descontoDomingoTamanhoExtra               := ADataSet.FieldByName('descontoDomingoTamanhoExtra').AsCurrency;
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TRPfoodDAOPromocao.Select;
begin
    Query.SQL('select idProdutoApi, idEmpresa, tipoDesconto, segundaFeira,                  ')
    .SQL('tercaFeira, quartaFeira, quintaFeira, sextaFeira, sabado, domingo,                ')
    .SQL('tipoMesa, tipoComanda,                                                            ')
    .SQL('descontoSegundaPadrao, descontoSegundaTamanhoP, descontoSegundaTamanhoM,          ')
    .SQL('descontoSegundaTamanhoG, descontoSegundaTamanhoGG, descontoSegundaTamanhoExtra,   ')
    .SQL('descontoTercaPadrao, descontoTercaTamanhoP, descontoTercaTamanhoM,                ')
    .SQL('descontoTercaTamanhoG, descontoTercaTamanhoGG, descontoTercaTamanhoExtra,         ')
    .SQL('descontoQuartaPadrao, descontoQuartaTamanhoP, descontoQuartaTamanhoM,             ')
    .SQL('descontoQuartaTamanhoG, descontoQuartaTamanhoGG, descontoQuartaTamanhoExtra,      ')
    .SQL('descontoQuintaPadrao, descontoQuintaTamanhoP, descontoQuintaTamanhoM,             ')
    .SQL('descontoQuintaTamanhoG, descontoQuintaTamanhoGG, descontoQuintaTamanhoExtra,      ')
    .SQL('descontoSextaPadrao, descontoSextaTamanhoP, descontoSextaTamanhoM,                ')
    .SQL('descontoSextaTamanhoG, descontoSextaTamanhoGG, descontoSextaTamanhoExtra,         ')
    .SQL('descontoSabadoPadrao, descontoSabadoTamanhoP, descontoSabadoTamanhoM,             ')
    .SQL('descontoSabadoTamanhoG, descontoSabadoTamanhoGG, descontoSabadoTamanhoExtra,      ')
    .SQL('descontoDomingoPadrao, descontoDomingoTamanhoP, descontoDomingoTamanhoM,          ')
    .SQL('descontoDomingoTamanhoG, descontoDomingoTamanhoGG, descontoDomingoTamanhoExtra    ')
    .SQL('from promocao                                                                     ');
end;

end.
