unit RPFood.DAO.Factory;

interface

uses
  System.SysUtils,
  RPFood.DAO.Conexao,
  RPFood.DAO.ADMIN.Usuario,
  RPFood.DAO.Bairro,
  RPFood.DAO.Categoria,
  RPFood.DAO.Cliente,
  RPFood.DAO.ClienteEndereco,
  RPFood.DAO.Empresa,
  RPFood.DAO.Endereco,
  RPFood.DAO.FormaPagamento,
  RPFood.DAO.Opcional,
  RPFood.DAO.Produto,
  RPFood.DAO.ProdutoOpcional,
  RPFood.DAO.Venda,
  RPFood.DAO.VendaItem,
  RPFood.DAO.VendaItemOpcional,
  RPFood.DAO.VendaStatusLog,
  RPFood.DAO.ConfiguracaoFuncionamento,
  RPFood.DAO.VendaEndereco,
  RPFood.DAO.RelatorioVendas,
  RPFood.DAO.TransferenciaImagens,
  RPFood.DAO.ConfiguracaoRPFood,
  RPFOOD.DAO.Happy_Hour,
  RPFood.DAO.Promocao,
  RPFood.DAO.RestricaoVenda;

type
  TRPFoodDAOCliente                          = RPFood.DAO.Cliente.TRPFoodDAOCliente;
  TRPFoodDAOClienteEndereco                  = RPFood.DAO.ClienteEndereco.TRPFoodDAOClienteEndereco;
  TRPFoodDAOVendaEndereco                    = RPFood.DAO.VendaEndereco.TRPFoodDAOVendaEndereco;
  TRPFoodDAOVenda                            = RPFood.DAO.Venda.TRPFoodDAOVenda;
  TRPFoodDAOVendaItem                        = RPFood.DAO.VendaItem.TRPFoodDAOVendaItem;
  TRPFoodDAOVendaItemOpcional                = RPFood.DAO.VendaItemOpcional.TRPFoodDAOVendaItemOpcional;
  TRPFoodDAOVendaStatusLog                   = RPFood.DAO.VendaStatusLog.TRPFoodDAOVendaStatusLog;
  TRPFoodDAORelatorioVendas                  = RPFood.DAO.RelatorioVendas.TRPFoodRelatorioVendas;
  TRPFoodDAOConfiguracaoFuncionamento        = RPFood.DAO.ConfiguracaoFuncionamento.TRPFoodDAOConfiguracaFuncionamento;
  TRPFoodDAOTransferenciaImagens             = RPFood.DAO.TransferenciaImagens.TRPFoodDAOTransferenciaImagens;
  TRPfoodDAOPromocao                         = RPFood.DAO.Promocao.TRPfoodDAOPromocao;
  TRPFoodDAORestricaoVenda                   = RPFood.DAO.RestricaoVenda.TRPFoodDAORestricaoVenda;


  TRPFoodDAOFactory = class
  private
    FIdEmpresa                               : Integer;
    FConexao                                 : IADRConnection;
    FADMINUsuarioDAO                         : TRPFoodDAOADMINUsuario;
    FBairroDAO                               : TRPFoodDAOBairro;
    FCategoriaDAO                            : TRPFoodDAOCategoria;
    FClienteDAO                              : TRPFoodDAOCliente;
    FClienteEnderecoDAO                      : TRPFoodDAOClienteEndereco;
    FEmpresaDAO                              : TRPFoodDAOEmpresa;
    FEnderecoDAO                             : TRPFoodDAOEndereco;
    FFormaPagamentoDAO                       : TRPFoodDAOFormaPagamento;
    FOpcionalDAO                             : TRPFoodDAOOpcional;
    FProdutoDAO                              : TRPFoodDAOProduto;
    FProdutoOpcionalDAO                      : TRPFoodDAOProdutoOpcional;
    FVendaDAO                                : TRPFoodDAOVenda;
    FVendaEnderecoDAO                        : TRPFoodDAOVendaEndereco;
    FVendaItemDAO                            : TRPFoodDAOVendaItem;
    FVendaItemOpcionalDAO                    : TRPFoodDAOVendaItemOpcional;
    FVendaStatusLogDAO                       : TRPFoodDAOVendaStatusLog;
    FVendaRelatorio                          : TRPFoodDAORelatorioVendas;
    FConfiguracaoFuncionamento               : TRPFoodDAOConfiguracaoFuncionamento;
    FTransferenciaImagensDAO                 : TRPFoodDAOTransferenciaImagens;
    FConfiguracaoRPFoodDAO                   : TRPFoodDAOConfiguracaoRPFood;
    FHappyHourDAO                            : TRPFoodDAOHappy_Hour;
    FPromocaoDAO                             : TRPfoodDAOPromocao;
    FRestricaoVendaDAO                       : TRPFoodDAORestricaoVenda;
  public
    constructor Create(AConexao: IADRConnection);
    destructor Destroy; override;

    function ADMINUsuarioDAO            : TRPFoodDAOADMINUsuario;
    function BairroDAO: TRPFoodDAOBairro;
    function CategoriaDAO               : TRPFoodDAOCategoria;
    function ClienteDAO                 : TRPFoodDAOCliente;
    function ClienteEnderecoDAO         : TRPFoodDAOClienteEndereco;
    function EmpresaDAO                 : TRPFoodDAOEmpresa;
    function EnderecoDAO                : TRPFoodDAOEndereco;
    function FormaPagamentoDAO          : TRPFoodDAOFormaPagamento;
    function OpcionalDAO                : TRPFoodDAOOpcional;
    function ProdutoDAO                 : TRPFoodDAOProduto;
    function ProdutoOpcionalDAO         : TRPFoodDAOProdutoOpcional;
    function VendaDAO                   : TRPFoodDAOVenda;
    function VendaEnderecoDAO           : TRPFoodDAOVendaEndereco;
    function VendaItemDAO               : TRPFoodDAOVendaItem;
    function VendaItemOpcionalDAO       : TRPFoodDAOVendaItemOpcional;
    function VendaStatusLogDAO          : TRPFoodDAOVendaStatusLog;
    function RelatorioVendas            : TRPFoodRelatorioVendas;
    function ConfiguracaoFuncionamento  : TRPFoodDAOConfiguracaoFuncionamento;
    function TransferenciaImangesDAO    : TRPFoodDAOTransferenciaImagens;
    function ConfiguracaoRPFoodDAO      : TRPFoodDAOConfiguracaoRPFood;
    function HappyHourDAO               : TRPFoodDAOHappy_Hour;
    function PromocaoDAO                : TRPfoodDAOPromocao;
    function RestricaoVendaDAO          : TRPFoodDAORestricaoVenda;
    function IdEmpresa(AValue: Integer) : TRPFoodDAOFactory;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

