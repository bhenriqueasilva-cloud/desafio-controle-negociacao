# Sistema de Controle de Negociações - Aliare

## Descrição
Sistema completo para controle de negociações entre produtores e distribuidores de insumos agrícolas. O projeto foi integralmente desenvolvido em Delphi Community Edition, utilizando o banco de dados Firebird 2.1 e componentização nativa VCL/FireDAC.

## Requisitos
### Software Necessário
- **Delphi Community Edition**
- **Firebird 2.1** - [Download Oficial](http://www.firebirdsql.org/en/firebird-2-1/)
- **FireDAC** - Componentes nativos de acesso a dados do Delphi

### Configuração do Banco de Dados
1. Instale o Firebird 2.1 em modo super-server/arquitetura padrão.
2. O banco de dados de produção está localizado em: `data/database/NEGOCIACOES.FDB`
3. Os scripts SQL estruturais estão disponíveis em: `docs/database/`

## Estrutura do Projeto
```text
C:\Aliari\DesafioNegociacao\
├── bin/                       # Binários e executáveis compilados (Win32/Release/Debug)
├── data/                      # Arquivos físicos do banco de dados Firebird
│   ├── database/              # Arquivo .FDB ativo
│   └── backups/               # Backups de segurança
├── docs/                      # Documentação e modelagem do desafio
│   ├── database/              # Scripts SQL estruturais e cargas iniciais
│   ├── diagramas/             # Diagramas arquiteturais
│   └── ESTRUTURA_PROJETO.md
├── src/                       # Código fonte do ecossistema Delphi
│   ├── App/                   # Camada de Apresentação (Formulários VCL)
│   ├── Core/                  # Camada de Domínio (Entidades e Enumerações)
│   ├── Infra/                 # Camada de Infraestrutura e Conexões
│   ├── Resources/             # Recursos visuais e arquivos de inicialização
│   └── Tests/                 # Cobertura de Testes Unitários automatizados
└── README.md
```

## Como Compilar e Executar

### 1. Abrir o Projeto
1. Abra o Delphi Community Edition.
2. Vá em **File ➔ Open Project**.
3. Selecione o arquivo principal: `src/ControleNegociacoes.dproj`.

### 2. Configurar os Caminhos de Compilação
1. Certifique-se de que o diretório de saída do binário está configurado corretamente:
   - **Project ➔ Options ➔ Delphi Compiler ➔ Output directory**
   - O caminho deve apontar para: `..\bin\$(Platform)\$(Config)`
2. Verifique o caminho de busca do compilador:
   - **Project ➔ Options ➔ Delphi Compiler ➔ Search path**
   - Deve conter a referência para: `..\src`

### 3. Compilar
1. Limpe o cache de compilação antigo: **Project ➔ Clean [NomeDoProjeto]**
2. Execute a reconstrução dos arquivos físicos: **Project ➔ Build [NomeDoProjeto]** (Atalho: `Shift + F9`)

### 4. Executar
1. Pressione `F9` (**Run ➔ Run**).
2. O executável final otimizado será gerado fisicamente em: `bin\Win32\Debug\ControleNegociacoes.exe`

## Configuração Ativa de Infraestrutura

### String de Conexão com o Banco de Dados
A configuração dinâmica de conexão reside em `src/Infra/CrossCutting/Configuration/DatabaseConfig.pas` mapeada para o diretório atual do projeto:

```pascal
constructor TDatabaseConfig.Create;
begin
  inherited;
  FServer := 'localhost';
  FDatabase := '..\..\..\data\database\NEGOCIACOES.FDB';
  FUserName := 'SYSDBA';
  FPassword := 'masterkey';
end;
```
## Regras de Negócio Implementadas

### Validação de Crédito Inteligente
- O produtor deve possuir limite de crédito em reais suficiente com o distribuidor para prosseguir com negociações.
- **Regra do Saldo Aprovado:** Conforme as diretrizes do desafio, apenas negociações com o status **"Aprovada"** consomem o limite do produtor. Negociações em estado **"Pendente"** (simulações/rascunhos) podem ser geradas e salvas livremente acima do limite; a trava atua estritamente no gatilho de mudança de status para a aprovação. Negociações **"Concluídas"** ou **"Canceladas"** liberam o saldo livre imediatamente no banco de dados.

### Manutenção e Consistência de Limites
- Adicionadas travas de segurança na camada de serviço do produtor para impedir que falhas operacionais reduzam ou excluam limites de crédito com distribuidores se o produtor já possuir saldo ativamente utilizado por contratos aprovados na safra atual.

### Status Matemáticos da Negociação
A entidade possui um fluxo de máquina de estados baseado em 4 status restritivos (`TTipoStatus`):
- **tsPendente**: Estado inicial automático de rascunho.
- **tsAprovada**: Ativado após o sucesso da validação de limite.
- **tsConcluida**: Contrato finalizado comercialmente.
- **tsCancelada**: Operação abortada, estornando o crédito.

## Testes Unitários Automatizados (DUnitX)
O projeto conta com uma cobertura robusta de testes automatizados via framework nativo **DUnitX**, garantindo a estabilidade e a integridade de todas as camadas de negócio.

### Executando os Testes
1. Abra o grupo de projetos de testes: `src/Tests/ControleNegociacoesTests.dproj`
2. Compile em modo Release ou Debug executando o comando **Build** (`Shift + F9`).
3. Execute o console de testes (`F9`). Os testes cobrem:
   - Validação estrita de documentos (CPF e CNPJ reais).
   - Bloqueio de inserções inválidas (Nomes vazios e preços nulos).
   - Simulação matemática e lógica de consumo e liberação do saldo de crédito aprovado.

## Padrões de Projeto e Práticas Aplicadas (Arquitetura)

### Princípios SOLID
- **Single Responsibility Principle (SRP):** Classes de serviço focadas puramente em orquestrar regras, isoladas dos repositórios físicos de acesso a dados.
- **Interface Segregation Principle (ISP):** Acoplamento focado em contratos abstratos, eliminando dependências rígidas entre objetos.
- **Dependency Inversion Principle (DIP):** Inversão de controle total realizada através de injeção de dependências no construtor das classes.

### Design Patterns (GoF e Corporativos)
- **Repository Pattern:** Abstração completa da camada de persistência física SQL via FireDAC.
- **Service Layer Pattern:** Encapsulamento centralizado dos fluxos operacionais de negócio e validações.
- **Fail-Fast Approach:** Validações de integridade realizadas no menor tempo de execução da CPU (atribuição via métodos `Set`).

## Contato e Desenvolvimento
Desenvolvido com excelência técnica como solução para o desafio de engenharia de software da **Aliare**.