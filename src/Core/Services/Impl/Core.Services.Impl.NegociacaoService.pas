unit Core.Services.Impl.NegociacaoService;

interface

uses
  System.Generics.Collections,
  Core.Services.Interfaces.INegociacaoService,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.INegociacaoItemRepository,
  Core.Services.Interfaces.IValidacaoCreditoService,
  Core.Entities.Negociacao,
  Core.Entities.NegociacaoItem,
  Core.Exceptions.NegociacaoNaoEncontradaException,
  Core.Exceptions.ValidacaoException,
  Core.Enums.TipoStatus;

type
  TNegociacaoService = class(TInterfacedObject, INegociacaoService)
  private
    FNegociacaoRepository: INegociacaoRepository;
    FNegociacaoItemRepository: INegociacaoItemRepository;
    FValidacaoCreditoService: IValidacaoCreditoService;
  public
    constructor Create(ANegociacaoRepository: INegociacaoRepository; ANegociacaoItemRepository: INegociacaoItemRepository; AValidacaoCreditoService: IValidacaoCreditoService);
    function Salvar(ANegociacao: TNegociacao): Boolean;
    function Atualizar(ANegociacao: TNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacao;
    function ObterTodos: TList<TNegociacao>;
    function ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
    function ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
    function AprovarNegociacao(AId: Integer): Boolean;
    function ConcluirNegociacao(AId: Integer): Boolean;
    function CancelarNegociacao(AId: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TNegociacaoService.Create(ANegociacaoRepository: INegociacaoRepository; ANegociacaoItemRepository: INegociacaoItemRepository; AValidacaoCreditoService: IValidacaoCreditoService);
begin
  inherited Create;
  FNegociacaoRepository := ANegociacaoRepository;
  FNegociacaoItemRepository := ANegociacaoItemRepository;
  FValidacaoCreditoService := AValidacaoCreditoService;
end;

function TNegociacaoService.Salvar(ANegociacao: TNegociacao): Boolean;
var
  LItem: TNegociacaoItem;
begin
  ANegociacao.Validar;
  FValidacaoCreditoService.ValidarCredito(ANegociacao.IdProdutor, ANegociacao.IdDistribuidor, ANegociacao.ValorTotal);
  Result := FNegociacaoRepository.Inserir(ANegociacao);
  if Result then
  begin
    for LItem in ANegociacao.Itens do
    begin
      LItem.IdNegociacao := ANegociacao.Id;
      FNegociacaoItemRepository.Inserir(LItem);
    end;
  end;
end;

function TNegociacaoService.Atualizar(ANegociacao: TNegociacao): Boolean;
var
  LItem: TNegociacaoItem;
begin
  ANegociacao.Validar;
  if ANegociacao.Status = TTipoStatus.tsAprovada then
    FValidacaoCreditoService.ValidarCredito(ANegociacao.IdProdutor, ANegociacao.IdDistribuidor, ANegociacao.ValorTotal);
  Result := FNegociacaoRepository.Atualizar(ANegociacao);
  if Result then
  begin
    FNegociacaoItemRepository.ExcluirPorNegociacao(ANegociacao.Id);
    for LItem in ANegociacao.Itens do
    begin
      LItem.IdNegociacao := ANegociacao.Id;
      FNegociacaoItemRepository.Inserir(LItem);
    end;
  end;
end;

function TNegociacaoService.Excluir(AId: Integer): Boolean;
begin
  FNegociacaoItemRepository.ExcluirPorNegociacao(AId);
  Result := FNegociacaoRepository.Excluir(AId);
end;

function TNegociacaoService.ObterPorId(AId: Integer): TNegociacao;
var
  LItensRepo: TList<TNegociacaoItem>;
begin
  Result := FNegociacaoRepository.ObterPorId(AId);
  if Result = nil then
    raise ENegociacaoNaoEncontradaException.CreateFmt('Negociação com ID %d não encontrada', [AId]);
  Result.Itens.Clear;
  LItensRepo := FNegociacaoItemRepository.ObterPorNegociacao(AId);
  try
    if Assigned(LItensRepo) then
      Result.Itens.AddRange(LItensRepo);
  finally
    if Assigned(LItensRepo) then
      LItensRepo.Free;
  end;
end;

function TNegociacaoService.ObterTodos: TList<TNegociacao>;
begin
  Result := FNegociacaoRepository.ObterTodos;
end;

function TNegociacaoService.ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
begin
  Result := FNegociacaoRepository.ObterPorProdutor(AIdProdutor);
end;

function TNegociacaoService.ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
begin
  Result := FNegociacaoRepository.ObterPorDistribuidor(AIdDistribuidor);
end;

function TNegociacaoService.AprovarNegociacao(AId: Integer): Boolean;
var
  LNegociacao: TNegociacao;
begin
  Result := False;
  LNegociacao := ObterPorId(AId);
  if not Assigned(LNegociacao) then
    Exit;
  try
    if not LNegociacao.PodeAprovar then
      raise EValidacaoException.Create('Negociação não pode ser aprovada no status atual');
    FValidacaoCreditoService.ValidarCredito(LNegociacao.IdProdutor, LNegociacao.IdDistribuidor, LNegociacao.ValorTotal);
    LNegociacao.Aprovar;
    Result := FNegociacaoRepository.Atualizar(LNegociacao);
  finally
    LNegociacao.Free;
  end;
end;

function TNegociacaoService.ConcluirNegociacao(AId: Integer): Boolean;
var
  LNegociacao: TNegociacao;
begin
  Result := False;
  LNegociacao := ObterPorId(AId);
  if not Assigned(LNegociacao) then
    Exit;
  try
    if not LNegociacao.PodeConcluir then
      raise EValidacaoException.Create('Negociação não pode ser concluída no status atual');
    LNegociacao.Concluir;
    Result := FNegociacaoRepository.Atualizar(LNegociacao);
  finally
    LNegociacao.Free;
  end;
end;

function TNegociacaoService.CancelarNegociacao(AId: Integer): Boolean;
var
  LNegociacao: TNegociacao;
begin
  Result := False;
  LNegociacao := ObterPorId(AId);
  if not Assigned(LNegociacao) then
    Exit;
  try
    if not LNegociacao.PodeCancelar then
      raise EValidacaoException.Create('Negociação não pode ser cancelada no status atual');
    LNegociacao.Cancelar;
    Result := FNegociacaoRepository.Atualizar(LNegociacao);
  finally
    LNegociacao.Free;
  end;
end;

end.

