unit Core.Services.Interfaces.IValidacaoCreditoService;

interface

type
  IValidacaoCreditoService = interface
    ['{790EF6E7-C0BC-4F27-9094-AA3FE3468928}']
    function ValidarCredito(AIdProdutor, AIdDistribuidor: Integer; AValorNegociacao: Currency): Boolean;
    function ObterLimiteDisponivel(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterLimiteTotal(AIdProdutor, AIdDistribuidor: Integer): Currency;
    function ObterValorUtilizado(AIdProdutor, AIdDistribuidor: Integer): Currency;
  end;

implementation

end.
