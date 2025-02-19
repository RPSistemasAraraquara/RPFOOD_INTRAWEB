unit RPFood.Entity.ADMIN.Usuario;

interface

type
  TRPFoodEntityADMINUsuario = class
  private
    Fcodigo: Integer;
    Femail: string;
    Fsenha: string;
    Fnome: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property email: string read Femail write Femail;
    property senha: string read Fsenha write Fsenha;
    property nome: string read Fnome write Fnome;
  end;

implementation

end.
