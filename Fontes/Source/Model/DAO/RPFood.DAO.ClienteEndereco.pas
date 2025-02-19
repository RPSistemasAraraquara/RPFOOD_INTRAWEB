unit RPFood.DAO.ClienteEndereco;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  RPFood.DAO.Base,
  RPFood.Entity.Classes;

type
  TRPFoodDAOClienteEndereco = class(TRPFoodDAOBase<TRPFoodEntityClienteEndereco>)
  private
    function GetTaxaEntrega(ACep: string): Currency;
    procedure SelectEndereco;
    procedure SelectEnderecoBairro;
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityClienteEndereco; override;
  public
    function Listar(AIdEmpresa, AIdCliente: Integer): TObjectList<TRPFoodEntityClienteEndereco>;
    function Buscar(AIdEndereco, AIdCliente: Integer): TRPFoodEntityClienteEndereco; overload;
    procedure Inserir(AEndereco: TRPFoodEntityClienteEndereco);
    procedure Alterar(AEndereco: TRPFoodEntityClienteEndereco);

    procedure AtualizarEnderecoPadrao(AIdCliente, AIdEndereco, AIdEmpresa: Integer);
    function ListarEnderecoBairro(AIdEmpresa, AIdCliente: Integer): TObjectList<TRPFoodEntityClienteEndereco>;
    function BuscarEnderecoBairro(AIdEndereco, AIdCliente: Integer): TRPFoodEntityClienteEndereco; overload;
    procedure InserirEnderecoBairro(AEndereco: TRPFoodEntityClienteEndereco);
  end;

implementation

{ TRPFoodDAOClienteEndereco }

uses
  RPFood.DAO.Factory;

procedure TRPFoodDAOClienteEndereco.Alterar(AEndereco: TRPFoodEntityClienteEndereco);
begin
  StartTransaction;
  try
    Query.SQL('update clientes_endereco set ')
      .SQL('  cep_002 = :cep_002, cep_003 = :cep_003, cep_004 = :cep_004,')
      .SQL('  cli_007 = :cli_007, cli_008 = :cli_008, cli_009 = :cli_009,')
      .SQL('  bai_001 = :bai_001, endereco_padrao = :endereco_padrao,    ')
      .SQL('  taxa  = :taxa, idCidade = :idCidade, UF = :UF              ')
      .SQL('where id_empresa = :idEmpresa')
      .SQL('and id_endereco = :idEndereco')
      .SQL('and cli_001 = :idCliente')
      .ParamAsString('cep_002', AEndereco.cep)
      .ParamAsString('cep_003', AEndereco.bairro)
      .ParamAsString('cep_004', AEndereco.endereco)
      .ParamAsString('cli_007', AEndereco.pontoReferencia)
      .ParamAsString('cli_008', AEndereco.numero, True)
      .ParamAsString('cli_009', AEndereco.complemento, True)
      .ParamAsInteger('bai_001', AEndereco.idBairro, True)
      .ParamAsBoolean('endereco_padrao', AEndereco.enderecoPadrao)
      .ParamAsInteger('idCliente', AEndereco.idCliente)
      .ParamAsInteger('idEmpresa', AEndereco.idEmpresa)
      .ParamAsInteger('idEndereco', AEndereco.idEndereco)
      .ParamAsFloat('taxa', AEndereco.taxaEntrega)
      .ParamAsInteger('idCidade', AEndereco.IdCidade)
      .ParamAsString('UF', AEndereco.UF)
      .ExecSQL;

    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TRPFoodDAOClienteEndereco.AtualizarEnderecoPadrao(AIdCliente, AIdEndereco, AIdEmpresa: Integer);
begin
  // Setar o Endereço passado como padrão = True
  Query.SQL('update clientes_endereco set endereco_padrao = :padrao')
    .SQL('where id_empresa = :idEmpresa')
    .SQL('and id_endereco = :idEndereco')
    .SQL('and cli_001 = :idCliente')
    .ParamAsInteger('idCliente', AIdCliente)
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idEndereco', AIdEndereco)
    .ParamAsBoolean('padrao', True)
    .ExecSQL;

  // Setar os demais como padrão = false
  Query.SQL('update clientes_endereco set endereco_padrao = :padrao')
    .SQL('where id_empresa = :idEmpresa')
    .SQL('and id_endereco <> :idEndereco')
    .SQL('and cli_001 = :idCliente')
    .ParamAsInteger('idCliente', AIdCliente)
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .ParamAsInteger('idEndereco', AIdEndereco)
    .ParamAsBoolean('padrao', False)
    .ExecSQL;
end;

function TRPFoodDAOClienteEndereco.Buscar(AIdEndereco, AIdCliente: Integer): TRPFoodEntityClienteEndereco;
var
  LDataSet: TDataSet;
