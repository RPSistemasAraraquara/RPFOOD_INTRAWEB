inherited FrmPedidoDetalheItem: TFrmPedidoDetalheItem
  Width = 783
  Height = 479
  Margins.Left = 2
  Margins.Top = 2
  Margins.Right = 2
  Margins.Bottom = 2
  Title = 'Detalhes do Item do Pedido'
  ExplicitWidth = 783
  ExplicitHeight = 479
  PixelsPerInch = 144
  DesignLeft = 2
  DesignTop = 2
  object IWIMAGEM_PRODUTO: TIWImage [0]
    AlignWithMargins = False
    Left = 19
    Top = 26
    Width = 96
    Height = 104
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Css = 'img-fluid rounded'
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    StyleRenderOptions.RenderPadding = False
    StyleRenderOptions.RenderBorder = False
    BorderOptions.Width = 0
    UseSize = False
    FriendlyName = 'IWIMAGEM_PRODUTO'
    TransparentColor = clNone
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestQuality
    JpegOptions.ProgressiveEncoding = True
    JpegOptions.Smoothing = True
  end
  object IWEDTOBSERVACAO: TIWEdit [1]
    AlignWithMargins = False
    Left = 149
    Top = 121
    Width = 82
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder=Olha s'#243': sem cebola ...')
    Css = 'form-control input-btn'
    StyleRenderOptions.RenderBorder = False
    LockOnAsyncEvents = [aeClick, aeExit]
    FriendlyName = 'IWEDTOBSERVACAO'
    MaxLength = 100
    SubmitOnAsyncEvent = True
  end
  object IWEDT_FRACAO_PRINCIPAL_QUANTIDADE: TIWEdit [2]
    AlignWithMargins = False
    Left = 198
    Top = 166
    Width = 58
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'data-value disabled')
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    StyleRenderOptions.RenderPadding = False
    StyleRenderOptions.RenderBorder = False
    LockOnAsyncEvents = [aeClick, aeChange]
    Editable = False
    NonEditableAsLabel = True
    FriendlyName = 'IWEDT_FRACAO_PRINCIPAL_QUANTIDADE'
    SubmitOnAsyncEvent = True
    OnAsyncClick = IWEDT_FRACAO_PRINCIPAL_QUANTIDADEAsyncClick
    DataType = stNumber
  end
  object IWEDT_QUANTIDADE_ITEM: TIWEdit [3]
    AlignWithMargins = False
    Left = 149
    Top = 91
    Width = 57
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Css = 'form-control input-btn input-number'
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    StyleRenderOptions.RenderPadding = False
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IWEDT_QUANTIDADE_ITEM'
    SubmitOnAsyncEvent = True
    OnAsyncChange = IWEDT_QUANTIDADE_ITEMAsyncChange
    DataType = stNumber
  end
  object IWIMAGEM_TESTE: TIWEdit [4]
    AlignWithMargins = False
    Left = 128
    Top = 167
    Width = 58
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Css = 'form-control input-btn input-number'
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    StyleRenderOptions.RenderPadding = False
    StyleRenderOptions.RenderBorder = False
    LockOnAsyncEvents = [aeChange]
    FriendlyName = 'IWIMAGEM_TESTE'
    SubmitOnAsyncEvent = True
    DataType = stNumber
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    MasterFormTag = True
    Left = 272
    Top = 32
  end
end
