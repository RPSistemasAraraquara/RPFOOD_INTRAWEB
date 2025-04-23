unit RPFood.Entity.PagamentoOnline;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  RPFood.Utils,
  RPFood.Entity.Endereco;

  type
  TPFoodEntityPagamentoOnline = class
  private
    FIdEmpresa: integer;
    FIdVenda: Integer;
    FIdCliente: Integer;
    FModeloIntegracao: string;
    FUrlQrCodePagamento:string;
    FValorPagamentoOnLine: Currency;
    FStatusPagamento: string;
  public
    property IdEmpresa: integer read FIdEmpresa write FIdEmpresa;
    property IdVenda: Integer read FIdVenda write FIdVenda;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property ModeloIntegracao: string read FModeloIntegracao write FModeloIntegracao;
    property UrlQrCodePagamento: string read FUrlQrCodePagamento write FUrlQrCodePagamento;
    property ValorPagamentoOnLine: Currency read FValorPagamentoOnLine write FValorPagamentoOnLine;
    property StatusPagamento: string read FStatusPagamento write FStatusPagamento;
  end;


implementation

{ TPFoodEntityPagamentoOnline }

end.
