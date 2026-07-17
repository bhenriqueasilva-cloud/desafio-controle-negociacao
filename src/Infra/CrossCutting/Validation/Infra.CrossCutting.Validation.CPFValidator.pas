unit Infra.CrossCutting.Validation.CPFValidator;

interface

uses
  System.SysUtils;

type
  TCPFValidator = class
  public

    class function Validar(const ACpf: string): Boolean;

    class function FormatarCPF(const ATexto: string): string;
  end;

implementation

class function TCPFValidator.Validar(const ACpf: string): Boolean;
var
  LTextoLimpo: string;
  I, D1, D2, Soma, Digito1, Digito2: Integer;
begin
  Result := False;

  LTextoLimpo := '';
  for I := 1 to Length(ACpf) do
  begin
    if CharInSet(ACpf[I], ['0'..'9']) then
      LTextoLimpo := LTextoLimpo + ACpf[I];
  end;

  if Length(LTextoLimpo) <> 11 then
    Exit;

  if (LTextoLimpo = '00000000000') or (LTextoLimpo = '11111111111') or
     (LTextoLimpo = '22222222222') or (LTextoLimpo = '33333333333') or
     (LTextoLimpo = '44444444444') or (LTextoLimpo = '55555555555') or
     (LTextoLimpo = '66666666666') or (LTextoLimpo = '77777777777') or
     (LTextoLimpo = '88888888888') or (LTextoLimpo = '99999999999') then
    Exit;

  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + (StrToInt(LTextoLimpo[I]) * (11 - I));

  D1 := 11 - (Soma mod 11);
  if D1 >= 10 then
    Digito1 := 0
  else
    Digito1 := D1;

  Soma := 0;
  for I := 1 to 10 do
  begin
    if I = 10 then
      Soma := Soma + (Digito1 * 2)
    else
      Soma := Soma + (StrToInt(LTextoLimpo[I]) * (12 - I));
  end;

  D2 := 11 - (Soma mod 11);
  if D2 >= 10 then
    Digito2 := 0
  else
    Digito2 := D2;

  Result := (LTextoLimpo[10] = IntToStr(Digito1)[1]) and
            (LTextoLimpo[11] = IntToStr(Digito2)[1]);
end;

class function TCPFValidator.FormatarCPF(const ATexto: string): string;
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

  if Length(LTextoLimpo) <> 11 then
  begin
    Result := ATexto;
    Exit;
  end;

  Result := Copy(LTextoLimpo, 1, 3) + '.' +
            Copy(LTextoLimpo, 4, 3) + '.' +
            Copy(LTextoLimpo, 7, 3) + '-' +
            Copy(LTextoLimpo, 10, 2);
end;

end.

