unit Core.Entities.Distribuidor;

interface

uses
  System.Generics.Collections,
  Core.Entities.CadastroBase,
  Core.Exceptions.ValidacaoException;

type
  TDistribuidor = class(TCadastroBase)
  private
    FCnpj: string;
    FDistribuidorProdutos: TList<Integer>;
    procedure SetCnpj(const AValue: string);
  protected
    function GetNomeEntidade: string; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Validar; override;
    function AdicionarProduto(AIdProduto: Integer): Boolean;
    function RemoverProduto(AIdProduto: Integer): Boolean;
    function PossuiProduto(AIdProduto: Integer): Boolean;
    function ObterDistribuidorProduto(AIdProduto: Integer): Integer;

    property Cnpj: string read FCnpj write SetCnpj;
    property DistribuidorProdutos: TList<Integer> read FDistribuidorProdutos;
  end;

implementation

uses
  System.SysUtils;

constructor TDistribuidor.Create;
begin
  inherited;
  FDistribuidorProdutos := TList<Integer>.Create;
end;

destructor TDistribuidor.Destroy;
begin
  FDistribuidorProdutos.Free;
  inherited;
end;

function TDistribuidor.GetNomeEntidade: string;
begin
  Result := 'distribuidor';
end;

procedure TDistribuidor.SetCnpj(const AValue: string);
begin
  if Trim(AValue) = '' then
    raise EValidacaoException.Create('CNPJ do distribuidor não pode ser vazio');
  FCnpj := Trim(AValue);
end;

procedure TDistribuidor.Validar;
begin
  inherited;
  if Trim(FCnpj) = '' then
    raise EValidacaoException.Create('CNPJ do distribuidor não pode ser vazio');
end;

function TDistribuidor.AdicionarProduto(AIdProduto: Integer): Boolean;
begin
  if AIdProduto <= 0 then
    raise EValidacaoException.Create('ID do produto deve ser maior que zero');

  if not FDistribuidorProdutos.Contains(AIdProduto) then
  begin
    FDistribuidorProdutos.Add(AIdProduto);
    Result := True;
  end
  else
    Result := False;
end;

function TDistribuidor.RemoverProduto(AIdProduto: Integer): Boolean;
begin
  Result := FDistribuidorProdutos.Remove(AIdProduto) >= 0;
end;

function TDistribuidor.PossuiProduto(AIdProduto: Integer): Boolean;
begin
  Result := FDistribuidorProdutos.Contains(AIdProduto);
end;

function TDistribuidor.ObterDistribuidorProduto(AIdProduto: Integer): Integer;
begin
  if FDistribuidorProdutos.Contains(AIdProduto) then
    Result := AIdProduto
  else
    Result := 0;
end;

end.

