@echo off
echo ========================================
echo   Installing Python 3.12 (Windows 64bit)
echo ========================================

:: Set Python version and download URL
set PYTHON_VERSION=3.12.6
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe
set INSTALLER=python-installer.exe

:: Download Python installer using PowerShell
echo Downloading Python %PYTHON_VERSION% ...
powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile %INSTALLER%"

:: Run silent install with Add to PATH enabled
echo Installing Python...
%INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

:: Wait a bit for install to finish
timeout /t 10 >nul

:: Verify installation
echo Checking Python installation...
python --version
pip --version

:: Install dependencies from requirements.txt
echo Installing Python dependencies...
pip install --upgrade pip
pip install -r requirements.txt

:: Cleanup installer
del %INSTALLER%

echo ========================================
echo ✅ Python + Dependencies installed
echo ========================================
pause
