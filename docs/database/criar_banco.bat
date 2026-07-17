@echo off
"C:\Program Files (x86)\Firebird\Firebird_2_1\bin\isql.exe" -u sysdba -p masterkey -i "%~dp0criar_banco.sql"
