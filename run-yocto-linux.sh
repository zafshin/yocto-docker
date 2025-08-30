#!/bin/bash
# Linux script to run the yocto container from the docker-yocto image
cd "$(dirname "$0")"
docker run -it --rm --name my-yocto-container -v "$PWD/projects:/home/yocto/projects" docker-yocto bash
