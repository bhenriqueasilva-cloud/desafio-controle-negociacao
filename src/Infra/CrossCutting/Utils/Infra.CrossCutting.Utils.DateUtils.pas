unit Infra.CrossCutting.Utils.DateUtils;

interface

uses
  System.SysUtils;

type
  TDateUtilsHelper = class
  public
    class function FormatarData(AData: TDateTime): string;
    class function DataValida(AData: TDateTime): Boolean;
  end;

implementation

class function TDateUtilsHelper.FormatarData(AData: TDateTime): string;
begin
  if AData = 0 then
    Result := ''
  else
    Result := FormatDateTime('dd/mm/yyyy', AData);
end;

class function TDateUtilsHelper.DataValida(AData: TDateTime): Boolean;
begin
  Result := (AData > 0) and (AData < EncodeDate(2100, 12, 31));
end;

end.