{ TRPFoodDAOFactory }



function TRPFoodDAOFactory.ADMINUsuarioDAO: TRPFoodDAOADMINUsuario;
begin
  if not Assigned(FADMINUsuarioDAO) then
    FADMINUsuarioDAO := TRPFoodDAOADMINUsuario.Create(FConexao);
  Result := FADMINUsuarioDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.BairroDAO: TRPFoodDAOBairro;
begin
  if not Assigned(FBairroDAO) then
    FBairroDAO := TRPFoodDAOBairro.Create(FConexao);
  Result := FBairroDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.CategoriaDAO: TRPFoodDAOCategoria;
begin
  if not Assigned(FCategoriaDAO) then
    FCategoriaDAO := TRPFoodDAOCategoria.Create(FConexao);
  Result := FCategoriaDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.ClienteDAO: TRPFoodDAOCliente;
begin
  if not Assigned(FClienteDAO) then
    FClienteDAO := TRPFoodDAOCliente.Create(FConexao);
  Result := FClienteDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.ClienteEnderecoDAO: TRPFoodDAOClienteEndereco;
begin
  if not Assigned(FClienteEnderecoDAO) then
    FClienteEnderecoDAO := TRPFoodDAOClienteEndereco.Create(FConexao);
  Result := FClienteEnderecoDAO;
  Result.ManagerTransaction(True);
end;

procedure TRPFoodDAOFactory.Commit;
begin
  FConexao.Commit;
end;

function TRPFoodDAOFactory.ConfiguracaoFuncionamento: TRPFoodDAOConfiguracaoFuncionamento;
begin
 if not Assigned(FConfiguracaoFuncionamento) then
    FConfiguracaoFuncionamento := TRPFoodDAOConfiguracaFuncionamento.Create(FConexao);
  Result := FConfiguracaoFuncionamento;
  Result.ManagerTransaction(True);

end;

function TRPFoodDAOFactory.ConfiguracaoRPFoodDAO: TRPFoodDAOConfiguracaoRPFood;
begin
  if not Assigned(FConfiguracaoRPFoodDAO) then
    FConfiguracaoRPFoodDAO:= TRPFoodDAOConfiguracaoRPFood.Create(FConexao);
  Result := FConfiguracaoRPFoodDAO;
  Result.ManagerTransaction(True);
end;

constructor TRPFoodDAOFactory.Create(AConexao: IADRConnection);
begin
  FConexao := AConexao;
end;

destructor TRPFoodDAOFactory.Destroy;
begin
  FADMINUsuarioDAO.Free;
  FBairroDAO.Free;
  FCategoriaDAO.Free;
  FClienteDAO.Free;
  FClienteEnderecoDAO.Free;
  FEmpresaDAO.Free;
  FEnderecoDAO.Free;
  FFormaPagamentoDAO.Free;
  FOpcionalDAO.Free;
  FProdutoDAO.Free;
  FProdutoOpcionalDAO.Free;
  FVendaDAO.Free;
  FVendaEnderecoDAO.Free;
  FVendaItemDAO.Free;
  FVendaItemOpcionalDAO.Free;
  FVendaStatusLogDAO.Free;
  FVendaRelatorio.Free;
  FConfiguracaoFuncionamento.Free;
  FTransferenciaImagensDAO.Free;
  FConfiguracaoRPFoodDAO.Free;
  FHappyHourDAO.Free;
  FPromocaoDAO.Free;
  FRestricaoVendaDAO.Free;
  inherited;
