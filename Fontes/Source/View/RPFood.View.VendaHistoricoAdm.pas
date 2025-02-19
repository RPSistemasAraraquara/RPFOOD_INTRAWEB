unit RPFood.View.VendaHistoricoAdm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  RPFood.View.Padrao,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  IWTemplateProcessorHTML,
  RPFood.Entity.Classes,
  Data.DB,
  ServerController,
  System.DateUtils,
  System.Generics.Collections,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  RPFood.View.Rotas,
  IWCompLabel,
  IWControl;
type
  TFrmVendaHistoricoAdm = class(TFrmPadrao)
    IWEDTOTALPEDIDOS: TIWLabelEx;
    IWEDTOTALPEDIDOSDELIVERY: TIWLabelEx;
    IWEDTOTALPEDIDOSBALCAO: TIWLabelEx;
    IWEDTOTALPEDIDOSCANCELADOS: TIWLabelEx;
    IWEDTOTALPEDIDOSABERTOS: TIWLabelEx;
    IWEDLISTACATEGORIAISMAISVENDIDAS: TIWLabel;
    IWEDTOTALPRODUTOSCADASTRADOS: TIWLabelEx;
    IWEDTOTALCLIENTESCADASTRADOS: TIWLabelEx;
    IWEDLISTAPRODUTOSMAISVENDIDOS: TIWLabelEx;
    IWEDLISTAMEDIAVENDASQUANTIDADE: TIWLabelEx;
    IWEDLISTAMEDIAVENDASVALOR: TIWLabelEx;
    IWEDQTDEVENDASPEDIDOSFINALIZADOS: TIWLabelEx;
    IWEDQTDEDELIVERYFINALIZADOS: TIWLabelEx;
    IWEDQTDEBALCAOFINALIZADOS: TIWLabelEx;
    IWEDQTDEVENDASCANCELADAS: TIWLabelEx;
    IWEDQTDEVENDASABERTAS: TIWLabelEx;

  procedure IWAppFormCreate(Sender: TObject);
  private
    FVenda     : TRPFoodEntityVenda;
    FDataInicio: TDateTime;
    FDataFim   : TDateTime;
    procedure Lista_Total_Vendas;
    procedure carregaHTMLLista_Produtos_Mais_Vendidos;
    procedure carregaHTMLLista_Categoria_Mais_Vendidas;
    procedure CarregaWwidget;
  public
    { Public declarations }
    destructor Destroy; override;
    function Lista_Categoria_Mais_Vendidas:String;
    function Lista_Produtos_Mais_Vendidos:String;
  end;

var
  FrmVendaHistoricoAdm: TFrmVendaHistoricoAdm;
implementation
{$R *.dfm}
{ TFrmVendaHistoricoAdm }
procedure TFrmVendaHistoricoAdm.carregaHTMLLista_Categoria_Mais_Vendidas;
begin
  IWEDLISTACATEGORIAISMAISVENDIDAS.Text:=lista_Categoria_Mais_Vendidas;
end;

procedure TFrmVendaHistoricoAdm.carregaHTMLLista_Produtos_Mais_Vendidos;
begin
  IWEDLISTAPRODUTOSMAISVENDIDOS.Text:=Lista_Produtos_Mais_Vendidos;
end;

procedure TFrmVendaHistoricoAdm.CarregaWwidget;
var
  LDataSet: TDataSet;
