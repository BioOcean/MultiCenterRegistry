@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp012_migrate_case_advice.ps1" -Export
pause
