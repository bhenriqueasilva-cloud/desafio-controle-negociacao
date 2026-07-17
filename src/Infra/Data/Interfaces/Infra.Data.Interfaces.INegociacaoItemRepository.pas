unit Infra.Data.Interfaces.INegociacaoItemRepository;

interface

uses
  Core.Entities.NegociacaoItem,
  System.Generics.Collections;

type
  INegociacaoItemRepository = interface
    ['{4D304ADF-3024-4786-BF6B-E7D31944F918}']
    function Inserir(AItem: TNegociacaoItem): Boolean;
    function Atualizar(AItem: TNegociacaoItem): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacaoItem;
    function ObterPorNegociacao(AIdNegociacao: Integer): TList<TNegociacaoItem>;
    function ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
  end;

implementation

end.
