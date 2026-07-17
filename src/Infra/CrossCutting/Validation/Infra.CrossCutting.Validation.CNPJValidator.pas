unit Infra.CrossCutting.Validation.CNPJValidator;

interface

uses
  System.SysUtils;

type
  TCNPJValidator = class
  public
    class function Validar(const ACnpj: string): Boolean;
    class function FormatarCNPJ(const ATexto: string): string;
  end;

implementation

class function TCNPJValidator.Validar(const ACnpj: string): Boolean;
var
  LTextoLimpo: string;
  I, Soma, Resto, Digito1, Digito2, vPeso: Integer;
begin
  Result := False;

  LTextoLimpo := '';
  for I := 1 to Length(ACnpj) do
  begin
    if CharInSet(ACnpj[I], ['0'..'9']) then
      LTextoLimpo := LTextoLimpo + ACnpj[I];
  end;

  if Length(LTextoLimpo) <> 14 then
    Exit;

  if (LTextoLimpo = '00000000000000') or (LTextoLimpo = '11111111111111') or
     (LTextoLimpo = '22222222222222') or (LTextoLimpo = '33333333333333') or
     (LTextoLimpo = '44444444444444') or (LTextoLimpo = '55555555555555') or
     (LTextoLimpo = '66666666666666') or (LTextoLimpo = '77777777777777') or
     (LTextoLimpo = '88888888888888') or (LTextoLimpo = '99999999999999') then
    Exit;

  Soma := 0;
  vPeso := 5;
  for I := 1 to 12 do
  begin
    Soma := Soma + (StrToInt(LTextoLimpo[I]) * vPeso);
    Dec(vPeso);
    if vPeso < 2 then
      vPeso := 9;
  end;

  Resto := Soma mod 11;
  if Resto < 2 then
    Digito1 := 0
  else
    Digito1 := 11 - Resto;

  Soma := 0;
  vPeso := 6;
  for I := 1 to 13 do
  begin
    if I = 13 then
      Soma := Soma + (Digito1 * vPeso)
    else
      Soma := Soma + (StrToInt(LTextoLimpo[I]) * vPeso);

    Dec(vPeso);
    if vPeso < 2 then
      vPeso := 9;
  end;

  Resto := Soma mod 11;
  if Resto < 2 then
    Digito2 := 0
  else
    Digito2 := 11 - Resto;

  Result := (LTextoLimpo[13] = IntToStr(Digito1)[1]) and
            (LTextoLimpo[14] = IntToStr(Digito2)[1]);
end;

class function TCNPJValidator.FormatarCNPJ(const ATexto: string): string;
var
  LTextoLimpo: string;
  I: Integer;
begin
  LTextoLimpo := '';
  for I := 1 to Length(ATexto) do
  begin
    if CharInSet(ATexto[I], ['0'..'9']) then
      LTextoLimpo := LTextoLimpo + ATexto[I];
  end;

  if Length(LTextoLimpo) <> 14 then
  begin
    Result := ATexto;
    Exit;
  end;

  Result := Copy(LTextoLimpo, 1, 2) + '.' +
            Copy(LTextoLimpo, 3, 3) + '.' +
            Copy(LTextoLimpo, 6, 3) + '/' +
            Copy(LTextoLimpo, 9, 4) + '-' +
            Copy(LTextoLimpo, 13, 2);
end;

end.

