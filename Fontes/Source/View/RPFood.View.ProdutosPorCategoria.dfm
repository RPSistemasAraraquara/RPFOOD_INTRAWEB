inherited FrmProdutosPorCategoria: TFrmProdutosPorCategoria
  Title = 'Produtos'
  PixelsPerInch = 144
  DesignLeft = 3
  DesignTop = 3
  object IWEDT_FILTRO: TIWEdit [0]
    AlignWithMargins = False
    Left = 64
    Top = 104
    Width = 200
    Height = 32
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExtraTagParams.Strings = (
      'placeholder="O que voc'#234' quer comer hoje..."')
    Css = 'form-control p-0'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IWEDT_FILTRO'
    SubmitOnAsyncEvent = True
    OnAsyncKeyDown = IWEDT_FILTROAsyncKeyDown
  end
  object IWBTN_VOLTAR: TIWButton [1]
    AlignWithMargins = False
    Left = 344
    Top = 50
    Width = 120
    Height = 30
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Css = 'btn btn-primary'
    Caption = 'Voltar'
    Color = clBtnFace
    FriendlyName = 'IWBTN_VOLTAR'
    OnAsyncClick = IWBTN_VOLTARAsyncClick
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    Left = 496
    Top = 328
  end
end
