#!/bin/bash
# Linux script to remove the docker-yocto image
cd "$(dirname "$0")"
docker rmi docker-yocto
