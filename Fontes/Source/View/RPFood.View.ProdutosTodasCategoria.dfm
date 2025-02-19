inherited FrmProdutostodascategoria: TFrmProdutostodascategoria
  PixelsPerInch = 144
  DesignLeft = 2
  DesignTop = 2
  object IWBTN_VOLTAR: TIWButton [0]
    AlignWithMargins = False
    Left = 352
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
  object IWEDT_FILTRO: TIWEdit [1]
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
end
