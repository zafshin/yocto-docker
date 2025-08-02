@echo off
REM Windows script to stop and remove the yocto container using docker
cd /d %~dp0
docker stop my-yocto-container
docker rm my-yocto-container
