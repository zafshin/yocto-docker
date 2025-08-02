@echo off
REM Windows script to stop the yocto container using docker-compose
cd /d %~dp0
docker-compose down
