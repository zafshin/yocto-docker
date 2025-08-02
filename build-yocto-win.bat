@echo off
REM Windows script to build the yocto image explicitly and run the container
cd /d %~dp0
REM Build the image with explicit name
docker build -t docker-yocto . --no-cache
