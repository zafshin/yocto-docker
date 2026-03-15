#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

device="${1:-}"
image_path="${2:-}"

if [[ -z "$device" ]]; then
  echo "Usage: sudo ./flash-yocto-linux.sh /dev/sdX [path/to/image.wic.bz2]" >&2
  exit 1
fi

if [[ "$device" != /dev/* ]]; then
  device="/dev/$device"
fi

if [[ ! -b "$device" ]]; then
  echo "Block device not found: $device" >&2
  exit 1
fi

if [[ -z "$image_path" ]]; then
  image_path="$(find projects/poky/build/tmp/deploy/images -type f -name '*.wic.bz2' | sort | tail -n 1)"
fi

if [[ -z "$image_path" || ! -f "$image_path" ]]; then
  echo "No .wic.bz2 image found. Build the Yocto image first or pass the image path explicitly." >&2
  exit 1
fi

echo "Image : $image_path"
echo "Target: $device"

lsblk -o NAME,SIZE,TYPE,RM,FSTYPE,MOUNTPOINTS "$device"

read -r -p "This will erase $device. Type YES to continue: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

while read -r partition; do
  [[ -n "$partition" ]] || continue
  sudo umount "$partition" 2>/dev/null || true
done < <(lsblk -ln -o PATH "$device" | tail -n +2)

if command -v bmaptool >/dev/null 2>&1; then
  bmap_path="${image_path%.bz2}.bmap"
  if [[ -f "$bmap_path" ]]; then
    sudo bmaptool copy "$image_path" "$device"
  else
    bzip2 -dc "$image_path" | sudo dd of="$device" bs=4M conv=fsync status=progress
  fi
else
  bzip2 -dc "$image_path" | sudo dd of="$device" bs=4M conv=fsync status=progress
fi

sync
echo "Flash complete: $device"