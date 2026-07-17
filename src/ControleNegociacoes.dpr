program ControleNegociacoes;

uses
  Vcl.Forms,
  App.Views.Principal.ViewPrincipal in 'App\Views\Principal\App.Views.Principal.ViewPrincipal.pas' {ViewPrincipal},
  App.Views.Negociacao.ViewAlteracaoStatusNegociacao in 'App\Views\Negociacao\App.Views.Negociacao.ViewAlteracaoStatusNegociacao.pas' {ViewAlteracaoStatusNegociacao},
  App.Views.Negociacao.ViewConsultaNegociacoes in 'App\Views\Negociacao\App.Views.Negociacao.ViewConsultaNegociacoes.pas' {ViewConsultaNegociacoes},
  App.Views.Negociacao.ViewManutencaoNegociacao in 'App\Views\Negociacao\App.Views.Negociacao.ViewManutencaoNegociacao.pas' {ViewManutencaoNegociacao},
  Core.Entities.CadastroBase in 'Core\Entities\Core.Entities.CadastroBase.pas',
  Core.Entities.Produtor in 'Core\Entities\Core.Entities.Produtor.pas',
  Core.Entities.Distribuidor in 'Core\Entities\Core.Entities.Distribuidor.pas',
  Core.Entities.Produto in 'Core\Entities\Core.Entities.Produto.pas',
  Core.Entities.Negociacao in 'Core\Entities\Core.Entities.Negociacao.pas',
  Core.Entities.NegociacaoItem in 'Core\Entities\Core.Entities.NegociacaoItem.pas',
  Core.Entities.ProdutorLimiteCredito in 'Core\Entities\Core.Entities.ProdutorLimiteCredito.pas',
  Core.Entities.StatusNegociacao in 'Core\Entities\Core.Entities.StatusNegociacao.pas',
  Core.Enums.TipoStatus in 'Core\Enums\Core.Enums.TipoStatus.pas',
  Core.Services.Interfaces.IProdutorService in 'Core\Services\Interfaces\Core.Services.Interfaces.IProdutorService.pas',
  Core.Services.Interfaces.IDistribuidorService in 'Core\Services\Interfaces\Core.Services.Interfaces.IDistribuidorService.pas',
  Core.Services.Interfaces.IProdutoService in 'Core\Services\Interfaces\Core.Services.Interfaces.IProdutoService.pas',
  Core.Services.Interfaces.INegociacaoService in 'Core\Services\Interfaces\Core.Services.Interfaces.INegociacaoService.pas',
  Core.Services.Interfaces.IRelatorioService in 'Core\Services\Interfaces\Core.Services.Interfaces.IRelatorioService.pas',
  Core.Services.Interfaces.IValidacaoCreditoService in 'Core\Services\Interfaces\Core.Services.Interfaces.IValidacaoCreditoService.pas',
  Core.Services.Impl.ProdutorService in 'Core\Services\Impl\Core.Services.Impl.ProdutorService.pas',
  Core.Services.Impl.DistribuidorService in 'Core\Services\Impl\Core.Services.Impl.DistribuidorService.pas',
  Core.Services.Impl.ProdutoService in 'Core\Services\Impl\Core.Services.Impl.ProdutoService.pas',
  Core.Services.Impl.NegociacaoService in 'Core\Services\Impl\Core.Services.Impl.NegociacaoService.pas',
  Core.Services.Impl.RelatorioService in 'Core\Services\Impl\Core.Services.Impl.RelatorioService.pas',
  Core.Services.Impl.ValidacaoCreditoService in 'Core\Services\Impl\Core.Services.Impl.ValidacaoCreditoService.pas',
  Core.Exceptions.CreditoExcedidoException in 'Core\Exceptions\Core.Exceptions.CreditoExcedidoException.pas',
  Core.Exceptions.NegociacaoNaoEncontradaException in 'Core\Exceptions\Core.Exceptions.NegociacaoNaoEncontradaException.pas',
  Infra.Data.Interfaces.IConnectionFactory in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IConnectionFactory.pas',
  Infra.Data.Interfaces.IProdutorRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutorRepository.pas',
  Infra.Data.Interfaces.IDistribuidorRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IDistribuidorRepository.pas',
  Infra.Data.Interfaces.IProdutoRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutoRepository.pas',
  Infra.Data.Interfaces.INegociacaoRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.INegociacaoRepository.pas',
  Infra.Data.Interfaces.INegociacaoItemRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.INegociacaoItemRepository.pas',
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IProdutorLimiteCreditoRepository.pas',
  Infra.Data.Firebird.FirebirdConnectionFactory in 'Infra\Data\Firebird\Infra.Data.Firebird.FirebirdConnectionFactory.pas',
  Infra.Data.Firebird.ProdutorRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.ProdutorRepositoryFB.pas',
  Infra.Data.Firebird.DistribuidorRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.DistribuidorRepositoryFB.pas',
  Infra.Data.Firebird.ProdutoRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.ProdutoRepositoryFB.pas',
  Infra.Data.Firebird.NegociacaoRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.NegociacaoRepositoryFB.pas',
  Infra.Data.Firebird.NegociacaoItemRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.NegociacaoItemRepositoryFB.pas',
  Infra.Data.Firebird.ProdutorLimiteCreditoRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.ProdutorLimiteCreditoRepositoryFB.pas',
  Infra.CrossCutting.Configuration.AppConfig in 'Infra\CrossCutting\Configuration\Infra.CrossCutting.Configuration.AppConfig.pas',
  Infra.CrossCutting.Configuration.DatabaseConfig in 'Infra\CrossCutting\Configuration\Infra.CrossCutting.Configuration.DatabaseConfig.pas',
  Infra.CrossCutting.Validation.CPFValidator in 'Infra\CrossCutting\Validation\Infra.CrossCutting.Validation.CPFValidator.pas',
  Infra.CrossCutting.Validation.CNPJValidator in 'Infra\CrossCutting\Validation\Infra.CrossCutting.Validation.CNPJValidator.pas',
  Infra.CrossCutting.Utils.DateUtils in 'Infra\CrossCutting\Utils\Infra.CrossCutting.Utils.DateUtils.pas',
  Infra.CrossCutting.Utils.CurrencyUtils in 'Infra\CrossCutting\Utils\Infra.CrossCutting.Utils.CurrencyUtils.pas',
  Infra.CrossCutting.Utils.StringUtils in 'Infra\CrossCutting\Utils\Infra.CrossCutting.Utils.StringUtils.pas',
  Infra.IoC.Container in 'Infra\IoC\Infra.IoC.Container.pas',
  Infra.IoC.ServiceLocator in 'Infra\IoC\Infra.IoC.ServiceLocator.pas',
  Core.Exceptions.ValidacaoException in 'Core\Exceptions\Core.Exceptions.ValidacaoException.pas',
  App.Views.Base.ViewBaseCadastro in 'App\Views\Base\App.Views.Base.ViewBaseCadastro.pas' {ViewBaseCadastro},
  App.Views.Produto.ViewCadastroProduto in 'App\Views\Produto\App.Views.Produto.ViewCadastroProduto.pas' {ViewCadastroProduto},
  App.Views.Base.ViewBaseCadastroDetail in 'App\Views\Base\App.Views.Base.ViewBaseCadastroDetail.pas' {ViewBaseCadastroDetail},
  App.Views.Distribuidor.ViewCadastroDistribuidorDetail in 'App\Views\Distribuidor\App.Views.Distribuidor.ViewCadastroDistribuidorDetail.pas' {ViewCadastroDistribuidorDetail},
  Infra.Data.Interfaces.IDistribuidorProdutoRepository in 'Infra\Data\Interfaces\Infra.Data.Interfaces.IDistribuidorProdutoRepository.pas',
  Infra.Data.Firebird.DistribuidorProdutoRepositoryFB in 'Infra\Data\Firebird\Infra.Data.Firebird.DistribuidorProdutoRepositoryFB.pas',
  App.Views.Produtor.ViewCadastroProdutorDetail in 'App\Views\Produtor\App.Views.Produtor.ViewCadastroProdutorDetail.pas' {ViewCadastroProdutorDetail},
  Vcl.Themes,
  Vcl.Styles,
  Infra.CrossCutting.Validation.MessageValidation in 'Infra\CrossCutting\Validation\Infra.CrossCutting.Validation.MessageValidation.pas';

{\ *.res}

begin
  ReportMemoryLeaksOnShutdown := True;


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TIoCContainer.Initialize;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;

end.