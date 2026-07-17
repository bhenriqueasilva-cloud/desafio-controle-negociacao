unit Core.Exceptions.CreditoExcedidoException;

interface

uses
  System.SysUtils;

type
  ECreditoExcedidoException = class(Exception)
  public
    constructor Create(const AMessage: string);
  end;

implementation

constructor ECreditoExcedidoException.Create(const AMessage: string);
begin
  inherited Create(AMessage);
end;

end.
