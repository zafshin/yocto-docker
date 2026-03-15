@echo off
REM Windows script to get a shell in the running yocto container
cd /d %~dp0
docker exec -it -u yocto my-yocto-container bash
