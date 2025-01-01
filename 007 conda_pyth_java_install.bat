:: create a bat file to:
:: 1.if java already installed, ignore java instalation 
:: 2 if java is not installed:
:: 3. install java,  
:: 4. insert java in system variables with "new system variable" called JAVA_HOME, 
:: 5. if java is installing add new path in system variables with the path to java
:: 6. if not installed , install miniconda WITH PYTHON 3.11.9 in c:\my_miniconda, if already installed ignore 
:: 7. after installing miniconda, create an miniconda enviroment called jupyter3119 in c:\my_miniconda,   
:: 8. Install jupyter in my_jupyter


@echo off
:: Check for Administrator privileges
:: The "fltmc" command requires admin rights, if it fails, restart as admin
fltmc >nul 2>nul
if %errorlevel% neq 0 (
    echo Requesting Administrator Privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit
)

:: Set variables
set JAVA_DOWNLOAD_URL=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe
set JAVA_INSTALL_DIR="C:\Program Files\Java"
set MINICONDA_DOWNLOAD_URL=https://repo.anaconda.com/miniconda/Miniconda3-py311_23.11.0-1-Windows-x86_64.exe
set MINICONDA_INSTALL_DIR="C:\my_miniconda"
set CONDA_ENV_NAME=jupyter3119

:: Check if Java is already installed
echo Checking for existing Java installation...
where java >nul 2>nul
if %ERRORLEVEL% == 0 (
    echo Java is already installed. Skipping Java installation.
    goto miniconda
) else (
    echo Java not found. Proceeding with Java installation...
)

:: Download and install Java if not installed
echo Downloading Java...
curl -L -o jdk_installer.exe %JAVA_DOWNLOAD_URL%
echo Installing Java...
start /wait jdk_installer.exe /s INSTALLDIR=%JAVA_INSTALL_DIR%

:: Find the Java path
for /d %%i in (%JAVA_INSTALL_DIR%\jdk-*) do set JAVA_PATH=%%i

:: Set JAVA_HOME and update system PATH
echo Setting JAVA_HOME and updating PATH...
setx JAVA_HOME "%JAVA_PATH%"
setx PATH "%JAVA_PATH%\bin;%PATH%"

:: Java installation complete
echo Java installation completed.

:miniconda
:: Check if Miniconda is already installed
echo Checking for existing Miniconda installation...
if exist "%MINICONDA_INSTALL_DIR%\Scripts\conda.exe" (
    echo Miniconda is already installed. Skipping Miniconda installation.
    goto create_env
) else (
    echo Miniconda not found. Proceeding with Miniconda installation...
)

:: Download and install Miniconda with Python 3.11.9
echo Downloading Miniconda...
curl -L -o miniconda_installer.exe %MINICONDA_DOWNLOAD_URL%
echo Installing Miniconda...
start /wait miniconda_installer.exe /InstallationType=JustMe /AddToPath=1 /RegisterPython=1 /S /D=%MINICONDA_INSTALL_DIR%

:: Initialize Conda
call "%MINICONDA_INSTALL_DIR%\Scripts\activate.bat"

:create_env
:: Check if the environment already exists
echo Checking for existing Conda environment...
call conda info --envs | findstr /i "%CONDA_ENV_NAME%" >nul
if %ERRORLEVEL% == 0 (
    echo Conda environment %CONDA_ENV_NAME% already exists. Skipping environment creation.
) else (
    echo Creating Conda environment %CONDA_ENV_NAME%...
    call conda create -y -n %CONDA_ENV_NAME% python=3.11.9
)

:: Activate the environment and install Jupyter
echo Activating environment and installing Jupyter...
call conda activate %CONDA_ENV_NAME%
call conda install -y jupyter

:: Cleanup
echo Cleaning up installers...
del jdk_installer.exe
del miniconda_installer.exe

echo Installation complete. Java, Miniconda, and Jupyter are ready!
pause

 