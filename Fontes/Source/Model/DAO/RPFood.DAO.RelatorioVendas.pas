unit RPFood.DAO.RelatorioVendas;

interface
uses
  RPFood.DAO.Base,
  RPFood.Entity.Classes,
  Data.DB,
  System.DateUtils,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.Entity.Types;

  type
    TRPFoodRelatorioVendas = class(TRPFoodDAOBase<TRPFoodEntityRelatorioVendas>)
  protected
  function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityRelatorioVendas; override;
  public
   FNumeroVenda:TRPFoodEntityRelatorioVendas ;
  function Listagem_simplificada(AIdEmpresa, AIdCliente: Integer)                                : TDataSet;
  function Total_Pedidos_Finalizados(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)       : TDataSet;
  function Total_Delivery_Finalizados(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)      : TDataSet;
  function Total_Balcao_Finalizados(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)        : TDataSet;
  function Total_Pedidos_Cancelados(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)        : TDataSet;
  function Total_Pedidos_Abertos(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)           : TDataSet;
  function Categoriais_Mais_Vendidas(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)       : TDataSet;
  function Quantidade_clientes(AIdEmpresa:Integer)                                               : TDataSet;
  function Quantidade_Produtos(AIdEmpresa:Integer)                                               : TDataSet;
  function Produtos_Mais_Vendidos(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)          : TDataSet;
  function Media_Vendas_Diaria(AIdEmpresa:Integer; ADataInicio, ADataFim: TDateTime)             : TDataSet;
  function Produtos_Venda_item (AIdEmpresa:Integer ; AIdVenda:Integer)                           : TDataSet;
  function Listagem_Vendas_Finalizadas_Por_Cliente(AIdEmpresa, AIdCliente: Integer)              : TDataSet;
  function Bairros_Mais_Vendidos(AIdEmpresa, Limit:Integer)                                      : TDataSet;
  function Melhores_Clientes(AIdEmpresa, Limit:Integer)                                          : TDataSet;
  function Produtos_Mais_Vendidos_Filtro_Limit(AIdEmpresa,Limit :Integer)                        : TDataSet;
  function ultima_sincronizacao (AIdEmpresa: Integer)                                            : TDataSet;
  function total_Venda_Com_QTDE_Valor(AIdEmpresa:Integer;ADataInicio, ADataFim: TDateTime)       :TDataSet;
  end;

implementation

