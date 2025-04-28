unit RPFood.Components.JSON;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  GBJSON.Config,
  GBJSON.Interfaces;

type
  TRPFoodComponentsJSON = class
  public
    function FromJSONString<T: class, constructor>(AStrJson: string): T;
    function ToJSONString(AObject: TObject): string; overload;
    function ToJSONObject(AObject: TObject): TJSONObject;
    function ToJSONString<T: class, constructor>(AList: TObjectList<T>): string; overload;
  end;

implementation

{ TRPFoodComponentsJSON }

function TRPFoodComponentsJSON.FromJSONString<T>(AStrJson: string): T;
begin
  Result := TGBJSONDefault.Serializer<T>.JsonStringToObject(AStrJson);
end;

function TRPFoodComponentsJSON.ToJSONObject(AObject: TObject): TJSONObject;
begin
  Result := TGBJSONDefault.Deserializer.ObjectToJsonObject(AObject);
end;

function TRPFoodComponentsJSON.ToJSONString(AObject: TObject): string;
begin
  Result := TGBJSONDefault.Deserializer.ObjectToJsonString(AObject);
end;

function TRPFoodComponentsJSON.ToJSONString<T>(AList: TObjectList<T>): string;
var
  LJSON: TJSONArray;
begin
  LJSON := TGBJSONDefault.Deserializer<T>.ListToJSONArray(AList);
  try
    Result := LJSON.ToString;
  finally
    LJSON.Free;
  end;
end;

initialization
  TGBJSONConfig.GetInstance.IgnoreEmptyValues(False);

end.
