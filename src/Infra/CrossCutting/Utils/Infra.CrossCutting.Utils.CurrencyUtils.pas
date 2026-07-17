unit Infra.CrossCutting.Utils.CurrencyUtils;

interface

uses
  System.SysUtils;

type
  TCurrencyUtilsHelper = class
  public
    class function FormatarMoeda(AValor: Currency): string;
    class function StringParaMoeda(const AValor: string): Currency;
  end;

implementation

class function TCurrencyUtilsHelper.FormatarMoeda(AValor: Currency): string;
begin
  Result := FormatFloat('R$ ,0.00', AValor);
end;

class function TCurrencyUtilsHelper.StringParaMoeda(const AValor: string): Currency;
begin
  Result := StrToCurr(StringReplace(AValor, 'R$', '', [rfReplaceAll, rfIgnoreCase]));
end;

end.
