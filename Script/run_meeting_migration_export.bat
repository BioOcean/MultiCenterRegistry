@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp008_migrate_meetings.ps1" -Export
