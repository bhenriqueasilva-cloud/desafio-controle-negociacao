unit Core.Entities.NegociacaoItem;

interface

uses
  Core.Exceptions.ValidacaoException;

type
  TNegociacaoItem = class
  private
    FId: Integer;
    FIdNegociacao: Integer;
    FIdProduto: Integer;
    FQuantidade: Double;
    FPrecoUnitario: Currency;
    FValorTotal: Currency;
    procedure SetQuantidade(const AValue: Double);
    procedure SetPrecoUnitario(const AValue: Currency);
    procedure SetValorTotal(const AValue: Currency);
  public
    procedure Validar;
    procedure CalcularValorTotal;

    property Id: Integer read FId write FId;
    property IdNegociacao: Integer read FIdNegociacao write FIdNegociacao;
    property IdProduto: Integer read FIdProduto write FIdProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property PrecoUnitario: Currency read FPrecoUnitario write SetPrecoUnitario;
    property ValorTotal: Currency read FValorTotal write SetValorTotal;
  end;

implementation

uses
  System.SysUtils;

procedure TNegociacaoItem.SetQuantidade(const AValue: Double);
begin
  if AValue <= 0 then
    raise EValidacaoException.Create('Quantidade deve ser maior que zero');
  FQuantidade := AValue;
end;

procedure TNegociacaoItem.SetPrecoUnitario(const AValue: Currency);
begin
  if AValue <= 0 then
    raise EValidacaoException.Create('Preço unitário deve ser maior que zero');
  FPrecoUnitario := AValue;
end;

procedure TNegociacaoItem.SetValorTotal(const AValue: Currency);
begin
  if AValue < 0 then
    raise EValidacaoException.Create('Valor total não pode ser negativo');
  FValorTotal := AValue;
end;

procedure TNegociacaoItem.Validar;
begin
  if FIdProduto <= 0 then
    raise EValidacaoException.Create('Produto não informado');
  if FQuantidade <= 0 then
    raise EValidacaoException.Create('Quantidade deve ser maior que zero');
  if FPrecoUnitario <= 0 then
    raise EValidacaoException.Create('Preço unitário deve ser maior que zero');
end;

procedure TNegociacaoItem.CalcularValorTotal;
begin
  FValorTotal := FQuantidade * FPrecoUnitario;
end;

end.
