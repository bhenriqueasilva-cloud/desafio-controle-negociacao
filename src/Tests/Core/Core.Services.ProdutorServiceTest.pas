unit Core.Services.ProdutorServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.IProdutorService,
  Core.Services.Impl.ProdutorService,
  Infra.Data.Interfaces.IProdutorRepository,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Infra.Data.Interfaces.INegociacaoRepository,
  Core.Entities.Produtor,
  Core.Entities.Negociacao,
  System.Generics.Collections,
  Core.Exceptions.ValidacaoException,
  System.SysUtils;

type
  TMockProdutorRepository = class(TInterfacedObject, IProdutorRepository)
  private
    FLastOperation: string;
  public
    property LastOperation: string read FLastOperation;
    function Inserir(AProdutor: TProdutor): Boolean;
    function Atualizar(AProdutor: TProdutor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProdutor;
    function ObterTodos: TList<TProdutor>;
    function ObterPorNome(const ANome: string): TList<TProdutor>;
    function ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
  end;

  TMockProdutorLimiteCreditoRepository = class(TInterfacedObject, IProdutorLimiteCreditoRepository)
  private
    FLastOperation: string;
    FShouldReturnTrue: Boolean;
  public
    property LastOperation: string read FLastOperation;
    property ShouldReturnTrue: Boolean read FShouldReturnTrue write FShouldReturnTrue;
    function Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function ObterPorId(AId: Integer): Currency;
    function ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
  end;

  TMockProdutorNegociacaoRepository = class(TInterfacedObject, INegociacaoRepository)
  public
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

  [TestFixture]
  TProdutorServiceTest = class
  private
    FService: IProdutorService;
    FMockProdutor: TMockProdutorRepository;
    FMockLimite: TMockProdutorLimiteCreditoRepository;
    FMockNegociacao: TMockProdutorNegociacaoRepository;
  public
    [Setup] procedure SetUp;
    [TearDown] procedure TearDown;
    [Test] procedure TestSalvarComSucessoCPF;
    [Test] procedure TestSalvarComSucessoCNPJ;
    [Test] procedure TestSalvarCPFInvalido;
    [Test] procedure TestSalvarCNPJInvalido;
    [Test] procedure TestSalvarDocumentoInvalidoTamanho;
    [Test] procedure TestSalvarNomeVazio;
    [Test] procedure TestAtualizarComSucesso;
    [Test] procedure TestExcluirComSucesso;
    [Test] procedure TestObterPorId;
    [Test] procedure TestObterTodos;
    [Test] procedure TestObterPorNome;
    [Test] procedure TestObterPorCpfCnpj;
    [Test] procedure TestSalvarProdutorLimiteCreditoComSucesso;
    [Test] procedure TestSalvarProdutorLimiteCreditoValorInvalido;
    [Test] procedure TestAtualizarProdutorLimiteCreditoComSucesso;
    [Test] procedure TestAtualizarProdutorLimiteCreditoValorInvalido;
    [Test] procedure TestExcluirProdutorLimiteCreditoComSucesso;
    [Test] procedure TestObterProdutorLimiteCredito;
  end;


implementation


{ TMockProdutorRepository }

function TMockProdutorRepository.Inserir(AProdutor: TProdutor): Boolean;
begin
  FLastOperation := 'Inserir';
  AProdutor.Id := 1;
  Result := True;
end;

function TMockProdutorRepository.Atualizar(AProdutor: TProdutor): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := True;
end;

function TMockProdutorRepository.Excluir(AId: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := True;
end;

function TMockProdutorRepository.ObterPorId(AId: Integer): TProdutor;
begin
  FLastOperation := 'ObterPorId';
  Result := TProdutor.Create;
  Result.Id := AId;
  Result.Nome := 'Produtor Mock';
  Result.CpfCnpj := '52998224725';
end;

function TMockProdutorRepository.ObterTodos: TList<TProdutor>;
begin
  FLastOperation := 'ObterTodos';
  Result := TList<TProdutor>.Create;
end;

function TMockProdutorRepository.ObterPorNome(const ANome: string): TList<TProdutor>;
begin
  FLastOperation := 'ObterPorNome';
  Result := TList<TProdutor>.Create;
end;

function TMockProdutorRepository.ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
begin
  FLastOperation := 'ObterPorCpfCnpj';
  Result := TProdutor.Create;
  Result.Id := 1;
  Result.Nome := 'Produtor Mock';
  Result.CpfCnpj := ACpfCnpj;
end;

{ TMockProdutorLimiteCreditoRepository }

function TMockProdutorLimiteCreditoRepository.Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
begin
  FLastOperation := 'Inserir';
  Result := FShouldReturnTrue;
end;

function TMockProdutorLimiteCreditoRepository.Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := FShouldReturnTrue;
end;

function TMockProdutorLimiteCreditoRepository.Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := FShouldReturnTrue;
end;

function TMockProdutorLimiteCreditoRepository.ObterPorId(AId: Integer): Currency;
begin
  FLastOperation := 'ObterPorId';
  Result := 10000;
end;

function TMockProdutorLimiteCreditoRepository.ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
begin
  FLastOperation := 'ObterLimite';
  AValorLimite := 50000;
  Result := 1;
end;

function TMockProdutorLimiteCreditoRepository.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
begin
  FLastOperation := 'ObterTodosPorProdutor';
  Result := TList<TPair<Integer, Currency>>.Create;
end;

{ TMockProdutorNegociacaoRepository }

function TMockProdutorNegociacaoRepository.Inserir(ANegociacao: TNegociacao): Boolean; begin Result := True; end;
function TMockProdutorNegociacaoRepository.Atualizar(ANegociacao: TNegociacao): Boolean; begin Result := True; end;
function TMockProdutorNegociacaoRepository.Excluir(AId: Integer): Boolean; begin Result := True; end;
function TMockProdutorNegociacaoRepository.ObterPorId(AId: Integer): TNegociacao; begin Result := nil; end;
function TMockProdutorNegociacaoRepository.ObterTodos: TList<TNegociacao>; begin Result := TList<TNegociacao>.Create; end;
function TMockProdutorNegociacaoRepository.ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>; begin Result := TList<TNegociacao>.Create; end;
function TMockProdutorNegociacaoRepository.ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>; begin Result := TList<TNegociacao>.Create; end;
function TMockProdutorNegociacaoRepository.ObterPorStatus(AStatus: Integer): TList<TNegociacao>; begin Result := TList<TNegociacao>.Create; end;
function TMockProdutorNegociacaoRepository.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency; begin Result := 0; end;

{ TProdutorServiceTest }

procedure TProdutorServiceTest.SetUp;
begin
  FMockProdutor := TMockProdutorRepository.Create;
  FMockLimite := TMockProdutorLimiteCreditoRepository.Create;
  FMockNegociacao := TMockProdutorNegociacaoRepository.Create;
  FMockLimite.ShouldReturnTrue := True;

  FService := TProdutorService.Create(FMockProdutor, FMockLimite, FMockNegociacao);
end;

procedure TProdutorServiceTest.TearDown;
begin
  FService := nil;
end;

procedure TProdutorServiceTest.TestSalvarComSucessoCPF;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Nome := 'Produtor Teste';
    LProdutor.CpfCnpj := '52998224725';
    Assert.IsTrue(FService.Salvar(LProdutor), 'Salvar deveria retornar True');
    Assert.AreEqual('Inserir', FMockProdutor.LastOperation);
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarComSucessoCNPJ;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Nome := 'Produtor Teste';
    LProdutor.CpfCnpj := '11222333000181';
    Assert.IsTrue(FService.Salvar(LProdutor), 'Salvar deveria retornar True');
    Assert.AreEqual('Inserir', FMockProdutor.LastOperation);
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarCPFInvalido;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Nome := 'Produtor Teste';
    LProdutor.CpfCnpj := '12345678902';
    Assert.WillRaise(
      procedure begin FService.Salvar(LProdutor); end,
      Exception,
      'Deveria lançar exceção para CPF inválido'
    );
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarCNPJInvalido;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Nome := 'Produtor Teste';
    LProdutor.CpfCnpj := '12345678000191';
    Assert.WillRaise(
      procedure begin FService.Salvar(LProdutor); end,
      Exception,
      'Deveria lançar exceção para CNPJ inválido'
    );
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarDocumentoInvalidoTamanho;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Nome := 'Produtor Teste';
    LProdutor.CpfCnpj := '123456789';
    Assert.WillRaise(
      procedure begin FService.Salvar(LProdutor); end,
      Exception,
      'Deveria lançar exceção para documento com tamanho inválido'
    );
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarNomeVazio;
var
  LProdutor: TProdutor;
  LErroLancado: Boolean;
begin
  LProdutor := TProdutor.Create;
  LErroLancado := False;
  try
    LProdutor.CpfCnpj := '52998224725';
    try
      LProdutor.Nome := '';
      FService.Salvar(LProdutor);
    except
      on E: Exception do
      begin
        if E.Message = 'Nome do produtor não pode ser vazio' then
          LErroLancado := True;
      end;
    end;
    Assert.IsTrue(LErroLancado);
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestAtualizarComSucesso;
var
  LProdutor: TProdutor;
begin
  LProdutor := TProdutor.Create;
  try
    LProdutor.Id := 1;
    LProdutor.Nome := 'Produtor Atualizado';
    LProdutor.CpfCnpj := '52998224725';
    Assert.IsTrue(FService.Atualizar(LProdutor), 'Atualizar deveria retornar True');
    Assert.AreEqual('Atualizar', FMockProdutor.LastOperation);
  finally
    LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestExcluirComSucesso;
begin
  Assert.IsTrue(FService.Excluir(1), 'Excluir deveria retornar True');
  Assert.AreEqual('Excluir', FMockProdutor.LastOperation);
end;

procedure TProdutorServiceTest.TestObterPorId;
var
  LProdutor: TProdutor;
begin
  LProdutor := FService.ObterPorId(1);
  try
    Assert.IsNotNull(LProdutor, 'Deveria retornar um produtor');
    Assert.AreEqual('ObterPorId', FMockProdutor.LastOperation);
  finally
    if Assigned(LProdutor) then LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestObterTodos;
var
  LLista: TList<TProdutor>;
begin
  LLista := FService.ObterTodos;
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterTodos', FMockProdutor.LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TProdutorServiceTest.TestObterPorNome;
var
  LLista: TList<TProdutor>;
begin
  LLista := FService.ObterPorNome('Teste');
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterPorNome', FMockProdutor.LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TProdutorServiceTest.TestObterPorCpfCnpj;
var
  LProdutor: TProdutor;
begin
  LProdutor := FService.ObterPorCpfCnpj('12345678901');
  try
    Assert.IsNotNull(LProdutor, 'Deveria retornar um produtor');
    Assert.AreEqual('ObterPorCpfCnpj', FMockProdutor.LastOperation);
  finally
    if Assigned(LProdutor) then LProdutor.Free;
  end;
end;

procedure TProdutorServiceTest.TestSalvarProdutorLimiteCreditoComSucesso;
begin
  Assert.IsTrue(FService.SalvarProdutorLimiteCredito(1, 1, 50000), 'SalvarProdutorLimiteCredito deveria retornar True');
  Assert.AreEqual('Inserir', FMockLimite.LastOperation);
end;

procedure TProdutorServiceTest.TestSalvarProdutorLimiteCreditoValorInvalido;
begin
  Assert.WillRaise(
    procedure begin FService.SalvarProdutorLimiteCredito(1, 1, 0); end,
    Exception,
    'Deveria lançar exceção para valor de limite inválido'
  );
end;

procedure TProdutorServiceTest.TestAtualizarProdutorLimiteCreditoComSucesso;
begin
  Assert.IsTrue(FService.AtualizarProdutorLimiteCredito(1, 1, 60000), 'AtualizarProdutorLimiteCredito deveria retornar True');
  Assert.AreEqual('Atualizar', FMockLimite.LastOperation);
end;

procedure TProdutorServiceTest.TestAtualizarProdutorLimiteCreditoValorInvalido;
begin
  Assert.WillRaise(
    procedure begin FService.AtualizarProdutorLimiteCredito(1, 1, -100); end,
    Exception,
    'Deveria lançar exceção para valor de limite inválido'
  );
end;

procedure TProdutorServiceTest.TestExcluirProdutorLimiteCreditoComSucesso;
begin
  Assert.IsTrue(FService.ExcluirProdutorLimiteCredito(1, 1), 'ExcluirProdutorLimiteCredito deveria retornar True');
  Assert.AreEqual('Excluir', FMockLimite.LastOperation);
end;

procedure TProdutorServiceTest.TestObterProdutorLimiteCredito;
var
  LId: Integer;
  LValor, LExpected: Currency;
begin
  LId := FService.ObterProdutorLimiteCredito(1, 1, LValor);
  LExpected := 50000;

  Assert.AreEqual(1, LId, 'Deveria retornar ID 1');
  Assert.IsTrue(LValor = LExpected, 'Deveria retornar valor 50000');
  Assert.AreEqual('ObterLimite', FMockLimite.LastOperation);
end;

initialization
  TDUnitX.RegisterTestFixture(TProdutorServiceTest);

end.

