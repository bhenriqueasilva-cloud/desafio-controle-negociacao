unit Infra.Data.Interfaces.IProdutoRepository;

interface

uses
  Core.Entities.Produto,
  System.Generics.Collections;

type
  IProdutoRepository = interface
    ['{230C0307-01D9-45A8-B2BB-A63DB29B76F2}']
    function Inserir(AProduto: TProduto): Boolean;
    function Atualizar(AProduto: TProduto): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProduto;
    function ObterTodos: TList<TProduto>;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
    function ObterPorNome(const ANome: string): TList<TProduto>;
  end;

implementation

end.
