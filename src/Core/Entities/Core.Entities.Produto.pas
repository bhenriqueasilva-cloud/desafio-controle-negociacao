unit Core.Entities.Produto;

interface

uses
  Core.Entities.CadastroBase,
  Core.Exceptions.ValidacaoException;

type
  TProduto = class(TCadastroBase)
  private
    FPrecoVenda: Currency;
    procedure SetPrecoVenda(const AValue: Currency);
  protected
    function GetNomeEntidade: string; override;
  public
    procedure Validar; override;

    property PrecoVenda: Currency read FPrecoVenda write SetPrecoVenda;
  end;

implementation

uses
  System.SysUtils;

function TProduto.GetNomeEntidade: string;
begin
  Result := 'produto';
end;

procedure TProduto.SetPrecoVenda(const AValue: Currency);
begin
  if AValue <= 0 then
    raise EValidacaoException.Create('Preço de venda deve ser maior que zero');
  FPrecoVenda := AValue;
end;

procedure TProduto.Validar;
begin
  inherited;
  if FPrecoVenda <= 0 then
    raise EValidacaoException.Create('Preço de venda deve ser maior que zero');
end;

end.
