unit Core.Entities.Produtor;

interface

uses
  System.Generics.Collections,
  Core.Entities.CadastroBase,
  Core.Exceptions.ValidacaoException;

type
  TProdutor = class(TCadastroBase)
  private
    FCpfCnpj: string;
    FLimitesCredito: TDictionary<Integer, Currency>;
    procedure SetCpfCnpj(const AValue: string);
  protected
    function GetNomeEntidade: string; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Validar; override;
    function AdicionarProdutorLimiteCredito(AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function ObterProdutorLimiteCredito(AIdDistribuidor: Integer): Currency;
    function PossuiProdutorLimiteCredito(AIdDistribuidor: Integer): Boolean;

    property CpfCnpj: string read FCpfCnpj write SetCpfCnpj;
    property LimitesCredito: TDictionary<Integer, Currency> read FLimitesCredito;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutor.Create;
begin
  inherited;
  FLimitesCredito := TDictionary<Integer, Currency>.Create;
end;

destructor TProdutor.Destroy;
begin
  FLimitesCredito.Free;
  inherited;
end;

function TProdutor.GetNomeEntidade: string;
begin
  Result := 'produtor';
end;

procedure TProdutor.SetCpfCnpj(const AValue: string);
begin
  if Trim(AValue) = '' then
    raise EValidacaoException.Create('CPF/CNPJ do produtor não pode ser vazio');
  FCpfCnpj := Trim(AValue);
end;

procedure TProdutor.Validar;
begin
  inherited;
  if Trim(FCpfCnpj) = '' then
    raise EValidacaoException.Create('CPF/CNPJ do produtor não pode ser vazio');
end;

function TProdutor.AdicionarProdutorLimiteCredito(AIdDistribuidor: Integer; AValor: Currency): Boolean;
begin
  if AValor <= 0 then
    raise EValidacaoException.Create('Valor do limite de crédito deve ser maior que zero');

   FLimitesCredito.AddOrSetValue(AIdDistribuidor, AValor);
   Result := True;
end;

function TProdutor.ObterProdutorLimiteCredito(AIdDistribuidor: Integer): Currency;
begin
  if not FLimitesCredito.TryGetValue(AIdDistribuidor, Result) then
    Result := 0;
end;

function TProdutor.PossuiProdutorLimiteCredito(AIdDistribuidor: Integer): Boolean;
begin
  Result := FLimitesCredito.ContainsKey(AIdDistribuidor);
end;

end.
