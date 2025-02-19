unit RPFood.Entity.VendaEndereco;

interface

type
  TRPFoodEntityVendaEndereco = class
  private
    FidVenda        : Integer;
    FidCliente      : Integer;
    FidBairro       : Integer;
    Fcep            : string;
    Flogradouro     : string;
    Fnumero         : string;
    Fcomplemento    : string;
    FpontoReferencia: string;
    Fbairro         : string;
    FBairro_Desc    : string;
    FIDEndereco     : Integer;
  public
    property idVenda         : Integer read FidVenda          write FidVenda;
    property idCliente       : Integer read FidCliente        write FidCliente;
    property idBairro        : Integer read FidBairro         write FidBairro;
    property cep             : string  read Fcep              write Fcep;
    property logradouro      : string  read Flogradouro       write Flogradouro;
    property numero          : string  read Fnumero           write Fnumero;
    property complemento     : string  read Fcomplemento      write Fcomplemento;
    property pontoReferencia : string  read FpontoReferencia  write FpontoReferencia;
    property bairro          : string  read Fbairro           write Fbairro;
    property bairro_descricao: string  read FBairro_Desc      write FBairro_Desc;
    property IDEndereco      : Integer read FIDEndereco       write FIDEndereco;

  end;

implementation

end.
