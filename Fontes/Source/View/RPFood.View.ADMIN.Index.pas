unit RPFood.View.ADMIN.Index;

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
  ServerController,
  System.DateUtils,
  System.Generics.Collections,
  Vcl.Dialogs,
  RPFood.View.ADMIN.Padrao,
  IWVCLComponent,
  IWBaseLayoutComponent,
  IWBaseContainerLayout,
  IWContainerLayout,
  Data.DB,
  IWTemplateProcessorHTML,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompLabel;
type
  TFrmADMINIndex = class(TFrmADMINPadrao)
    IWEDTTOP10BAIRROS: TIWLabelEx;
    IWEDTTOP10CLIENTES: TIWLabelEx;
    IWEDTTOP10PRODUCT: TIWLabelEx;
    IWEDTULTIMASINCRONIZACAO: TIWLabelEx;
    IWEDTQTDE_VENDAS: TIWLabelEx;
    IWEDTVALOR_VENDAS: TIWLabelEx;
    IWEDTVALOR_TAXAENTREGA: TIWLabelEx;
    procedure IWAppFormCreate(Sender: TObject);
  private
    FDataInicio: TDateTime;
    FDataFim   : TDateTime;
    procedure top_10_bairros;
    procedure top_10_Clientes;
    procedure top_10_Product;
    procedure ultima_sincronizacao;
    procedure Qtde_Vendas_Dia;
  public
   function Carrega_html_top_10_bairros      :string;
   function Carrega_Html_top_10_Clientes     :string;
   function Carrega_Html_Top_10_Product      :string;
   function Carrega_Html_ultima_sincronizacao:string;
   function Carrega_Html_Qtde_Vendas_Dia     :string;
  end;

var
  FrmADMINIndex: TFrmADMINIndex;

implementation

{$R *.dfm}

{ TFrmADMINIndex }

function TFrmADMINIndex.Carrega_Html_Qtde_Vendas_Dia: string;
var
  LDataSet :TDataSet;
begin
   FDataInicio:=Now;
   FDataFim   :=Now;
   LDataSet   :=FController.DAO.RelatorioVendas.total_Venda_Com_QTDE_Valor(UserSession.IdEmpresa,FDataInicio,FDataFim);
   try
    Result:= LDataSet.FieldByName('quantidade_vendas').AsString;
    IWEDTVALOR_VENDAS.Text     :=FormatFloat('###,###,##0.00',LDataSet.FieldByName('valor_total_vendas').AsFloat);
    IWEDTVALOR_TAXAENTREGA.Text:=FormatFloat('###,###,##0.00',LDataSet.FieldByName('taxa_entrega').AsFloat);
   finally
    Result:=result;
    LDataSet.Free;
   end;
end;

function TFrmADMINIndex.Carrega_html_top_10_bairros: string;
var
  LDataSet:TDataSet;
begin
  LDataSet    :=FController.DAO.RelatorioVendas.Bairros_Mais_Vendidos(UserSession.IdEmpresa,10);
  LDataSet.First;
  Result:='';
  try
    while not LDataSet.eof do
    begin
       Result:=result+'<li class="list-group-item d-flex justify-content-between"><span class="mb-0">'
       +LDataSet.FieldByName('descricao').AsString +
       '</span><strong>R$'+FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_bairro').AsFloat)+
       '</strong></li>';
      LDataSet.Next;  
    end;

  finally
    result:=Result;
    LDataSet.Free;
  end;
end;

function TFrmADMINIndex.Carrega_Html_top_10_Clientes: string;
var 
LDataSet:TDataSet;
begin
  LDataSet :=FController.DAO.RelatorioVendas.Melhores_Clientes(UserSession.IdEmpresa,10);
  Result   :='';
  LDataSet.First;
  try         
    while not LDataSet.eof do
    begin
      Result:=Result+
      '<li class="list-group-item d-flex justify-content-between"><span class="mb-0">'+
      LDataSet.FieldByName('cli_002').asstring                                        +
      '</span><strong>                                                          '+
      LDataSet.FieldByName('quantidade_compra_por_cliente').AsString                  +    
      ' Compras</strong></li>';
      LDataSet.Next;
    end;             
  finally
    Result:=Result;
    LDataSet.Free;   
  end;                 
end;