end;

function TRPFoodDAOFactory.EmpresaDAO: TRPFoodDAOEmpresa;
begin
  if not Assigned(FEmpresaDAO) then
    FEmpresaDAO := TRPFoodDAOEmpresa.Create(FConexao);
  Result := FEmpresaDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.EnderecoDAO: TRPFoodDAOEndereco;
begin
  if not Assigned(FEnderecoDAO) then
    FEnderecoDAO := TRPFoodDAOEndereco.Create(FConexao);
  Result := FEnderecoDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.FormaPagamentoDAO: TRPFoodDAOFormaPagamento;
begin
  if not Assigned(FFormaPagamentoDAO) then
    FFormaPagamentoDAO := TRPFoodDAOFormaPagamento.Create(FConexao);
  Result := FFormaPagamentoDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.HappyHourDAO: TRPFoodDAOHappy_Hour;
begin
  if not Assigned(FHappyHourDAO) then
    FHappyHourDAO :=TRPFoodDAOHappy_Hour.Create(FConexao);
  Result  := FHappyHourDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.IdEmpresa(AValue: Integer): TRPFoodDAOFactory;
begin
  Result:=self;
  FIdEmpresa:=AValue;
end;

function TRPFoodDAOFactory.OpcionalDAO: TRPFoodDAOOpcional;
begin
  if not Assigned(FOpcionalDAO) then
    FOpcionalDAO := TRPFoodDAOOpcional.Create(FConexao);
  Result := FOpcionalDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.ProdutoDAO: TRPFoodDAOProduto;
begin
  if not Assigned(FProdutoDAO) then
    FProdutoDAO := TRPFoodDAOProduto.Create(FConexao);
  Result := FProdutoDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.ProdutoOpcionalDAO: TRPFoodDAOProdutoOpcional;
begin
  if not Assigned(FProdutoOpcionalDAO) then
    FProdutoOpcionalDAO := TRPFoodDAOProdutoOpcional.Create(FConexao);
  Result := FProdutoOpcionalDAO;
  Result.ManagerTransaction(True);
end;


function TRPFoodDAOFactory.PromocaoDAO: TRPfoodDAOPromocao;
begin
  if not Assigned(FPromocaoDAO) then
    FPromocaoDAO:=TRPfoodDAOPromocao.Create(FConexao);
  Result := FPromocaoDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.RelatorioVendas: TRPFoodRelatorioVendas;
begin
   if not Assigned(FVendaRelatorio) then
    FVendaRelatorio := TRPFoodRelatorioVendas.Create(FConexao);
  Result := FVendaRelatorio;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.RestricaoVendaDAO: TRPFoodDAORestricaoVenda;
begin
  if not Assigned(FRestricaoVendaDAO) then
  begin
   FRestricaoVendaDAO:=TRPFoodDAORestricaoVenda.Create(FConexao);
   FRestricaoVendaDAO.IdEmpresa(FIdEmpresa);
  end;


  Result:=FRestricaoVendaDAO;
 // Result.ManagerTransaction(True);
end;

procedure TRPFoodDAOFactory.Rollback;
begin
  FConexao.Rollback;
end;

procedure TRPFoodDAOFactory.StartTransaction;
begin
  FConexao.StartTransaction;
end;

function TRPFoodDAOFactory.TransferenciaImangesDAO: TRPFoodDAOTransferenciaImagens;
begin
  if not Assigned(FTransferenciaImagensDAO) then
    FTransferenciaImagensDAO := TRPFoodDAOTransferenciaImagens.Create(FConexao);
  Result := FTransferenciaImagensDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.VendaDAO: TRPFoodDAOVenda;
begin
  if not Assigned(FVendaDAO) then
    FVendaDAO := TRPFoodDAOVenda.Create(FConexao);
  Result := FVendaDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.VendaEnderecoDAO: TRPFoodDAOVendaEndereco;
begin
  if not Assigned(FVendaEnderecoDAO) then
    FVendaEnderecoDAO := TRPFoodDAOVendaEndereco.Create(FConexao);
  Result := FVendaEnderecoDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.VendaItemDAO: TRPFoodDAOVendaItem;
begin
  if not Assigned(FVendaItemDAO) then
    FVendaItemDAO := TRPFoodDAOVendaItem.Create(FConexao);
  Result := FVendaItemDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.VendaItemOpcionalDAO: TRPFoodDAOVendaItemOpcional;
begin
  if not Assigned(FVendaItemOpcionalDAO) then
    FVendaItemOpcionalDAO := TRPFoodDAOVendaItemOpcional.Create(FConexao);
  Result := FVendaItemOpcionalDAO;
  Result.ManagerTransaction(True);
end;

function TRPFoodDAOFactory.VendaStatusLogDAO: TRPFoodDAOVendaStatusLog;
begin
  if not Assigned(FVendaStatusLogDAO) then
    FVendaStatusLogDAO := TRPFoodDAOVendaStatusLog.Create(FConexao);
  Result := FVendaStatusLogDAO;
  Result.ManagerTransaction(True);
end;

end.


