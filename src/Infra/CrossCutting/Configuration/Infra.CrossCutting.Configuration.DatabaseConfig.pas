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
    function ResolverCaminhoBanco(const ACaminho: string): string;
    function ObterCaminhoRelativoBanco: string;
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
  DEFAULT_DATABASE = '..\data\database\NEGOCIACOES.FDB';
  DEFAULT_USERNAME = 'SYSDBA';
  DEFAULT_PASSWORD = 'masterkey';

constructor TDatabaseConfig.Create;
begin
  inherited Create;

  FIniFile := IncludeTrailingPathDelimiter(
    ExtractFilePath(ParamStr(0))
  ) + 'config.ini';

  CarregarConfiguracoes;
end;

destructor TDatabaseConfig.Destroy;
begin
  SalvarConfiguracoes;
  inherited Destroy;
end;

function TDatabaseConfig.ResolverCaminhoBanco(
  const ACaminho: string): string;
begin
  if Trim(ACaminho) = '' then
    Exit(
      ExpandFileName(
        ExtractFilePath(ParamStr(0)) + DEFAULT_DATABASE
      )
    );

  if ExtractFileDrive(ACaminho) <> '' then
    Result := ExpandFileName(ACaminho)
  else
    Result := ExpandFileName(
      ExtractFilePath(ParamStr(0)) + ACaminho
    );
end;

function TDatabaseConfig.ObterCaminhoRelativoBanco: string;
var
  LDiretorioExe: string;
begin
  LDiretorioExe := IncludeTrailingPathDelimiter(
    ExtractFilePath(ParamStr(0))
  );

  Result := ExtractRelativePath(
    LDiretorioExe,
    FDatabase
  );

  if Result = '' then
    Result := DEFAULT_DATABASE;
end;

procedure TDatabaseConfig.CarregarConfiguracoes;
var
  LIniFile: TIniFile;
  LCaminhoConfigurado: string;
begin
  FServer := DEFAULT_SERVER;
  FDatabase := ResolverCaminhoBanco(DEFAULT_DATABASE);
  FUserName := DEFAULT_USERNAME;
  FPassword := DEFAULT_PASSWORD;

  if FileExists(FIniFile) then
  begin
    LIniFile := TIniFile.Create(FIniFile);
    try
      FServer := LIniFile.ReadString(
        INI_SECTION,
        INI_SERVER,
        DEFAULT_SERVER
      );

      LCaminhoConfigurado := LIniFile.ReadString(
        INI_SECTION,
        INI_DATABASE,
        DEFAULT_DATABASE
      );

      FDatabase := ResolverCaminhoBanco(
        LCaminhoConfigurado
      );

      FUserName := LIniFile.ReadString(
        INI_SECTION,
        INI_USERNAME,
        DEFAULT_USERNAME
      );

      FPassword := LIniFile.ReadString(
        INI_SECTION,
        INI_PASSWORD,
        DEFAULT_PASSWORD
      );
    finally
      LIniFile.Free;
    end;
  end
  else
    SalvarConfiguracoes;
end;

procedure TDatabaseConfig.SalvarConfiguracoes;
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(FIniFile);
  try
    LIniFile.WriteString(
      INI_SECTION,
      INI_SERVER,
      FServer
    );

    LIniFile.WriteString(
      INI_SECTION,
      INI_DATABASE,
      ObterCaminhoRelativoBanco
    );

    LIniFile.WriteString(
      INI_SECTION,
      INI_USERNAME,
      FUserName
    );

    LIniFile.WriteString(
      INI_SECTION,
      INI_PASSWORD,
      FPassword
    );
  finally
    LIniFile.Free;
  end;
end;

end.
