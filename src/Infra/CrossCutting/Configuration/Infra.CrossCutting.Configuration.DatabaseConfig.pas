unit Infra.CrossCutting.Configuration.DatabaseConfig;

interface

uses
  System.IniFiles;

type
  TDatabaseConfig = class
  private
    FServer: string;
    FDatabase: string;
    FUserName: string;
    FPassword: string;
    FIniFile: string;
    procedure CarregarConfiguracoes;
    procedure SalvarConfiguracoes;
  public
    constructor Create;
    destructor Destroy; override;

    property Server: string read FServer write FServer;
    property Database: string read FDatabase write FDatabase;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

implementation

uses
  System.SysUtils;

const
  INI_SECTION = 'Database';
  INI_SERVER = 'Server';
  INI_DATABASE = 'Database';
  INI_USERNAME = 'UserName';
  INI_PASSWORD = 'Password';
  DEFAULT_SERVER = 'localhost';
  DEFAULT_DATABASE = '..\..\..\data\database\NEGOCIACOES.FDB';
  DEFAULT_USERNAME = 'SYSDBA';
  DEFAULT_PASSWORD = 'masterkey';

constructor TDatabaseConfig.Create;
begin
  inherited;
  FIniFile := ExtractFilePath(ParamStr(0)) + 'config.ini';
  CarregarConfiguracoes;
end;

destructor TDatabaseConfig.Destroy;
begin
  SalvarConfiguracoes;
  inherited;
end;

procedure TDatabaseConfig.CarregarConfiguracoes;
var
  LIniFile: TIniFile;
begin
  if FileExists(FIniFile) then
  begin
    LIniFile := TIniFile.Create(FIniFile);
    try
      FServer := LIniFile.ReadString(INI_SECTION, INI_SERVER, DEFAULT_SERVER);
      FDatabase := LIniFile.ReadString(INI_SECTION, INI_DATABASE, DEFAULT_DATABASE);
      if ExtractFileDrive(FDatabase) = '' then
        FDatabase := ExpandFileName(ExtractFilePath(ParamStr(0)) + FDatabase);
      FUserName := LIniFile.ReadString(INI_SECTION, INI_USERNAME, DEFAULT_USERNAME);
      FPassword := LIniFile.ReadString(INI_SECTION, INI_PASSWORD, DEFAULT_PASSWORD);
    finally
      LIniFile.Free;
    end;
  end
  else
  begin

    FServer := DEFAULT_SERVER;
    FDatabase := ExpandFileName(ExtractFilePath(ParamStr(0)) + DEFAULT_DATABASE);
    FUserName := DEFAULT_USERNAME;
    FPassword := DEFAULT_PASSWORD;

    SalvarConfiguracoes;
  end;
end;

procedure TDatabaseConfig.SalvarConfiguracoes;
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(FIniFile);
  try
    LIniFile.WriteString(INI_SECTION, INI_SERVER, FServer);
    LIniFile.WriteString(INI_SECTION, INI_DATABASE, FDatabase);
    LIniFile.WriteString(INI_SECTION, INI_USERNAME, FUserName);
    LIniFile.WriteString(INI_SECTION, INI_PASSWORD, FPassword);
  finally
    LIniFile.Free;
  end;
end;

end.
