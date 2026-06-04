@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp002_inventory_form_fields.ps1"
if errorlevel 1 exit /b %errorlevel%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp003_build_field_catalog.ps1"
if errorlevel 1 exit /b %errorlevel%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp005_build_form_catalog_seed.ps1"
