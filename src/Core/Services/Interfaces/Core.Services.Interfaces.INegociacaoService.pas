unit Core.Services.Interfaces.INegociacaoService;

interface

uses
  Core.Entities.Negociacao,
  System.Generics.Collections;

type
  INegociacaoService = interface
    ['{1A953D89-D4F9-42D4-AAFD-1731D74E6407}']
    function Salvar(ANegociacao: TNegociacao): Boolean;
    function Atualizar(ANegociacao: TNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacao;
    function ObterTodos: TList<TNegociacao>;
    function ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
    function ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
    function AprovarNegociacao(AId: Integer): Boolean;
    function ConcluirNegociacao(AId: Integer): Boolean;
    function CancelarNegociacao(AId: Integer): Boolean;
  end;

implementation

end.
