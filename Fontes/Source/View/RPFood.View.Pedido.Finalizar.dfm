inherited FrmPedidoFinalizar: TFrmPedidoFinalizar
  Width = 1034
  Height = 960
  Margins.Left = 6
  Margins.Top = 6
  Margins.Right = 6
  Margins.Bottom = 6
  Title = 'Finalizar Pedido'
  OnShow = IWAppFormShow
  ExplicitWidth = 1034
  ExplicitHeight = 960
  PixelsPerInch = 168
  DesignLeft = 2
  DesignTop = 2
  object IWEDT_VALOR_PAGO: TIWEdit [0]
    AlignWithMargins = False
    Left = 37
    Top = 330
    Width = 300
    Height = 38
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExtraTagParams.Strings = (
      'placeholder="R$ 0.00" required=""')
    Css = 'form-control'
    ParentShowHint = True
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
    LockOnAsyncEvents = [aeClick]
    FriendlyName = 'IWEDT_VALOR_PAGO'
    SubmitOnAsyncEvent = True
    DataType = stNumber
    DataTypeOptions.Max = '99999'
    DataTypeOptions.Min = '0'
    DataTypeOptions.NumberType = ntCurrency
    DataTypeOptions.NumberValidation = nvIntraWeb
  end
  object IWBTN_CONFIRMAR_TROCO: TIWButton [1]
    AlignWithMargins = False
    Left = 37
    Top = 386
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
    OnAsyncClick = IWBTN_CONFIRMAR_TROCOAsyncClick
  end
  object IWBTN_CANCELAR_TROCO: TIWButton [2]
    AlignWithMargins = False
    Left = 197
    Top = 386
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
    FriendlyName = 'IWBTN_CANCELAR_TROCO'
    OnAsyncClick = IWBTN_CANCELAR_TROCOAsyncClick
  end
  object IWEDTCEP: TIWEdit [3]
    AlignWithMargins = False
    Left = 37
    Top = 50
    Width = 234
    Height = 38
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
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
    FriendlyName = 'IWEDTCEP'
    ScriptEvents = <
      item
        EventCode.Strings = (
          'if(this.value.length == 8) {'
          '  ajaxCall('#39'BuscarCep'#39', '#39#39');'
          '}')
        Event = 'onChange'
      end>
    SubmitOnAsyncEvent = True
  end
  object IWEDTENDERECO: TIWEdit [4]
    AlignWithMargins = False
    Left = 336
    Top = 50
    Width = 233
    Height = 38
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
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
  object IWEDTNUMERO: TIWEdit [5]
    AlignWithMargins = False
    Left = 37
    Top = 116
    Width = 234
    Height = 37
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
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
    SubmitOnAsyncEvent = True
  end
  object IWEDTCOMPLEMENTO: TIWEdit [6]
    AlignWithMargins = False
    Left = 336
    Top = 116
    Width = 233
    Height = 37
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
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
    SubmitOnAsyncEvent = True
  end
  object IWEDTBAIRRO: TIWEdit [7]
    AlignWithMargins = False
    Left = 336
    Top = 181
    Width = 233
    Height = 37
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExtraTagParams.Strings = (
      'placeholder="Bairro" required')
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
    ReadOnly = True
    SubmitOnAsyncEvent = True
  end
  object IWEDTREFERENCIA: TIWEdit [8]
    AlignWithMargins = False
    Left = 37
    Top = 181
    Width = 234
    Height = 37
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
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
    SubmitOnAsyncEvent = True
  end
  object IWOBSERVACAO: TIWMemo [9]
    AlignWithMargins = False
    Left = 373
    Top = 302
    Width = 196
    Height = 141
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExtraTagParams.Strings = (
      'rows="4" placeholder="Outras informa'#231#245'es..."')
    Css = 'form-control h-auto'
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
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'IWOBSERVACAO'
    OnAsyncChange = IWOBSERVACAOAsyncChange
  end
  object IWEDTSELECIONAENDERECOS: TIWButton [10]
    AlignWithMargins = False
    Left = 47
    Top = 450
    Width = 412
    Height = 35
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Css = 'btn btn-danger btn-block'
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
    Caption = 'Selecione outros endere'#231'os'
    Color = clBtnFace
    FriendlyName = 'IWEDTSELECIONAENDERECOS'
    OnAsyncClick = IWEDTSELECIONAENDERECOSAsyncClick
  end
  object IWLBLRETIRADA: TIWLabel [11]
    AlignWithMargins = False
    Left = 597
    Top = 560
    Width = 0
    Height = 0
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    HasTabOrder = False
    FriendlyName = 'IWLBLRETIRADA'
    RawText = True
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    Left = 696
    Top = 16
  end
end
