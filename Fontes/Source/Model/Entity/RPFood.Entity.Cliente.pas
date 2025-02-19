unit RPFood.Entity.Cliente;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  RPFood.Utils,
  RPFood.Entity.Endereco;

type
  TRPFoodEntityCliente = class
  private
    FidEmpresa      : Integer;
    Fnome           : string;
    Femail          : string;
    Fsenha          : string;
    FidCliente      : Integer;
    Fcelular        : string;
    Ftelefone       : string;
    Fenderecos      : TObjectList<TRPFoodEntityClienteEndereco>;
    procedure SetEnderecos(const Value: TObjectList<TRPFoodEntityClienteEndereco>);
    function GetEnderecoPadrao: TRPFoodEntityClienteEndereco;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(ASource: TRPFoodEntityCliente);
    procedure Validar;
    procedure ValidarPreenchimentoSenha;
    function EnderecoCompleto: string;
    function GetEndereco(AIdEndereco: Integer): TRPFoodEntityClienteEndereco;

    property idCliente    : Integer                               read FidCliente write FidCliente;
    property idEmpresa    : Integer                               read FidEmpresa write FidEmpresa;
    property nome         : string                                read Fnome      write Fnome;
    property email        : string                                read Femail     write Femail;
    property senha        : string                                read Fsenha     write Fsenha;
    property celular      : string                                read Fcelular   write Fcelular;
    property telefone     : string                                read Ftelefone  write Ftelefone;
    property enderecoPadrao: TRPFoodEntityClienteEndereco         read GetEnderecoPadrao;
    property enderecos: TObjectList<TRPFoodEntityClienteEndereco> read Fenderecos write SetEnderecos;
  end;

implementation

{ TRPFoodEntityCliente }

procedure TRPFoodEntityCliente.Assign(ASource: TRPFoodEntityCliente);
var
  LEndereco: TRPFoodEntityClienteEndereco;
begin
  Self.idCliente := ASource.idCliente;
  Self.idEmpresa := ASource.idEmpresa;
  Self.nome      := ASource.nome;
  Self.email     := ASource.email;
  Self.senha     := ASource.senha;
  Self.celular   := ASource.celular;
  Self.telefone  := ASource.telefone;

  FreeAndNil(Fenderecos);
  Fenderecos := TObjectList<TRPFoodEntityClienteEndereco>.Create;
  for LEndereco in ASource.enderecos do
  begin
    Fenderecos.Add(TRPFoodEntityClienteEndereco.Create);
    Fenderecos.Last.Assign(LEndereco);
  end;
end;

constructor TRPFoodEntityCliente.Create;
begin
  Fenderecos := TObjectList<TRPFoodEntityClienteEndereco>.Create;
end;

destructor TRPFoodEntityCliente.Destroy;
begin
  Fenderecos.Free;
  inherited;
end;

function TRPFoodEntityCliente.EnderecoCompleto: string;
begin
  if enderecoPadrao <> nil then
    Result := Format('%s, %s, %s, %s', [enderecoPadrao.endereco,
      enderecoPadrao.numero, enderecoPadrao.complemento, enderecoPadrao.pontoReferencia]);
end;

function TRPFoodEntityCliente.GetEndereco(AIdEndereco: Integer): TRPFoodEntityClienteEndereco;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Fenderecos.Count) do
  begin
    if Fenderecos[I].idEndereco = AIdEndereco then
      Exit(Fenderecos[I]);
  end;
end;

function TRPFoodEntityCliente.GetEnderecoPadrao: TRPFoodEntityClienteEndereco;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Fenderecos.Count) do
  begin
    if Fenderecos[I].enderecoPadrao then
      Exit(Fenderecos[I]);
  end;

  if (not Assigned(Result)) and (Fenderecos.Count > 0) then
    Result := Fenderecos[0];
end;


procedure TRPFoodEntityCliente.SetEnderecos(const Value: TObjectList<TRPFoodEntityClienteEndereco>);
begin
  Fenderecos.Free;
  Fenderecos := Value;
end;

procedure TRPFoodEntityCliente.Validar;
var
  LEndereco: TRPFoodEntityEndereco;
  Utils: TUtils;
begin
  utils:=TUtils.Create;
  try
    if Self.nome = EmptyStr then
      raise Exception.Create('O nome é de preenchimento obrigatório.');

    if Self.email = EmptyStr then
      raise Exception.Create('O email é de preenchimento obrigatório.');

    if Self.senha = EmptyStr then
      raise Exception.Create('O senha é de preenchimento obrigatório.');

     if Length(Self.senha) < 4 then
      raise Exception.Create('A senha necessita ter no mínimo 4 digítos.');


    if not Utils.ValidarCelular(Self.celular) then
      raise Exception.Create('Celular inválido');

    for LEndereco in Fenderecos do
      LEndereco.Validar;
  finally
    Utils.Free;
  end;
end;

procedure TRPFoodEntityCliente.ValidarPreenchimentoSenha;
begin
  if Length(Self.senha) < 4 then
    raise Exception.Create('A senha necessita ter no mínimo 4 digítos.');
end;


end.
