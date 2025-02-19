unit RPFood.Entity.Categoria;

interface

uses
  System.Classes,
  System.SysUtils,
  RPFood.Utils;

type
  TRPFoodEntityCategoria = class
  private
    Fcodigo   : Integer;
    Fdescricao: string;
    FidEmpresa: Integer;
    function GetCaminhoHtmlImagem: string;
  public
    function CaminhoWWWRootImagem: string;
    procedure SalvarImagem(AImagem: TMemoryStream);

    property codigo           : Integer  read Fcodigo              write Fcodigo;
    property idEmpresa        : Integer  read FidEmpresa           write FidEmpresa;
    property descricao        : string   read Fdescricao           write Fdescricao;
    property caminhoHtmlImagem: string   read GetCaminhoHtmlImagem;
  end;

implementation

{ TRPFoodEntityCategoria }

function TRPFoodEntityCategoria.GetCaminhoHtmlImagem: string;
var
utils:TUtils;
begin
  utils:=TUtils.Create;
  try
    utils.RemoveCaracteresEspeciais(descricao);
    Result := Format('images/rpfood/categorias/%d_%d_%s.png',
    [idEmpresa, codigo,  utils.RemoveCaracteresEspeciais(descricao)]);

    if not FileExists(CaminhoWWWRootImagem) then
      Result := 'images/rpfood/default/PRODUTO-SEM-IMAGEM.jpg';
  finally
    utils.Free;
  end;
end;

function TRPFoodEntityCategoria.CaminhoWWWRootImagem: string;
var
utils:TUtils;
begin
  utils:=tutils.Create;
  try
    utils.RemoveCaracteresEspeciais(descricao);
    Result := Format('%s\wwwroot\images\rpfood\categorias\%d_%d_%s.png',
    [ExtractFilePath(GetModuleName(HInstance)), idEmpresa, codigo,
    utils.RemoveCaracteresEspeciais(descricao)]);
  finally
    utils.Free;
  end;
end;

procedure TRPFoodEntityCategoria.SalvarImagem(AImagem: TMemoryStream);
var
  LPath: string;
begin
  try
    if (Assigned(AImagem)) and (AImagem.Size > 0) then
    begin
      LPath := CaminhoWWWRootImagem;
      ForceDirectories(ExtractFilePath(LPath));
      AImagem.Position := 0;
       AImagem.SaveToFile(LPath);
    end;
  except
  end;
end;

end.
