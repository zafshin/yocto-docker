#!/bin/bash
# Linux script to build the yocto image explicitly and run the container
cd "$(dirname "$0")"
# Build the image with explicit name
docker build -t docker-yocto . --no-cache

