inherited FrmIndex: TFrmIndex
  Width = 715
  Height = 415
  Margins.Left = 6
  Margins.Top = 6
  Margins.Right = 6
  Margins.Bottom = 6
  Title = 'Pedido'
  OnDestroy = IWAppFormDestroy
  ExplicitWidth = 715
  ExplicitHeight = 415
  PixelsPerInch = 168
  DesignLeft = 2
  DesignTop = 2
  object IWEDT_FILTRO: TIWEdit [0]
    AlignWithMargins = False
    Left = 119
    Top = 91
    Width = 233
    Height = 37
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Visible = False
    ExtraTagParams.Strings = (
      'placeholder="O que voc'#234' quer comer hoje..."')
    Css = 'form-control p-0'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IWEDT_FILTRO'
    SubmitOnAsyncEvent = True
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    Left = 504
    Top = 200
  end
end
