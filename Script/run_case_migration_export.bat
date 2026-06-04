@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp006_migrate_cases.ps1" -Export
