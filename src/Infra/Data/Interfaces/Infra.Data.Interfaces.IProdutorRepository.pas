unit Infra.Data.Interfaces.IProdutorRepository;

interface

uses
  Core.Entities.Produtor,
  System.Generics.Collections;

type
  IProdutorRepository = interface
    ['{1CBC28D0-4641-42D5-8F3A-14C0DD4988DA}']
    function Inserir(AProdutor: TProdutor): Boolean;
    function Atualizar(AProdutor: TProdutor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProdutor;
    function ObterTodos: TList<TProdutor>;
    function ObterPorNome(const ANome: string): TList<TProdutor>;
    function ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
  end;

implementation

end.
