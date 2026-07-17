# Estrutura do Projeto - Sistema de Controle de Negociações

## Visão Geral
Este documento define a estrutura de diretórios e arquivos do projeto, seguindo princípios SOLID, Clean Code e melhores práticas de desenvolvimento Delphi.

## Estrutura de Diretórios

```
Desafio Técnico/
├── bin/                          # Binários compilados
│   ├── Win32/                    # Binários 32-bit
│   │   └── Debug/
│   │   └── Release/
│   └── Win64/                    # Binários 64-bit
│       └── Debug/
│       └── Release/
│
├── data/                         # Arquivos de banco de dados
│   ├── database/                 # Arquivos .fdb do Firebird
│   │   └── NEGOCIACOES.FDB
│   └── backups/                  # Backups do banco de dados
│
├── docs/                         # Documentação do projeto
│   ├── database/                 # Scripts de banco de dados
│   │   ├── 01_CriacaoTabelas.sql
│   │   ├── 02_InsertsIniciais.sql
│   │   ├── 03_StoredProcedures.sql
│   │   └── 04_Triggers.sql
│   ├── diagramas/                # Diagramas do sistema
│   │   ├── DER.png
│   │   └── FluxoNegociacao.png
│   ├── manuais/                  # Manuais do usuário
│   │   └── ManualUsuario.pdf
│   └── especificacoes/           # Especificações técnicas
│       └── Requisitos.md
│
├── src/                          # Código fonte
│   ├── ControleNegociacoes.dpr   # Arquivo principal do projeto
│   ├── ControleNegociacoes.dproj # Arquivo de projeto Delphi
│   │
│   ├── App/                      # Camada de Apresentação (VCL/FMX)
│   │   ├── Views/                # Formulários/Views
│   │   │   ├── Principal/
│   │   │   │   └── ViewPrincipal.pas
│   │   │   │   └── ViewPrincipal.dfm
│   │   │   ├── Produtor/
│   │   │   │   ├── ViewCadastroProdutor.pas
│   │   │   │   ├── ViewCadastroProdutor.dfm
│   │   │   │   └── ViewListaProdutores.pas
│   │   │   │   └── ViewListaProdutores.dfm
│   │   │   ├── Distribuidor/
│   │   │   │   ├── ViewCadastroDistribuidor.pas
│   │   │   │   ├── ViewCadastroDistribuidor.dfm
│   │   │   │   └── ViewListaDistribuidores.pas
│   │   │   │   └── ViewListaDistribuidores.dfm
│   │   │   ├── Produto/
│   │   │   │   ├── ViewCadastroProduto.pas
│   │   │   │   ├── ViewCadastroProduto.dfm
│   │   │   │   └── ViewListaProdutos.pas
│   │   │   │   └── ViewListaProdutos.dfm
│   │   │   ├── Negociacao/
│   │   │   │   ├── ViewManutencaoNegociacao.pas
│   │   │   │   ├── ViewManutencaoNegociacao.dfm
│   │   │   │   ├── ViewConsultaNegociacoes.pas
│   │   │   │   ├── ViewConsultaNegociacoes.dfm
│   │   │   │   ├── ViewAlteracaoStatusNegociacao.pas
│   │   │   │   └── ViewAlteracaoStatusNegociacao.dfm
│   │   │   └── Relatorio/
│   │   │       ├── ViewPreviewRelatorio.pas
│   │   │       └── ViewPreviewRelatorio.dfm
│   │   │
│   │   ├── Components/            # Componentes personalizados
│   │   │   ├── EditCPF.pas
│   │   │   ├── EditCNPJ.pas
│   │   │   ├── EditMoeda.pas
│   │   │   └── GridNegociacao.pas
│   │   │
│   │   ├── Dialogs/               # Diálogos personalizados
│   │   │   ├── DialogConfirmacao.pas
│   │   │   └── DialogSelecao.pas
│   │   │
│   │   └── Helpers/              # Helpers da camada de view
│   │       └── ViewHelper.pas
│   │
│   ├── Core/                     # Camada de Domínio (Business Logic)
│   │   ├── Entities/             # Entidades do domínio
│   │   │   ├── Produtor.pas
│   │   │   ├── Distribuidor.pas
│   │   │   ├── Produto.pas
│   │   │   ├── Negociacao.pas
│   │   │   ├── ItemNegociacao.pas
│   │   │   ├── LimiteCredito.pas
│   │   │   └── StatusNegociacao.pas
│   │   │
│   │   ├── Services/             # Serviços de domínio
│   │   │   ├── Interfaces/
│   │   │   │   ├── IProdutorService.pas
│   │   │   │   ├── IDistribuidorService.pas
│   │   │   │   ├── IProdutoService.pas
│   │   │   │   ├── INegociacaoService.pas
│   │   │   │   ├── IRelatorioService.pas
│   │   │   │   └── IValidacaoCreditoService.pas
│   │   │   │
│   │   │   ├── Impl/             # Implementações dos serviços
│   │   │   │   ├── ProdutorService.pas
│   │   │   │   ├── DistribuidorService.pas
│   │   │   │   ├── ProdutoService.pas
│   │   │   │   ├── NegociacaoService.pas
│   │   │   │   ├── RelatorioService.pas
│   │   │   │   └── ValidacaoCreditoService.pas
│   │   │   │
│   │   │   └── DTOs/             # Data Transfer Objects
│   │   │       ├── ProdutorDTO.pas
│   │   │       ├── DistribuidorDTO.pas
│   │   │       ├── ProdutoDTO.pas
│   │   │       ├── NegociacaoDTO.pas
│   │   │       ├── ItemNegociacaoDTO.pas
│   │   │       └── RelatorioNegociacaoDTO.pas
│   │   │
│   │   ├── Validators/           # Validadores de domínio
│   │   │   ├── ProdutorValidator.pas
│   │   │   ├── DistribuidorValidator.pas
│   │   │   ├── ProdutoValidator.pas
│   │   │   ├── NegociacaoValidator.pas
│   │   │   └── CreditoValidator.pas
│   │   │
│   │   ├── Exceptions/           # Exceções de domínio
│   │   │   ├── CreditoExcedidoException.pas
│   │   │   ├── NegociacaoNaoEncontradaException.pas
│   │   │   └── ValidacaoException.pas
│   │   │
│   │   └── Enums/                # Enumerações
│   │       └── TipoStatus.pas
│   │
│   ├── Infra/                    # Camada de Infraestrutura
│   │   ├── Data/                 # Acesso a dados
│   │   │   ├── Interfaces/
│   │   │   │   ├── IConnectionFactory.pas
│   │   │   │   ├── IProdutorRepository.pas
│   │   │   │   ├── IDistribuidorRepository.pas
│   │   │   │   ├── IProdutoRepository.pas
│   │   │   │   ├── INegociacaoRepository.pas
│   │   │   │   └── IItemNegociacaoRepository.pas
│   │   │   │
│   │   │   ├── Firebird/         # Implementação Firebird
│   │   │   │   ├── FirebirdConnectionFactory.pas
│   │   │   │   ├── ProdutorRepositoryFB.pas
│   │   │   │   ├── DistribuidorRepositoryFB.pas
│   │   │   │   ├── ProdutoRepositoryFB.pas
│   │   │   │   ├── NegociacaoRepositoryFB.pas
│   │   │   │   └── ItemNegociacaoRepositoryFB.pas
│   │   │   │
│   │   │   └── Models/           # Models de banco de dados
│   │   │       ├── ProdutorModel.pas
│   │   │       ├── DistribuidorModel.pas
│   │   │       ├── ProdutoModel.pas
│   │   │       ├── NegociacaoModel.pas
│   │   │       └── ItemNegociacaoModel.pas
│   │   │
│   │   ├── ORM/                  # Mapeamento ORM (se necessário)
│   │   │   ├── Interfaces/
│   │   │   │   └── IMapper.pas
│   │   │   └── Mappers/
│   │   │       ├── ProdutorMapper.pas
│   │   │       ├── DistribuidorMapper.pas
│   │   │       ├── ProdutoMapper.pas
│   │   │       └── NegociacaoMapper.pas
│   │   │
│   │   ├── CrossCutting/         # Concerns transversais
│   │   │   ├── Logging/
│   │   │   │   ├── Interfaces/
│   │   │   │   │   └── ILogger.pas
│   │   │   │   └── Impl/
│   │   │   │       └── FileLogger.pas
│   │   │   │
│   │   │   ├── Configuration/
│   │   │   │   ├── AppConfig.pas
│   │   │   │   └── DatabaseConfig.pas
│   │   │   │
│   │   │   ├── Validation/
│   │   │   │   ├── CPFValidator.pas
│   │   │   │   └── CNPJValidator.pas
│   │   │   │
│   │   │   └── Utils/
│   │   │       ├── DateUtils.pas
│   │   │       ├── CurrencyUtils.pas
│   │   │       └── StringUtils.pas
│   │   │
│   │   └── IoC/                  # Inversão de Controle
│   │       ├── Container.pas
│   │       └── ServiceLocator.pas
│   │
│   ├── Resources/                # Recursos da aplicação
│   │   ├── Images/               # Imagens e ícones
│   │   │   ├── Icons/
│   │   │   └── Logos/
│   │   └── Reports/              # Templates de relatórios
│   │       └── RelatorioNegociacoes.rav
│   │
│   └── Tests/                    # Testes unitários
│       ├── Core/
│       │   ├── Services/
│       │   │   ├── NegociacaoServiceTest.pas
│       │   │   └── ValidacaoCreditoServiceTest.pas
│       │   └── Validators/
│       │       └── CreditoValidatorTest.pas
│       └── Infra/
│           └── Validation/
│               ├── CPFValidatorTest.pas
│               └── CNPJValidatorTest.pas
│
├── lib/                          # Bibliotecas externas (se necessário)
│   └── Firebird/
│
└── README.md                     # Documentação do projeto
```

