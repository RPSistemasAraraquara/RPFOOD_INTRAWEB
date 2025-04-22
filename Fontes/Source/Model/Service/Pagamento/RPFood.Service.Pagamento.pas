unit RPFood.Service.Pagamento;

interface

uses
  RPFood.Entity.Classes,
  RPFood.Entity.Types,
  Soap.EncdDecd,
  RPFood.View.Rotas,
  RPFood.DAO.Factory,
  System.SysUtils,
  System.Classes,
  IWCompExtCtrls,
  MercadoPago;

 type
 TRPFoodServicePagamento  = class
  private
    FDAO      : TRPFoodDAOFactory;
    FValorPedido:Currency;
    FConfiguracaoMercadoPago : TRPFoodEntityConfiguracaoPagamentoMercadoPago;
    FComponenteMercadoPago: TMercadoPago;
    FQrCodeDigitavel: string;
    FQrCodeURL: string;
    FIdPIX: string;
   function Base64ToStream(const Base64: string): TMemoryStream;
  public
    function DAO(AValue: TRPFoodDAOFactory): TRPFoodServicePagamento;
    function ValorPedido(AValor:Double):TRPFoodServicePagamento;
    function GerarQRCode(AImage: TIWImage): TRPFoodServicePagamento;
    function CarregarConfiguracoesMercadoPago(ANome,AEmail:string):TRPFoodServicePagamento;
    procedure LeQRCodeDigitavel(var AQrcode, QUrl: string);
    property QrCodeDigitavel: string read FQrCodeDigitavel write FQrCodeDigitavel;
    property QrCodeURL: string read FQrCodeURL write FQrCodeURL;
    procedure ConsultarStatusPIX(var AStatus:string);
    property IdPIX: string read FIdPIX write FIdPIX;

 end;


implementation

{ TRPFoodServicePagamento }

function TRPFoodServicePagamento.Base64ToStream(const Base64: string): TMemoryStream;
var
  Bytes: TBytes;
begin
  Result := TMemoryStream.Create;
  if Base64.Trim = '' then
    Exit;

  try
    Bytes := DecodeBase64(AnsiString(Base64));
    if Length(Bytes) > 0 then
    begin
      Result.WriteBuffer(Bytes[0], Length(Bytes));
      Result.Position := 0;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao converter QRCODE Base64 em imagem: ' + E.Message);
  end;
end;

function TRPFoodServicePagamento.CarregarConfiguracoesMercadoPago(ANome,AEmail:string):TRPFoodServicePagamento;
begin
  FreeAndNil(FConfiguracaoMercadoPago);
  FConfiguracaoMercadoPago:=FDAO.ConfiguracaoPagamentoMercadoPagoDAO.Buscar(1);
  if not Assigned(FConfiguracaoMercadoPago) then
    raise Exception.Create('Mercado Pago não configurado') ;


  FComponenteMercadoPago:=TMercadoPago.Create(nil);

  FComponenteMercadoPago.Configuracoes.AccessToken:= FConfiguracaoMercadoPago.AcessToken;
  FComponenteMercadoPago.Configuracoes.PublicKey  := FConfiguracaoMercadoPago.Key;
  FComponenteMercadoPago.Configuracoes.URLPayment := 'https://api.mercadopago.com/v1/payments?access_token=';
  FComponenteMercadoPago.Configuracoes.URLToken   := 'https://api.mercadopago.com/v1/card_tokens?public_key=';
  FComponenteMercadoPago.PIX.ClienteNome          := ANome;
  FComponenteMercadoPago.PIX.ClienteSobrenome     := ANome+AEmail;

  FComponenteMercadoPago.PIX.ClienteEmail         := AEmail;
  FComponenteMercadoPago.PIX.Descricao            := 'Pedido Delivery';
  FComponenteMercadoPago.PIX.Valor                := FValorPedido;

  FComponenteMercadoPago.PIX.URLNotificacao       := 'https://www.rpfood.com.br';



end;

procedure TRPFoodServicePagamento.ConsultarStatusPIX(var AStatus: string);
var
  LDescricaoStatus: string;
begin
   if FComponenteMercadoPago.PIX.Consultar(IdPIX)then
    LDescricaoStatus := FComponenteMercadoPago.PIX.Status.Descricao;
  AStatus := LDescricaoStatus;
end;


function TRPFoodServicePagamento.DAO(AValue: TRPFoodDAOFactory): TRPFoodServicePagamento;
begin
  Result:=Self;
  FDAO:=AValue;
end;

function TRPFoodServicePagamento.GerarQRCode(AImage: TIWImage): TRPFoodServicePagamento;
var
  LStream: TMemoryStream;
begin
  Result := Self;





  if FComponenteMercadoPago.PIX.Gerar then
  begin
    LStream := TMemoryStream.Create;
    try
      LStream.LoadFromStream(FComponenteMercadoPago.PIX.Base64);
      LStream.Position := 0;
      AImage.Picture.LoadFromStream(LStream);
      AImage.Visible    := True;
      AImage.Width      := 200;
      AImage.Height     := 200;
      AImage.RenderSize := True;
      AImage.AutoSize   := False;
      QrCodeDigitavel   := FComponenteMercadoPago.PIX.QrCode;
      QrCodeURL         := FComponenteMercadoPago.PIX.Url;
      IdPIX             := FComponenteMercadoPago.PIX.ID;
      FComponenteMercadoPago.PIX.Url    := 'www.rpfood.com.br';
    finally
      LStream.Free;
    end;
  end;
end;

procedure TRPFoodServicePagamento.LeQRCodeDigitavel(var AQrcode, QUrl: string);
begin
  AQrcode := QrCodeDigitavel;
  QUrl := QrCodeURL;
end;

function TRPFoodServicePagamento.ValorPedido(AValor: Double): TRPFoodServicePagamento;
begin
  Result:=Self;
  FValorPedido:=AValor;
end;

end.
