#!/bin/bash
# Linux script to run the yocto container using docker-compose
cd "$(dirname "$0")"
docker-compose up
