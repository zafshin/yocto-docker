@echo off
REM Windows script to load the yocto image from a file
cd /d %~dp0
docker load -i yocto-dev-image.docker
