unit RPFood.Service.Imagem.Produto;

interface

uses
  RPFood.DAO.Factory,
  RPFood.Entity.Classes,
  RPFood.Service.Imagem,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceImagemProduto = class(TRPFoodServiceImagem)
  private
    function ExisteTransferencia(AProduto: TRPFoodEntityProduto): Boolean;
  public
    procedure Carregar; override;
  end;

implementation

{ TRPFoodServiceImagemProduto }

procedure TRPFoodServiceImagemProduto.Carregar;
var
  LProduto        : TRPFoodEntityProduto;
  LCarregaDoBanco : Boolean;
  LMemoryStream   : TMemoryStream;
begin
  LProduto        := TRPFoodEntityProduto(FObjeto);
  LCarregaDoBanco := not FileExists(LProduto.CaminhoWWWRootImagem);
  if not LCarregaDoBanco then
    LCarregaDoBanco := ExisteTransferencia(LProduto);

  if LCarregaDoBanco then
  begin
    LMemoryStream := FDAO.ProdutoDAO.GetImagem(LProduto);
    try
      LProduto.SalvarImagem(LMemoryStream);
    finally
      LMemoryStream.Free;
    end;
  end;
end;

function TRPFoodServiceImagemProduto.ExisteTransferencia(AProduto: TRPFoodEntityProduto): Boolean;
var
  LTransferencia: TRPFoodEntityTransferenciaImagens;
begin
  Result := False;
  LTransferencia := FDAO.TransferenciaImangesDAO.BuscaPorProduto(FIdEmpresa,
    AProduto.codigo);
  try
    if Assigned(LTransferencia) then
    begin
      Result := True;
      FDAO.TransferenciaImangesDAO.DeletePorProduto(FIdEmpresa, AProduto.codigo);
    end;
  finally
    LTransferencia.Free;
  end;
end;

end.
