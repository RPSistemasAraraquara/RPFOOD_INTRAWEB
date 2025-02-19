unit RPFood.DAO.Base;

interface

uses
  ADRConn.DAO.Base,
  RPFood.Entity.Classes,
  RPFood.DAO.Conexao,
  Data.DB,
  System.Generics.Collections,
  System.SysUtils;

type
  TRPFoodDAOBase<T: class, constructor> = class(TADRConnDAOBase)
  private
    FFactory: TObject;
  protected
    FIdEmpresa                                                      : Integer;
    function Query                                                  : IADRQuery;
    function FactoryDAO                                             : TObject;
    function DataSetToList(ADataSet: TDataSet)                      : TObjectList<T>;
    function DataSetToEntity(ADataSet: TDataSet)                    : T; virtual; abstract;
    function ProximoId(AIdEmpresa: Integer; ATabela, ACampo: string): Integer;
  public
    constructor Create(AConexao: IADRConnection);
    destructor Destroy; override;
    procedure ManagerTransaction(AValue: Boolean);
    function IdEmpresa(AValue:Integer):TRPFoodDAOBase<T>;
  end;

implementation

uses
  RPFood.DAO.Factory;

{ TRPFoodDAOBase<T> }

constructor TRPFoodDAOBase<T>.Create(AConexao: IADRConnection);
begin
  inherited;
  FIdEmpresa:=1;
end;

function TRPFoodDAOBase<T>.DataSetToList(ADataSet: TDataSet): TObjectList<T>;
begin
  Result := TObjectList<T>.Create;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      Result.Add(DataSetToEntity(ADataSet));
      ADataSet.Next;
    end;
  except
    Result.Free;
    raise;
  end;
end;

destructor TRPFoodDAOBase<T>.Destroy;
begin
  FFactory.Free;
  inherited;
end;

function TRPFoodDAOBase<T>.FactoryDAO: TObject;
begin
  if not Assigned(FFactory) then
    FFactory := TRPFoodDAOFactory.Create(FConnection);
  Result := FFactory;
end;

function TRPFoodDAOBase<T>.IdEmpresa(AValue: Integer): TRPFoodDAOBase<T>;
begin
  Result    :=self;
  FIdEmpresa:=AValue;
end;

procedure TRPFoodDAOBase<T>.ManagerTransaction(AValue: Boolean);
begin
  inherited ManagerTransaction(AValue);
end;

function TRPFoodDAOBase<T>.ProximoId(AIdEmpresa: Integer; ATabela, ACampo: string): Integer;
begin
  Query.SQL('select (coalesce(max(%s),0) + 1) as proximoId ', [ACampo])
    .SQL('from %s where id_empresa = :idEmpresa', [ATabela])
    .ParamAsInteger('idEmpresa', AIdEmpresa)
    .Open;

  Result := Query.DataSet.FieldByName('proximoId').AsInteger;
end;

function TRPFoodDAOBase<T>.Query: IADRQuery;
begin
  Result := FQuery;
end;

end.
