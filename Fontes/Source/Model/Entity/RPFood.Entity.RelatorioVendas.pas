unit RPFood.Entity.RelatorioVendas;

interface
uses
  System.SysUtils;
  type
    TRPFoodEntityRelatorioVendas= class
  private
    FtaxaEntrega: Currency;
    Fdata: TDateTime;
    Fid: Integer;
    FidEmpresa: Integer;
    FvalorAReceber: Currency;
    Ftroco: Currency;
    FvalorTotalProdutos: Currency;
    FvalorTotal: Currency;
    FvalorTotalOpcionais: Currency;
    FrecebidoLeCheff: Boolean;
    Fobservacao: string;
    Fsituacao_pedido    :String;
    Fvenda_entrega      :String;
    Fprodutos_codigo    :Integer;
    Fdescricao_produto  :String;
    Fvalor_unitario     :Currency;
    Fquantidade_produtos:Double;
    Fvalor_total_product:Currency;
    Fobservacao_produto :String;
  public
    property id: Integer read Fid write Fid;
    property idEmpresa: Integer read FidEmpresa write FidEmpresa;
    property data: TDateTime read Fdata write Fdata;
    property taxaEntrega: Currency read FtaxaEntrega write FtaxaEntrega;
    property valorTotalProdutos: Currency read FvalorTotalProdutos write FvalorTotalProdutos;
    property valorTotal: Currency read FvalorTotal write FvalorTotal;
    property valorTotalOpcionais: Currency read FvalorTotalOpcionais write FvalorTotalOpcionais;
    property valorAReceber: Currency read FvalorAReceber write FvalorAReceber;
    property troco: Currency read Ftroco write Ftroco;
    property recebidoLeCheff: Boolean read FrecebidoLeCheff write FrecebidoLeCheff;
    property observacao: string read Fobservacao write Fobservacao;
    property descricao_produto: string read Fdescricao_produto write Fdescricao_produto;
    property situacao_pedido:string read Fsituacao_pedido write Fsituacao_pedido;
    property venda_entrega:string read Fvenda_entrega write Fvenda_entrega;
    property produtos_codigo:integer read Fprodutos_codigo write Fprodutos_codigo;
    property quantidade_produtos: Double read Fquantidade_produtos write Fquantidade_produtos;
    property valor_unitario: Currency read Fvalor_unitario write Fvalor_unitario;
    property valor_total_product : Currency read Fvalor_total_product write Fvalor_total_product;
    property observacao_produto  : string read Fobservacao_produto write Fobservacao_produto;
  end;

implementation


end.