function TFrmADMINIndex.Carrega_Html_Top_10_Product: string;
var
  LDataSet:TDataSet;
  LProdut :string;
begin
  LDataSet:=FController.DAO.RelatorioVendas.Produtos_Mais_Vendidos_Filtro_Limit(UserSession.IdEmpresa,10);
  Result:='';
  LProdut:='';
  LDataSet.First;
  try
    while not LDataSet.Eof do
    begin
      if LDataSet.RecNo=1 then
      begin
       LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-primary" style="width: 99%"></div>                        '+
       '</div>                                                                                '+
       '</div> <br><br>                                                                       ';

      end
      else if LDataSet.RecNo=2 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-info" style="width: 90%"></div>                           '+
       '</div>                                                                                '+
       '</div> <br><br>                                                                       ';
      end

      else if LDataSet.RecNo=3 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-roxo-light" style="width: 86%"></div>                     '+
       '</div>                                                                                '+
       '</div> <br><br>                                                                       ';
      end

      else if LDataSet.RecNo=4 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-success" style="width: 83%"></div>                        '+
       '</div>                                                                                '+
       '</div>  <br><br>                                                                      ';
      end

      else if LDataSet.RecNo=5 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-warning" style="width: 78%"></div>                        '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else if LDataSet.RecNo=5 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-gradient" style="width: 70%"></div>                       '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else if LDataSet.RecNo=6 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-verde" style="width: 64%"></div>                          '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else if LDataSet.RecNo=7 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-danger" style="width: 58%"></div>                         '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else if LDataSet.RecNo=8 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-write" style="width: 50%"></div>                          '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else if LDataSet.RecNo=9 then
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-warning" style="width: 45%"></div>                        '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end

      else
      begin
        LProdut:=LProdut+
       '<div class="col-12">                                                                  '+
       ' <div class="d-flex justify-content-between">                                         '+
       ' <h6>                                                                                 '+
       LDataSet.FieldByName('descricao').asstring                                              +
       '</h6>                                                                                 '+

       '<span>Qtde:                                                                           '+
       LDataSet.FieldByName('quantidade_vendida').asstring                                     +
       '</span>                                                                               '+
        '<span>R$                                                                             '+
       FormatFloat('###,###,##0.00',LDataSet.FieldByName('total_produtos_vendidos').AsFloat)   +
       '</span>                                                                               '+
       '</div>                                                                                '+
       '<div class="progress">                                                                '+
       '<div class="progress-bar bg-azul-light" style="width: 38%"></div>                     '+
       '</div>                                                                                '+
       '</div>    <br><br>                                                                    ';
      end ;
      LDataSet.next;
    end;

  finally
    Result:=LProdut;
    LDataSet.Free;
  end;
end;

function TFrmADMINIndex.Carrega_Html_ultima_sincronizacao: string;
var
  LDataSet: TDataSet;
begin
  LDataSet:=FController.DAO.RelatorioVendas.ultima_sincronizacao(UserSession.IdEmpresa);
  try
    Result:=FormatDateTime('dd/mm/yyyy hh:nn:ss', LDataSet.FieldByName('data').AsDateTime);
  finally
    Result:=Result;
    LDataSet.Free;
  end;
end;

procedure TFrmADMINIndex.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  top_10_bairros;
  top_10_Clientes;
  top_10_Product;
  ultima_sincronizacao;
  Qtde_Vendas_Dia;
end;

procedure TFrmADMINIndex.Qtde_Vendas_Dia;
begin
  IWEDTQTDE_VENDAS.Text:=Carrega_Html_Qtde_Vendas_Dia;
end;

procedure TFrmADMINIndex.top_10_bairros;
begin
  IWEDTTOP10BAIRROS.Text:=Carrega_html_top_10_bairros;
end;

procedure TFrmADMINIndex.top_10_Clientes;
begin
   IWEDTTOP10CLIENTES.Text:=Carrega_Html_top_10_Clientes;
end;

procedure TFrmADMINIndex.top_10_Product;
begin
  IWEDTTOP10PRODUCT.Text:=Carrega_Html_Top_10_Product;
end;

procedure TFrmADMINIndex.ultima_sincronizacao;
begin
  IWEDTULTIMASINCRONIZACAO.Text:=Carrega_Html_ultima_sincronizacao;
end;

initialization
  TFrmADMINIndex.SetURL('', 'admin/index.html');

end.
