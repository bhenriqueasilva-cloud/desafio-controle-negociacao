unit Core.Services.Interfaces.IProdutoService;

interface

uses
  System.Generics.Collections,
  Core.Entities.Produto;

type
  IProdutoService = interface
    ['{AB7E875F-16FE-4490-BC44-A03E3D13C7C0}']
    function Salvar(AProduto: TProduto): Boolean;
    function Atualizar(AProduto: TProduto): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProduto;
    function ObterTodos: TList<TProduto>;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
    function ObterPorNome(const ANome: string): TList<TProduto>;
  end;

implementation

end.
