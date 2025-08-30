#!/bin/bash
# Linux script to save the yocto image to a file for transfer
cd "$(dirname "$0")"
docker save -o yocto-dev-image.docker docker-yocto
