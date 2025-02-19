object FrmEsqueciMinhaSenha: TFrmEsqueciMinhaSenha
  Left = 0
  Top = 0
  Width = 506
  Height = 418
  RenderInvisibleControls = True
  AllowPageAccess = True
  ConnectionMode = cmAny
  OnCreate = IWAppFormCreate
  Background.Fixed = False
  LayoutMgr = IWTemplate
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  DesignLeft = 3
  DesignTop = 3
  object IWEDTEMAIL: TIWEdit
    AlignWithMargins = False
    Left = 32
    Top = 88
    Width = 200
    Height = 32
    ExtraTagParams.Strings = (
      'placeholder="Email"')
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
    SubmitOnAsyncEvent = True
    DataType = stEmail
  end
  object IWTemplate: TIWTemplateProcessorHTML
    TagType = ttIntraWeb
    Left = 376
    Top = 80
  end
end
