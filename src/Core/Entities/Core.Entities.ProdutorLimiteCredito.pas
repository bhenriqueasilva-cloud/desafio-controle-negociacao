unit Core.Entities.ProdutorLimiteCredito;

interface

uses
  Core.Exceptions.ValidacaoException;

type
  TProdutorLimiteCredito = class
  private
    FId: Integer;
    FIdProdutor: Integer;
    FIdDistribuidor: Integer;
    FValorLimite: Currency;
    procedure SetValorLimite(const AValue: Currency);
  public
    procedure Validar;

    property Id: Integer read FId write FId;
    property IdProdutor: Integer read FIdProdutor write FIdProdutor;
    property IdDistribuidor: Integer read FIdDistribuidor write FIdDistribuidor;
    property ValorLimite: Currency read FValorLimite write SetValorLimite;
  end;

implementation

uses
  System.SysUtils;

procedure TProdutorLimiteCredito.SetValorLimite(const AValue: Currency);
begin
  if AValue < 0 then
    raise EValidacaoException.Create('Valor do limite não pode ser negativo');
  FValorLimite := AValue;
end;

procedure TProdutorLimiteCredito.Validar;
begin
  if FIdProdutor <= 0 then
    raise EValidacaoException.Create('Produtor não informado');
  if FIdDistribuidor <= 0 then
    raise EValidacaoException.Create('Distribuidor não informado');
  if FValorLimite < 0 then
    raise EValidacaoException.Create('Valor do limite não pode ser negativo');
end;

end.
