unit Core.Services.NegociacaoServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.INegociacaoService,
  Core.Services.Impl.NegociacaoService,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.INegociacaoItemRepository,
  Core.Services.Interfaces.IValidacaoCreditoService,
  Core.Entities.Negociacao,
  Core.Entities.NegociacaoItem,
  Core.Enums.TipoStatus,
  System.Generics.Collections,
  System.SysUtils;

type
  TMockNegociacaoRepository = class(TInterfacedObject, INegociacaoRepository)
  private
    FLista: TList<TNegociacao>;
    FLastOperation: string;
  public
    constructor Create;
    destructor Destroy; override;
    property LastOperation: string read FLastOperation;
    function Inserir(ANegociacao: TNegociacao): Boolean;
    function Atualizar(ANegociacao: TNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacao;
    function ObterTodos: TList<TNegociacao>;
    function ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
    function ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
    function ObterPorStatus(AStatus: Integer): TList<TNegociacao>;
    function ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency;
  end;

  TMockNegociacaoItemRepository = class(TInterfacedObject, INegociacaoItemRepository)
  public
    function Inserir(AItem: TNegociacaoItem): Boolean;
    function Atualizar(AItem: TNegociacaoItem): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacaoItem;
    function ObterPorNegociacao(AIdNegociacao: Integer): TList<TNegociacaoItem>;
    function ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
  end;

  TMockValidacaoCreditoService = class(TInterfacedObject, IValidacaoCreditoService)
  public
    function ValidarCredito(AIdProdutor, AIdDistribuidor: Integer; AValorNegociacao: Currency): Boolean;
    function ObterLimiteDisponivel(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterLimiteTotal(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterValorUtilizado(AIdProdutor, AIdDistribuidor: Integer): Currency;
  end;

  [TestFixture]
  TNegociacaoServiceTest = class
  private
    FService: INegociacaoService;
    FMockNegociacao: INegociacaoRepository;
    FMockItem: INegociacaoItemRepository;
    FMockCredito: IValidacaoCreditoService;
  public
    [Setup] procedure SetUp;
    [TearDown] procedure TearDown;
    [Test] procedure TestExcluirComSucesso;
    [Test] procedure TestObterTodos;
    [Test] procedure TestObterPorProdutor;
    [Test] procedure TestObterPorDistribuidor;
    [Test] procedure TestObterPorIdExistente;
    [Test] procedure TestObterPorIdInexistente;
    [Test] procedure TestMocksSecundariosInjetadosComSucesso;
    [Test] procedure TestVerificarLimitesDeCreditoSimulados;
    [Test] procedure TestObterItensDaNegociacaoVazia;
    [Test] procedure TestBuscarNegociacoesComFiltroDeStatus;
  end;

implementation

constructor TMockNegociacaoRepository.Create;
begin
  inherited;
  FLista := TList<TNegociacao>.Create;
end;

destructor TMockNegociacaoRepository.Destroy;
var
  LItem: TNegociacao;
begin
  for LItem in FLista do
    if Assigned(LItem) then LItem.Free;
  FLista.Free;
  inherited;
end;

function TMockNegociacaoRepository.Inserir(ANegociacao: TNegociacao): Boolean;
begin
  FLastOperation := 'Inserir';
  if FLista.IndexOf(ANegociacao) = -1 then
    FLista.Add(ANegociacao);
  Result := True;
end;

function TMockNegociacaoRepository.Atualizar(ANegociacao: TNegociacao): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := True;
end;

function TMockNegociacaoRepository.Excluir(AId: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := True;
end;

function TMockNegociacaoRepository.ObterPorStatus(AStatus: Integer): TList<TNegociacao>;
begin
  FLastOperation := 'ObterPorStatus';
  Result := TList<TNegociacao>.Create;
end;

function TMockNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  FLastOperation := 'ObterValorTotalAprovado';
  Result := 0;
end;

function TMockNegociacaoRepository.ObterPorId(AId: Integer): TNegociacao;
begin
  FLastOperation := 'ObterPorId';
  if AId <= 0 then
  begin
    Result := nil;
    Exit;
  end;
  Result := TNegociacao.Create;
  Result.Id := AId;
  Result.Status := tsPendente;
end;

function TMockNegociacaoRepository.ObterTodos: TList<TNegociacao>;
begin
  FLastOperation := 'ObterTodos';
  Result := TList<TNegociacao>.Create;
end;

function TMockNegociacaoRepository.ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
begin
  FLastOperation := 'ObterPorProdutor';
  Result := TList<TNegociacao>.Create;
end;

function TMockNegociacaoRepository.ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
begin
  FLastOperation := 'ObterPorDistribuidor';
  Result := TList<TNegociacao>.Create;
end;

function TMockNegociacaoItemRepository.Inserir(AItem: TNegociacaoItem): Boolean;
begin
  Result := True;
end;

function TMockNegociacaoItemRepository.Atualizar(AItem: TNegociacaoItem): Boolean;
begin
  Result := True;
end;

function TMockNegociacaoItemRepository.Excluir(AId: Integer): Boolean;
begin
  Result := True;
end;

function TMockNegociacaoItemRepository.ObterPorId(AId: Integer): TNegociacaoItem;
begin
  Result := nil;
end;

function TMockNegociacaoItemRepository.ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
begin
  Result := True;
end;

function TMockNegociacaoItemRepository.ObterPorNegociacao(AIdNegociacao: Integer): TList<TNegociacaoItem>;
begin
  Result := TList<TNegociacaoItem>.Create;
end;

function TMockValidacaoCreditoService.ValidarCredito(AIdProdutor, AIdDistribuidor: Integer; AValorNegociacao: Currency): Boolean;
begin
  Result := True;
end;

function TMockValidacaoCreditoService.ObterLimiteDisponivel(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  Result := 50000.00;
end;

function TMockValidacaoCreditoService.ObterLimiteTotal(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  Result := 100000.00;
end;

function TMockValidacaoCreditoService.ObterValorUtilizado(AIdProdutor, AIdDistribuidor: Integer): Currency;
begin
  Result := 0.00;
end;

procedure TNegociacaoServiceTest.SetUp;
begin
  FMockNegociacao := TMockNegociacaoRepository.Create;
  FMockItem := TMockNegociacaoItemRepository.Create;
  FMockCredito := TMockValidacaoCreditoService.Create;
  FService := TNegociacaoService.Create(FMockNegociacao, FMockItem, FMockCredito);
end;

procedure TNegociacaoServiceTest.TearDown;
begin
  FService := nil;
  FMockNegociacao := nil;
  FMockItem := nil;
  FMockCredito := nil;
end;

procedure TNegociacaoServiceTest.TestExcluirComSucesso;
begin
  Assert.IsTrue(FService.Excluir(1));
  Assert.AreEqual('Excluir', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
end;

procedure TNegociacaoServiceTest.TestObterTodos;
var
  LLista: TList<TNegociacao>;
begin
  LLista := FService.ObterTodos;
  try
    Assert.IsNotNull(LLista);
    Assert.AreEqual('ObterTodos', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TNegociacaoServiceTest.TestObterPorProdutor;
var
  LLista: TList<TNegociacao>;
begin
  LLista := FService.ObterPorProdutor(1);
  try
    Assert.IsNotNull(LLista);
    Assert.AreEqual('ObterPorProdutor', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TNegociacaoServiceTest.TestObterPorDistribuidor;
var
  LLista: TList<TNegociacao>;
begin
  LLista := FService.ObterPorDistribuidor(1);
  try
    Assert.IsNotNull(LLista);
    Assert.AreEqual('ObterPorDistribuidor', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TNegociacaoServiceTest.TestObterPorIdExistente;
var
  LNegociacao: TNegociacao;
begin
  LNegociacao := FService.ObterPorId(1);
  try
    Assert.IsNotNull(LNegociacao);
    Assert.AreEqual(1, LNegociacao.Id);
    Assert.AreEqual('ObterPorId', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
  finally
    if Assigned(LNegociacao) then LNegociacao.Free;
  end;
end;

procedure TNegociacaoServiceTest.TestObterPorIdInexistente;
var
  LErroLancado: Boolean;
begin
  LErroLancado := False;
  try
    FService.ObterPorId(0);
  except
    on E: Exception do
    begin
      if E.ClassName = 'ENegociacaoNaoEncontradaException' then
        LErroLancado := True;
    end;
  end;
  Assert.IsTrue(LErroLancado);
end;

procedure TNegociacaoServiceTest.TestMocksSecundariosInjetadosComSucesso;
begin
  Assert.IsNotNull(FMockItem);
  Assert.IsNotNull(FMockCredito);
end;

procedure TNegociacaoServiceTest.TestVerificarLimitesDeCreditoSimulados;
begin
  Assert.AreEqual<Currency>(50000.00, FMockCredito.ObterLimiteDisponivel(1, 1));
  Assert.AreEqual<Currency>(100000.00, FMockCredito.ObterLimiteTotal(1, 1));
  Assert.AreEqual<Currency>(0.00, FMockCredito.ObterValorUtilizado(1, 1));
end;

procedure TNegociacaoServiceTest.TestObterItensDaNegociacaoVazia;
var
  LNegociacao: TNegociacao;
begin
  LNegociacao := FService.ObterPorId(5);
  try
    Assert.IsNotNull(LNegociacao);
    Assert.AreEqual(0, LNegociacao.Itens.Count);
  finally
    if Assigned(LNegociacao) then LNegociacao.Free;
  end;
end;

procedure TNegociacaoServiceTest.TestBuscarNegociacoesComFiltroDeStatus;
var
  LLista: TList<TNegociacao>;
begin
  LLista := FMockNegociacao.ObterPorStatus(0);
  try
    Assert.IsNotNull(LLista);
    Assert.AreEqual('ObterPorStatus', (FMockNegociacao as TMockNegociacaoRepository).LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TNegociacaoServiceTest);
end.

