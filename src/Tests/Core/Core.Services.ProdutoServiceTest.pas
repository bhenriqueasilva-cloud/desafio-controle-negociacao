unit Core.Services.ProdutoServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.IProdutoService,
  Core.Services.Impl.ProdutoService,
  Infra.Data.Interfaces.IProdutoRepository,
  Core.Entities.Produto,
  System.Generics.Collections,
  Core.Exceptions.ValidacaoException,
  System.SysUtils;

type
  TMockProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  private
    FProdutos: TList<TProduto>;
    FLastOperation: string;
  public
    constructor Create;
    destructor Destroy; override;
    property LastOperation: string read FLastOperation;
    
    function Inserir(AProduto: TProduto): Boolean;
    function Atualizar(AProduto: TProduto): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProduto;
    function ObterTodos: TList<TProduto>;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
    function ObterPorNome(const ANome: string): TList<TProduto>;
  end;

  [TestFixture]
  TProdutoServiceTest = class
  private
    FService: IProdutoService;
    FMockRepository: TMockProdutoRepository;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;

    [Test] procedure TestSalvarComSucesso;
    [Test] procedure TestSalvarPrecoVendaInvalido;
    [Test] procedure TestSalvarNomeVazio;
    [Test] procedure TestAtualizarComSucesso;
    [Test] procedure TestExcluirComSucesso;
    [Test] procedure TestObterPorId;
    [Test] procedure TestObterTodos;
    [Test] procedure TestObterTodosPorDistribuidor;
    [Test] procedure TestObterPorNome;
  end;

implementation

{ TMockProdutoRepository }

constructor TMockProdutoRepository.Create;
begin
  inherited;
  FProdutos := TList<TProduto>.Create;
end;

destructor TMockProdutoRepository.Destroy;
var
  LProduto: TProduto;
begin
  for LProduto in FProdutos do
    if Assigned(LProduto) then
      LProduto.Free;
  FProdutos.Free;
  inherited;
end;

function TMockProdutoRepository.Inserir(AProduto: TProduto): Boolean;
begin
  FLastOperation := 'Inserir';
  AProduto.Id := FProdutos.Count + 1;
  Result := True;
end;

function TMockProdutoRepository.Atualizar(AProduto: TProduto): Boolean;
begin
  FLastOperation := 'Atualizar';
  Result := True;
end;

function TMockProdutoRepository.Excluir(AId: Integer): Boolean;
begin
  FLastOperation := 'Excluir';
  Result := True;
end;

function TMockProdutoRepository.ObterPorId(AId: Integer): TProduto;
begin
  FLastOperation := 'ObterPorId';
  if (AId > 0) and (AId <= FProdutos.Count) then
    Result := FProdutos[AId - 1]
  else
  begin
    Result := TProduto.Create;
    Result.Id := AId;
    Result.Nome := 'Produto Mock';
    Result.PrecoVenda := 100.50;
  end;
end;

function TMockProdutoRepository.ObterTodos: TList<TProduto>;
begin
  FLastOperation := 'ObterTodos';
  Result := TList<TProduto>.Create;
end;

function TMockProdutoRepository.ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
begin
  FLastOperation := 'ObterTodosPorDistribuidor';
  Result := TList<TProduto>.Create;
end;

function TMockProdutoRepository.ObterPorNome(const ANome: string): TList<TProduto>;
begin
  FLastOperation := 'ObterPorNome';
  Result := TList<TProduto>.Create;
end;

{ TProdutoServiceTest }

procedure TProdutoServiceTest.SetUp;
begin
  FMockRepository := TMockProdutoRepository.Create;
  FService := TProdutoService.Create(FMockRepository);
end;

procedure TProdutoServiceTest.TearDown;
begin
  FService := nil;
end;

procedure TProdutoServiceTest.TestSalvarComSucesso;
var
  LProduto: TProduto;
