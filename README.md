# Yocto Docker Environment

This project provides a ready-to-use Docker environment for Yocto development on Windows and Linux. It includes scripts for building, running, exporting, importing, and managing your Yocto container and image.

## Features
- Ubuntu 24.04 base image with all Yocto dependencies pre-installed
- Non-root user (`yocto`) with sudo access and password (`yoctopass`)
- Persistent project directory via volume mount
- Linux launch scripts map the container user to your host UID/GID so files created in `projects` keep normal local ownership
- Scripts for Windows and Linux to build, run, stop, export, import, and remove the container/image

## Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows or Linux)
- (Optional) [docker-compose](https://docs.docker.com/compose/) for compose-based workflows

## Usage

### 1. Build the Docker Image
#### Windows
Run:
```bat
build-yocto-win.bat
```
#### Linux
Run:
```sh
./build-yocto-linux.sh
```

### 2. Run the Container
#### Windows
Run:
```bat
run-yocto-win.bat
```
#### Linux
Run:
```sh
./run-yocto-linux.sh
```

This will start the container and mount the `projects` folder from your host to `/home/yocto/projects` in the container.

On Linux, the run scripts pass your local UID, GID, and umask into the container so files written under `projects` are owned by your local user instead of an internal container-only account.

### 3. Run with Docker Compose (Optional)
#### Windows
```bat
run-yocto-compose-win.bat
```
#### Linux
```sh
./run-yocto-compose-linux.sh
```

### 4. Stop the Container
#### Windows
```bat
stop-yocto-win.bat
```
#### Linux
```sh
./stop-yocto-linux.sh
```

Or, if using compose:
- `stop-yocto-compose-win.bat` (Windows)
- `./stop-yocto-compose-linux.sh` (Linux)

### 5. Export/Import the Docker Image
To save the image for transfer:
- `export-yocto-win.bat` (Windows)
- `./export-yocto-linux.sh` (Linux)

To load the image on another machine:
- `import-yocto-win.bat` (Windows)
- `./import-yocto-linux.sh` (Linux)

### 6. Remove the Docker Image
- `remove-yocto-win.bat` (Windows)
- `./remove-yocto-linux.sh` (Linux)

### 7. Flash an SD Card on Linux
If your build produced a `.wic.bz2` image, you can flash it to an SD card with:

```sh
sudo ./flash-yocto-linux.sh /dev/sdX
```

You can also pass the image path explicitly:

```sh
sudo ./flash-yocto-linux.sh /dev/sdX projects/poky/build/tmp/deploy/images/raspberrypi3-64/core-image-minimal-raspberrypi3-64.rootfs-20260314122809.wic.bz2
```

## Notes & Limitations
- **Case Sensitivity:** Windows filesystems (NTFS/exFAT) are case-insensitive. Yocto/bitbake requires a case-sensitive filesystem for TMPDIR. Do not mount your build directory from Windows if you need case sensitivity—build inside the container's native filesystem instead.
- **Persistence:** Only files in the mounted `projects` directory are persistent. Files created elsewhere in the container will be lost when the container is removed unless you use `docker commit` or `docker cp`.
- **No ext4 VHDX Support:** Windows cannot natively mount ext4 VHDX files. For case-sensitive builds, use a Linux VM or WSL2.
- **User:** The default user is `yocto` with password `yoctopass` (change in Dockerfile if needed).

## Troubleshooting
- If you get errors about missing images, make sure to build the image first.
- If you get errors about case-insensitive filesystems, do not use a Windows bind mount for your build directory.
- If you still see old file ownership behavior after updating these scripts, rebuild the image with `./build-yocto-linux.sh` before starting the container again.
- To copy files in/out of the container, use `docker cp` or a shared volume.

## Example: Copying Files Out of the Container
```sh
docker cp my-yocto-container:/home/yocto/projects ./projects_backup
```

## License
MIT
