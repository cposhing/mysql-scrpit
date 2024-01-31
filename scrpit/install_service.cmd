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
if %ERRORLEVEL% equ 0 goto validateService
echo [����]��ǰ�ű�"%SCRPIT_BASE_NAME%"�ƺ���һ�������λ��
goto fail

:validateService
set /a count=0

for /f "tokens=*" %%a in ('sc query mysql') do (
    set /a count+=1
    set "output[!count!]=%%a"
)

for /l %%i in (1,1,!count!) do (
    echo !output[%%i]!
)

:createService
cmd /s /c ""%MYSQLD_EXE%" --install"
if %ERRORLEVEL% equ 1 goto fail
goto end

:fail
set EXIT_CODE=%ERRORLEVEL%
echo [����]���������, ����ִ�в���
pause

:end
exit /b %EXIT_CODE%

