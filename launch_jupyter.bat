@echo off
:: if you installed miniconda just for you (like me) "activate.bat" file is inside your "C:\Users\your_user_name\miniconda3\scripts\activate.bat"

:: Launch Anaconda Powershell Prompt
call "C:\Users\paulo\miniconda3\Scripts\activate.bat" qeeg397
:: Change to the desired directory
cd /d E:\my_notebooks
:: Start Jupyter Notebook
jupyter notebook