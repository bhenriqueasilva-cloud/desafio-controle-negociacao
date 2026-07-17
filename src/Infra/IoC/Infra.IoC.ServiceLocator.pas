unit Infra.IoC.ServiceLocator;

interface

type
  TServiceLocator = class
  public
    class function GetService(const AInterfaceGuid: TGUID): IInterface;
  end;

implementation

class function TServiceLocator.GetService(const AInterfaceGuid: TGUID): IInterface;
begin

  Result := nil;
end;

end.
