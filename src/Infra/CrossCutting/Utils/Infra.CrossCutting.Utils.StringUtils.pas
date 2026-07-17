unit Infra.CrossCutting.Utils.StringUtils;

interface

type
  TStringUtilsHelper = class
  public
    class function SoNumeros(const ATexto: string): string;
    class function SoLetras(const ATexto: string): string;
    class function EstaVazio(const ATexto: string): Boolean;
  end;

implementation

uses
  System.SysUtils, System.Character;

class function TStringUtilsHelper.SoNumeros(const ATexto: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATexto) do
    if ATexto[I].IsDigit then
      Result := Result + ATexto[I];
end;

class function TStringUtilsHelper.SoLetras(const ATexto: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATexto) do
    if ATexto[I].IsLetter then
      Result := Result + ATexto[I];
end;

class function TStringUtilsHelper.EstaVazio(const ATexto: string): Boolean;
begin
  Result := Trim(ATexto) = '';
end;

end.
