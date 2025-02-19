inherited FrmBuscarEndereco: TFrmBuscarEndereco
  OnDestroy = IWAppFormDestroy
  DesignLeft = 2
  DesignTop = 2
  object IWEDTENDERECO: TIWEdit [0]
    AlignWithMargins = False
    Left = 69
    Top = 127
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="Endere'#231'o" required')
    Css = 'form-control'
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
    FriendlyName = 'IWEDTENDERECO'
    ReadOnly = True
    SubmitOnAsyncEvent = True
  end
  object IWLBLENDERECO: TIWLabelEx [1]
    AlignWithMargins = False
    Left = 69
    Top = 90
    Width = 72
    Height = 17
    HasTabOrder = False
    FriendlyName = 'IWLBLENDERECO'
    Caption = 'ENDERE'#199'O'
  end
  object IWEDTNUMERO: TIWEdit [2]
    AlignWithMargins = False
    Left = 288
    Top = 127
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="N'#250'mero" required')
    Css = 'form-control'
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
    FriendlyName = 'IWEDTNUMERO'
    MaxLength = 80
    SubmitOnAsyncEvent = True
  end
  object IWLBLNUMERO: TIWLabelEx [3]
    AlignWithMargins = False
    Left = 292
    Top = 98
    Width = 61
    Height = 17
    HasTabOrder = False
    FriendlyName = 'IWLBLNUMERO'
    Caption = 'N'#218'MERO'
  end
  object IWEDTBAIRRO: TIWEdit [4]
    AlignWithMargins = False
    Left = 69
    Top = 203
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="Bairro"')
    Css = 'form-control'
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
    FriendlyName = 'IWEDTBAIRRO'
    MaxLength = 80
    SubmitOnAsyncEvent = True
    Enabled = False
  end
  object IWLBLBAIRRO: TIWLabel [5]
    AlignWithMargins = False
    Left = 85
    Top = 171
    Width = 40
    Height = 17
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Css = 'label class="mb-1"'
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    StyleRenderOptions.RenderPadding = False
    StyleRenderOptions.RenderBorder = False
    Font.Color = clNone
    Font.Size = 10
    Font.Style = [fsBold]
    Font.PxSize = 13
    HasTabOrder = False
    FriendlyName = 'IWLBLBAIRRO'
    Caption = 'Bairro'
  end
  object IWEDTTAXA: TIWEdit [6]
    AlignWithMargins = False
    Left = 288
    Top = 208
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Taxa"')
    Css = 'form-control'
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
    FriendlyName = 'IWEDTTAXA'
    SubmitOnAsyncEvent = True
    Enabled = False
    DataType = stNumber
    DataTypeOptions.FloatDP = 2
  end
  object IWLBLTAXA: TIWLabel [7]
    AlignWithMargins = False
    Left = 290
    Top = 174
    Width = 93
    Height = 17
    HasTabOrder = False
    FriendlyName = 'IWLBLTAXA'
    Caption = 'Taxa Motoboy'
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    Left = 632
    Top = 120
  end
end
