@echo off
setlocal

:: Mudar para o diretorio raiz do projeto
cd /d "%~dp0..\.."

set DB_PATH=data\database\NEGOCIACOES.FDB
set BACKUP_DIR=data\backups
set ISQL_PATH=C:\Program Files (x86)\Firebird\Firebird_2_1\bin\isql.exe

echo ========================================
echo Script de Criacao de Banco de Dados
echo ========================================
echo Diretorio atual: %CD%
echo.

:: Criar diretorio de backup se nao existir
if not exist "%BACKUP_DIR%" (
    echo Criando diretorio de backup: %BACKUP_DIR%
    mkdir "%BACKUP_DIR%"
)

@echo off

:: Se o banco não existir, avisa e pula para o final
if not exist "%DB_PATH%" (
    echo Nenhum banco atual encontrado. Criando novo banco...
    echo.
    goto :FIM
)

echo Banco atual encontrado. Fazendo backup...

:: Remove barras e pontos da data e hora de forma simples
set LIMPA_DATA=%DATE:/=-%
set LIMPA_HORA=%TIME::=-%
set LIMPA_HORA=%LIMPA_HORA:,=-%
set LIMPA_HORA=%LIMPA_HORA: =0%

:: Cria o sufixo único
set TIMESTAMP=%LIMPA_DATA%_%LIMPA_HORA%

:: Executa a cópia
copy "%DB_PATH%" "%BACKUP_DIR%\NEGOCIACOES_BACKUP_%TIMESTAMP%.FDB"

echo Backup concluido: NEGOCIACOES_BACKUP_%TIMESTAMP%.FDB
echo.

:FIM


:: Remover banco atual se existir
if exist "%DB_PATH%" (
    echo Removendo banco atual...
    del "%DB_PATH%"
    echo.
)

:: Executar script de criacao do banco
echo Criando novo banco de dados...
"%ISQL_PATH%" -u sysdba -p masterkey -i "docs\database\01_CriacaoBanco.sql"
if errorlevel 1 (
    echo ERRO: Falha ao criar banco de dados.
    pause
    exit /b 1
)
echo Banco criado com sucesso.
echo.

:: Executar script de criacao das tabelas
echo Criando tabelas...
"%ISQL_PATH%" -u sysdba -p masterkey -i "docs\database\02_CriacaoTabelas.sql"
if errorlevel 1 (
    echo ERRO: Falha ao criar tabelas.
    pause
    exit /b 1
)
echo Tabelas criadas com sucesso.
echo.

echo ========================================
echo Processo concluido com sucesso!
echo ========================================
echo.
pause