begin
  LProduto := TProduto.Create;
  try
    LProduto.Nome := 'Produto Teste';
    LProduto.PrecoVenda := 100.50;
    
    Assert.IsTrue(FService.Salvar(LProduto), 'Salvar deveria retornar True');
    Assert.AreEqual('Inserir', FMockRepository.LastOperation, 'Deveria chamar Inserir');
  finally
    LProduto.Free;
  end;
end;

procedure TProdutoServiceTest.TestSalvarPrecoVendaInvalido;
var
  LProduto: TProduto;
  LErroLancado: Boolean;
begin
  LProduto := TProduto.Create;
  LErroLancado := False;
  try
    LProduto.Nome := 'Produto Teste';

    try
      LProduto.PrecoVenda := 0.0;
      FService.Salvar(LProduto);
    except
      on E: Exception do
      begin
        if E.Message = 'Preço de venda deve ser maior que zero' then
          LErroLancado := True;
      end;
    end;

    Assert.IsTrue(LErroLancado, 'Deveria ter disparado EValidacaoException ao atribuir preco zero');
  finally
    LProduto.Free;
  end;
end;

procedure TProdutoServiceTest.TestSalvarNomeVazio;
var
  LProduto: TProduto;
  LErroLancado: Boolean;
begin
  LProduto := TProduto.Create;
  LErroLancado := False;
  try
    LProduto.PrecoVenda := 100.50;

    try
      LProduto.Nome := '';
      FService.Salvar(LProduto);
    except
      on E: Exception do
      begin
        if E.Message = 'Nome do produto não pode ser vazio' then
          LErroLancado := True;
      end;
    end;

    Assert.IsTrue(LErroLancado, 'Deveria ter disparado EValidacaoException ao atribuir nome vazio');
  finally
    LProduto.Free;
  end;
end;

procedure TProdutoServiceTest.TestAtualizarComSucesso;
var
  LProduto: TProduto;
begin
  LProduto := TProduto.Create;
  try
    LProduto.Id := 1;
    LProduto.Nome := 'Produto Atualizado';
    LProduto.PrecoVenda := 150.75;
    
    Assert.IsTrue(FService.Atualizar(LProduto), 'Atualizar deveria retornar True');
    Assert.AreEqual('Atualizar', FMockRepository.LastOperation, 'Deveria chamar Atualizar');
  finally
    LProduto.Free;
  end;
end;

procedure TProdutoServiceTest.TestExcluirComSucesso;
begin
  Assert.IsTrue(FService.Excluir(1), 'Excluir deveria retornar True');
  Assert.AreEqual('Excluir', FMockRepository.LastOperation, 'Deveria chamar Excluir');
end;

procedure TProdutoServiceTest.TestObterPorId;
var
  LProduto: TProduto;
begin
  LProduto := FService.ObterPorId(1);
  try
    Assert.IsNotNull(LProduto, 'Deveria retornar um produto');
    Assert.AreEqual('ObterPorId', FMockRepository.LastOperation, 'Deveria chamar ObterPorId');
  finally
    LProduto.Free;
  end;
end;

procedure TProdutoServiceTest.TestObterTodos;
var
  LLista: TList<TProduto>;
begin
  LLista := FService.ObterTodos;
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterTodos', FMockRepository.LastOperation, 'Deveria chamar ObterTodos');
  finally
    LLista.Free;
  end;
end;

procedure TProdutoServiceTest.TestObterTodosPorDistribuidor;
var
  LLista: TList<TProduto>;
begin
  LLista := FService.ObterTodosPorDistribuidor(1);
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterTodosPorDistribuidor', FMockRepository.LastOperation, 'Deveria chamar ObterTodosPorDistribuidor');
  finally
    LLista.Free;
  end;
end;

procedure TProdutoServiceTest.TestObterPorNome;
var
  LLista: TList<TProduto>;
begin
  LLista := FService.ObterPorNome('Teste');
  try
    Assert.IsNotNull(LLista, 'Deveria retornar uma lista');
    Assert.AreEqual('ObterPorNome', FMockRepository.LastOperation, 'Deveria chamar ObterPorNome');
  finally
    LLista.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TProdutoServiceTest);

end.
