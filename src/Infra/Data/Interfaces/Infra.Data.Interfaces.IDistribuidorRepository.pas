unit Infra.Data.Interfaces.IDistribuidorRepository;

interface

uses
  Core.Entities.Distribuidor,
  System.Generics.Collections;

type
  IDistribuidorRepository = interface
    ['{8E7CCEB8-5DD8-4398-AE13-D00D4D6F83CB}']
    function Inserir(ADistribuidor: TDistribuidor): Boolean;
    function Atualizar(ADistribuidor: TDistribuidor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TDistribuidor;
    function ObterTodos: TList<TDistribuidor>;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
    function ObterPorNome(const ANome: string): TList<TDistribuidor>;
    function ObterPorCnpj(const ACnpj: string): TDistribuidor;
  end;

implementation

end.
