-- Script para criação do banco de dados
-- Execute este script no isql: isql -u sysdba -p masterkey
-- Depois digite: INPUT 'caminho\para\este\arquivo.sql'

CREATE DATABASE 'C:\Aliari\Desafio Técnico\data\database\NEGOCIACOES.FDB' 
PAGE_SIZE 8192 
DEFAULT CHARACTER SET UTF8;

-- Se o caminho acima não funcionar devido ao acento, tente:
-- CREATE DATABASE 'C:\Aliari\Desafio Tecnico\data\database\NEGOCIACOES.FDB' 
-- PAGE_SIZE 8192 
-- DEFAULT CHARACTER SET UTF8;

QUIT;
