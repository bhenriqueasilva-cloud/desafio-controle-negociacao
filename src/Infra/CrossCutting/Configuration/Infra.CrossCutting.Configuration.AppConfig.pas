unit Infra.CrossCutting.Configuration.AppConfig;

interface

type
  TAppConfig = class
  public
    class function GetDatabasePath: string;
    class function GetBackupPath: string;
  end;

implementation

uses
  System.SysUtils;

class function TAppConfig.GetDatabasePath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + '..\..\data\database\';
end;

class function TAppConfig.GetBackupPath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + '..\..\data\backups\';
end;

end.
