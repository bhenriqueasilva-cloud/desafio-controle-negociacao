unit Core.Services.Impl.ProdutoService;

interface

uses
  System.Generics.Collections,
  Core.Services.Interfaces.IProdutoService,
  Core.Entities.Produto,
  Infra.Data.Interfaces.IProdutoRepository;

type
  TProdutoService = class(TInterfacedObject, IProdutoService)
  private
    FProdutoRepository: IProdutoRepository;
  public
    constructor Create(AProdutoRepository: IProdutoRepository);
    function Salvar(AProduto: TProduto): Boolean;
    function Atualizar(AProduto: TProduto): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProduto;
    function ObterTodos: TList<TProduto>;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
    function ObterPorNome(const ANome: string): TList<TProduto>;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutoService.Create(AProdutoRepository: IProdutoRepository);
begin
  inherited Create;
  FProdutoRepository := AProdutoRepository;
end;

function TProdutoService.Salvar(AProduto: TProduto): Boolean;
begin
  AProduto.Validar;
  if AProduto.PrecoVenda <= 0 then
    raise Exception.Create('Preço de venda deve ser maior que zero');
  Result := FProdutoRepository.Inserir(AProduto);
end;

function TProdutoService.Atualizar(AProduto: TProduto): Boolean;
begin
  AProduto.Validar;
  Result := FProdutoRepository.Atualizar(AProduto);
end;

function TProdutoService.Excluir(AId: Integer): Boolean;
begin
  Result := FProdutoRepository.Excluir(AId);
end;

function TProdutoService.ObterPorId(AId: Integer): TProduto;
begin
  Result := FProdutoRepository.ObterPorId(AId);
end;

function TProdutoService.ObterTodos: TList<TProduto>;
begin
  Result := FProdutoRepository.ObterTodos;
end;

function TProdutoService.ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
begin
  Result := FProdutoRepository.ObterTodosPorDistribuidor(AIdDistribuidor);
end;

function TProdutoService.ObterPorNome(const ANome: string): TList<TProduto>;
begin
  Result := FProdutoRepository.ObterPorNome(ANome);
end;

end.

