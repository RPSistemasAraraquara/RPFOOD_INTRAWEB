inherited FrmClienteMeusDados: TFrmClienteMeusDados
  Title = 'Meus Dados'
  DesignLeft = 2
  DesignTop = 2
  object IWEDTNOME: TIWEdit [0]
    AlignWithMargins = False
    Left = 32
    Top = 56
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Nome" required')
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
    FriendlyName = 'IWEDTNOME'
    MaxLength = 90
    SubmitOnAsyncEvent = True
  end
  object IWEDTEMAIL: TIWEdit [1]
    AlignWithMargins = False
    Left = 32
    Top = 112
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Email" required')
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
    FriendlyName = 'IWEDTEMAIL'
    ReadOnly = True
    ScriptEvents = <
      item
        EventCode.Strings = (
          'return this.value = this.value.toLowerCase();')
        Event = 'onKeyUp'
      end>
    SubmitOnAsyncEvent = True
    DataType = stEmail
  end
  object IWEDTSENHA: TIWEdit [2]
    AlignWithMargins = False
    Left = 288
    Top = 112
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Senha" required')
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
    FriendlyName = 'IWEDTSENHA'
    MaxLength = 30
    Required = True
    SubmitOnAsyncEvent = True
    DataType = stPassword
  end
  object IWEDTCELULAR: TIWEdit [3]
    AlignWithMargins = False
    Left = 32
    Top = 168
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Celular"')
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
    FriendlyName = 'IWEDTCELULAR'
    MaxLength = 20
    Required = True
    SubmitOnAsyncEvent = True
    DataType = stTel
  end
  object IWEDTTELEFONE: TIWEdit [4]
    AlignWithMargins = False
    Left = 288
    Top = 168
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Telefone"')
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
    FriendlyName = 'IWEDTTELEFONE'
    MaxLength = 20
    SubmitOnAsyncEvent = True
  end
  inherited IWTemplate: TIWTemplateProcessorHTML
    Left = 504
    Top = 208
  end
end
