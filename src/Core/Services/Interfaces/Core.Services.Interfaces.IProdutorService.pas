unit Core.Services.Interfaces.IProdutorService;

interface

uses
  System.Generics.Collections,
  Core.Entities.Produtor;

type
  IProdutorService = interface
    ['{F1233207-2427-4D17-A6FE-922F42E02D1A}']
    function Salvar(AProdutor: TProdutor): Boolean;
    function Atualizar(AProdutor: TProdutor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProdutor;
    function ObterTodos: TList<TProdutor>;
    function ObterPorNome(const ANome: string): TList<TProdutor>;
    function ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;

    function ObterProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
    function SalvarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
    function AtualizarProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer; AValorLimite: Currency): Boolean;
    function ExcluirProdutorLimiteCredito(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function PossuiDistribuidores(AIdProdutor: Integer): Boolean;
  end;

implementation

end.