begin
  SelectEndereco;
  Query.SQL('where id_endereco = :idEndereco')
    .SQL('and cli_001 = :idCliente')
    .ParamAsInteger('idEndereco', AIdEndereco)
    .ParamAsInteger('idCliente', AIdCliente);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOClienteEndereco.BuscarEnderecoBairro(AIdEndereco, AIdCliente: Integer): TRPFoodEntityClienteEndereco;
var
  LDataSet: TDataSet;
begin
   SelectEnderecoBairro;
  Query.SQL('where id_endereco = :idEndereco')
    .SQL('and cli_001 = :idCliente          ')
    .ParamAsInteger('idEndereco', AIdEndereco)
    .ParamAsInteger('idCliente', AIdCliente);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToEntity(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOClienteEndereco.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityClienteEndereco;
var
  FieldTaxaEntrega: TField;
begin
  Result := nil;
  if ADataSet.RecordCount > 0 then
  begin
    Result := TRPFoodEntityClienteEndereco.Create;
    try
      Result.idEndereco      := ADataSet.FieldByName('id_endereco').AsInteger;
      Result.idEmpresa       := ADataSet.FieldByName('id_empresa').AsInteger;
      Result.idCliente       := ADataSet.FieldByName('cli_001').AsInteger;
      Result.cep             := ADataSet.FieldByName('cep_002').AsString;
      Result.endereco        := ADataSet.FieldByName('cep_004').AsString;
      Result.idBairro        := ADataSet.FieldByName('bai_001').AsInteger;
      Result.bairro          := ADataSet.FieldByName('cep_003').AsString;
      Result.numero          := ADataSet.FieldByName('cli_008').AsString;
      Result.complemento     := ADataSet.FieldByName('cli_009').AsString;
      Result.pontoReferencia := ADataSet.FieldByName('cli_007').AsString;
      Result.enderecoPadrao  := ADataSet.FieldByName('endereco_padrao').AsBoolean;
      Result.IdCidade        := ADataSet.FieldByName('idCidade').AsInteger;
      Result.UF              := ADataSet.FieldByName('UF').AsString;

      FieldTaxaEntrega       := ADataSet.FindField('taxa_entrega');
      if Assigned(FieldTaxaEntrega) then
         Result.taxaEntrega := FieldTaxaEntrega.AsFloat;
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TRPFoodDAOClienteEndereco.GetTaxaEntrega(ACep: string): Currency;
begin
  Result := TRPFoodDAOFactory(FactoryDAO)
    .EnderecoDAO.GetTaxaEntrega(ACep);
end;

procedure TRPFoodDAOClienteEndereco.Inserir(AEndereco: TRPFoodEntityClienteEndereco);
begin
  AEndereco.Validar;
  AEndereco.idEndereco := ProximoId(AEndereco.idEmpresa, 'clientes_endereco', 'id_endereco');
  StartTransaction;
  try
    Query.SQL('insert into clientes_endereco (id_endereco, cli_001,             ')
      .SQL(' id_empresa, cep_002, cep_003, cep_004,cli_007,cli_008,cli_009,     ')
      .SQL(' bai_001, endereco_padrao, taxa, idCidade, UF)                      ')
      .SQL('values (                                                            ')
      .SQL(' :id_endereco, :cli_001, :id_empresa, :cep_002, :cep_003, :cep_004, ')
      .SQL(' :cli_007, :cli_008, :cli_009, :bai_001, :endereco_padrao, :taxa,   ')
      .SQL(' :idCidade, :UF)                                                    ')
      .ParamAsInteger('id_endereco', AEndereco.idEndereco)
      .ParamAsInteger('id_empresa', AEndereco.idEmpresa)
      .ParamAsInteger('cli_001', AEndereco.idCliente)
      .ParamAsString('cep_002', AEndereco.cep)
      .ParamAsString('cep_003', AEndereco.bairro)
      .ParamAsString('cep_004', AEndereco.endereco)
      .ParamAsString('cli_007', AEndereco.pontoReferencia, True)
      .ParamAsString('cli_008', AEndereco.numero, True)
      .ParamAsString('cli_009', AEndereco.complemento, True)
      .ParamAsInteger('bai_001', AEndereco.idBairro, True)
      .ParamAsBoolean('endereco_padrao', AEndereco.enderecoPadrao)
      .ParamAsFloat('taxa', AEndereco.taxaEntrega)
      .ParamAsInteger('idCidade', AEndereco.IdCidade)
      .ParamAsString('UF', AEndereco.UF);
    Query.ExecSQL;
    Commit;
  except
    on E: Exception do
    begin
      E.Message := 'Erro ao salvar endereço: ' + E.Message;
      Rollback;
      raise;
    end;
  end;
end;

procedure TRPFoodDAOClienteEndereco.InserirEnderecoBairro( AEndereco: TRPFoodEntityClienteEndereco);
begin
  AEndereco.Validar;
  AEndereco.idEndereco := ProximoId(AEndereco.idEmpresa, 'clientes_endereco', 'id_endereco');
  StartTransaction;
  try
    Query.SQL('insert into clientes_endereco ( id_endereco, cli_001, id_empresa,          ')
      .SQL(' cep_002, cep_003, cep_004,cli_007, cli_008, cli_009, bai_001,                ')
      .SQL(' endereco_padrao,taxa, idCidade, UF)                                          ')
      .SQL('values    (                                                                   ')
      .SQL(' :id_endereco, :cli_001, :id_empresa, :cep_002, :cep_003, :cep_004,:cli_007,  ')
      .SQL(' :cli_008, :cli_009, :bai_001, :endereco_padrao, :taxa, :idCidade, :UF )      ')
      .ParamAsInteger('id_endereco', AEndereco.idEndereco)
      .ParamAsInteger('id_empresa', AEndereco.idEmpresa)
      .ParamAsInteger('cli_001', AEndereco.idCliente)
      .ParamAsString('cep_002', AEndereco.cep)
      .ParamAsString('cep_003', AEndereco.bairro)
      .ParamAsString('cep_004', AEndereco.endereco)
      .ParamAsString('cli_007', AEndereco.pontoReferencia, True)
      .ParamAsString('cli_008', AEndereco.numero, True)
      .ParamAsString('cli_009', AEndereco.complemento, True)
      .ParamAsInteger('bai_001', AEndereco.idBairro, True)
      .ParamAsBoolean('endereco_padrao', AEndereco.enderecoPadrao)
      .ParamAsCurrency('taxa',AEndereco.taxaEntrega)
      .ParamAsInteger('idCidade', AEndereco.IdCidade)
      .ParamAsString('UF', AEndereco.UF);
    Query.ExecSQL;
    Commit;
  except
    on E: Exception do
    begin
      E.Message := 'Erro ao salvar endereço: ' + E.Message;
      Rollback;
      raise;
    end;
  end;
end;

function TRPFoodDAOClienteEndereco.Listar(AIdEmpresa, AIdCliente: Integer): TObjectList<TRPFoodEntityClienteEndereco>;
var
  LDataSet: TDataSet;
begin
  SelectEndereco;
  Query.SQL('where id_empresa = :id_empresa          ')
    .SQL('and cli_001 = :idCliente                   ')
    .SQL('order by endereco_padrao desc, id_endereco ')
    .ParamAsInteger('id_empresa', AIdEmpresa)
    .ParamAsInteger('idCliente', AIdCliente);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

function TRPFoodDAOClienteEndereco.ListarEnderecoBairro(AIdEmpresa,AIdCliente: Integer): TObjectList<TRPFoodEntityClienteEndereco>;
var
  LDataSet: TDataSet;
begin
   SelectEnderecoBairro;
  Query.SQL('where id_empresa = :id_empresa         ')
    .SQL('and cli_001 = :idCliente                  ')
    .SQL('order by endereco_padrao desc, id_endereco')
    .ParamAsInteger('id_empresa', AIdEmpresa)
    .ParamAsInteger('idCliente', AIdCliente);

  LDataSet := Query.OpenDataSet;
  try
    Result := DataSetToList(LDataSet);
  finally
    LDataSet.Free;
  end;
end;

procedure TRPFoodDAOClienteEndereco.SelectEndereco;
begin
  Query.SQL('select clientes_endereco.id_endereco, clientes_endereco.cli_001, clientes_endereco.id_empresa, clientes_endereco.cep_002,            ')
    .SQL(' clientes_endereco.cep_003, clientes_endereco.endereco_padrao,clientes_endereco.cep_004, clientes_endereco.cli_007,                     ')
    .SQL(' clientes_endereco.cli_008, clientes_endereco.cli_009, clientes_endereco.bai_001,bairro.bai_003 as taxa_entrega,                        ')
    .SQL(' clientes_endereco.idCidade, clientes_endereco.UF                                                                                       ')
    .SQL('from clientes_endereco                                                                                                                  ')
    .SQL('left join bairro  on bairro.bai_001 =clientes_endereco.bai_001                                                                          ');
end;

procedure TRPFoodDAOClienteEndereco.SelectEnderecoBairro;
begin
  Query.SQL('select clientes_endereco.id_endereco, clientes_endereco.cli_001, clientes_endereco.id_empresa,')
   .SQL(' clientes_endereco.cep_002, clientes_endereco.cep_003, clientes_endereco.endereco_padrao,         ')
   .SQL(' clientes_endereco.cep_004, clientes_endereco.cli_007, clientes_endereco.cli_008,                 ')
   .SQL(' clientes_endereco.cli_009, clientes_endereco.bai_001,bairro.bai_003 as taxa_entrega,             ')
   .SQL(' clientes_endereco.idCidade, clientes_endereco.UF                                                 ')
   .SQL(' from clientes_endereco                                                                           ')
   .SQL('left join bairro  on bairro.bai_001 =clientes_endereco.bai_001                                    ');
end;

end.

