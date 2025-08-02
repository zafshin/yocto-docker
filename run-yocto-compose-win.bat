@echo off
REM Windows script to run the yocto container using docker-compose
cd /d %~dp0
docker-compose up
