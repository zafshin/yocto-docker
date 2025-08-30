#!/bin/bash
# Linux script to stop and remove the yocto container using docker-compose
cd "$(dirname "$0")"
docker stop my-yocto-container
docker rm my-yocto-container