unit RPFood.View.Erro500;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IWTemplateProcessorHTML;

type
  TIWException = class(TIWAppForm)
    IWTemplate: TIWTemplateProcessorHTML;
  public
  end;

implementation

{$R *.dfm}

initialization
  TIWException.SetURL('', 'erro-500.html');


end.
