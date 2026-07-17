# Sistema de Controle de NegociaÃ§Ãµes - Aliare

## DescriÃ§Ã£o
Sistema para controle de negociaÃ§Ãµes entre produtores e distribuidores de insumos agrÃ­colas, desenvolvido em Delphi Community Edition com banco de dados Firebird 2.1.

## Requisitos

### Software NecessÃ¡rio
- **Delphi Community Edition** (versÃ£o mais recente)
- **Firebird 2.1** - [Download](http://www.firebirdsql.org/en/firebird-2-1/)
- **IBX (InterBase Express)** - Componentes nativos do Delphi

### ConfiguraÃ§Ã£o do Banco de Dados
1. Instale o Firebird 2.1
2. O banco de dados jÃ¡ foi criado em: `data/database/NEGOCIACOES.FDB`
3. Scripts SQL disponÃ­veis em: `docs/database/`

## Estrutura do Projeto

```
Desafio TÃ©cnico/
â”œâ”€â”€ bin/                    # BinÃ¡rios compilados
â”œâ”€â”€ data/                   # Arquivos do banco de dados
â”‚   â”œâ”€â”€ database/          # Arquivo .fdb
â”‚   â””â”€â”€ backups/           # Backups
â”œâ”€â”€ docs/                   # DocumentaÃ§Ã£o
â”‚   â”œâ”€â”€ database/          # Scripts SQL
â”‚   â”œâ”€â”€ diagramas/         # Diagramas do sistema
â”‚   â””â”€â”€ ESTRUTURA_PROJETO.md
â”œâ”€â”€ lib/                    # Bibliotecas externas
â”œâ”€â”€ src/                    # CÃ³digo fonte
â”‚   â”œâ”€â”€ App/              # Camada de ApresentaÃ§Ã£o (VCL)
â”‚   â”œâ”€â”€ Core/             # Camada de DomÃ­nio
â”‚   â”œâ”€â”€ Infra/            # Camada de Infraestrutura
â”‚   â”œâ”€â”€ Resources/        # Recursos (imagens, relatÃ³rios)
â”‚   â””â”€â”€ Tests/            # Testes unitÃ¡rios
â””â”€â”€ README.md
```

## Como Compilar

### 1. Abrir o Projeto
1. Abra o Delphi Community Edition
2. File â†’ Open Project
3. Selecione: `src/ControleNegociacoes.dproj`

### 2. Configurar o Projeto
1. Verifique se o caminho de saÃ­da estÃ¡ correto:
   - Project â†’ Options â†’ Delphi Compiler â†’ Output dir
   - Deve apontar para: `..\bin\$(Platform)\$(Config)`

2. Configure o Library Path:
   - Project â†’ Options â†’ Delphi Compiler â†’ Search path
   - Adicione: `..\src`

### 3. Compilar
1. Build â†’ Compile (Ctrl+F9)
2. Build â†’ Build All (Shift+F9)

### 4. Executar
1. Run â†’ Run (F9)
2. O executÃ¡vel serÃ¡ gerado em: `bin\Win32\Debug\ControleNegociacoes.exe`

## ConfiguraÃ§Ã£o do Banco de Dados

### Caminho do Banco
O arquivo de configuraÃ§Ã£o estÃ¡ em: `src/Infra/CrossCutting/Configuration/DatabaseConfig.pas`

```pascal
constructor TDatabaseConfig.Create;
begin
  inherited;
  FServer := 'localhost';
  FDatabase := 'C:\Aliari\Desafio TÃ©cnico\data\database\NEGOCIACOES.FDB';
  FUserName := 'SYSDBA';
  FPassword := 'masterkey';
end;
```

### Recriar o Banco de Dados (se necessÃ¡rio)
1. Abra o prompt de comando
2. Navegue atÃ©: `C:\Program Files (x86)\Firebird\Firebird_2_1\bin`
3. Execute:
   ```
   isql -u sysdba -p masterkey -i "C:\Aliari\Desafio TÃ©cnico\docs\database\01_CriacaoBanco.sql"
   isql -u sysdba -p masterkey -i "C:\Aliari\Desafio TÃ©cnico\docs\database\02_CriacaoTabelas.sql"
   isql -u sysdba -p masterkey -i "C:\Aliari\Desafio TÃ©cnico\docs\database\03_InsertsIniciais.sql"
   ```

## Funcionalidades Implementadas

### Camada de DomÃ­nio (Core/)
- **Entidades**: Produtor, Distribuidor, Produto, Negociacao, ItemNegociacao, LimiteCredito
- **ValidaÃ§Ãµes**: ValidaÃ§Ã£o de campos e regras de negÃ³cio
- **ServiÃ§os**: ValidacaoCreditoService, NegociacaoService

### Camada de Infraestrutura (Infra/)
- **Acesso a Dados**: RepositÃ³rios com IBX (InterBase Express)
- **ConfiguraÃ§Ã£o**: DatabaseConfig, AppConfig
- **ValidaÃ§Ã£o**: CPFValidator, CNPJValidator
- **Utils**: DateUtils, CurrencyUtils, StringUtils

### Camada de ApresentaÃ§Ã£o (App/)
- **ViewPrincipal**: FormulÃ¡rio principal com menu
- **ViewCadastroProdutor**: Cadastro de produtores
- **ViewManutencaoNegociacao**: ManutenÃ§Ã£o de negociaÃ§Ãµes
- **ViewAlteracaoStatusNegociacao**: AlteraÃ§Ã£o de status
- **ViewConsultaNegociacoes**: Consulta e relatÃ³rios

## Regras de NegÃ³cio

### ValidaÃ§Ã£o de CrÃ©dito
- O produtor deve ter limite de crÃ©dito suficiente com o distribuidor
- O sistema considera negociaÃ§Ãµes aprovadas no cÃ¡lculo do crÃ©dito utilizado
- Exemplo: Limite R$ 60.000,00 + Aprovada R$ 20.000,00 = DisponÃ­vel R$ 40.000,00

### Status de NegociaÃ§Ã£o
- **Pendente**: Status inicial
- **Aprovada**: ApÃ³s validaÃ§Ã£o de crÃ©dito
- **ConcluÃ­da**: NegociaÃ§Ã£o finalizada
- **Cancelada**: NegociaÃ§Ã£o cancelada

## PadrÃµes Utilizados

### SOLID
- **Single Responsibility**: Cada classe tem uma Ãºnica responsabilidade
- **Open/Closed**: Aberto para extensÃ£o, fechado para modificaÃ§Ã£o
- **Liskov Substitution**: Subtipos sÃ£o substituÃ­veis
- **Interface Segregation**: Interfaces especÃ­ficas
- **Dependency Inversion**: Depender de abstraÃ§Ãµes

### GoF
- **Repository Pattern**: Acesso a dados
- **Service Layer**: LÃ³gica de negÃ³cio
- **DTO Pattern**: TransferÃªncia de dados
- **Factory Pattern**: CriaÃ§Ã£o de objetos
- **Dependency Injection**: InversÃ£o de controle

## PrÃ³ximos Passos

### ImplementaÃ§Ãµes Pendentes
1. Completar implementaÃ§Ãµes dos repositÃ³rios (Distribuidor, Produto, Negociacao, ItemNegociacao)
2. Implementar LimiteCreditoRepository
3. Completar a lÃ³gica do IoC Container
4. Implementar testes unitÃ¡rios
5. Completar a integraÃ§Ã£o das views com os serviÃ§os
6. Implementar geraÃ§Ã£o de relatÃ³rios

### Componentes Personalizados
1. EditCPF - MÃ¡scara para CPF
2. EditCNPJ - MÃ¡scara para CNPJ
3. EditMoeda - FormataÃ§Ã£o monetÃ¡ria
4. GridNegociacao - Grid personalizado para negociaÃ§Ãµes

## Troubleshooting

### Erro de ConexÃ£o com Banco de Dados
1. Verifique se o serviÃ§o Firebird estÃ¡ rodando
2. Verifique o caminho do banco em DatabaseConfig.pas
3. Verifique usuÃ¡rio e senha (SYSDBA/masterkey)

### Erro de CompilaÃ§Ã£o
1. Verifique se o IBX estÃ¡ instalado
2. Verifique os Library Paths
3. Limpe o cache: Build â†’ Clean

### Erro de Componentes
1. Verifique se os componentes IBX estÃ£o disponÃ­veis na paleta
2. Adicione IBX ao projeto se necessÃ¡rio

## Contato
Desafio TÃ©cnico - Aliare

## LicenÃ§a
Este projeto foi desenvolvido como parte do processo seletivo da Aliare.
