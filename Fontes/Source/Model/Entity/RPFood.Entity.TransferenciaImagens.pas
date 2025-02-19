unit RPFood.Entity.TransferenciaImagens;

interface

type
  TRPFoodEntityTransferenciaImagens = class
  private
    FidEmpresa      : Integer;
    FTipo           : string;
    Fidregistro     : Integer;
    Fid             : Integer;
  public
    property id         : Integer   read Fid          write Fid;
    property idEmpresa  : Integer   read FidEmpresa   write FidEmpresa;
    property tipo       : string    read FTipo        write FTipo;
    property idRegistro : Integer   read FidRegistro  write FidRegistro;
  end;

implementation

end.
