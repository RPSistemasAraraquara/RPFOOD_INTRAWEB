unit RPFood.Entity.PagamentoOnline;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  RPFood.Utils,
  RPFood.Entity.Endereco;

  type
  TRPFoodEntityPagamentoOnline = class
  private
    FIdEmpresa              : integer;
    FIdVenda                : Integer;
    FIdCliente              : Integer;
    FModeloIntegracao       : string;
    FUrlQrCodePagamento     : string;
    FValorPagamentoOnLine   : Currency;
    FStatusPagamento        : string;
    Fidautorizacaopagamento : string;
  public
    property IdEmpresa             : integer    read FIdEmpresa               write FIdEmpresa;
    property IdVenda               : Integer    read FIdVenda                 write FIdVenda;
    property IdCliente             : Integer    read FIdCliente               write FIdCliente;
    property idautorizacaopagamento: string     read Fidautorizacaopagamento  write Fidautorizacaopagamento;
    property ModeloIntegracao      : string     read FModeloIntegracao        write FModeloIntegracao;
    property UrlQrCodePagamento    : string     read FUrlQrCodePagamento      write FUrlQrCodePagamento;
    property ValorPagamentoOnLine  : Currency   read FValorPagamentoOnLine    write FValorPagamentoOnLine;
    property StatusPagamento       : string     read FStatusPagamento         write FStatusPagamento;
  end;


implementation

{ TPFoodEntityPagamentoOnline }

end.
