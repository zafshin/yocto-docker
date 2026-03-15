#!/bin/bash
# Linux script to run the yocto container using docker-compose
cd "$(dirname "$0")"
export LOCAL_UID="$(id -u)"
export LOCAL_GID="$(id -g)"
export LOCAL_UMASK="$(umask)"

docker-compose up --build
