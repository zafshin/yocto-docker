#!/bin/bash
# Linux script to load the yocto image from a file
cd "$(dirname "$0")"
docker load -i yocto-dev-image.docker
