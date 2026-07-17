unit Core.Exceptions.NegociacaoNaoEncontradaException;

interface

uses
  System.SysUtils;

type
  ENegociacaoNaoEncontradaException = class(Exception)
  public
    constructor Create(const AMessage: string);
  end;

implementation

constructor ENegociacaoNaoEncontradaException.Create(const AMessage: string);
begin
  inherited Create(AMessage);
end;

end.
