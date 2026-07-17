unit Infra.Data.Firebird.FirebirdConnectionFactory;

interface

uses
  Data.DB,
  Infra.Data.Interfaces.IConnectionFactory,
  Infra.CrossCutting.Configuration.DatabaseConfig,
  System.SysUtils,
  System.Variants,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client;

type
  TFirebirdConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    FConnection: TFDConnection;
    FConfig: TDatabaseConfig;
    FFBDriverLink: TFDPhysFBDriverLink;
  public
    constructor Create(AConfig: TDatabaseConfig);
    destructor Destroy; override;

    function GetConnection: TCustomConnection;
    procedure Disconnect;
    function GetConnectionObject: TFDConnection;
  end;

implementation

constructor TFirebirdConnectionFactory.Create(AConfig: TDatabaseConfig);
begin
  inherited Create;
  FConfig := AConfig;

  FFBDriverLink := TFDPhysFBDriverLink.Create(nil);

  FConnection := TFDConnection.Create(nil);
  FConnection.Params.DriverID := 'FB';
  FConnection.Params.Database := FConfig.Database;
  FConnection.Params.UserName := FConfig.UserName;
  FConnection.Params.Password := FConfig.Password;

  FConnection.Params.Add('CharacterSet=UTF8');
  FConnection.Params.Add('Dialect=3');
  FConnection.LoginPrompt := False;
end;

destructor TFirebirdConnectionFactory.Destroy;
begin
  if Assigned(FConnection) then
  begin
    if FConnection.Connected then
      FConnection.Connected := False;
    FConnection.Free;
  end;

  if Assigned(FFBDriverLink) then
    FFBDriverLink.Free;

  inherited;
end;

function TFirebirdConnectionFactory.GetConnection: TCustomConnection;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;

  Result := FConnection;
end;

procedure TFirebirdConnectionFactory.Disconnect;
begin
  if Assigned(FConnection) and FConnection.Connected then
    FConnection.Connected := False;
end;

function TFirebirdConnectionFactory.GetConnectionObject: TFDConnection;
begin
  Result := FConnection;
end;

end.

