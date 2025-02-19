object DMConexao: TDMConexao
  OldCreateOrder = False
  Height = 298
  Width = 378
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=rpfood'
      'User_Name=postgres'
      'Password=postgres'
      'Server=127.0.0.1'
      'DriverID=PG')
    LoginPrompt = False
    Left = 176
    Top = 136
  end
  object FDQuery: TFDQuery
    Connection = FDConn
    Left = 176
    Top = 200
  end
end
