unit Core.Services.ValidacaoCreditoServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.IValidacaoCreditoService,
  Core.Services.Impl.ValidacaoCreditoService,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Core.Entities.Negociacao,
  System.Generics.Collections,
  Core.Exceptions.CreditoExcedidoException,
  Core.Exceptions.ValidacaoException,
  System.SysUtils;

type
  TMockNegociacaoRepository = class(TInterfacedObject, INegociacaoRepository)
  private
    FValorAprovado: Currency;
  public
    property ValorAprovado: Currency read FValorAprovado write FValorAprovado;
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

  TMockLimiteCreditoRepository = class(TInterfacedObject, IProdutorLimiteCreditoRepository)
  private
    FValorLimite: Currency;
  public
    property ValorLimite: Currency read FValorLimite write FValorLimite;
    function Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function ObterPorId(AId: Integer): Currency;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
    function ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
  end;

  [TestFixture]
  TValidacaoCreditoServiceTest = class
  private
    FService: IValidacaoCreditoService;
    FMockNegociacao: TMockNegociacaoRepository;
    FMockLimite: TMockLimiteCreditoRepository;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCreditoSuficiente;
    [Test]
    procedure TestCreditoInsuficiente;
    [Test]
    procedure TestSemLimiteCadastrado;
    [Test]
    procedure TestValidarCreditoProdutorInvalido;
    [Test]
    procedure TestValidarCreditoDistribuidorInvalido;
    [Test]
    procedure TestValidarCreditoValorNegociacaoInvalido;
    [Test]
    procedure TestObterLimiteDisponivel;
    [Test]
    procedure TestObterLimiteTotal;
    [Test]
    procedure TestObterValorUtilizado;
    [Test]
    procedure TestObterLimiteTotalSemLimite;
  end;

implementation

{ TMockNegociacaoRepository }

function TMockNegociacaoRepository.Inserir(ANegociacao: TNegociacao): Boolean; begin Result := True; end;
function TMockNegociacaoRepository.Atualizar(ANegociacao: TNegociacao): Boolean; begin Result := True; end;
function TMockNegociacaoRepository.Excluir(AId: Integer): Boolean; begin Result := True; end;
function TMockNegociacaoRepository.ObterPorId(AId: Integer): TNegociacao; begin Result := nil; end;
function TMockNegociacaoRepository.ObterTodos: TList<TNegociacao>; begin Result := nil; end;
function TMockNegociacaoRepository.ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>; begin Result := nil; end;
function TMockNegociacaoRepository.ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>; begin Result := nil; end;
function TMockNegociacaoRepository.ObterPorStatus(AStatus: Integer): TList<TNegociacao>; begin Result := nil; end;
function TMockNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency; begin Result := FValorAprovado; end;

{ TMockLimiteCreditoRepository }

function TMockLimiteCreditoRepository.Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean; begin Result := True; end;
function TMockLimiteCreditoRepository.Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean; begin Result := True; end;
function TMockLimiteCreditoRepository.Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean; begin Result := True; end;
function TMockLimiteCreditoRepository.ObterPorId(AId: Integer): Currency; begin Result := FValorLimite; end;
function TMockLimiteCreditoRepository.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>; begin Result := nil; end;

function TMockLimiteCreditoRepository.ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
begin
  AValorLimite := FValorLimite;
  if FValorLimite > 0 then Result := 1 else Result := 0;
end;

{ TValidacaoCreditoServiceTest }

procedure TValidacaoCreditoServiceTest.SetUp;
begin
  FMockNegociacao := TMockNegociacaoRepository.Create;
  FMockLimite := TMockLimiteCreditoRepository.Create;
  FService := TValidacaoCreditoService.Create(
    FMockNegociacao,
    FMockLimite
  );
end;

procedure TValidacaoCreditoServiceTest.TearDown;
begin
  FService := nil;
end;

procedure TValidacaoCreditoServiceTest.TestCreditoSuficiente;
begin
  FMockLimite.ValorLimite := 60000;
  FMockNegociacao.ValorAprovado := 20000;
  Assert.IsTrue(FService.ValidarCredito(1, 1, 30000), 'Credito deveria ser validado com sucesso');
end;

procedure TValidacaoCreditoServiceTest.TestCreditoInsuficiente;
begin
  FMockLimite.ValorLimite := 60000;
  FMockNegociacao.ValorAprovado := 20000;

  Assert.WillRaise(
    procedure
    begin
      FService.ValidarCredito(1, 1, 50000);
    end,
    ECreditoExcedidoException,
    'Deveria ter lancado ECreditoExcedidoException'
  );
end;

procedure TValidacaoCreditoServiceTest.TestSemLimiteCadastrado;
begin
  FMockLimite.ValorLimite := 0;
  FMockNegociacao.ValorAprovado := 0;

  Assert.WillRaise(
    procedure
    begin
      FService.ValidarCredito(1, 1, 10000);
    end,
    ECreditoExcedidoException,
    'Deveria ter lancado ECreditoExcedidoException para cliente sem limite'
  );
end;

procedure TValidacaoCreditoServiceTest.TestValidarCreditoProdutorInvalido;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.ValidarCredito(0, 1, 10000);
    end,
    EValidacaoException,
    'Deveria lancar EValidacaoException para produtor invalido'
  );
end;

procedure TValidacaoCreditoServiceTest.TestValidarCreditoDistribuidorInvalido;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.ValidarCredito(1, 0, 10000);
    end,
    EValidacaoException,
    'Deveria lancar EValidacaoException para distribuidor invalido'
  );
end;

procedure TValidacaoCreditoServiceTest.TestValidarCreditoValorNegociacaoInvalido;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.ValidarCredito(1, 1, 0);
    end,
    EValidacaoException,
    'Deveria lancar EValidacaoException para valor de negociacao invalido'
  );
end;

procedure TValidacaoCreditoServiceTest.TestObterLimiteDisponivel;
begin
  FMockLimite.ValorLimite := 60000;
  FMockNegociacao.ValorAprovado := 20000;
  
  Assert.AreEqual< Currency >(40000, FService.ObterLimiteDisponivel(1, 1), 'Limite disponivel deveria ser 40000');
end;

procedure TValidacaoCreditoServiceTest.TestObterLimiteTotal;
begin
  FMockLimite.ValorLimite := 60000;
  
  Assert.AreEqual< Currency >(60000, FService.ObterLimiteTotal(1, 1), 'Limite total deveria ser 60000');
end;

procedure TValidacaoCreditoServiceTest.TestObterValorUtilizado;
begin
  FMockNegociacao.ValorAprovado := 20000;
  
  Assert.AreEqual< Currency >(20000, FService.ObterValorUtilizado(1, 1), 'Valor utilizado deveria ser 20000');
end;

procedure TValidacaoCreditoServiceTest.TestObterLimiteTotalSemLimite;
begin
  FMockLimite.ValorLimite := 0;
  
  Assert.AreEqual< Currency >(0, FService.ObterLimiteTotal(1, 1), 'Limite total deveria ser 0 quando nao cadastrado');
end;

initialization
  TDUnitX.RegisterTestFixture(TValidacaoCreditoServiceTest);

end.
