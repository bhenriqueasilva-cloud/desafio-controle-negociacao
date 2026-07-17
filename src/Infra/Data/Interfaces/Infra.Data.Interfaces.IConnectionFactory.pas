unit Infra.Data.Interfaces.IConnectionFactory;

interface

uses
  Data.DB;

type
  IConnectionFactory = interface
    ['{0A4A3CC1-13D4-4677-ACD2-14B6BBE3E41C}']
    function GetConnection: TCustomConnection;
    procedure Disconnect;
  end;

implementation

end.
