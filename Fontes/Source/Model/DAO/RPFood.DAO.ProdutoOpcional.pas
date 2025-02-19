unit RPFood.DAO.ProdutoOpcional;

interface

uses
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOProdutoOpcional = class(TRPFoodDAOBase<TRPFoodEntityProdutoOpcional>)
  private
    procedure SelectProdutoOpcional;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityProdutoOpcional; override;
  public
    function Listar(AIdEmpresa, ACodigoProduto: Integer;ATamanho:string; ACarrossel:Boolean): TObjectList<TRPFoodEntityProdutoOpcional>;
  end;

implementation

{ TRPFoodDAOProdutoOpcional }

uses
  RPFood.DAO.Factory;

function TRPFoodDAOProdutoOpcional.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityProdutoOpcional;
var
  LOpcional: TRPFoodEntityOpcional;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityProdutoOpcional.Create;
    try
      Result.idEmpresa      := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.codigoProduto  := ADataSet.FieldByName('id_material').AsInteger;
      Result.codigoOpcional := ADataSet.FieldByName('codigo').AsInteger;
      LOpcional             := TRPFoodDAOFactory(FactoryDAO).OpcionalDAO.Buscar(Result.idEmpresa, Result.codigoOpcional);
      try
        Result.opcional.Assign(LOpcional);
      finally
        LOpcional.Free;
      end;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOProdutoOpcional.Listar(AIdEmpresa, ACodigoProduto: Integer; ATamanho:string;ACarrossel:Boolean): TObjectList<TRPFoodEntityProdutoOpcional>;
var
  LDataSet: TDataSet;
begin
  SelectProdutoOpcional;
  Query.SQL('where produtos_opcional.id_empresa = :idEmpresa               ')
  .SQL('and produtos_opcional.id_material = :codigoProduto                 ')
  .SQL('group by opcional.codigo, opcional.descricao,                      ')
  .SQL(' opcional.valor, opcional.id_empresa, produtos_opcional.id_material')

  .SQL('order by opcional.descricao')
  .ParamAsInteger('idEmpresa', AIdEmpresa)
  .ParamAsInteger('codigoProduto', ACodigoProduto);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOProdutoOpcional.SelectProdutoOpcional;
begin
  Query.SQL('select opcional.codigo, opcional.descricao,                       ')
  .SQL(' opcional.opc_p,opcional.opc_m,opcional.opc_g,                         ')
  .SQL(' opcional.opc_extra,opcional.opc_gg,                                   ')
  .SQL(' opcional.valor_opc_p,opcional.valor_opc_g,                            ')
  .SQL(' opcional.valor_opc_m,opcional.valor_opc_extra,                        ')
  .SQL(' opcional.valor_opc_gg,                                                ')
  .SQL(' opcional.valor, opcional.id_empresa, produtos_opcional.id_material    ')
  .SQL(' from produtos_opcional                                                ')
  .SQL(' left join opcional on opcional.codigo = produtos_opcional.id_opcional ')
  .SQL(' and opcional.id_empresa = produtos_opcional.id_empresa                ')
  .SQL(' left join produtos on produtos.codigo = produtos_opcional.id_material ')
  .SQL(' and produtos.id_empresa = produtos_opcional.id_empresa');
end;

end.


