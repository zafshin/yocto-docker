#!/bin/bash
# Linux script to run the yocto container from the docker-yocto image
cd "$(dirname "$0")"
docker run -it --rm --name my-yocto-container \
	-e LOCAL_UID="$(id -u)" \
	-e LOCAL_GID="$(id -g)" \
	-e LOCAL_UMASK="$(umask)" \
	-v "$PWD/projects:/home/yocto/projects" \
	docker-yocto bash
