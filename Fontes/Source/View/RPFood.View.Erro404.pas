unit RPFood.View.Erro404;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IWTemplateProcessorHTML,
  Vcl.Controls, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWHTMLControls;

type
  TFrmErro404 = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
  public
  end;

implementation

{$R *.dfm}

initialization
  TFrmErro404.SetURL('', 'erro-404.html');


end.
