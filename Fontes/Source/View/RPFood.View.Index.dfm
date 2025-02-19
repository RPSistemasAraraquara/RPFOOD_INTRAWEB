inherited FrmIndex: TFrmIndex
  Title = 'Pedido'
  OnDestroy = IWAppFormDestroy
  PixelsPerInch = 144
  DesignLeft = 2
  DesignTop = 2
  object IWEDT_FILTRO: TIWEdit [0]
    AlignWithMargins = False
    Left = 424
    Top = 352
    Width = 200
    Height = 32
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
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
