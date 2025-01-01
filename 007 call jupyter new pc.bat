@echo off
:: Ensure conda is initialized properly
call "C:\my_miniconda\Scripts\activate.bat"

:: Activate the Conda environment
call conda activate jupyter3119

:: Check if activation was successful
if %ERRORLEVEL% neq 0 (
    echo Failed to activate conda environment. Exiting...
    pause
    exit /b
)

:: Ensure the notebook directory exists
if not exist "C:\my_notebooks" (
    echo Notebook directory does not exist. Creating it now...
    mkdir "C:\my_notebooks"
)

:: Change to the notebook directory
cd /d C:\my_notebooks

:: Start Jupyter Notebook
echo Launching Jupyter Notebook...
call jupyter notebook

:: Keep the window open to see errors
pause
