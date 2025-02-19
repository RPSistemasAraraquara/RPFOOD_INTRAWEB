unit RPFood.Entity.Empresa;

interface

uses
  System.SysUtils,
  RPFood.Entity.Endereco;

type
  TRPFoodEntityEmpresa = class
  private
    FidEmpresa: Integer;
    FrazaoSocial: string;
    Fnome: string;
    Fcnpj: string;
    Fendereco: TRPFoodEntityEndereco;
    Femail: string;
    Ffone1: string;

  public
    constructor Create;
    destructor Destroy; override;

    function EnderecoCompleto           : string;
    property idEmpresa                  : Integer       read FidEmpresa       write FidEmpresa;
    property nome                       : string        read Fnome            write Fnome;
    property razaoSocial                : string        read FrazaoSocial     write FrazaoSocial;
    property cnpj                       : string        read Fcnpj            write Fcnpj;
    property email                      : string        read Femail           write Femail;
    property fone1                      : string        read Ffone1           write Ffone1;
    property endereco: TRPFoodEntityEndereco            read Fendereco        write Fendereco;
  end;

implementation

{ TRPFoodEntityEmpresa }

constructor TRPFoodEntityEmpresa.Create;
begin
  Fendereco := TRPFoodEntityEndereco.Create;
end;

destructor TRPFoodEntityEmpresa.Destroy;
begin
  Fendereco.Free;
  inherited;
end;

function TRPFoodEntityEmpresa.EnderecoCompleto: string;
begin
  Result := Format('%s, %s, %s, %s, %s', [Fendereco.endereco,
    Fendereco.numero, Fendereco.complemento, Fendereco.pontoReferencia, Fnome]);
end;

end.
