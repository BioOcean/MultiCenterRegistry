@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp010_migrate_files.ps1" -Export
