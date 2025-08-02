@echo off
REM Windows script to remove the docker-yocto image
cd /d %~dp0
docker rmi docker-yocto