{ TRPFoodRelatorioVendas }
function TRPFoodRelatorioVendas.Bairros_Mais_Vendidos(AIdEmpresa, Limit:Integer) :TDataSet;
begin
  Query.SQL('select sub.descricao, sum(sub.total_bairro) as total_bairro from (                      ')
       .SQL(' select b.bai_002 as descricao,                                                         ')
       .SQL(' sum(v.sales) as total_bairro                                                           ')
       .SQL(' from venda v                                                                           ')
       .SQL(' join clientes_endereco c on c.cli_001 = v.id_cliente and c.id_empresa = v.id_empresa   ')
       .SQL(' join bairro b on b.bai_001 = c.bai_001 and b.emp_001 = c.id_empresa                    ')
       .SQL(' where v.id_cliente > 0                                                                 ')
       .SQL(' and v.id_empresa = :idEmpresa                                                          ')
       .SQL(' and v.id_situacao not in (101,107,108,109)                                             ')
       .SQL(' and v.tipo_entrega = ''D''                                                             ')
       .SQL(' group by b.bai_001, b.bai_002                                                          ')
       .SQL(' union                                                                                  ')

       .SQL(' select b.bai_002 as descricao,                                                         ')
       .SQL('	sum(v.sales) as total_bairro                                                           ')
       .SQL('	from venda v                                                                           ')
       .SQL('	join venda_endereco e on e.id_venda = v.id_venda                                       ')
       .SQL('	join bairro b on b.bai_001 = e.id_bairro                                               ')
       .SQL('	where v.id_cliente > 0                                                                 ')
       .SQL('	and v.id_empresa = :idEmpresa                                                          ')
       .SQL('	and v.id_situacao not in (101,107,108,109)                                             ')
       .SQL('	and v.tipo_entrega = ''D''                                                             ')
       .SQL('	group by b.bai_001, b.bai_002) as sub                                                  ')
       .SQL('	group by sub.descricao                                                                 ')
       .SQL('	order by total_bairro desc, descricao                                                  ')
       .SQL('	limit  ' + IntToStr(limit)                                                              )
      .ParamAsInteger('idEmpresa', AIdEmpresa) ;
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Categoriais_Mais_Vendidas(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL('select cat.codigo, cat.descricao, sum(vi.totals_products) as total_categoria         ')
       .SQL('from vendaitem vi                                                                    ')
       .SQL('join produtos mat on mat.id_empresa = vi.id_empresa and mat.codigo = vi.id_product   ')
       .SQL('join grupos cat on cat.id_empresa = vi.id_empresa and cat.codigo = mat.codigrupo     ')
       .SQL('join venda v on v.id_venda=vi.id_venda and v.id_empresa=vi.id_empresa                ')
       .SQL('where v.id_situacao not in (101,107,108,109)                                         ')
       .SQL('and vi.id_situacao = 4                                                               ')
       .SQL('and v.id_empresa = :idEmpresa                                                        ')
       .SQL('and v.data_pedido::date between :dataInicio and :dataFim                             ')
       .SQL('group by cat.codigo, cat.descricao                                                   ')
       .SQL('order by total_categoria desc, cat.descricao                                         ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;


function TRPFoodRelatorioVendas.DataSetToEntity( ADataSet: TDataSet): TRPFoodEntityRelatorioVendas;
begin
   Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityRelatorioVendas.Create;
    try
      Result.id                       := ADataSet.FieldByName('id_venda').AsInteger;
      Result.idEmpresa                := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.data                     := ADataSet.FieldByName('data_pedido').AsDateTime;
      Result.valorAReceber            := ADataSet.FieldByName('valor_receber').AsCurrency;
      Result.troco                    := ADataSet.FieldByName('troco').AsCurrency;
      Result.valorTotalProdutos       := ADataSet.FieldByName('totals_products').AsCurrency;
      Result.valorTotal               := ADataSet.FieldByName('sales').AsCurrency;
      Result.valorTotalOpcionais      := ADataSet.FieldByName('sub_total').AsCurrency;
      Result.recebidoLeCheff          := ADataSet.FieldByName('b_recebido_lecheff').AsBoolean;
      Result.observacao               := ADataSet.FieldByName('observacao').AsString;
      Result.situacao_pedido          := ADataSet.FieldByName('situacao_pedido').AsString;
      Result.venda_entrega            := ADataSet.FieldByName('venda_entrega').AsString;
      Result.descricao_produto        := ADataSet.FieldByName('descricao').AsString;
      Result.valor_unitario           := ADataSet.FieldByName('valor_unitario').AsFloat;
      Result.quantidade_produtos      :=ADataSet.FieldByName('quantidade_produtos').AsFloat;
      Result.valor_total_product      :=ADataSet.FieldByName('valor_total_produtos').AsFloat;
      Result.observacao_produto       :=ADataSet.FieldByName('obs_item').AsString;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodRelatorioVendas.Listagem_simplificada(AIdEmpresa, AIdCliente: Integer): TDataSet;
begin
  Query.SQL('select distinct(venda.id_venda), venda.id_empresa, venda.id_situacao,                    ')
       .SQL(' venda.id_formapgto, venda.observacao, venda.id_cliente, venda.totals_products,          ')
       .SQL(' venda.sub_total, venda.taxa_entrega, venda.sales,                                       ')
       .SQL(' venda.troco, venda.valor_receber, venda.data_pedido, venda.b_recebido_lecheff,          ')
       .SQL(' venda.tipo_entrega, formapgto.descricao as pagamento_descricao,                         ')
       .SQL(' case venda.id_situacao                                                                  ')
       .SQL('   when 100 then '' Pedido enviado ''                                                    ')
       .SQL('   when 101 then '' Pedido rejeitado''                                                   ')
       .SQL('   when 102 then '' Pedido em preparo''                                                  ')
       .SQL('   when 103 then '' Pedido esta á caminho''                                              ')
       .SQL('   when 104 then '' Pronto para retirada''                                               ')
       .SQL('   when 105 then '' Pedido finalizado''                                                  ')
       .SQL('   when 106 then '' Pedido cancelado ''                                                  ')
       .SQL('   when 109 then '' Pedido rejeitado''                                                   ')
       .SQL(' end as situacao_pedido,                                                                 ')
       .SQL(' case venda.tipo_entrega                                                                 ')
       .SQL('   when ''D'' then ''Delivery''                                                          ')
       .SQL('   when ''R'' then ''Retirada''                                                          ')
       .SQL(' end as venda_entrega,                                                                   ')
       .SQL('  venda_endereco.logradouro, venda_endereco.numero                                       ')
       .SQL('from venda                                                                               ')
       .SQL('left join formapgto on venda.id_formapgto = formapgto.id and venda.id_empresa = formapgto.id_empresa              ')
       .SQL('left join venda_endereco on venda_endereco.id_venda=venda.id_venda and venda_endereco.id_cliente=venda.id_cliente ')
       .SQL('where venda.id_cliente = :idCliente and venda.id_empresa = :idEmpresa                    ')
       .SQL('order by venda.id_venda desc                                                              ')
       .ParamAsInteger('idEmpresa',AIdEmpresa)
       .ParamAsInteger('idCliente',AIdCliente);
  Result := Query.OpenDataSet;

end;

function TRPFoodRelatorioVendas.Listagem_Vendas_Finalizadas_Por_Cliente(AIdEmpresa, AIdCliente: Integer): TDataSet;
begin
  Query.SQL('select distinct(venda.id_venda), venda.id_empresa, venda.id_situacao,                                             ')
       .SQL(' venda.id_formapgto, venda.observacao, venda.id_cliente, venda.totals_products,                                   ')
       .SQL(' venda.sub_total, venda.taxa_entrega, venda.sales,                                                                ')
       .SQL(' venda.troco, venda.valor_receber, venda.data_pedido, venda.b_recebido_lecheff,                                   ')
       .SQL(' venda.tipo_entrega, formapgto.descricao as pagamento_descricao,                                                  ')
       .SQL(' case venda.tipo_entrega                                                                                          ')
       .SQL('   when ''D'' then ''Delivery''                                                                                   ')
       .SQL('   when ''R'' then ''Retirada''                                                                                   ')
       .SQL(' end as venda_entrega,                                                                                            ')
       .SQL('  venda_endereco.logradouro, venda_endereco.numero                                                                ')
       .SQL('from venda                                                                                                        ')
       .SQL('left join formapgto on venda.id_formapgto = formapgto.id and venda.id_empresa = formapgto.id_empresa              ')
       .SQL('left join venda_endereco on venda_endereco.id_venda=venda.id_venda and venda_endereco.id_cliente=venda.id_cliente ')
       .SQL('where venda.id_cliente = :idCliente and venda.id_empresa = :idEmpresa and venda.id_situacao=106                   ')
       .SQL('order by venda.id_venda desc                                                                                      ')
       .ParamAsInteger('idEmpresa',AIdEmpresa)
       .ParamAsInteger('idCliente',AIdCliente);
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Media_Vendas_Diaria(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL(' select v.data_pedido::date as data,                      ')
       .SQL(' count(1) as qtde,                                        ')
       .SQL(' sum(v.sales) as valor_total,                             ')
       .SQL(' cast(avg(v.sales) as numeric(15,2)) as valor_media       ')
       .SQL(' from venda v                                             ')
       .SQL(' where v.id_empresa = :idEmpresa                          ')
       .SQL(' and v.data_pedido::date between :dataInicio and :dataFim ')
       .SQL(' and v.id_situacao = 106                                  ')
       .SQL(' group by data                                            ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Melhores_Clientes(AIdEmpresa, Limit: Integer): TDataSet;
begin
  Query.SQL(' select count(venda.id_venda) as quantidade_compra_por_cliente,clientes.cli_002                  ')
       .SQL('from venda                                                                                        ')
       .SQL('left join clientes on clientes.cli_001=venda.id_cliente and venda.id_empresa=clientes.id_empresa  ')
       .SQL('where venda.id_cliente>0 and venda.id_situacao=106 and venda.id_empresa = :idEmpresa              ')
       .SQL('group by clientes.cli_002                                                                         ')
       .SQL('order by quantidade_compra_por_cliente desc                                                       ')
       .SQL('limit '+  IntToStr(limit)                                                                          )
       .ParamAsInteger('idEmpresa',AIdEmpresa);
  Result:=Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Produtos_Mais_Vendidos(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL('select mat.codigo, mat.descricao,                                                    ')
       .SQL('  sum(vi.totals_products) as total_produtos_vendidos                                 ')
       .SQL('  from vendaitem vi                                                                  ')
       .SQL('  join produtos mat on mat.id_empresa = vi.id_empresa and mat.codigo = vi.id_product ')
       .SQL('  join venda v on v.id_venda=vi.id_venda and v.id_empresa=vi.id_empresa              ')
       .SQL('  where v.id_situacao not in (101,107,108,109)                                       ')
       .SQL('  and vi.id_situacao = 4                                                             ')
       .SQL('  and v.id_empresa =:idEmpresa                                                       ')
       .SQL('  and v.data_pedido::date between :dataInicio and :dataFim                           ')
       .SQL('  group by mat.codigo, mat.descricao                                                 ')
       .SQL('  order by total_produtos_vendidos desc, mat.descricao                               ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Produtos_Mais_Vendidos_Filtro_Limit(AIdEmpresa,Limit: Integer): TDataSet;
begin
  Query.SQL('select mat.codigo, mat.descricao,                                                    ')
       .SQL('  sum(vi.totals_products) as total_produtos_vendidos,count(*) as quantidade_vendida  ')
       .SQL('  from vendaitem vi                                                                  ')
       .SQL('  join produtos mat on mat.id_empresa = vi.id_empresa and mat.codigo = vi.id_product ')
       .SQL('  join venda v on v.id_venda=vi.id_venda and v.id_empresa=vi.id_empresa              ')
       .SQL('  where v.id_situacao not in (101,107,108,109)                                       ')
       .SQL('  and vi.id_situacao = 4                                                             ')
       .SQL('  and v.id_empresa =:idEmpresa                                                       ')
       .SQL('  group by mat.codigo, mat.descricao                                                 ')
       .SQL('  order by quantidade_vendida desc, mat.descricao                                    ')
       .SQL('  limit  ' + IntToStr(Limit)                                                          )
       .ParamAsInteger('idEmpresa', AIdEmpresa) ;
  Result := Query.OpenDataSet;

end;

function TRPFoodRelatorioVendas.Produtos_Venda_item(AIdEmpresa,AIdVenda: Integer): TDataSet;
begin

 Query.SQL('select vi.id_venda, vi.id_empresa, vi.numero_item,                              ')
  .SQL(' mat.codigo,                                                                        ')
  .SQL(' cast((                                                                             ')
  .SQL(' case when vi.b_venda_tamanho then                                                  ')
  .SQL(' case vi.tamanho                                                                    ')
  .SQL(' when ''P'' then  concat(mat.descricao,'' ('',mat.tamanho_p,'')'')                  ')
  .SQL(' when ''M'' then  concat(mat.descricao,'' ('',mat.tamanho_m,'')'')                  ')
  .SQL(' when ''G'' then  concat(mat.descricao,'' ('',mat.tamanho_g,'')'')                  ')
  .SQL(' when ''GG'' then concat(mat.descricao,'' ('',mat.tamanho_gg,'')'')                 ')
  .SQL(' when ''E'' then  concat(mat.descricao,'' ('',mat.tamanho_extra,'')'')              ')
  .SQL(' else mat.tamanho_padrao end                                                        ')
  .SQL(' else                                                                               ')
  .SQL(' mat.descricao end) as varchar(100)) as descricao,                                  ')
  .SQL('vi.quantidade, vi.valor_unit_product, vi.totals_products,                           ')
  .SQL('(                                                                                   ')
  .SQL(' SELECT STRING_AGG(CONCAT('''',opcional.descricao, '' ''), '', '')                ')

  .SQL(' from vendaitemopcional                                                             ')
  .SQL(' join opcional ON opcional.codigo = vendaitemopcional.id_opcional and opcional.id_empresa = vendaitemopcional.id_empresa ')
  .SQL(' where vendaitemopcional.id_venda = vi.id_venda                                     ')
  .SQL(' and vendaitemopcional.id_numero_item = vi.numero_item                              ')
  .SQL(' and vendaitemopcional.id_empresa = vi.id_empresa                                   ')
  .SQL(') AS descricao_opcional                                                             ')
  .SQL('from vendaitem vi                                                                   ')
  .SQL('join produtos mat on mat.id_empresa = vi.id_empresa and mat.codigo = vi.id_product  ')
  .SQL('join venda v on v.id_venda=vi.id_venda and v.id_empresa=vi.id_empresa               ')
  .SQL('where vi.id_venda = :idVenda                                                        ')
  .SQL('and vi.id_empresa = :idEmpresa                                                      ')
  .SQL('and vi.id_situacao = 4                                                              ')
  .SQL('order by vi.id_venda, vi.numero_item                                                ')

  .ParamAsInteger('idEmpresa', AIdEmpresa)
  .ParamAsInteger('idVenda', AIdVenda) ;
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Quantidade_clientes(AIdEmpresa: Integer): TDataSet;
begin
  Query.SQL('select count(1) as clientes_cadastrados from clientes        ')
       .SQL('where id_empresa = :idEmpresa and sit_001=4                  ')
       .ParamAsInteger('idEmpresa', AIdEmpresa);
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Quantidade_Produtos(AIdEmpresa: Integer): TDataSet;
begin
  Query.SQL('select count(1) as produtos_cadastrados                          ')
       .SQL ('    from produtos where id_empresa = :idEmpresa                 ')
       .SQL ('    and id_situacao=4 and b_venda_web=true                      ')
       .ParamAsInteger('idEmpresa', AIdEmpresa);
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Total_Balcao_Finalizados(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL(' select coalesce(sum(sales),0) as valor_total_balcao,       ')
       .SQL('count(id_venda) as qtde_Balcao_Finalizados                  ')
       .SQL(' from venda  where                                          ')
       .SQL(' id_situacao=106 and tipo_entrega=''B''                     ')
       .SQL(' and id_empresa = :idEmpresa                                ')
       .SQL(' and data_pedido::date between :dataInicio                  ')
       .SQL(' and :dataFim                                               ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Total_Delivery_Finalizados(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL(' select coalesce(sum(sales),0) as valor_total_delivery,      ')
       .SQL('count(id_venda) as qtde_Delivery_Finalizados                 ')
       .SQL(' from venda  where                                           ')
       .SQL(' id_situacao=106 and tipo_entrega=''D''                      ')
       .SQL(' and id_empresa = :idEmpresa                                 ')
       .SQL(' and data_pedido::date between :dataInicio                   ')
       .SQL(' and :dataFim                                                ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Total_Pedidos_Abertos(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime):TDataSet;
begin
  Query.SQL('select coalesce(sum(sales),0)                  ')
       .SQL('   as valor_pedidos_aberto,                    ')
       .SQL('count(id_venda) as qtde_pedidos_abertos        ')
       .SQL('   from venda                                  ')
       .SQL('   where id_situacao  in(100,102,103,104,105)  ')
       .SQL('   and id_empresa = :idEmpresa                 ')
       .SQL('   and data_pedido::date between :dataInicio   ')
       .SQL('   and :dataFim                                ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Total_Pedidos_Cancelados(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL('select coalesce(sum(sales),0)                           ')
       .SQL('   as valor_pedidos_cancelados,                          ')
       .SQL ('count(id_venda) as qtde_pedidos_cancelados  from venda  ')
       .SQL('   where id_situacao in(101,107,108,109)                 ')
       .SQL('   and id_empresa = :idEmpresa                           ')
       .SQL('   and data_pedido::date between :dataInicio             ')
       .SQL('   and :dataFim                                          ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.Total_Pedidos_Finalizados(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL(' select coalesce(sum(sales),0) as valor_Total_Pedidos_Finalizados, ')
       .SQL('count(id_venda) as qtde_vendas_Pedidos_Finalizados                      ')
       .SQL(' from venda  where                                                      ')
       .SQL(' id_situacao=106                                                        ')
       .SQL(' and id_empresa = :idEmpresa                                            ')
       .SQL(' and data_pedido::date between :dataInicio                              ')
       .SQL(' and :dataFim                                                           ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.total_Venda_Com_QTDE_Valor(AIdEmpresa: Integer; ADataInicio, ADataFim: TDateTime): TDataSet;
begin
  Query.SQL('select count(1) as quantidade_vendas, sum (sales) as valor_total_vendas,sum(taxa_entrega) as taxa_entrega   ')
       .SQL('from venda where id_empresa = :idEmpresa                                                                    ')
       .SQL('and data_pedido::date between :dataInicio and :dataFim                                                      ')
       .ParamAsInteger('idEmpresa', AIdEmpresa)
       .ParamAsDateTime('dataInicio', StartOfTheDay(ADataInicio))
       .ParamAsDateTime('dataFim', EndOfTheDay(ADataFim));
  Result := Query.OpenDataSet;
end;

function TRPFoodRelatorioVendas.ultima_sincronizacao(AIdEmpresa: Integer): TDataSet;
begin
  Query.SQL('select * from sincronizacao     ')
       .SQL(' where id_empresa = :idEmpresa  ')
       .SQL('order by id desc limit 1        ')
       .ParamAsInteger('idEmpresa', AIdEmpresa);
  Result := Query.OpenDataSet;
end;

end.





