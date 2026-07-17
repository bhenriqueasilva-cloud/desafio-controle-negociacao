unit Core.Services.RelatorioServiceTest;

interface

uses
  DUnitX.TestFramework,
  Core.Services.Interfaces.IRelatorioService,
  Core.Services.Impl.RelatorioService;

type
  [TestFixture]
  TRelatorioServiceTest = class
  public
    [Test]
    procedure TestCriarServico;
  end;

implementation

{ TRelatorioServiceTest }

procedure TRelatorioServiceTest.TestCriarServico;
var
  LService: IRelatorioService;
begin
  LService := TRelatorioService.Create;
  Assert.IsNotNull(LService, 'Deveria criar a instância do serviço');
end;

initialization
  TDUnitX.RegisterTestFixture(TRelatorioServiceTest);

end.
