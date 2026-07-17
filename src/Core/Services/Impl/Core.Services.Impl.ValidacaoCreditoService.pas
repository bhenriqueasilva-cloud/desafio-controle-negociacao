unit Core.Services.Impl.ValidacaoCreditoService;

interface

uses
  Core.Services.Interfaces.IValidacaoCreditoService,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Core.Exceptions.CreditoExcedidoException,
  Core.Exceptions.ValidacaoException;

type
  TValidacaoCreditoService = class(TInterfacedObject, IValidacaoCreditoService)
  private
    FNegociacaoRepository: INegociacaoRepository;
    FProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository;
  public
    constructor Create(ANegociacaoRepository: INegociacaoRepository; AProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository);
    function ValidarCredito(AIdProdutor, AIdDistribuidor: Integer; AValorNegociacao: Currency): Boolean;
    function ObterLimiteDisponivel(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterLimiteTotal(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterValorUtilizado(AIdProdutor, AIdDistribuidor: Integer): Currency;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoCreditoService.Create(ANegociacaoRepository:
  INegociacaoRepository; AProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository);
begin
  inherited Create;
  FNegociacaoRepository := ANegociacaoRepository;
  FProdutorLimiteCreditoRepository := AProdutorLimiteCreditoRepository;
end;

function TValidacaoCreditoService.ObterValorUtilizado(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  Result := FNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor);
end;

function TValidacaoCreditoService.ObterLimiteTotal(AIdProdutor, AIdDistribuidor: Integer): Currency;
var
  LValorLimite: Currency;
  LIdLimite: Integer;
begin
  LIdLimite := FProdutorLimiteCreditoRepository.ObterLimite(AIdProdutor, AIdDistribuidor, LValorLimite);
  if LIdLimite = 0 then
    Result := 0
  else
    Result := LValorLimite;
end;

function TValidacaoCreditoService.ObterLimiteDisponivel(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  Result := ObterLimiteTotal(AIdProdutor, AIdDistribuidor) - ObterValorUtilizado(AIdProdutor, AIdDistribuidor);
end;

function TValidacaoCreditoService.ValidarCredito(AIdProdutor, AIdDistribuidor: Integer; AValorNegociacao: Currency): Boolean;
var
  LLimiteDisponivel: Currency;
  LValorUtilizado: Currency;
  LLimiteTotal: Currency;
begin
  if AIdProdutor <= 0 then
    raise EValidacaoException.Create('Produtor não informado para validação de crédito');
  if AIdDistribuidor <= 0 then
    raise EValidacaoException.Create('Distribuidor não informado para validação de crédito');
  if AValorNegociacao <= 0 then
    raise EValidacaoException.Create('Valor da negociação deve ser maior que zero');

  LValorUtilizado := ObterValorUtilizado(AIdProdutor, AIdDistribuidor);
  LLimiteTotal := ObterLimiteTotal(AIdProdutor, AIdDistribuidor);
  LLimiteDisponivel := LLimiteTotal - LValorUtilizado;

  if LLimiteTotal <= 0 then
    raise ECreditoExcedidoException.Create('Produtor não possui limite de crédito cadastrado para este distribuidor');

  if AValorNegociacao > LLimiteDisponivel then
    raise ECreditoExcedidoException.CreateFmt('Crédito excedido. Limite: R$ %.2f, Utilizado: R$ %.2f, Disponível: R$ %.2f, Nova Negociação: R$ %.2f', [LLimiteTotal, LValorUtilizado, LLimiteDisponivel, AValorNegociacao]);

  Result := True;
end;

end.

