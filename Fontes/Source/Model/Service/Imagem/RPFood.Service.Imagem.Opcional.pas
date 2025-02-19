unit RPFood.Service.Imagem.Opcional;

interface
uses

  RPFood.DAO.Factory,
  RPFood.Entity.Classes,
  RPFood.Service.Imagem,
  System.SysUtils,
  System.Classes;

type
  TRPFoodServiceImagemOpcional = class(TRPFoodServiceImagem)
  private
  //  function ExisteTransferencia(AOpcional: TRPFoodEntityOpcional): Boolean;
  public
    procedure Carregar; override;
 end;

implementation

{ TRPFoodServiceImagemOpcional }

procedure TRPFoodServiceImagemOpcional.Carregar;
//var
//  LOpcional: TRPFoodEntityOpcional;
//  LCarregaDoBanco: Boolean;
//  LMemoryStream: TMemoryStream;
begin
//  LOpcional := TRPFoodEntityOpcional(FObjeto);
//  LCarregaDoBanco := not FileExists(LOpcional.CaminhoWWWRootImagem);
//  if not LCarregaDoBanco then
//    LCarregaDoBanco := ExisteTransferencia(LOpcional);

//  if LCarregaDoBanco then
//  begin
//    LMemoryStream := FDAO.OpcionalDAO.GetImagem(LOpcional);
//    try
//      LOpcional.SalvarImagem(LMemoryStream);
//    finally
//      LMemoryStream.Free;
//    end;
//  end;
end;

//function TRPFoodServiceImagemOpcional.ExisteTransferencia(AOpcional: TRPFoodEntityOpcional): Boolean;
//var
//  LTransferencia: TRPFoodEntityTransferenciaImagens;
//begin
//   Result := False;
//  LTransferencia := FDAO.TransferenciaImangesDAO.BuscaPorOpcional(FIdEmpresa,
//    AOpcional.codigo);
//  try
//    if Assigned(LTransferencia) then
//    begin
//      Result := True;
//      FDAO.TransferenciaImangesDAO.DeletePorProduto(FIdEmpresa, AOpcional.codigo);
//    end;
//  finally
//    LTransferencia.Free;
//  end;
//end;

end.
