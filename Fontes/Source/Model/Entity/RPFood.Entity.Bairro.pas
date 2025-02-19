unit RPFood.Entity.Bairro;

interface

type
  TRPFoodEntityBairro = class
  private
    FIdEmpresa       : Integer;
    FIdBairro        : Integer;
    FDescricao       : string;
    Ftaxa            : Currency;
    FSituacao        : Integer;
    FRestricaoEntrega: Boolean;
  public
    property IdEmpresa        : Integer     read FIdEmpresa         write FIdEmpresa;
    property IdBairro         : Integer     read FIdBairro          write FIdBairro;
    property Descricao        : string      read FDescricao         write FDescricao;
    property taxa             : Currency    read Ftaxa              write Ftaxa;
    property Situacao         : Integer     read FSituacao          write FSituacao;
    property RestricaoEntrega : Boolean     read FRestricaoEntrega  write FRestricaoEntrega;
  end;

implementation

end.
