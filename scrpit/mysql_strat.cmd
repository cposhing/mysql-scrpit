@echo off 

title MySQL Server

:: ����mysql
set EXIT_CODE=0

::::::::::::::::::::::::::::::::::::::::::::::
set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.

set SCRPIT_BASE_NAME=%~f0

set SCRPIT_HOME=%DIRNAME%
for %%i in ("%SCRPIT_HOME%") do set SCRPIT_HOME=%%~fi

for %%I in ("%SCRPIT_HOME%..\") do set MYSQL_HOME=%%~dpfI
set MYSQLD_EXE=%MYSQL_HOME%bin\mysqld.exe

"%MYSQLD_EXE%" -V >NUL 2>&1
if %ERRORLEVEL% equ 0 goto createMyIni
echo [����]��ǰ�ű�"%SCRPIT_BASE_NAME%"�ƺ���һ�������λ��
goto fail

:createMyIni
if exist "%SCRPIT_HOME%\my.template.ini" goto doCreate
echo [����]"%SCRPIT_HOME%"�²�����my.template.ini����ģ���ļ�
goto fail

:doCreate
powershell -Command "&{"^
						"$content = Get-Content -Path \"%SCRPIT_HOME%\my.template.ini\" -Raw | "^
						"ForEach-Object {$_ -replace '\$\{basedir\}', '%MYSQL_HOME%'} | "^
						"ForEach-Object {$_ -replace '\\', '/'}; "^
						"$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False; "^
						"[System.IO.File]::WriteAllLines(\"%MYSQL_HOME%\\my.ini\", $content, $Utf8NoBomEncoding); "^
					"}"


:validate
if exist "%MYSQL_HOME%\my.ini" goto start
echo [����]"%MYSQL_HOME%"�²�����my.ini�����ļ�
goto fail

:start
set FILENAME=%MYSQL_HOME%postgresql.log
cmd /s /c ""%MYSQLD_EXE%" --defaults-file="%MYSQL_HOME%\my.ini" --console"

if %ERRORLEVEL% equ 1 goto fail
goto end

:fail
set EXIT_CODE=%ERRORLEVEL%
echo [����]���������, ����ִ�в���
pause

:end
exit /b %EXIT_CODE%

