unit RPFood.Service.Imagem.Categoria;

interface

uses
  RPFood.DAO.Factory,
  RPFood.Entity.Classes,
  RPFood.Service.Imagem,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceImagemCategoria = class(TRPFoodServiceImagem)
  private
    function ExisteTransferencia(ACategoria: TRPFoodEntityCategoria): Boolean;
  public
    procedure Carregar; override;
  end;

implementation

{ TRPFoodServiceImagemCategoria }

procedure TRPFoodServiceImagemCategoria.Carregar;
var
  LCategoria      : TRPFoodEntityCategoria;
  LCarregaDoBanco : Boolean;
  LMemoryStream   : TMemoryStream;
begin
  LCategoria      := TRPFoodEntityCategoria(FObjeto);
  LCarregaDoBanco := not FileExists(LCategoria.CaminhoWWWRootImagem);
  if not LCarregaDoBanco then
    LCarregaDoBanco := ExisteTransferencia(LCategoria);

  if LCarregaDoBanco then
  begin
    LMemoryStream := FDAO.CategoriaDAO.GetImagem(LCategoria);
    try
      LCategoria.SalvarImagem(LMemoryStream);
    finally
      LMemoryStream.Free;
    end;
  end;
end;

function TRPFoodServiceImagemCategoria.ExisteTransferencia(ACategoria: TRPFoodEntityCategoria): Boolean;
var
  LTransferencia: TRPFoodEntityTransferenciaImagens;
begin
  Result := False;
  LTransferencia := FDAO.TransferenciaImangesDAO.BuscaPorCategoria(FIdEmpresa,
    ACategoria.codigo);
  try
    if Assigned(LTransferencia) then
    begin
      Result := True;
      FDAO.TransferenciaImangesDAO.DeletePorCategoria(FIdEmpresa, ACategoria.codigo);
    end;
  finally
    LTransferencia.Free;
  end;
end;

end.
