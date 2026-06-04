@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp009_migrate_identity.ps1" -Export -TemporaryPassword "123456"
