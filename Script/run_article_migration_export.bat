@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp014_migrate_articles.ps1" -Export
