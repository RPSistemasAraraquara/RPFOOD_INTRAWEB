unit RPFood.Components;

interface

uses
  RPFood.Components.JSON,
  ACBrMail;

type
  TRPFoodComponents = class
  private
    FJSON: TRPFoodComponentsJSON;
    FACBrMail: TACBrMail;
  public
    destructor Destroy; override;

    function JSON: TRPFoodComponentsJSON;
    function Mail: TACBrMail;
  end;

implementation

{ TRPFoodComponents }

function TRPFoodComponents.Mail: TACBrMail;
begin
  if not Assigned(FACBrMail) then
  begin
    FACBrMail := TACBrMail.Create(nil);
    FACBrMail.From     := 'naoresponder@rpfood.com.br';
    FACBrMail.FromName := 'NoReply - RPSistema';
    FACBrMail.Host     := 'mail.rpfood.com.br';
    FACBrMail.Username := 'naoresponder@rpfood.com.br';
    FACBrMail.Password := ']Aq?etCkoRb;';
    FACBrMail.Port     := '465';
    FACBrMail.IsHTML   := False;
    FACBrMail.SetTLS   := True;
    FACBrMail.SetSSL   := True;
  end;
  Result := FACBrMail;
end;

destructor TRPFoodComponents.Destroy;
begin
  FJSON.Free;
  FACBrMail.Free;
  inherited;
end;

function TRPFoodComponents.JSON: TRPFoodComponentsJSON;
begin
  if not Assigned(FJSON) then
    FJSON := TRPFoodComponentsJSON.Create;
  Result := FJSON;
end;

end.