## Convenções de Nomenclatura

### Arquivos Pascal (.pas)
- **Classes**: PascalCase (ex: `ProdutorService.pas`)
- **Interfaces**: Prefixo 'I' + PascalCase (ex: `IProdutorService.pas`)
- **DTOs**: Sufixo 'DTO' + PascalCase (ex: `ProdutorDTO.pas`)
- **Exceptions**: Sufixo 'Exception' (ex: `CreditoExcedidoException.pas`)
- **Validators**: Sufixo 'Validator' (ex: `CreditoValidator.pas`)
- **Testes**: Sufixo 'Test' (ex: `NegociacaoServiceTest.pas`)

### Arquivos de Formulário (.dfm)
- Mesmo nome do arquivo .pas correspondente

### Units
- **Nome da Unit**: Deve ser igual ao nome do arquivo
- **Uses Clause**: Organizada em seções (System, Classes, etc.)

### Classes
- **Classes**: PascalCase (ex: `TProdutorService`)
- **Interfaces**: Prefixo 'I' + PascalCase (ex: `IProdutorService`)
- **Campos privados**: Prefixo 'F' + PascalCase (ex: `FNome`)
- **Propriedades**: PascalCase (ex: `Nome`)
- **Métodos**: PascalCase (ex: `ValidarCredito`)
- **Eventos**: Prefixo 'On' + PascalCase (ex: `OnCreditoExcedido`)

