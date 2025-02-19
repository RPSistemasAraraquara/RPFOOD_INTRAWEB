unit RPFood.Service.Imagem;

interface

uses
  RPFood.DAO.Factory,
  RPFood.Entity.Classes,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceImagem = class
  protected
    FDAO      : TRPFoodDAOFactory;
    FObjeto   : TObject;
    FIdEmpresa: Integer;
  public
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceImagem;
    function Objeto(AValue: TObject): TRPFoodServiceImagem;
    function IdEmpresa(Value: Integer): TRPFoodServiceImagem;
    procedure Carregar; virtual;
  end;

implementation

{ TRPFoodServiceImagem }

uses
  RPFood.Service.Imagem.Produto,
  RPFood.Service.Imagem.Categoria;

procedure TRPFoodServiceImagem.Carregar;
var
  LStrategy: TRPFoodServiceImagem;
begin
  LStrategy := nil;
  try
    if FObjeto is TRPFoodEntityProduto then
      LStrategy := TRPFoodServiceImagemProduto.Create
    else
    if FObjeto is TRPFoodEntityCategoria then
      LStrategy := TRPFoodServiceImagemCategoria.Create;

    if Assigned(LStrategy) then
    begin
      LStrategy.DAO(FDAO)
        .IdEmpresa(FIdEmpresa)
        .Objeto(FObjeto);

      LStrategy.Carregar;
    end;
  finally
    LStrategy.Free;
  end;
end;

function TRPFoodServiceImagem.DAO(AValue: TRPFoodDAOFactory): TRPFoodServiceImagem;
begin
  Result  := Self;
  FDAO    := AValue;
end;

function TRPFoodServiceImagem.IdEmpresa(Value: Integer): TRPFoodServiceImagem;
begin
  Result      := Self;
  FIdEmpresa  := Value;
end;

function TRPFoodServiceImagem.Objeto(AValue: TObject): TRPFoodServiceImagem;
begin
  Result  := Self;
  FObjeto := AValue;
end;

end.
