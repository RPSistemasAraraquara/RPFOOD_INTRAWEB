unit RPFood.Entity.Types;

interface

uses
  System.SysUtils;

type
  TRPSituacaoPedido = (spEnviado, spRejeitado, spAceito, spEmPreparo,
    spSaiuParaEntrega, spProntoParaRetirar, spFinalizado, spCanceladoEstabelecimento,
    spCanceladoCliente, spRejeitadoTempoEspera);

  TRPTipoEntrega = (teDelivery, teRetirada);

   TRPFoodTipoDesconto = (tdValor, tdPercentual);

  TRPSituacaoPedidoHeler = record helper for TRPSituacaoPedido
  public
    function Descricao: string;
    function DBValue: Integer;
    function StatusFinal: Boolean;
    procedure FromDBValue(AValue: Integer);
  end;

  TRPTipoEntregaHelper = record helper for TRPTipoEntrega
  public
    function Descricao: string;
    function DBValue: string;
    procedure FromDBValue(AValue: string);
  end;

   TRPFoodTipoDescontoHelper = record helper for TRPFoodTipoDesconto
  public
    function DBValue: string;
    procedure FromDBValue(AValue: string);
  end;



implementation

{ TRPTipoEntregaHelper }

function TRPTipoEntregaHelper.DBValue: string;
begin
  case Self of
    teDelivery: Result := 'D';
    teRetirada: Result := 'R';
  end;
end;

function TRPTipoEntregaHelper.Descricao: string;
begin
  case Self of
    teDelivery: Result := 'Delivery';
    teRetirada: Result := 'Retirada';
  end;
end;

procedure TRPTipoEntregaHelper.FromDBValue(AValue: string);
begin
  if AValue.ToLower = 'd' then
    Self := teDelivery
  else
  if AValue.ToLower = 'r' then
    Self := teRetirada;
end;

{ TRPSituacaoPedidoHeler }

function TRPSituacaoPedidoHeler.DBValue: Integer;
begin
  Result := 100;
  case Self of
    spEnviado                 : Result := 100;
    spRejeitado               : Result := 101;
    spAceito                  : Result := 102;
    spEmPreparo               : Result := 103;
    spSaiuParaEntrega         : Result := 104;
    spProntoParaRetirar       : Result := 105;
    spFinalizado              : Result := 106;
    spCanceladoEstabelecimento: Result := 107;
    spCanceladoCliente        : Result := 108;
    spRejeitadoTempoEspera    : Result := 109;
  end;
end;

function TRPSituacaoPedidoHeler.Descricao: string;
begin
  Result := 'Pedido enviado';
  case Self of
    spEnviado                          : Result := 'Pedido enviado';
    spRejeitado                        : Result := 'Pedido rejeitado';
    spAceito                           : Result := 'Pedido aceito';
    spEmPreparo                        : Result := 'Pedido em preparo';
    spSaiuParaEntrega                  : Result := 'Pedido saiu para entrega';
    spProntoParaRetirar                : Result := 'Pedido pronto para retirada';
    spFinalizado                       : Result := 'Pedido finalizado';
    spCanceladoEstabelecimento         : Result := 'Pedido cancelado pelo estabelecimento';
    spCanceladoCliente                 : Result := 'Pedido cancelado pelo cliente';
    spRejeitadoTempoEspera             : Result := 'Pedido rejeitado';
  end;
end;

procedure TRPSituacaoPedidoHeler.FromDBValue(AValue: Integer);
begin
  Self := spEnviado;
  if AValue = 100 then
    Self := spEnviado
  else
  if AValue = 101 then
    Self := spRejeitado
  else
  if AValue = 102 then
    Self := spAceito
  else
  if AValue = 103 then
    Self := spEmPreparo
  else
  if AValue = 104 then
    Self := spSaiuParaEntrega
  else
  if AValue = 105 then
    Self := spProntoParaRetirar
  else
  if AValue = 106 then
    Self := spFinalizado
  else
  if AValue = 107 then
    Self := spCanceladoEstabelecimento
  else
  if AValue = 108 then
    Self := spCanceladoCliente
  else
  if AValue = 109 then
    Self := spRejeitadoTempoEspera;
end;

function TRPSituacaoPedidoHeler.StatusFinal: Boolean;
begin
  Result := False;
  case Self of
    spEnviado                 : Result := False;
    spRejeitado               : Result := True;
    spAceito                  : Result := False;
    spEmPreparo               : Result := False;
    spSaiuParaEntrega         : Result := False;
    spProntoParaRetirar       : Result := False;
    spFinalizado              : Result := True;
    spCanceladoEstabelecimento: Result := True;
    spCanceladoCliente        : Result := True;
    spRejeitadoTempoEspera    : Result := True;
  end;
end;

{ TRPFoodTipoDescontoHelper }

function TRPFoodTipoDescontoHelper.DBValue: string;
begin
  case Self of
    tdValor: Result := 'VALOR';
    tdPercentual: Result := 'PERCENTUAL';
  end;
end;

procedure TRPFoodTipoDescontoHelper.FromDBValue(AValue: string);
begin
  Self := tdValor;
  if AValue.ToLower = 'percentual' then
    Self := tdPercentual;
end;

end.
