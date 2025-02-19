inherited FrmClienteEndereco: TFrmClienteEndereco
  Width = 783
  Height = 479
  Margins.Left = 2
  Margins.Top = 2
  Margins.Right = 2
  Margins.Bottom = 2
  Title = 'Meus Endere'#231'os'
  OnDestroy = IWAppFormDestroy
  ExplicitWidth = 783
  ExplicitHeight = 479
  PixelsPerInch = 144
  DesignLeft = 2
  DesignTop = 2
  object IWEDTENDERECO: TIWEdit [0]
    AlignWithMargins = False
    Left = 29
    Top = 159
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
    SubmitOnAsyncEvent = True
  end
  object IWEDTNUMERO: TIWEdit [1]
    AlignWithMargins = False
    Left = 210
    Top = 159
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
  object IWEDTCOMPLEMENTO: TIWEdit [2]
    AlignWithMargins = False
    Left = 29
    Top = 204
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="Complemento"')
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
    FriendlyName = 'IWEDTCOMPLEMENTO'
    MaxLength = 80
    SubmitOnAsyncEvent = True
  end
  object IWEDTREFERENCIA: TIWEdit [3]
    AlignWithMargins = False
    Left = 210
    Top = 204
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="Ponto de Refer'#234'ncia"')
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
    FriendlyName = 'IWEDTREFERENCIA'
    MaxLength = 80
    SubmitOnAsyncEvent = True
  end
  object IWLBLBAIRROLISTA: TIWLabel [4]
    AlignWithMargins = False
    Left = 215
    Top = 241
    Width = 63
    Height = 28
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
    FriendlyName = 'IWLBLBAIRROLISTA'
    Caption = 'Bairro'
  end
  object IWLBLTAXA: TIWLabel [5]
    AlignWithMargins = False
    Left = 39
    Top = 303
    Width = 139
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    HasTabOrder = False
    FriendlyName = 'IWLBLTAXA'
    Caption = 'Taxa Motoboy'
  end
  object IWEDTTAXA: TIWEdit [6]
    AlignWithMargins = False
    Left = 29
    Top = 337
    Width = 200
    Height = 32
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
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
  object IWEDTBAIRROLISTA: TIWComboBox [7]
    AlignWithMargins = True
    Left = 215
    Top = 276
    Width = 121
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Visible = False
    Css = 'btn btn-danger dropdown-toggle dropdown-toggle-split'
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
    OnAsyncChange = IWEDTBAIRROLISTAAsyncChange
    ItemIndex = -1
    FriendlyName = 'IWEDTBAIRROLISTA'
    NoSelectionText = '-- No Selection --'
  end
  object IWBTNOVOENDERECO: TIWButton [8]
    AlignWithMargins = False
    Left = 29
    Top = 411
    Width = 120
    Height = 30
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Css = 'btn btn-primary'
    Caption = 'NOVO'
    Color = clBtnFace
    FriendlyName = 'IWBTNOVOENDERECO'
    OnAsyncClick = IWBTNOVOENDERECOAsyncClick
  end
  object IWLBLENDERECO: TIWLabelEx [9]
    AlignWithMargins = False
    Left = 29
    Top = 130
    Width = 107
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    HasTabOrder = False
    FriendlyName = 'IWLBLENDERECO'
    Caption = 'ENDERE'#199'O'
  end
  object IWLBLPADRAO: TIWLabelEx [10]
    AlignWithMargins = False
    Left = 309
    Top = 337
    Width = 85
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    HasTabOrder = False
    FriendlyName = 'IWLBLPADRAO'
    Caption = 'PADR'#195'O'
  end
  object IWLBLNUMERO: TIWLabelEx [11]
    AlignWithMargins = False
    Left = 214
    Top = 130
    Width = 92
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    HasTabOrder = False
    FriendlyName = 'IWLBLNUMERO'
    Caption = 'N'#218'MERO'
  end
  object IWLBLCEP: TIWLabelEx [12]
    AlignWithMargins = False
    Left = 29
    Top = 11
    Width = 36
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Css = 'label class="mb-1"'
    HasTabOrder = False
    FriendlyName = 'IWLBLCEP'
    Caption = 'CEP'
  end
  object IWEDTBAIRRO: TIWEdit [13]
    AlignWithMargins = False
    Left = 29
    Top = 269
    Width = 160
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ExtraTagParams.Strings = (
      'placeholder="Complemento"')
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
  object IWLBLBAIRRO: TIWLabel [14]
    AlignWithMargins = False
    Left = 45
    Top = 237
    Width = 63
    Height = 28
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
  object IWEDTCEP: TIWEdit [15]
    AlignWithMargins = False
    Left = 29
    Top = 49
    Width = 200
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExtraTagParams.Strings = (
      'placeholder="CEP" required')
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
    LockOnAsyncEvents = [aeClick, aeChange]
    FriendlyName = 'IWEDTCEP'
    MaxLength = 8
    SubmitOnAsyncEvent = True
    OnAsyncChange = IWEDTCEPAsyncChange
    DataTypeOptions.Max = '12'
    DataTypeOptions.NumberType = ntText
    DataTypeOptions.NumberValidation = nvIntraWeb
    DelayKeyEvents = True
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    MasterFormTag = True
    RenderStyles = True
    Top = 281
  end
end
