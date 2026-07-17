unit Infra.Data.Interfaces.INegociacaoRepository;

interface

uses
  Core.Entities.Negociacao,
  System.Generics.Collections;

type
  INegociacaoRepository = interface
    ['{2073E234-236E-428C-AABA-28203CC2353E}']
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

implementation

end.
