unit Infra.Data.Interfaces.IItemNegociacaoRepository;

interface

uses
  Core.Entities.ItemNegociacao,
  System.Generics.Collections;

type
  IItemNegociacaoRepository = interface
    ['']
    function Inserir(AItem: TItemNegociacao): Boolean;
    function Atualizar(AItem: TItemNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TItemNegociacao;
    function ObterPorNegociacao(AIdNegociacao: Integer): TList<TItemNegociacao>;
    function ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
  end;

implementation

end.
