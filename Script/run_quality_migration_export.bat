@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp007_migrate_quality.ps1" -Export
