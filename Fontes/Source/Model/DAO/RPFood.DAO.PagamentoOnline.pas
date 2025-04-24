unit RPFood.DAO.PagamentoOnline;

interface

uses
  Data.DB,
  System.Generics.Collections,
  System.SysUtils,
  RPFood.DAO.Base,
  RPFood.Utils,
  RPFood.Entity.Classes;

  type
   TRPFoodDAOPagamentoOnline  = class(TRPFoodDAOBase<TRPFoodEntityPagamentoOnline>)
   protected
    function DataSetToEntity(ADataset :TDataSet):TRPFoodEntityPagamentoOnline;override;
    function ProximoId(AIdEmpresa: Integer): Integer;
   public
    procedure Insert(APagamentoOnline:TRPFoodEntityPagamentoOnline);
  end;

implementation

{ TRPFoodDAOPagamentoOnline }

function TRPFoodDAOPagamentoOnline.DataSetToEntity(ADataset: TDataSet): TRPFoodEntityPagamentoOnline;
begin
  Result:=nil;
  if ADataset.RecordCount>0 then
  begin
    Result:=TRPFoodEntityPagamentoOnline.Create;
    try
      Result.IdEmpresa             :=ADataset.FieldByName('idempresa').AsInteger;
      Result.IdVenda               :=ADataset.FieldByName('idVenda').AsInteger;
      Result.IdCliente             :=ADataset.FieldByName('idcliente').AsInteger;
      Result.ModeloIntegracao      :=ADataset.FieldByName('integracaopagamento').AsString;
      Result.UrlQrCodePagamento    :=ADataset.FieldByName('urlqrcode').AsString;
      Result.ValorPagamentoOnLine  :=ADataset.FieldByName('valorpagamentoonline').AsCurrency;
      Result.StatusPagamento       :=ADataset.FieldByName('status').AsString;
      Result.idautorizacaopagamento:=ADataset.FieldByName('idautorizacaopagamento').AsString;
    except
      Result.Free;
      raise ;
    end;
  end;
end;

procedure TRPFoodDAOPagamentoOnline.Insert(APagamentoOnline: TRPFoodEntityPagamentoOnline);
begin
  APagamentoOnline.IdVenda:=ProximoId(1);
  StartTransaction;
  try
     Query.SQL(' insert into pagamentoonline (')
      .SQL('idempresa, idVenda, idcliente, integracaopagamento, urlqrcode, valorpagamentoonline, status,idautorizacaopagamento)')
      .SQL('values (                                                                                     ')
      .SQL(':idempresa, :idVenda, :idcliente, :integracaopagamento, :urlqrcode, :valorpagamentoonline, :status, :idautorizacaopagamento)')
      .ParamAsInteger('idempresa', APagamentoOnline.IdEmpresa)
      .ParamAsInteger('idVenda', APagamentoOnline.IdVenda)
      .ParamAsInteger('idcliente', APagamentoOnline.IdCliente)
      .ParamAsString('integracaopagamento', APagamentoOnline.ModeloIntegracao)
      .ParamAsString('urlqrcode', APagamentoOnline.UrlQrCodePagamento)
      .ParamAsCurrency('valorpagamentoonline', APagamentoOnline.ValorPagamentoOnLine)
      .ParamAsString('status', APagamentoOnline.StatusPagamento)
      .ParamAsString('idautorizacaopagamento', APagamentoOnline.idautorizacaopagamento)
      .ExecSQL;
  except
    Rollback;
    raise;
  end;
end;

function TRPFoodDAOPagamentoOnline.ProximoId(AIdEmpresa: Integer): Integer;
begin
  Query.SQL('select (coalesce(max(id_venda),0) + 1) as proximoId ')
    .SQL('from venda where id_empresa = :idEmpresa               ')
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .Open;
  Result := Query.DataSet.FieldByName('proximoId').AsInteger;
end;

end.
