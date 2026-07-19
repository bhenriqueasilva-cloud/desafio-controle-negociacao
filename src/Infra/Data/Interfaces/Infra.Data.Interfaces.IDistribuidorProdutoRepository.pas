unit Infra.Data.Interfaces.IDistribuidorProdutoRepository;

interface

uses
  System.Generics.Collections;

type
  TRecordDistribuidorProduto = record
    Id: Integer;
    IdDistribuidor: Integer;
    IdProduto: Integer;
    ValorProduto: Currency;
  end;

  IDistribuidorProdutoRepository = interface
    ['{CDD8CCC1-8929-4646-8B31-4835EB7646B6}']
    function Inserir(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Atualizar(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Excluir(AIdDistribuidor, AIdProduto: Integer): Boolean;
    function ObterPorId(AId: Integer; out AValorProduto: Currency): Integer;
    function ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TRecordDistribuidorProduto>;
    function PossuiProdutos(AIdDistribuidor: Integer): Boolean;
  end;

implementation

end.
