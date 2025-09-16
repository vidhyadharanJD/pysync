@echo off
echo ========================================
echo   Installing Python 3.12 (Windows 64bit)
echo ========================================

:: Set Python version and download URL
set PYTHON_VERSION=3.12.6
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe
set INSTALLER=python-installer.exe

:: Define Python install location (per-user install)
set PYTHON_DIR=%LocalAppData%\Programs\Python\Python312
set PYTHON_EXE=%PYTHON_DIR%\python.exe

:: Download Python installer using PowerShell
echo Downloading Python %PYTHON_VERSION% ...
powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile %INSTALLER%"

:: Run silent install with Add to PATH enabled
echo Installing Python...
%INSTALLER% /quiet InstallAllUsers=0 PrependPath=1 Include_test=0

:: Wait for install to finish
timeout /t 10 >nul

:: Check Python installation
if not exist "%PYTHON_EXE%" (
    echo ❌ Python installation failed.
    pause
    exit /b 1
)

echo ✅ Python installed successfully

:: Ensure pip is installed & upgraded for THIS python
echo Setting up pip...
"%PYTHON_EXE%" -m ensurepip --upgrade
"%PYTHON_EXE%" -m pip install --upgrade pip

:: Install dependencies (hardcoded list so no requirements.txt needed)
echo Installing Python dependencies (oci, requests)...
"%PYTHON_EXE%" -m pip install oci requests --quiet

:: Cleanup installer
del %INSTALLER%

echo ========================================
echo ✅ Python + Dependencies installed
echo ========================================
pause
