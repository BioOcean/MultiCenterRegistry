@echo off
setlocal
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%.."

rem ===== 按需修改以下配置 =====
set "MCR_SOURCE_SQLSERVER=Server=10.1.10.105;Database=LM.BJAZQC.PCI;User Id=sa;Password=qq89370949;"
set "MCR_TARGET_CONFIG=%ROOT_DIR%\MultiCenterRegistry\appsettings.json"
set "MCR_OUTPUT_DIRECTORY=%SCRIPT_DIR%output\all_migration"
set "MCR_SOURCE_FILE_ROOT=%ROOT_DIR%\MultiCenterRegistry\FileStorage"
set "MCR_FILE_COPY_REPORT=%SCRIPT_DIR%output\all_migration\05_files\file_copy_report"
set "MCR_TEMP_PASSWORD_HASH=100000.MU0SHDwAlyx0Gxxr/QmeRA==.0opzlcJ3kT1iYQ08beD8J2c+RbhtTTA1DCc2ALkBcy4="
rem ============================

if "%MCR_TEMP_PASSWORD_HASH%"=="" (
  echo Please set MCR_TEMP_PASSWORD_HASH first.
  pause
  exit /b 1
)

echo Full MCR migration will run.
echo 1. Cleanup target MCR data.
echo 2. Migrate all data from SQL Server to PostgreSQL.
echo 3. Copy files from FileStorage root to upload and dicom, then cleanup copied source files.
echo.
echo Target config: %MCR_TARGET_CONFIG%
echo Source files: %MCR_SOURCE_FILE_ROOT%
echo.
set /p MCR_CONFIRM=Input YES to continue:
if not "%MCR_CONFIRM%"=="YES" (
  echo Cancelled.
  pause
  exit /b 1
)

set "MCR_POWERSHELL="
where pwsh >nul 2>nul
if not errorlevel 1 set "MCR_POWERSHELL=pwsh"
if "%MCR_POWERSHELL%"=="" (
  where powershell.exe >nul 2>nul
  if not errorlevel 1 set "MCR_POWERSHELL=powershell.exe"
)
if "%MCR_POWERSHELL%"=="" (
  echo PowerShell was not found.
  pause
  exit /b 1
)

"%MCR_POWERSHELL%" -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%run_full_migration.ps1" ^
  -SourceConnection "%MCR_SOURCE_SQLSERVER%" ^
  -TargetConfigPath "%MCR_TARGET_CONFIG%" ^
  -OutputDirectory "%MCR_OUTPUT_DIRECTORY%" ^
  -TemporaryPasswordHash "%MCR_TEMP_PASSWORD_HASH%"

if errorlevel 1 (
  echo Migration failed.
  pause
  exit /b 1
)

echo Data migration completed. Copying files and cleaning copied source files.

"%MCR_POWERSHELL%" -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%03_copy_migrated_files.ps1" ^
  -SourceRoot "%MCR_SOURCE_FILE_ROOT%" ^
  -TargetConfigPath "%MCR_TARGET_CONFIG%" ^
  -ManifestPath "%MCR_OUTPUT_DIRECTORY%\05_files\file_manifest.csv" ^
  -ReportDirectory "%MCR_FILE_COPY_REPORT%" ^
  -UseFileNameFallback ^
  -CleanupCopiedSourceFiles ^
  -Overwrite

if errorlevel 1 (
  echo File copy failed.
  pause
  exit /b 1
)

echo Full migration completed.
echo Output: %MCR_OUTPUT_DIRECTORY%
echo File copy report: %MCR_FILE_COPY_REPORT%
pause
