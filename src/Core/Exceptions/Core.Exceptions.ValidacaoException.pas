unit Core.Exceptions.ValidacaoException;

interface

uses
  System.SysUtils;

type
  EValidacaoException = class(Exception)
  public
    constructor Create(const AMessage: string);
  end;

implementation

constructor EValidacaoException.Create(const AMessage: string);
begin
  inherited Create(AMessage);
end;

end.
