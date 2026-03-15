#!/bin/bash
set -euo pipefail

username="${YOCTO_USERNAME:-yocto}"
local_uid="${LOCAL_UID:-}"
local_gid="${LOCAL_GID:-}"
local_umask="${LOCAL_UMASK:-0022}"

if ! id "$username" >/dev/null 2>&1; then
  echo "Configured user '$username' does not exist." >&2
  exit 1
fi

current_uid="$(id -u "$username")"
current_gid="$(id -g "$username")"

if [ -n "$local_gid" ] && [ "$local_gid" != "$current_gid" ]; then
  if getent group "$local_gid" >/dev/null 2>&1; then
    usermod -g "$local_gid" "$username"
  else
    groupmod -g "$local_gid" "$username"
    usermod -g "$local_gid" "$username"
  fi
fi

if [ -n "$local_uid" ] && [ "$local_uid" != "$current_uid" ]; then
  existing_user="$(getent passwd "$local_uid" | cut -d: -f1 || true)"
  if [ -n "$existing_user" ] && [ "$existing_user" != "$username" ]; then
    echo "Cannot map $username to UID $local_uid because it is already used by $existing_user." >&2
    exit 1
  fi
  usermod -u "$local_uid" "$username"
fi

umask "$local_umask"
export HOME="/home/$username"

if [ -d "$HOME" ]; then
  chown "$username":"$(id -gn "$username")" "$HOME"
fi

if [ "$#" -eq 0 ]; then
  set -- bash
fi

exec sudo -E -H -u "$username" -- "$@"