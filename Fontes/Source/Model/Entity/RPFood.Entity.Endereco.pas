unit RPFood.Entity.Endereco;

interface

uses
  System.SysUtils,
  RPFood.Utils,
  RPFood.Entity.Bairro;

type
  TRPFoodEntityEndereco = class
  private
    Fbairro               : string;
    Fuf                   : string;
    FtaxaEntrega          : Currency;
    Fcep                  : string;
    Fendereco             : string;
    Fnumero               : string;
    Fcomplemento          : string;
    FpontoReferencia      : string;
    FidBairro             : Integer;
    FidCidade            : Integer;


    procedure SetCep(const AValue: string);
    function GetEnderecoCompleto: string;
  public
    procedure Assign(ASource: TRPFoodEntityEndereco);
    procedure Validar;

    property cep              : string              read Fcep                 write SetCep;
    property endereco         : string              read Fendereco            write Fendereco;
    property idBairro         : Integer             read FidBairro            write FidBairro;
    property bairro           : string              read Fbairro              write Fbairro;
    property taxaEntrega      : Currency            read FtaxaEntrega         write FtaxaEntrega;
    property numero           : string              read Fnumero              write Fnumero;
    property complemento      : string              read Fcomplemento         write Fcomplemento;
    property pontoReferencia  : string              read FpontoReferencia     write FpontoReferencia;
    property enderecoCompleto : string              read GetEnderecoCompleto;
    property idCidade         : Integer             read FidCidade            write FidCidade;
    property UF               : string              read FUF                  write FUF;


  end;

  TRPFoodEntityClienteEndereco = class(TRPFoodEntityEndereco)
  private
    FidEndereco            : Integer;
    FidCliente             : Integer;
    FidEmpresa             : Integer;
    FenderecoPadrao        : Boolean;
    FTaxa                  : Currency;
    FTaxaEntregaBairro     : TRPFoodEntityBairro;
    FIdCidade              : Integer;
    FUF                    : String;

    procedure SetBuscaTaxaEntrega(const AValue:TRPFoodEntityBairro);
  public
    constructor Create;
    destructor destroy;override;
    procedure Assign(ASource: TRPFoodEntityEndereco); reintroduce;

    property idEndereco        : Integer              read FidEndereco          write FidEndereco;
    property idCliente         : Integer              read FidCliente           write FidCliente;
    property idEmpresa         : Integer              read FidEmpresa           write FidEmpresa;
    property enderecoPadrao    : Boolean              read FenderecoPadrao      write FenderecoPadrao;
    property taxa              : Currency             read Ftaxa                write Ftaxa;
    property TaxaEntregaBairro : TRPFoodEntityBairro  read FTaxaEntregaBairro   write SetBuscaTaxaEntrega;
    property IdCidade          : Integer              read FIdCidade            write FIdCidade;
    property UF                : String               read FUF                  write FUF;




  end;

implementation

{ TRPFoodEntityEndereco }

procedure TRPFoodEntityEndereco.Assign(ASource: TRPFoodEntityEndereco);
begin
  Fcep             := ASource.cep;
  Fendereco        := ASource.endereco;
  FidBairro        := ASource.idBairro;
  Fbairro          := ASource.bairro;
  FtaxaEntrega     := ASource.taxaEntrega;
  Fnumero          := ASource.numero;
  Fcomplemento     := ASource.complemento;
  FpontoReferencia := ASource.pontoReferencia;
  FidCidade        := ASource.idCidade;
  Fuf              := ASource.UF;
end;

function TRPFoodEntityEndereco.GetEnderecoCompleto: string;
begin
  Result := Format('%s, %s, %s, %s', [Fendereco,
    Fnumero, Fcomplemento, FpontoReferencia]);
end;

procedure TRPFoodEntityEndereco.SetCep(const AValue: string);
var
  Utils: TUtils;
begin
  Utils := TUtils.Create;
  try
    FCep := Utils.ApenasNumeros(AValue);
  finally
    Utils.Free;
  end;
end;


procedure TRPFoodEntityEndereco.Validar;
begin
  if Self.endereco = EmptyStr then
    raise Exception.Create('O endereco é de preenchimento obrigatório.');

  if Self.numero = EmptyStr then
    raise Exception.Create('O numero é de preenchimento obrigatório.');

  if Self.idBairro = 0 then
    raise Exception.Create('Id Bairro não preenchido.');

  if Self.bairro = EmptyStr then
    raise Exception.Create('O bairro é de preenchimento obrigatório.');


end;

{ TRPFoodEntityClienteEndereco }

procedure TRPFoodEntityClienteEndereco.Assign(ASource: TRPFoodEntityEndereco);
var
  LEndereco: TRPFoodEntityClienteEndereco;
begin
  inherited Assign(ASource);
  if ASource is TRPFoodEntityClienteEndereco then
  begin
    LEndereco := TRPFoodEntityClienteEndereco(ASource);
    FidEndereco     := LEndereco.idEndereco;
    FidCliente      := LEndereco.idCliente;
    FidEmpresa      := LEndereco.idEmpresa;
    FenderecoPadrao := LEndereco.enderecoPadrao;
    FTaxa           := LEndereco.taxa;
    FIdCidade       := LEndereco.IdCidade;
    FUF             := LEndereco.UF;
  end;
end;

constructor TRPFoodEntityClienteEndereco.Create;
begin
  FenderecoPadrao := False;
  FTaxaEntregaBairro  :=TRPFoodEntityBairro.Create;
end;

destructor TRPFoodEntityClienteEndereco.destroy;
begin
  FTaxaEntregaBairro.Free;
  inherited;
end;

procedure TRPFoodEntityClienteEndereco.SetBuscaTaxaEntrega(const AValue: TRPFoodEntityBairro);
begin
  FreeAndNil(FTaxaEntregaBairro);
  FTaxaEntregaBairro:=AValue;
end;

end.
