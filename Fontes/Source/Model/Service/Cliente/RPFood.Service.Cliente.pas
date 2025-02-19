unit RPFood.Service.Cliente;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  RPFood.DAO.Factory,
  RPFood.Entity.Classes;

type
  TRPFoodServiceCliente = class
  private
    FDAO: TRPFoodDAOFactory;
    FCliente: TRPFoodEntityCliente;

    procedure SalvarCliente;
    procedure SalvarEndereco;
  public
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceCliente;
    function Cliente(AValue: TRPFoodEntityCliente): TRPFoodServiceCliente;

    procedure Salvar;
    procedure Alterar;
    procedure AdicionarEndereco(AEndereco: TRPFoodEntityClienteEndereco);
    procedure AlterarEndereco(AEndereco: TRPFoodEntityClienteEndereco);
    procedure AdicionarEnderecoBairro(AEndereco:TRPFoodEntityClienteEndereco);

  end;

implementation

{ TRPFoodServiceCliente }

procedure TRPFoodServiceCliente.AdicionarEndereco(AEndereco: TRPFoodEntityClienteEndereco);
var
  LDAOEndereco: TRPFoodDAOClienteEndereco;
begin
  AEndereco.idCliente := FCliente.idCliente;
  AEndereco.idEmpresa := FCliente.idEmpresa;

  FDAO.StartTransaction;
  try
    LDAOEndereco := FDAO.ClienteEnderecoDAO;
    LDAOEndereco.ManagerTransaction(False);
    LDAOEndereco.Inserir(AEndereco);
    if AEndereco.enderecoPadrao then
      FDAO.ClienteEnderecoDAO.AtualizarEnderecoPadrao(AEndereco.idCliente,
        AEndereco.idEndereco, AEndereco.idEmpresa);
    FDAO.Commit;
    FCliente.enderecos.Add(TRPFoodEntityClienteEndereco.Create);
    FCliente.enderecos.Last.Assign(AEndereco);
  except
    FDAO.Rollback;
    raise;
  end;
end;

procedure TRPFoodServiceCliente.AdicionarEnderecoBairro(AEndereco: TRPFoodEntityClienteEndereco);
var
LDAOEnderecoBairro:TRPFoodDAOClienteEndereco;

begin
  AEndereco.idCliente := FCliente.idCliente;
  AEndereco.idEmpresa := FCliente.idEmpresa;

  FDAO.StartTransaction;
  try
    LDAOEnderecoBairro:=FDAO.ClienteEnderecoDAO;
    LDAOEnderecoBairro.ManagerTransaction(False);

    LDAOEnderecoBairro.InserirEnderecoBairro(AEndereco);
    if AEndereco.enderecoPadrao then
      FDAO.ClienteEnderecoDAO.AtualizarEnderecoPadrao(AEndereco.idCliente,
        AEndereco.idEndereco, AEndereco.idEmpresa);
    FDAO.Commit;
    FCliente.enderecos.Add(TRPFoodEntityClienteEndereco.Create);
    FCliente.enderecos.Last.Assign(AEndereco);
  except
    FDAO.Rollback;
    raise;
  end;
end;

procedure TRPFoodServiceCliente.Alterar;
begin
  FDAO.ClienteDAO.Alterar(FCliente);
end;

procedure TRPFoodServiceCliente.AlterarEndereco(AEndereco: TRPFoodEntityClienteEndereco);
var
LDAOEnderecoBairro:TRPFoodDAOClienteEndereco;
begin
  AEndereco.idCliente := FCliente.idCliente;
  AEndereco.idEmpresa := FCliente.idEmpresa;
  FDAO.StartTransaction;
  try
    LDAOEnderecoBairro:=FDAO.ClienteEnderecoDAO;
    LDAOEnderecoBairro.ManagerTransaction(false);
    LDAOEnderecoBairro.Alterar(AEndereco);

    if AEndereco.enderecoPadrao then
      FDAO.ClienteEnderecoDAO.AtualizarEnderecoPadrao(AEndereco.idCliente,
        AEndereco.idEndereco, AEndereco.idEmpresa);
    FDAO.Commit;
  except
    FDAO.Rollback;
    raise;
  end;
end;

function TRPFoodServiceCliente.Cliente(AValue: TRPFoodEntityCliente): TRPFoodServiceCliente;
begin
  Result := Self;
  FCliente := AValue;
end;

function TRPFoodServiceCliente.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceCliente;
begin
  Result := Self;
  FDAO := AValue;
end;

procedure TRPFoodServiceCliente.Salvar;
begin
  FCliente.Validar;
  FDAO.StartTransaction;
  try
    SalvarCliente;
    SalvarEndereco;
    FDAO.Commit;
  except
    FDAO.Rollback;
    raise;
  end;
end;

procedure TRPFoodServiceCliente.SalvarCliente;
var
  LDAOCliente: TRPFoodDAOCliente;
begin
  LDAOCliente := FDAO.ClienteDAO;
  LDAOCliente.ManagerTransaction(False); // Pra não startar transação la dentro...
  LDAOCliente.Gravar(FCliente);
end;

procedure TRPFoodServiceCliente.SalvarEndereco;
var
  LDAOEndereco: TRPFoodDAOClienteEndereco;
  LEndereco: TRPFoodEntityClienteEndereco;
begin
  LDAOEndereco := FDAO.ClienteEnderecoDAO;
  LDAOEndereco.ManagerTransaction(False);

  for LEndereco in FCliente.enderecos do
  begin
    LEndereco.idCliente := FCliente.idCliente;
    LEndereco.idEmpresa := FCliente.idEmpresa;
    if LEndereco.idEndereco = 0 then
      LDAOEndereco.Inserir(LEndereco)
    else
      LDAOEndereco.Alterar(LEndereco);
  end;
end;

end.
