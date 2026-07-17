unit Core.Services.DistribuidorServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.IDistribuidorService,
  Core.Services.Impl.DistribuidorService,
  Infra.Data.Interfaces.IDistribuidorRepository,
  Infra.Data.Interfaces.IDistribuidorProdutoRepository,
  Core.Entities.Distribuidor,
  System.Generics.Collections,
  Core.Exceptions.ValidacaoException,
  System.SysUtils;

type
  TMockDistribuidorRepository = class(TInterfacedObject, IDistribuidorRepository)
  private
    FDistribuidores: TList<TDistribuidor>;
    FLastOperation: string;
  public
    constructor Create;
    destructor Destroy; override;
    property LastOperation: string read FLastOperation;
    function Inserir(ADistribuidor: TDistribuidor): Boolean;
    function Atualizar(ADistribuidor: TDistribuidor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TDistribuidor;
    function ObterTodos: TList<TDistribuidor>;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
    function ObterPorNome(const ANome: string): TList<TDistribuidor>;
    function ObterPorCnpj(const ACnpj: string): TDistribuidor;
  end;

  TMockDistribuidorProdutoRepository = class(TInterfacedObject, IDistribuidorProdutoRepository)
  private
    FLastOperation: string;
    FShouldReturnTrue: Boolean;
  public
    property LastOperation: string read FLastOperation;
    property ShouldReturnTrue: Boolean read FShouldReturnTrue write FShouldReturnTrue;
    function Inserir(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Atualizar(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Excluir(AIdDistribuidor, AIdProduto: Integer): Boolean;
    function ObterPorId(AId: Integer; out AValorProduto: Currency): Integer;
    function ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TRecordDistribuidorProduto>;
  end;

  [TestFixture]
  TDistribuidorServiceTest = class
  private
    FService: IDistribuidorService;
    FMockDistribuidor: TMockDistribuidorRepository;
    FMockProduto: TMockDistribuidorProdutoRepository;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test] procedure TestSalvarComSucesso;
    [Test] procedure TestSalvarCNPJInvalido;
    [Test] procedure TestSalvarNomeVazio;
    [Test] procedure TestAtualizarComSucesso;
    [Test] procedure TestExcluirComSucesso;
    [Test] procedure TestObterPorId;
    [Test] procedure TestObterTodos;
    [Test] procedure TestObterPorNome;
    [Test] procedure TestObterPorCnpj;
    [Test] procedure TestObterTodosPorProdutor;
    [Test] procedure TestSalvarDistribuidorProdutos;
    [Test] procedure TestAtualizarDistribuidorProdutos;
    [Test] procedure TestExcluirDistribuidorProduto;
    [Test] procedure TestObterDistribuidorProdutos;
  end;

implementation

{ TMockDistribuidorRepository }

{ TMockDistribuidorRepository }

constructor TMockDistribuidorRepository.Create;
begin
  inherited;
  FDistribuidores := TList<TDistribuidor>.Create;
end;

destructor TMockDistribuidorRepository.Destroy;
var
  LDistribuidor: TDistribuidor;
begin
  for LDistribuidor in FDistribuidores do
    if Assigned(LDistribuidor) then LDistribuidor.Free;
  FDistribuidores.Free;
  inherited;
end;

function TMockDistribuidorRepository.Inserir(ADistribuidor: TDistribuidor): Boolean;
begin
  FLastOperation := 'Inserir';
  ADistribuidor.Id := FDistribuidores.Count + 1;
  Result := True;
end;

function TMockDistribuidorRepository.Atualizar(ADistribuidor: TDistribuidor): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := True;
end;

function TMockDistribuidorRepository.Excluir(AId: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := True;
end;

function TMockDistribuidorRepository.ObterPorId(AId: Integer): TDistribuidor;
begin
  FLastOperation := 'ObterPorId';
  if (AId > 0) and (AId <= FDistribuidores.Count) then
    Result := FDistribuidores[AId - 1]
  else
  begin
    Result := TDistribuidor.Create;
    Result.Id := AId;
    Result.Nome := 'Distribuidor Mock';
    Result.Cnpj := '11222333000181';
  end;
end;

function TMockDistribuidorRepository.ObterTodos: TList<TDistribuidor>;
begin
  FLastOperation := 'ObterTodos';
  Result := TList<TDistribuidor>.Create;
end;

function TMockDistribuidorRepository.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
begin
  FLastOperation := 'ObterTodosPorProdutor';
  Result := TList<TDistribuidor>.Create;
end;

function TMockDistribuidorRepository.ObterPorNome(const ANome: string): TList<TDistribuidor>;
begin
  FLastOperation := 'ObterPorNome';
  Result := TList<TDistribuidor>.Create;
end;

function TMockDistribuidorRepository.ObterPorCnpj(const ACnpj: string): TDistribuidor;
begin
  FLastOperation := 'ObterPorCnpj';
  Result := TDistribuidor.Create;
  Result.Id := 1;
  Result.Nome := 'Distribuidor Mock';
  Result.Cnpj := ACnpj;
end;

{ TMockDistribuidorProdutoRepository }

function TMockDistribuidorProdutoRepository.Inserir(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
begin
  FLastOperation := 'Inserir';
  Result := FShouldReturnTrue;
end;

function TMockDistribuidorProdutoRepository.Atualizar(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := FShouldReturnTrue;
end;

function TMockDistribuidorProdutoRepository.Excluir(AIdDistribuidor, AIdProduto: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := FShouldReturnTrue;
end;

function TMockDistribuidorProdutoRepository.ObterPorId(AId: Integer; out AValorProduto: Currency): Integer;
begin
  FLastOperation := 'ObterPorId';
  AValorProduto := 100;
  Result := 1;
end;

function TMockDistribuidorProdutoRepository.ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
begin
  FLastOperation := 'ObterPorDistribuidorProdutor';
  AValorProduto := 150;
  Result := 1;
end;

function TMockDistribuidorProdutoRepository.ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TRecordDistribuidorProduto>;
begin
  FLastOperation := 'ObterTodosPorDistribuidor';
  Result := TList<TRecordDistribuidorProduto>.Create;
end;

{ TDistribuidorServiceTest }

procedure TDistribuidorServiceTest.SetUp;
begin
  FMockDistribuidor := TMockDistribuidorRepository.Create;
  FMockProduto := TMockDistribuidorProdutoRepository.Create;
  FMockProduto.ShouldReturnTrue := True;
  FService := TDistribuidorService.Create(FMockDistribuidor, FMockProduto);
end;

procedure TDistribuidorServiceTest.TearDown;
begin
  FService := nil;
end;

procedure TDistribuidorServiceTest.TestSalvarComSucesso;
var
  LDistribuidor: TDistribuidor;
begin
  LDistribuidor := TDistribuidor.Create;
  try
    LDistribuidor.Nome := 'Distribuidor Teste';
    LDistribuidor.Cnpj := '11222333000181';
    Assert.IsTrue(FService.Salvar(LDistribuidor), 'Salvar deveria retornar True');
    Assert.AreEqual('Inserir', FMockDistribuidor.LastOperation);
  finally
    LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestSalvarCNPJInvalido;
var
  LDistribuidor: TDistribuidor;
begin
  LDistribuidor := TDistribuidor.Create;
  try
    LDistribuidor.Nome := 'Distribuidor Teste';
    LDistribuidor.Cnpj := '12345678000191';
    Assert.WillRaise(
      procedure begin FService.Salvar(LDistribuidor); end,
      Exception,
      'Deveria lançar exceção para CNPJ inválido'
    );
  finally
    LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestSalvarNomeVazio;
var
  LDistribuidor: TDistribuidor;
  LErroLancado: Boolean;
begin
  LDistribuidor := TDistribuidor.Create;
  LErroLancado := False;
  try
    try
      LDistribuidor.Nome := '';
      LDistribuidor.Cnpj := '11222333000181';
      FService.Salvar(LDistribuidor);
    except
      on E: Exception do
      begin
        if E.Message = 'Nome do distribuidor não pode ser vazio' then
          LErroLancado := True;
      end;
    end;

    Assert.IsTrue(LErroLancado, 'Deveria ter disparado EValidacaoException ao atribuir nome vazio');
  finally
    LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestAtualizarComSucesso;
var
  LDistribuidor: TDistribuidor;
begin
  LDistribuidor := TDistribuidor.Create;
  try
    LDistribuidor.Id := 1;
    LDistribuidor.Nome := 'Distribuidor Atualizado';
    LDistribuidor.Cnpj := '11222333000181';
    Assert.IsTrue(FService.Atualizar(LDistribuidor), 'Atualizar deveria retornar True');
    Assert.AreEqual('Atualizar', FMockDistribuidor.LastOperation);
  finally
    LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestExcluirComSucesso;
begin
  Assert.IsTrue(FService.Excluir(1), 'Excluir deveria retornar True');
  Assert.AreEqual('Excluir', FMockDistribuidor.LastOperation);
end;

procedure TDistribuidorServiceTest.TestObterPorId;
var
  LDistribuidor: TDistribuidor;
begin
  LDistribuidor := FService.ObterPorId(1);
  try
    Assert.IsNotNull(LDistribuidor, 'Deveria retornar um distribuidor');
    Assert.AreEqual('ObterPorId', FMockDistribuidor.LastOperation);
  finally
    if Assigned(LDistribuidor) then LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestObterTodos;
var
  LLista: TList<TDistribuidor>;
begin
  LLista := FService.ObterTodos;
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterTodos', FMockDistribuidor.LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestObterPorNome;
var
  LLista: TList<TDistribuidor>;
begin
  LLista := FService.ObterPorNome('Teste');
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterPorNome', FMockDistribuidor.LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestObterPorCnpj;
var
  LDistribuidor: TDistribuidor;
begin
  LDistribuidor := FService.ObterPorCnpj('12345678000190');
  try
    Assert.IsNotNull(LDistribuidor, 'Deveria retornar um distribuidor');
    Assert.AreEqual('ObterPorCnpj', FMockDistribuidor.LastOperation);
  finally
    if Assigned(LDistribuidor) then LDistribuidor.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestObterTodosPorProdutor;
var
  LLista: TList<TDistribuidor>;
begin
  LLista := FService.ObterTodosPorProdutor(1);
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterTodosPorProdutor', FMockDistribuidor.LastOperation);
  finally
    if Assigned(LLista) then LLista.Free;
  end;
end;

procedure TDistribuidorServiceTest.TestSalvarDistribuidorProdutos;
begin
  Assert.IsTrue(FService.SalvarDistribuidorProdutos(1, 2, 100), 'Deveria retornar True');
  Assert.AreEqual('Inserir', FMockProduto.LastOperation);
end;

procedure TDistribuidorServiceTest.TestAtualizarDistribuidorProdutos;
begin
  Assert.IsTrue(FService.AtualizarDistribuidorProdutos(1, 1, 2, 150), 'Deveria retornar True');
  Assert.AreEqual('Atualizar', FMockProduto.LastOperation);
end;

procedure TDistribuidorServiceTest.TestExcluirDistribuidorProduto;
begin
  Assert.IsTrue(FService.ExcluirDistribuidorProduto(1, 2), 'Deveria retornar True');
  Assert.AreEqual('Excluir', FMockProduto.LastOperation);
end;

procedure TDistribuidorServiceTest.TestObterDistribuidorProdutos;
var
  LId: Integer;
  LValor, LExpected: Currency;
begin
  LId := FService.ObterDistribuidorProdutos(1, 2, LValor);
  LExpected := 150;
  Assert.AreEqual(1, LId, 'Deveria retornar ID 1');
  Assert.IsTrue(LValor = LExpected, 'Deveria retornar valor 150');
  Assert.AreEqual('ObterPorDistribuidorProdutor', FMockProduto.LastOperation);
end;

initialization
  TDUnitX.RegisterTestFixture(TDistribuidorServiceTest);
end.