### Variáveis
- **Locais**: camelCase (ex: `valorTotal`)
- **Globais**: Prefixo 'g' + camelCase (ex: `gConfiguracao`)
- **Parâmetros**: Prefixo 'A' + PascalCase (ex: `AValor`)

### Constantes
- **Const**: PascalCase ou UPPER_CASE (ex: `MaximoItens` ou `MAXIMO_ITENS`)

## Responsabilidades das Camadas

### Camada de Apresentação (App/)
- Responsável pela interação com o usuário
- Formulários VCL/FMX
- Componentes visuais personalizados
- Não contém lógica de negócio

### Camada de Domínio (Core/)
- Contém a lógica de negócio
- Entidades do domínio
- Serviços de domínio
- Regras de validação
- Independente de infraestrutura

### Camada de Infraestrutura (Infra/)
- Acesso a dados
- Integração com banco de dados
- Conexão externa
- Logging
- Configuração

### Camada de Testes (Tests/)
- Testes unitários
- Testes de integração
- Testes de serviços e validadores

## Padrões de Projeto Utilizados

### SOLID
- **S**ingle Responsibility: Cada classe tem uma única responsabilidade
- **O**pen/Closed: Aberto para extensão, fechado para modificação
- **L**iskov Substitution: Subtipos são substituíveis
- **I**nterface Segregation: Interfaces específicas
- **D**ependency Inversion: Depender de abstrações

### GoF
- **Repository Pattern**: Para acesso a dados
- **Service Layer**: Para lógica de negócio
- **DTO Pattern**: Para transferência de dados
- **Factory Pattern**: Para criação de objetos
- **Strategy Pattern**: Para validações
- **Dependency Injection**: Para inversão de controle

### Outros Padrões
- **Data Mapper**: Para mapeamento objeto-relacional
- **Unit of Work**: Para gerenciamento de transações
- **Specification**: Para consultas complexas

## Organização de Código

### Estrutura de uma Unit
```pascal
unit NomeUnit;

interface

uses
  // Uses da interface

type
  // Declarações de tipos

implementation

uses
  // Uses da implementação

{$R *.dfm}

// Implementação

end.
```

### Ordenação de Métodos
1. Construtores/Destrutores
2. Propriedades
3. Métodos públicos
4. Métodos protegidos
5. Métodos privados
6. Event handlers

## Configuração de Compilação

### Debug
- Symbols: ON
- Optimization: OFF
- Stack frames: ON
- Debug information: ON

### Release
- Symbols: OFF
- Optimization: ON
- Stack frames: OFF
- Debug information: OFF

## Dependências Externas

### Firebird 2.1
- Driver: IBX (InterBase Express) - nativo do Delphi
- Alternativa: FireDAC (se disponível na versão Community)

### Relatórios
- Rave Reports (nativo do Delphi)
- FastReport (se disponível)

## Próximos Passos

1. Criar a estrutura de diretórios
2. Configurar o projeto no Delphi
3. Criar os scripts de banco de dados
4. Implementar as entidades do domínio
5. Implementar os repositórios
6. Implementar os serviços
7. Criar as views
8. Implementar testes unitários