begin
  LDataSet  :=FController.DAO.RelatorioVendas.Quantidade_Produtos(UserSession.IdEmpresa);
  try
    IWEDTOTALPRODUTOSCADASTRADOS.Text:=LDataSet.FieldByName('produtos_cadastrados').AsString;
  finally
   LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Quantidade_clientes(UserSession.IdEmpresa);
  try
     IWEDTOTALCLIENTESCADASTRADOS.Text:=LDataSet.FieldByName('clientes_cadastrados').AsString;
  finally
    LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Quantidade_Produtos(UserSession.IdEmpresa);
  try
     IWEDLISTAPRODUTOSMAISVENDIDOS.Text:=LDataSet.FieldByName('produtos_cadastrados').AsString;
  finally
    LDataSet.Free;
  end;

   LDataSet :=FController.DAO.RelatorioVendas.Media_Vendas_Diaria(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
     IWEDLISTAMEDIAVENDASQUANTIDADE.Text:=FormatFloat('###,###,##0',LDataSet.FieldByName('qtde').AsFloat);
  finally
    LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Media_Vendas_Diaria(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
     IWEDLISTAMEDIAVENDASVALOR.Text:='R$'+FormatFloat('###,###,##0.00',LDataSet.FieldByName('valor_media').AsFloat);
  finally
    LDataSet.Free;
  end;
end;

destructor TFrmVendaHistoricoAdm.Destroy;
begin
  FreeAndNil(FVenda);
  inherited;
end;
function TFrmVendaHistoricoAdm.Lista_Categoria_Mais_Vendidas: String;
var
  LDataSet: TDataSet;
  LCategorias:String;
begin
  FDataFim    := Now;
  FDataInicio := IncDay(FDataFim, -31);
  LDataSet    :=FController.DAO.RelatorioVendas.Categoriais_Mais_Vendidas(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
    LCategorias :='';
    LDataSet.First;
    while not LDataSet.Eof do
    begin
      LCategorias:=LCategorias+
      '<div class="d-flex justify-content-between mb-2">                                                                  '+
      '<span><svg class="me-2" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"> '+
      '<rect width="16" height="16" rx="4" fill="#1FBF75"/>                                                               '+
      '</svg> '+
      LDataSet.FieldByName('descricao').AsString+
      '</span>                                                                                                             '+
      '<h6>R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('total_categoria').AsFloat)+ '</h6>                      '+
      '</div>';
    LDataSet.Next;
    end;
  finally
     result:=LCategorias;
     LDataSet.Free;
  end;
end;

function TFrmVendaHistoricoAdm.Lista_Produtos_Mais_Vendidos: String;
var
  LDataSet:TDataSet;
begin
  FDataFim    := Now;
  FDataInicio := IncDay(FDataFim, -31);
  LDataSet    :=FController.DAO.RelatorioVendas.Produtos_Mais_Vendidos(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
   Result  :='';
   LDataSet.First;
    while not LDataSet.eof do
    begin
      Result := Result +
        '  <div class="d-flex justify-content-between mb-2">                                     '+
        '     <span><svg class="me-2" width="16" height="16" viewBox="0 0 16 16" fill="none"     '+
        '           xmlns="http://www.w3.org/2000/svg">                                          '+
        '           <rect width="16" height="16" rx="4" fill="var(--primary)" />                 '+
        '        </svg>                                                                          '+
         LDataSet.FieldByName('descricao').AsString                                               +
        '         </span> <h6>                                                                   '+
        'R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('total_produtos_vendidos').AsFloat)         +
        '</h6> </div>                                                                            ';
      LDataSet.Next;
    end;

  finally
    LDataSet.Free;
  end;
end;

procedure TFrmVendaHistoricoAdm.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  carregaHTMLLista_Categoria_Mais_Vendidas;
  Lista_Total_Vendas;
  CarregaWwidget;
  carregaHTMLLista_Produtos_Mais_Vendidos;
end;

procedure TFrmVendaHistoricoAdm.Lista_Total_Vendas;
var
  LDataSet: TDataSet;
begin
  FDataFim    := Now;
  FDataInicio := IncDay(FDataFim, -31);
  LDataSet    :=FController.DAO.RelatorioVendas.Total_Pedidos_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim) ;
  try
    IWEDTOTALPEDIDOS.Text:='R$'+FormatFloat('###,###,##0.00',LDataSet.FieldByName('valor_Total_Pedidos_Finalizados').AsFloat) ;
  finally
    LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Total_Delivery_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim) ;
  try
    IWEDTOTALPEDIDOSDELIVERY.Text:='R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('valor_total_delivery').AsFloat);
  finally
    LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Total_Balcao_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim) ;
  try
    IWEDTOTALPEDIDOSBALCAO.Text:='R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('valor_total_balcao').AsFloat);
  finally
    LDataSet.Free;
  end;
  LDataSet :=FController.DAO.RelatorioVendas.Total_Pedidos_Cancelados(UserSession.IdEmpresa,FDataInicio,FDataFim) ;
  try
    IWEDTOTALPEDIDOSCANCELADOS.Text:='R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('valor_pedidos_cancelados').AsFloat) ;
  finally
     LDataSet.Free;
  end;

  LDataSet :=FController.DAO.RelatorioVendas.Total_Pedidos_Abertos(UserSession.IdEmpresa,FDataInicio,FDataFim) ;
  try
   IWEDTOTALPEDIDOSABERTOS.Text:='R$'+FormatFloat('###,###,##0.00', LDataSet.FieldByName('valor_pedidos_aberto').AsFloat);
  finally
    LDataSet.Free;
  end;

  LDataSet:=FController.DAO.RelatorioVendas.Total_Pedidos_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
    IWEDQTDEVENDASPEDIDOSFINALIZADOS.Text:= LDataSet.FieldByName('qtde_vendas_Pedidos_Finalizados').AsString ;
  finally
    LDataSet.Free;
  end;

  LDataSet:=FController.DAO.RelatorioVendas.Total_Delivery_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
    IWEDQTDEDELIVERYFINALIZADOS.Text:= LDataSet.FieldByName('qtde_Delivery_Finalizados').AsString;
  finally
     LDataSet.Free;
  end;

  LDataSet:=FController.DAO.RelatorioVendas.Total_Balcao_Finalizados(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
    IWEDQTDEBALCAOFINALIZADOS.Text:= LDataSet.FieldByName('qtde_Balcao_Finalizados').AsString;
  finally
    LDataSet.Free;
  end;

  LDataSet:=FController.DAO.RelatorioVendas.Total_Pedidos_Cancelados(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
    IWEDQTDEVENDASCANCELADAS.Text:=LDataSet.FieldByName('qtde_pedidos_cancelados').AsString;
  finally
   LDataSet.Free;
  end;

  LDataSet:=FController.DAO.RelatorioVendas.Total_Pedidos_Abertos(UserSession.IdEmpresa,FDataInicio,FDataFim);
  try
   IWEDQTDEVENDASABERTAS.Text:=LDataSet.FieldByName('qtde_pedidos_abertos').AsString;
  finally
    LDataSet.Free;
  end;
end;

initialization
  TFrmVendaHistoricoAdm.SetURL('', 'venda-historico-adm');
end.
