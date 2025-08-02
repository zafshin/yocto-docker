@echo off
REM Windows script to save the yocto image to a file for transfer
cd /d %~dp0
docker save -o yocto-dev-image.docker docker-yocto
