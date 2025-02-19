unit RPFood.Resources;

interface

uses
  GBJSON.Interfaces,
  GBJSON.Helper,
  REST.Json,
  System.Classes,
  System.JSON,
  System.SysUtils;

type
  TRPFoodResources = class
  private
    FDATABASE_PASSWORD    : string;
    FDATABASE_HOST        : string;
    FDATABASE_USERNAME    : string;
    FDATABASE_SCHEMA      : string;
    FDATABASE_PORT        : Integer;
    FDATABASE_ALIAS       : string;
    FPORT                 : Integer;
    FSERVICE_NAME         : string;
    FSERVICE_TITLE        : string;
    FSERVICE_DESCRIPTION  : string;
    FAPP_PATH             : string;

    function ResourceFile: string;
    procedure LoadConfig;
    procedure SaveConfig(AFileName: string); overload;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveConfig; overload;
    function VersaoSistema        : string;
    property APP_PATH             : string     read FAPP_PATH;
    property PORT                 : Integer    read FPORT                 write FPORT;
    property DATABASE_HOST        : string     read FDATABASE_HOST        write FDATABASE_HOST;
    property DATABASE_PORT        : Integer    read FDATABASE_PORT        write FDATABASE_PORT;
    property DATABASE_SCHEMA      : string     read FDATABASE_SCHEMA      write FDATABASE_SCHEMA;
    property DATABASE_ALIAS       : string     read FDATABASE_ALIAS       write FDATABASE_ALIAS;
    property DATABASE_USERNAME    : string     read FDATABASE_USERNAME    write FDATABASE_USERNAME;
    property DATABASE_PASSWORD    : string     read FDATABASE_PASSWORD    write FDATABASE_PASSWORD;
    property SERVICE_NAME         : string     read FSERVICE_NAME         write FSERVICE_NAME;
    property SERVICE_TITLE        : string     read FSERVICE_TITLE        write FSERVICE_TITLE;
    property SERVICE_DESCRIPTION  : string     read FSERVICE_DESCRIPTION  write FSERVICE_DESCRIPTION;
  end;

var
  APP_RESOURCES: TRPFoodResources;

implementation

{ TRPFoodResources }

constructor TRPFoodResources.Create;
begin

  FAPP_PATH            := ExtractFilePath(GetModuleName(HInstance));
  FPORT                := 8080;
  FDATABASE_PORT       := 5432;
  FDATABASE_SCHEMA     := 'public';
  FDATABASE_HOST       := '127.0.0.1';
  FDATABASE_ALIAS      := 'FOOD';
  FDATABASE_USERNAME   := 'postgres';
  FDATABASE_PASSWORD   := '123';
  FSERVICE_NAME        := 'RPFoodService';
  FSERVICE_TITLE       := 'RPFood';
  FSERVICE_DESCRIPTION := 'RPFood - Online Food Delivery';
  LoadConfig;
end;

destructor TRPFoodResources.Destroy;
begin

  inherited;
end;

procedure TRPFoodResources.LoadConfig;
var
  LJSON: TJSONObject;
  LArquivo: TStringList;
begin
  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(ResourceFile);
    LJSON := TGBJSONDefault.Deserializer.StringToJsonObject(LArquivo.Text);
    try
      if Assigned(LJSON) then
        TGBJSONDefault.Serializer.JsonObjectToObject(Self, LJSON);
    finally
      LJSON.Free;
    end;
  finally
    LArquivo.Free;
  end;
end;

function TRPFoodResources.ResourceFile: string;
begin
  Result := ExtractFilePath(GetModuleName(HInstance))+ 'RPFood.json';
  if not FileExists(Result) then
    SaveConfig(Result);
end;

procedure TRPFoodResources.SaveConfig;
begin
  SaveConfig(ResourceFile);
end;

function TRPFoodResources.VersaoSistema: string;
begin
  Result := 'v 6.0.0';
end;

procedure TRPFoodResources.SaveConfig(AFileName: string);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.fromObject(Self);
  try
    LJSON.SaveToFile(AFileName);
  finally
    LJSON.Free;
  end;
end;

initialization
  APP_RESOURCES := TRPFoodResources.Create;

finalization
  APP_RESOURCES.Free;

end.
