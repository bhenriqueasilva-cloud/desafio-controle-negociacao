unit Core.Services.Interfaces.IDistribuidorService;

interface

uses
  System.Generics.Collections,
  Core.Entities.Distribuidor;

type
  IDistribuidorService = interface
    ['{9B973E4F-31E5-42B7-AD70-66705A5253DF}']
    function Salvar(ADistribuidor: TDistribuidor): Boolean;
    function Atualizar(ADistribuidor: TDistribuidor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TDistribuidor;
    function ObterTodos: TList<TDistribuidor>;
    function ObterPorNome(const ANome: string): TList<TDistribuidor>;
    function ObterPorCnpj(const ACnpj: string): TDistribuidor;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
    function ObterDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency) : Integer;
    function SalvarDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency) : Boolean;
    function AtualizarDistribuidorProdutos(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency) : Boolean;
    function ExcluirDistribuidorProduto(AIdDistribuidor, AIdProduto: Integer): Boolean;
  end;

implementation

end.
