inherited FrmProdutostodascategoria: TFrmProdutostodascategoria
  Width = 1999
  Height = 1223
  Margins.Left = 6
  Margins.Top = 6
  Margins.Right = 6
  Margins.Bottom = 6
  ExplicitWidth = 1999
  ExplicitHeight = 1223
  PixelsPerInch = 168
  DesignLeft = 2
  DesignTop = 2
  object IWBTN_VOLTAR: TIWButton [0]
    AlignWithMargins = False
    Left = 411
    Top = 58
    Width = 140
    Height = 35
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Css = 'btn btn-primary'
    Caption = 'Voltar'
    Color = clBtnFace
    FriendlyName = 'IWBTN_VOLTAR'
    OnAsyncClick = IWBTN_VOLTARAsyncClick
  end
  object IWEDT_FILTRO: TIWEdit [1]
    AlignWithMargins = False
    Left = 75
    Top = 121
    Width = 233
    Height = 38
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExtraTagParams.Strings = (
      'placeholder="O que voc'#234' quer comer hoje..."')
    Css = 'form-control p-0'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IWEDT_FILTRO'
    SubmitOnAsyncEvent = True
    OnAsyncKeyDown = IWEDT_FILTROAsyncKeyDown
  end
end
