@echo off

:: Check if any command-line argument contains "--h" or "--help" (case insensitive)
set "help_arg_found=false"
for %%i in (%*) do (
    if /I "%%i"=="--h" set "help_arg_found=true"
    if /I "%%i"=="--help" set "help_arg_found=true"
)

:: Display help instructions and exit if --h or --help is found
if "%help_arg_found%"=="true" (
    echo Usage Instructions:
    echo   gen_migr.bat ^<tag1^> ^<tag2^> [^<filename^>] [--ui] [--page]
    echo.
    echo   Arguments:
    echo     ^<tag1^>         : The name of the first Git tag to compare.
    echo     ^<tag2^>         : The name of the second Git tag to compare.
    echo     [^<filename^>]   : Optional filename for the migr file.
    echo.
    echo   Options:
    echo     --ui            : Generate UI changes list.
    echo     --page          : Generate page build.
    echo.
    echo   Description:
    echo     The gen_migr script generates migration changes based on the differences
    echo     between two Git tags. It outputs the changes to a specified filename or
    echo     the default migr file. Use this script to track changes related to migrations.
    exit /b
)

:: Set variables for command-line arguments
set "tag1=%1"
set "tag2=%2"
set "filename=%3"
set "ui_arg_found=false"
set "page_arg_found=false"

set "use_filename=true"

:: Check if the third argument starts with "--"
if "%filename:~0,2%"=="--" (
  set "use_filename=false"
)

:: Check for --ui or --page and update variables
for %%i in (%*) do (
    if /I "%%i"=="--ui" set "ui_arg_found=true"
    if /I "%%i"=="--page" set "page_arg_found=true"
)

:: Display the difference between two tags
git diff %tag1% %tag2% --name-only -- "../../main/oracle/module/*.pck" "../../main/oracle/setup/*.pck"  > difference.txt

if "%ui_arg_found%"=="true" (
  git diff %tag1% %tag2% --name-only -- "../../main/oracle/ui/*.pck" "../../main/oracle/uit/*.pck" "../../main/oracle/uis/*.sql" > difference_ui.txt
)

if "%page_arg_found%"=="true" (
  git diff %tag1% %tag2% --name-only -- "../../main/page" > difference_page.txt
)

:: Run the Python script with any additional arguments (excluding --ui and --page)
if "%use_filename%"=="false" (
  python gen_migr.py %tag2%  
) else (
  python gen_migr.py %tag2% %filename%
)

if "%ui_arg_found%"=="true" (
  if "%use_filename%"=="false" (
    python gen_ui_changes_list.py %tag2%  
  ) else (
    python gen_ui_changes_list.py %tag2% %filename%
  )
)

if "%page_arg_found%"=="true" (
  python gen_page_build.py
)

:: Delete difference files
:: call delete_difference_files.bat
