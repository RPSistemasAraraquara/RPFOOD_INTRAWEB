unit RPFood.DAO.VendaEndereco;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  RPFood.Entity.Classes,
  RPFood.DAO.Base;

type
  TRPFoodDAOVendaEndereco = class(TRPFoodDAOBase<TRPFoodEntityVendaEndereco>)
  protected
    function DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaEndereco; override;
  public
    procedure Salvar(AVenda: TRPFoodEntityVenda);
  end;

implementation

{ TRPFoodDAOVendaEndereco }

function TRPFoodDAOVendaEndereco.DataSetToEntity(ADataSet: TDataSet): TRPFoodEntityVendaEndereco;
begin
  raise Exception.Create('Sem necessidade de implementação no momento.');
end;

procedure TRPFoodDAOVendaEndereco.Salvar(AVenda: TRPFoodEntityVenda);
var
  LClienteEndereco: TRPFoodEntityClienteEndereco;
begin
  StartTransaction;
  try
    Query.SQL('insert into venda_endereco                           (')
      .SQL('  id_venda, id_cliente, id_bairro, cep, logradouro,      ')
      .SQL('  numero, complemento, ponto_referencia,bairro_desc,     ')
      .SQL('  id_endereco                                            )')
      .SQL('  values (                                               ')
      .SQL('  :id_venda, :id_cliente, :id_bairro, :cep, :logradouro, ')
      .SQL('  :numero, :complemento, :ponto_referencia,:bairro_desc, ')
      .SQL('  :id_endereco                                           )')
      .ParamAsInteger('id_venda', AVenda.id)
      .ParamAsInteger('id_cliente', AVenda.cliente.idCliente)
      .ParamAsInteger('id_bairro', AVenda.vendaEndereco.idBairro)
      .ParamAsString('cep', AVenda.vendaEndereco.cep)
      .ParamAsString('logradouro', AVenda.vendaEndereco.endereco)
      .ParamAsString('numero', AVenda.vendaEndereco.numero, True)
      .ParamAsString('complemento', AVenda.vendaEndereco.complemento, True)
      .ParamAsString('ponto_referencia', AVenda.vendaEndereco.pontoReferencia, True)
      .ParamAsString('bairro_desc', AVenda.vendaEndereco.bairro)
      .ParamAsInteger('id_endereco', AVenda.IDEndereco)
      .ExecSQL;
    Commit;
  except
    Rollback;
    raise;
  end;

end;

end.
