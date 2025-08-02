@echo off
REM Windows script to run the yocto container from the docker-yocto image
cd /d %~dp0
docker run -it --rm --name my-yocto-container -v %cd%\projects:/home/yocto/projects docker-yocto bash

