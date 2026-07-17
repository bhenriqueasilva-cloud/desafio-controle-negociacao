    program ControleNegociacoesTests;

{$APPTYPE GUI}
{$STRONGLINKTYPES ON}

uses
  Vcl.Forms,
  DUnitX.TestFramework,
  DUnitX.Loggers.GUI.VCL,
  Core.Services.ValidacaoCreditoServiceTest in 'Core\Core.Services.ValidacaoCreditoServiceTest.pas',
  Core.Services.DistribuidorServiceTest in 'Core\Core.Services.DistribuidorServiceTest.pas',
  Core.Services.NegociacaoServiceTest in 'Core\Core.Services.NegociacaoServiceTest.pas',
  Core.Services.ProdutoServiceTest in 'Core\Core.Services.ProdutoServiceTest.pas',
  Core.Services.ProdutorServiceTest in 'Core\Core.Services.ProdutorServiceTest.pas',
  Core.Services.RelatorioServiceTest in 'Core\Core.Services.RelatorioServiceTest.pas',
  Core.Entities.Negociacao in '..\Core\Entities\Core.Entities.Negociacao.pas',
  Core.Entities.NegociacaoItem in '..\Core\Entities\Core.Entities.NegociacaoItem.pas',
  Core.Entities.Produtor in '..\Core\Entities\Core.Entities.Produtor.pas',
  Core.Entities.Distribuidor in '..\Core\Entities\Core.Entities.Distribuidor.pas',
  Core.Entities.Produto in '..\Core\Entities\Core.Entities.Produto.pas',
  Core.Entities.CadastroBase in '..\Core\Entities\Core.Entities.CadastroBase.pas',
  Core.Enums.TipoStatus in '..\Core\Enums\Core.Enums.TipoStatus.pas',
  Core.Exceptions.NegociacaoNaoEncontradaException in '..\Core\Exceptions\Core.Exceptions.NegociacaoNaoEncontradaException.pas',
  Core.Exceptions.ValidacaoException in '..\Core\Exceptions\Core.Exceptions.ValidacaoException.pas',
  Core.Exceptions.CreditoExcedidoException in '..\Core\Exceptions\Core.Exceptions.CreditoExcedidoException.pas',
  Infra.Data.Interfaces.INegociacaoRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.INegociacaoRepository.pas',
  Infra.Data.Interfaces.INegociacaoItemRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.INegociacaoItemRepository.pas',
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutorLimiteCreditoRepository.pas',
  Infra.Data.Interfaces.IDistribuidorRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.IDistribuidorRepository.pas',
  Infra.Data.Interfaces.IDistribuidorProdutoRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.IDistribuidorProdutoRepository.pas',
  Infra.Data.Interfaces.IProdutoRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutoRepository.pas',
  Infra.Data.Interfaces.IProdutorRepository in '..\Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutorRepository.pas',
  Core.Services.Interfaces.IValidacaoCreditoService in '..\Core\Services\Interfaces\Core.Services.Interfaces.IValidacaoCreditoService.pas',
  Core.Services.Interfaces.IDistribuidorService in '..\Core\Services\Interfaces\Core.Services.Interfaces.IDistribuidorService.pas',
  Core.Services.Interfaces.INegociacaoService in '..\Core\Services\Interfaces\Core.Services.Interfaces.INegociacaoService.pas',
  Core.Services.Interfaces.IProdutoService in '..\Core\Services\Interfaces\Core.Services.Interfaces.IProdutoService.pas',
  Core.Services.Interfaces.IProdutorService in '..\Core\Services\Interfaces\Core.Services.Interfaces.IProdutorService.pas',
  Core.Services.Interfaces.IRelatorioService in '..\Core\Services\Interfaces\Core.Services.Interfaces.IRelatorioService.pas',
  Core.Services.Impl.ValidacaoCreditoService in '..\Core\Services\Impl\Core.Services.Impl.ValidacaoCreditoService.pas',
  Core.Services.Impl.DistribuidorService in '..\Core\Services\Impl\Core.Services.Impl.DistribuidorService.pas',
  Core.Services.Impl.NegociacaoService in '..\Core\Services\Impl\Core.Services.Impl.NegociacaoService.pas',
  Core.Services.Impl.ProdutoService in '..\Core\Services\Impl\Core.Services.Impl.ProdutoService.pas',
  Core.Services.Impl.ProdutorService in '..\Core\Services\Impl\Core.Services.Impl.ProdutorService.pas',
  Core.Services.Impl.RelatorioService in '..\Core\Services\Impl\Core.Services.Impl.RelatorioService.pas',
  Infra.CrossCutting.Validation.CNPJValidator in '..\Infra\CrossCutting\Validation\Infra.CrossCutting.Validation.CNPJValidator.pas',
  Infra.CrossCutting.Validation.CPFValidator in '..\Infra\CrossCutting\Validation\Infra.CrossCutting.Validation.CPFValidator.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Executa o motor gráfico oficial do DUnitX VCL
  DUnitX.Loggers.GUI.VCL.Run;
end.

