inherited FrmPedidoPagamentoOnline: TFrmPedidoPagamentoOnline
  Width = 1576
  OnShow = IWAppFormShow
  ExplicitWidth = 1576
  PixelsPerInch = 168
  DesignLeft = 4
  DesignTop = 4
  object IWBTN_CONFIRMAR_TROCO: TIWButton [0]
    AlignWithMargins = False
    Left = 504
    Top = 834
    Width = 140
    Height = 35
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Css = 'btn btn-primary btn-sm'
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
    Caption = 'Confirmar'
    Color = clBtnFace
    FriendlyName = 'IWBTN_CONFIRMAR_TROCO'
  end
  object IWBTN_CANCELAR: TIWButton [1]
    AlignWithMargins = False
    Left = 757
    Top = 834
    Width = 140
    Height = 35
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExtraTagParams.Strings = (
      'data-bs-dismiss="modal"')
    Css = 'btn btn-danger light btn-sm'
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
    Caption = 'N'#227'o quero troco'
    Color = clBtnFace
    FriendlyName = 'IWBTN_CANCELAR'
  end
  object IWCODIGOQRCODE: TIWEdit [2]
    AlignWithMargins = False
    Left = 448
    Top = 767
    Width = 350
    Height = 56
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    Editable = False
    FriendlyName = 'IWCODIGOQRCODE'
    SubmitOnAsyncEvent = True
  end
  object IWQRCODEURL: TIWEdit [3]
    AlignWithMargins = False
    Left = 854
    Top = 767
    Width = 350
    Height = 56
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    Editable = False
    FriendlyName = 'IWQRCODEURL'
    SubmitOnAsyncEvent = True
  end
  object IWQRCODE: TIWImage [4]
    AlignWithMargins = False
    Left = 504
    Top = 378
    Width = 659
    Height = 365
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    BorderOptions.Width = 0
    UseSize = False
    FriendlyName = 'IWQRCODE'
    TransparentColor = clNone
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
end
