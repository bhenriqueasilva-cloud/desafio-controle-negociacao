# Estrutura do Projeto - Sistema de Controle de Negociações

## Visão Geral
Este documento descreve a estrutura REAL do projeto conforme o código-fonte enviado.

## Estrutura de Diretórios

```
├── data
│   ├── backups
│   │   └── NEGOCIACOES.fbk
│   ├── database
│   │   └── NEGOCIACOES.FDB
│   └── query.sql
├── docs
│   ├── database
│   │   ├── 01_CriacaoBanco.sql
│   │   ├── 02_CriacaoTabelas.sql
│   │   ├── 02_CriacaoTabelas_alternativo.sql
│   │   ├── 03_InsertsIniciais.sql
│   │   ├── criar_banco.bat
│   │   └── criar_banco_manual.sql
│   └── ESTRUTURA_PROJETO.md
├── src
│   ├── App
│   │   └── Views
│   │       ├── Base
│   │       │   ├── App.Views.Base.ViewBaseCadastro.dfm
│   │       │   ├── App.Views.Base.ViewBaseCadastro.pas
│   │       │   ├── App.Views.Base.ViewBaseCadastroDetail.dfm
│   │       │   └── App.Views.Base.ViewBaseCadastroDetail.pas
│   │       ├── Distribuidor
│   │       │   ├── App.Views.Distribuidor.ViewCadastroDistribuidor.dfm
│   │       │   ├── App.Views.Distribuidor.ViewCadastroDistribuidor.pas
│   │       │   ├── App.Views.Distribuidor.ViewCadastroDistribuidorDetail.dfm
│   │       │   └── App.Views.Distribuidor.ViewCadastroDistribuidorDetail.pas
│   │       ├── Negociacao
│   │       │   ├── App.Views.Negociacao.ViewAlteracaoStatusNegociacao.dfm
│   │       │   ├── App.Views.Negociacao.ViewAlteracaoStatusNegociacao.pas
│   │       │   ├── App.Views.Negociacao.ViewConsultaNegociacoes.dfm
│   │       │   ├── App.Views.Negociacao.ViewConsultaNegociacoes.pas
│   │       │   ├── App.Views.Negociacao.ViewManutencaoNegociacao.dfm
│   │       │   └── App.Views.Negociacao.ViewManutencaoNegociacao.pas
│   │       ├── Principal
│   │       │   ├── App.Views.Principal.ViewPrincipal.dfm
│   │       │   └── App.Views.Principal.ViewPrincipal.pas
│   │       ├── Produto
│   │       │   ├── App.Views.Produto.ViewCadastroProduto.dfm
│   │       │   └── App.Views.Produto.ViewCadastroProduto.pas
│   │       └── Produtor
│   │           ├── App.Views.Produtor.ViewCadastroProdutor.dfm
│   │           ├── App.Views.Produtor.ViewCadastroProdutor.pas
│   │           ├── App.Views.Produtor.ViewCadastroProdutorDetail.dfm
│   │           └── App.Views.Produtor.ViewCadastroProdutorDetail.pas
│   ├── Core
│   │   ├── Entities
│   │   │   ├── Core.Entities.CadastroBase.pas
│   │   │   ├── Core.Entities.Distribuidor.pas
│   │   │   ├── Core.Entities.ItemNegociacao.pas
│   │   │   ├── Core.Entities.Negociacao.pas
│   │   │   ├── Core.Entities.NegociacaoItem.pas
│   │   │   ├── Core.Entities.Produto.pas
│   │   │   ├── Core.Entities.Produtor.pas
│   │   │   ├── Core.Entities.ProdutorLimiteCredito.pas
│   │   │   └── Core.Entities.StatusNegociacao.pas
│   │   ├── Enums
│   │   │   └── Core.Enums.TipoStatus.pas
│   │   ├── Exceptions
│   │   │   ├── Core.Exceptions.CreditoExcedidoException.pas
│   │   │   ├── Core.Exceptions.NegociacaoNaoEncontradaException.pas
│   │   │   └── Core.Exceptions.ValidacaoException.pas
│   │   └── Services
│   │       ├── Impl
│   │       │   ├── Core.Services.Impl.DistribuidorService.pas
│   │       │   ├── Core.Services.Impl.NegociacaoService.pas
│   │       │   ├── Core.Services.Impl.ProdutorService.pas
│   │       │   ├── Core.Services.Impl.ProdutoService.pas
│   │       │   ├── Core.Services.Impl.RelatorioService.pas
│   │       │   └── Core.Services.Impl.ValidacaoCreditoService.pas
│   │       └── Interfaces
│   │           ├── Core.Services.Interfaces.IDistribuidorService.pas
│   │           ├── Core.Services.Interfaces.INegociacaoService.pas
│   │           ├── Core.Services.Interfaces.IProdutorService.pas
│   │           ├── Core.Services.Interfaces.IProdutoService.pas
│   │           ├── Core.Services.Interfaces.IRelatorioService.pas
│   │           └── Core.Services.Interfaces.IValidacaoCreditoService.pas
│   ├── Infra
│   │   ├── CrossCutting
│   │   │   ├── Configuration
│   │   │   │   ├── Infra.CrossCutting.Configuration.AppConfig.pas
│   │   │   │   └── Infra.CrossCutting.Configuration.DatabaseConfig.pas
│   │   │   ├── Utils
│   │   │   │   ├── Infra.CrossCutting.Utils.CurrencyUtils.pas
│   │   │   │   ├── Infra.CrossCutting.Utils.DateUtils.pas
│   │   │   │   └── Infra.CrossCutting.Utils.StringUtils.pas
│   │   │   └── Validation
│   │   │       ├── Infra.CrossCutting.Validation.CNPJValidator.pas
│   │   │       ├── Infra.CrossCutting.Validation.CPFValidator.pas
│   │   │       └── Infra.CrossCutting.Validation.MessageValidation.pas
│   │   ├── Data
│   │   │   ├── Firebird
│   │   │   │   ├── Infra.Data.Firebird.DistribuidorProdutoRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.DistribuidorRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.FirebirdConnectionFactory.pas
│   │   │   │   ├── Infra.Data.Firebird.ItemNegociacaoRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.NegociacaoItemRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.NegociacaoRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.ProdutoRepositoryFB.pas
│   │   │   │   ├── Infra.Data.Firebird.ProdutorLimiteCreditoRepositoryFB.pas
│   │   │   │   └── Infra.Data.Firebird.ProdutorRepositoryFB.pas
│   │   │   └── Interfaces
│   │   │       ├── Infra.Data.Interfaces.IConnectionFactory.pas
│   │   │       ├── Infra.Data.Interfaces.IDistribuidorProdutoRepository.pas
│   │   │       ├── Infra.Data.Interfaces.IDistribuidorRepository.pas
│   │   │       ├── Infra.Data.Interfaces.IItemNegociacaoRepository.pas
│   │   │       ├── Infra.Data.Interfaces.INegociacaoItemRepository.pas
│   │   │       ├── Infra.Data.Interfaces.INegociacaoRepository.pas
│   │   │       ├── Infra.Data.Interfaces.IProdutoRepository.pas
│   │   │       ├── Infra.Data.Interfaces.IProdutorLimiteCreditoRepository.pas
│   │   │       └── Infra.Data.Interfaces.IProdutorRepository.pas
│   │   └── IoC
│   │       ├── Infra.IoC.Container.pas
│   │       └── Infra.IoC.ServiceLocator.pas
│   ├── Resources
│   │   └── Images
│   │       └── Icons
│   │           ├── adicionar.bmp
│   │           ├── Aliari.ico
│   │           ├── Aliari2.ico
│   │           ├── botao-de-menos.bmp
│   │           ├── cancelar.bmp
│   │           ├── excluir (1).bmp
│   │           ├── excluir.bmp
│   │           ├── Inserir.bmp
│   │           ├── mais.bmp
│   │           └── sinal-de-menos.bmp
│   ├── Tests
│   │   ├── Core
│   │   │   ├── Core.Services.DistribuidorServiceTest.pas
│   │   │   ├── Core.Services.NegociacaoServiceTest.pas
│   │   │   ├── Core.Services.ProdutorServiceTest.pas
│   │   │   ├── Core.Services.ProdutoServiceTest.pas
│   │   │   ├── Core.Services.RelatorioServiceTest.pas
│   │   │   ├── Core.Services.ValidacaoCreditoServiceTest.pas
│   │   │   └── Core.Services.ValidacaoCreditoServiceTest.pas.bak
│   │   ├── Win32
│   │   │   └── Debug
│   │   │       ├── ControleNegociacoesTests.exe
│   │   │       ├── ControleNegociacoesTests.ini
│   │   │       └── dunitx-results.xml
│   │   ├── ControleNegociacoesTests.dpr
│   │   └── ControleNegociacoesTests.dproj
│   ├── config.ini
│   ├── ControleNegociacoes.dpr
│   ├── ControleNegociacoes.dproj
│   ├── ControleNegociacoes.exe
│   ├── DesafioNegociacao.groupproj
│   └── fbclient.dll
├── .gitignore
└── README.md
```

## Convenções de Nomenclatura
- Classes: PascalCase.
- Interfaces: prefixo I.
- Campos privados: prefixo F.
- Parâmetros: prefixo A.
- Units com o mesmo nome do arquivo.

## Responsabilidades das Camadas
- App: Interface do usuário (Views).
- Core: Regras de negócio, entidades e serviços.
- Infra: Persistência, Firebird, IoC e infraestrutura.
- Resources: Recursos da aplicação.
- Tests: Testes unitários.

## Padrões Utilizados
- SOLID
- Repository Pattern
- Service Layer
- Factory
- Dependency Injection
- Clean Code

## Configuração de Compilação
- Debug: otimizações desabilitadas e símbolos habilitados.
- Release: otimizações habilitadas e símbolos desabilitados.

## Dependências
- Delphi
- Firebird
- Firedac