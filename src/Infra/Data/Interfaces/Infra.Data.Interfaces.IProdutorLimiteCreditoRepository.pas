unit Infra.Data.Interfaces.IProdutorLimiteCreditoRepository;

interface

uses
  System.Generics.Collections;

type
  IProdutorLimiteCreditoRepository = interface
    ['{A177A6CC-E71C-4587-845C-0CECFCA1E6CC}']
    function Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function ObterPorId(AId: Integer): Currency;
    function ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
  end;

implementation

end.
