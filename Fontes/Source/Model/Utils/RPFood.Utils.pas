unit RPFood.Utils;

interface

uses
  System.SysUtils,
  RegularExpressions,
  RTTI;

type
  TUtils = class
  private
   
  public
    function ApenasNumeros(AValue: string): string;
    function ValidarCelular(const ATelefone: string): Boolean;
    function ValidarCPF(const ACPF: string): Boolean;
    function ValidarEmail(const Email: string): Boolean;
    function RemoveCaracteres(const Value: string): string;
    function RemoveCaracteresEspeciais(const AValue: string): string;
  end;

implementation

 uses
  System.Character, ServerController;


{ TUtils }

function TUtils.ApenasNumeros(AValue: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to AValue.Length do
  begin
    if CharInSet(AValue[I], ['0' .. '9']) then
      Result := Result + AValue[I];
  end;
end;

function TUtils.RemoveCaracteres(const Value: string): string;
begin
   Result := TRegEx.Replace(Value, '[^a-zA-Z0-9-&]', '');
end;

function TUtils.RemoveCaracteresEspeciais(const AValue: string): string;
var
  i: Integer;
  c: Char;
begin
  Result := '';

   for i := 1 to Length(AValue) do
  begin
    c := AValue[i];
    if CharInSet(c, ['A'..'Z', 'a'..'z', '0'..'9', 'Ç', 'ç', 'Á', 'á', 'É', 'é', 'Í', 'í', 'Ó', 'ó', 'Ú', 'ú', 'Â', 'â', 'Ê', 'ê', 'Ô', 'ô', 'Ã', 'ã', 'Õ', 'õ', 'À', 'à', ' ', '$', '&', '-']) then
      Result := Result + c;
  end;
end;

function TUtils.ValidarCelular(const ATelefone: string): Boolean;
begin
  Result := (Length(ApenasNumeros(ATelefone)) in [10, 11])
end;

function TUtils.ValidarCPF(const ACPF: string): Boolean;
begin
  Result := (Length(ApenasNumeros(ACPF)) = 11);
end;

function TUtils.ValidarEmail(const Email: string): Boolean;
const
  EmailRegex = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
begin
  Result := TRegEx.IsMatch(Email, EmailRegex);
end;

end.

