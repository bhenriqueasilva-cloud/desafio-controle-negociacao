unit Core.Services.Impl.ProdutorService;

interface

uses
  System.Generics.Collections,
  Core.Services.Interfaces.IProdutorService,
  Core.Entities.Produtor,
  Infra.Data.Interfaces.IProdutorRepository,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.CrossCutting.Validation.CPFValidator,
  Infra.CrossCutting.Validation.CNPJValidator;

type
  TProdutorService = class(TInterfacedObject, IProdutorService)
  private
    FProdutorRepository: IProdutorRepository;
    FProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository;
    FNegociacaoRepository: INegociacaoRepository;
    procedure ValidarDocumento(const ACpfCnpj: string);
  public
    constructor Create(
      AProdutorRepository: IProdutorRepository;
      AProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository;
      ANegociacaoRepository: INegociacaoRepository
    );
    destructor Destroy; override;

    function Salvar(AProdutor: TProdutor): Boolean;
    function Atualizar(AProdutor: TProdutor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProdutor;
    function ObterTodos: TList<TProdutor>;
    function ObterPorNome(const ANome: string): TList<TProdutor>;
    function ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
    function ObterProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
    function SalvarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
    function AtualizarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
    function ExcluirProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function PossuiDistribuidores(AIdProdutor: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutorService.Create(
  AProdutorRepository: IProdutorRepository;
  AProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository;
  ANegociacaoRepository: INegociacaoRepository
);
begin
  inherited Create;
  FProdutorRepository := AProdutorRepository;
  FProdutorLimiteCreditoRepository := AProdutorLimiteCreditoRepository;
  FNegociacaoRepository := ANegociacaoRepository;
end;

destructor TProdutorService.Destroy;
begin
  inherited;
end;

procedure TProdutorService.ValidarDocumento(const ACpfCnpj: string);
var
  LTextoLimpo: string;
  I: Integer;
begin
  LTextoLimpo := '';
  for I := 1 to Length(ACpfCnpj) do
  begin
    if CharInSet(ACpfCnpj[I], ['0'..'9']) then
      LTextoLimpo := LTextoLimpo + ACpfCnpj[I];
  end;

  if Length(LTextoLimpo) = 11 then
  begin
    if not TCPFValidator.Validar(LTextoLimpo) then
      raise Exception.Create('CPF informado é inválido.');
  end
  else if Length(LTextoLimpo) = 14 then
  begin
    if not TCNPJValidator.Validar(LTextoLimpo) then
      raise Exception.Create('CNPJ informado é inválido.');
  end
  else
    raise Exception.Create('O documento deve conter exatamente 11 dígitos para CPF ou 14 dígitos para CNPJ.');
end;

function TProdutorService.Salvar(AProdutor: TProdutor): Boolean;
begin
  AProdutor.Validar;
  ValidarDocumento(AProdutor.CpfCnpj);
  Result := FProdutorRepository.Inserir(AProdutor);
end;

function TProdutorService.Atualizar(AProdutor: TProdutor): Boolean;
begin
  AProdutor.Validar;
  ValidarDocumento(AProdutor.CpfCnpj);
  Result := FProdutorRepository.Atualizar(AProdutor);
end;

function TProdutorService.Excluir(AId: Integer): Boolean;
begin
  Result := FProdutorRepository.Excluir(AId);
end;

function TProdutorService.ObterPorId(AId: Integer): TProdutor;
begin
  Result := FProdutorRepository.ObterPorId(AId);
end;

function TProdutorService.ObterTodos: TList<TProdutor>;
begin
  Result := FProdutorRepository.ObterTodos;
end;

function TProdutorService.ObterPorNome(const ANome: string): TList<TProdutor>;
begin
  Result := FProdutorRepository.ObterPorNome(ANome);
end;

function TProdutorService.ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
begin
  Result := FProdutorRepository.ObterPorCpfCnpj(ACpfCnpj);
end;

function TProdutorService.SalvarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
var
  LValorUtilizado: Currency;
begin
  if AValorLimite <= 0 then
    raise Exception.Create('Valor do limite de crédito deve ser maior que zero.');

  LValorUtilizado := FNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor);
  if AValorLimite < LValorUtilizado then
    raise Exception.CreateFmt(
      'Não é possível definir o limite inicial para %s, pois o produtor já possui %s em negociações aprovadas.',
      [CurrToStr(AValorLimite), CurrToStr(LValorUtilizado)]
    );

  Result := FProdutorLimiteCreditoRepository.Inserir(AIdProdutor, AIdDistribuidor, AValorLimite);
end;

function TProdutorService.AtualizarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
var
  LValorUtilizado: Currency;
begin
  if AValorLimite <= 0 then
    raise Exception.Create('Valor do limite de crédito deve ser maior que zero.');

  LValorUtilizado := FNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor);

  if AValorLimite < LValorUtilizado then
    raise Exception.CreateFmt(
      'Não é possível reduzir o limite para %s, pois o produtor já possui %s em negociações aprovadas com este distribuidor.',
      [CurrToStr(AValorLimite), CurrToStr(LValorUtilizado)]
    );

  Result := FProdutorLimiteCreditoRepository.Atualizar(AIdProdutor, AIdDistribuidor, AValorLimite);
end;

function TProdutorService.ExcluirProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer): Boolean;
var
  LValorUtilizado: Currency;
begin
  LValorUtilizado := FNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor);

  if LValorUtilizado > 0 then
    raise Exception.CreateFmt(
      'Não é possível excluir o limite de crédito, pois o produtor já possui %s em negociações aprovadas com este distribuidor.',
      [CurrToStr(LValorUtilizado)]
    );

  Result := FProdutorLimiteCreditoRepository.Excluir(AIdProdutor, AIdDistribuidor);
end;

function TProdutorService.ObterProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
begin
  Result := FProdutorLimiteCreditoRepository.ObterLimite(AIdProdutor, AIdDistribuidor, AValorLimite);
end;

function TProdutorService.PossuiDistribuidores(AIdProdutor: Integer): Boolean;
begin
  Result := FProdutorLimiteCreditoRepository.PossuiDistribuidores(AIdProdutor);
end;

end.
