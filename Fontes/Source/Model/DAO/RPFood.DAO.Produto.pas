unit RPFood.DAO.Produto;

interface

uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

type
  TRPFoodDAOProduto = class(TRPFoodDAOBase<TRPFoodEntityProduto>)
  private
    procedure SelectProduto;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityProduto; override;
  public
    function GetImagem(AIdEmpresa, ACodigo: Integer): TMemoryStream; overload;
    function GetImagem(AProduto: TRPFoodEntityProduto): TMemoryStream; overload;
    function Buscar(AIdEmpresa, AIdProduto: Integer): TRPFoodEntityProduto;
    function Listar(AIdEmpresa, AIdCategoria: Integer): TObjectList<TRPFoodEntityProduto>;
    function ListaDestaques(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;
    function ProdutosQuePermitemFracao(AIdEmpresa, AIdCategoria: Integer; ATamanho: string): TObjectList<TRPFoodEntityProduto>;
    function BuscarTodosProdutos(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;
    function PesquisarProdutos(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;

  end;

implementation

{ TRPFoodDAOProduto }

uses
  RPFood.DAO.Factory;

function TRPFoodDAOProduto.Buscar(AIdEmpresa, AIdProduto: Integer): TRPFoodEntityProduto;
var
  LDataSet: TDataSet;
begin
  SelectProduto;
  Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true')
    .SQL('and produtos.id_empresa = :idEmpresa                             ')
    .SQL('and produtos.codigo = :codigo                                    ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', AIdProduto);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOProduto.BuscarTodosProdutos(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;
var
  LDataSet: TDataSet;
begin
  SelectProduto;
  Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true')
  .SQL('and produtos.id_empresa = :idEmpresa')
  .SQL('order by descricao')
  .ParamAsInteger('idEmpresa', AIdEmpresa) ;

 LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOProduto.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityProduto;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityProduto.Create;
    try
      Result.codigo            := ADataSet.FieldByName('codigo').AsInteger;
      Result.idEmpresa         := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.descricao         := ADataSet.FieldByName('descricao').AsString;
      Result.idGrupo           := ADataSet.FieldByName('id_grupo').AsInteger;
      Result.observacao        := ADataSet.FieldByName('observacao').AsString;
      Result.valFinal          := ADataSet.FieldByName('valFinal').AsCurrency;
      Result.destaqueWeb       := ADataSet.FieldByName('b_destaque_web').AsBoolean;
      Result.vendaPorTamanho   := ADataSet.FieldByName('b_venda_tamanho').AsBoolean;
      Result.permiteFrac       := ADataSet.FieldByName('b_permite_frac').AsBoolean;
      Result.valorTamanhoP     := ADataSet.FieldByName('valor_tam_p').AsCurrency;
      Result.valorTamanhoM     := ADataSet.FieldByName('valor_tam_m').AsCurrency;
      Result.valorTamanhoG     := ADataSet.FieldByName('valor_tam_g').AsCurrency;
      Result.valorTamanhoGG    := ADataSet.FieldByName('valor_tam_gg').AsCurrency;
      Result.valorTamanhoExtra := ADataSet.FieldByName('valor_tam_extra').AsCurrency;
      Result.tamanhoP          := ADataSet.FieldByName('tamanho_p').AsString;
      Result.tamanhoM          := ADataSet.FieldByName('tamanho_m').AsString;
      Result.tamanhoG          := ADataSet.FieldByName('tamanho_g').AsString;
      Result.tamanhoGG         := ADataSet.FieldByName('tamanho_gg').AsString;
      Result.tamanhoExtra      := ADataSet.FieldByName('tamanho_extra').AsString;
      Result.tamanhoPadrao     := ADataSet.FieldByName('tamanho_padrao').AsString;
      Result.utiliza_carrossel := ADataSet.FieldByName('b_carrossel').AsBoolean;
      Result.happyHourAtivar   := ADataSet.FieldByName('utiliza_happy_hour').AsBoolean;
      Result.restringirVenda   := ADataSet.FieldByName('restringirVenda').AsBoolean;
      Result.OpcionalMinimo    := ADataSet.FieldByName('opcional_minimo').AsInteger;
      Result.OpcionalMaximo    := ADataSet.FieldByName('opcional_maximo').AsInteger;

      if Result.happyHourAtivar then
      begin
       Result.happyHour := TRPFoodDAOFactory(FactoryDAO).HappyHourDAO.Buscar(Result.codigo, Result.idEmpresa);

       if Result.happyHour.HoraDeHappyHour then
        Result.valFinal := TRPFoodDAOFactory(FactoryDAO).HappyHourDAO.ValorHappyHour(Result.happyHour);
      end;

      if Result.restringirVenda then
       Result.restricao := TRPFoodDAOFactory(FactoryDAO).IdEmpresa(Result.idEmpresa).RestricaoVendaDAO.Buscar(result.codigo);

    except
      Result.Free;
      raise;
    end;
  end;
end;


function TRPFoodDAOProduto.GetImagem(AProduto: TRPFoodEntityProduto): TMemoryStream;
begin
  Result := GetImagem(AProduto.idEmpresa, AProduto.codigo);
end;

function TRPFoodDAOProduto.GetImagem(AIdEmpresa, ACodigo: Integer): TMemoryStream;
var
  LDataSet: TDataSet;
begin
  Result := nil;
  Query.SQL('select produtos.img from produtos')
    .SQL('where produtos.codigo = :codigo')
    .SQL('and produtos.id_empresa = :idEmpresa')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('codigo', ACodigo);
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

function TRPFoodDAOProduto.ListaDestaques(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;
var
  LDataSet: TDataSet;
begin
  SelectProduto;
   Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true         ')
    .SQL('and produtos.b_destaque_web = true and produtos.id_empresa = :idEmpresa   ')
    .SQL('order by produtos.descricao limit 20                                      ')
    .ParamAsInteger('idEmpresa', AIdEmpresa);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOProduto.Listar(AIdEmpresa, AIdCategoria: Integer): TObjectList<TRPFoodEntityProduto>;
var
  LDataSet: TDataSet;
begin
  SelectProduto;
  Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true       ')
    .SQL('and produtos.id_empresa = :idEmpresa                                    ')
    .SQL('and produtos.codigrupo = :idGrupo                                       ')
    .SQL('order by produtos.descricao                                             ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idGrupo', AIdCategoria);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOProduto.PesquisarProdutos(AIdEmpresa: Integer): TObjectList<TRPFoodEntityProduto>;
var
  LDataSet: TDataSet;
begin
   SelectProduto;
  Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true and UPPER(produtos.descricao) LIKE ''% %'' ')
  .SQL('and produtos.id_empresa = :idEmpresa                                                                           ')
  .SQL('order by id_grupo,descricao                                                                                    ')
  .ParamAsInteger('idEmpresa', AIdEmpresa) ;

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;

end;

function TRPFoodDAOProduto.ProdutosQuePermitemFracao(AIdEmpresa, AIdCategoria: Integer; ATamanho:string): TObjectList<TRPFoodEntityProduto>;
var
  LDataSet: TDataSet;
  LTamanho: string;
begin
  LTamanho := '';

  if ATamanho = 'P' then
    Ltamanho := ' and tamanho_p is not null and tamanho_p <>'''' and b_venda_tamanho=true '
  else if ATamanho = 'M' then
    Ltamanho := ' and tamanho_m is not null and tamanho_m <>'''' and b_venda_tamanho=true '
  else if ATamanho = 'G' then
    Ltamanho := ' and tamanho_g is not null  and tamanho_g <>'''' and b_venda_tamanho=true '
  else if ATamanho='GG' then
    Ltamanho := ' and tamanho_gg is not null and tamanho_gg <>'''' and b_venda_tamanho=true '
  else if ATamanho='EG' then
  	LTamanho := 'and tamanho_extra is not null  and tamanho_extra <>'''' and b_venda_tamanho=true '
  else  LTamanho := ' and b_venda_tamanho=false ';

  SelectProduto;
  Query.SQL('where produtos.id_situacao = 4 and produtos.b_venda_web = true')
    .SQL('and produtos.id_empresa = :idEmpresa                             ')
    .SQL('and produtos.codigrupo = :idGrupo                                ')
    .SQL('and produtos.b_permite_frac = true                               ')
    .SQL( LTamanho)
    .SQL('order by produtos.descricao')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idGrupo', AIdCategoria);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOProduto.SelectProduto;
begin
  Query.SQL('select produtos.id_empresa, produtos.codigo, grupos.codigo as id_grupo,           ')
    .SQL(' produtos.descricao, produtos.Observacao, produtos.valfinal,tamanho_p,               ')
    .SQL(' tamanho_m, tamanho_g, tamanho_gg, tamanho_extra, tamanho_padrao,valor_tam_p,        ')
    .SQL(' valor_tam_m, valor_tam_g, valor_tam_gg, valor_tam_extra,b_destaque_web,             ')
    .SQL(' b_permite_frac, b_carrossel,utiliza_happy_hour,b_venda_tamanho,                     ')
    .SQL(' produtos.utiliza_promocao,produtos.restringirVenda,produtos.opcional_maximo,        ')
    .SQL(' produtos.opcional_minimo                                                            ')
    .SQL(' from produtos                                                                       ')
    .SQL('left join grupos on grupos.codigo = produtos.codigrupo                               ')
end;

end.


