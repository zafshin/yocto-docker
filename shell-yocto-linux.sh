#!/bin/bash
# Linux script to get a shell in the running yocto container
cd "$(dirname "$0")"
docker exec -it my-yocto-container bash
