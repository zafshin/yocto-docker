#!/bin/bash
# Linux script to stop the yocto container using docker-compose
cd "$(dirname "$0")"
docker-compose down
