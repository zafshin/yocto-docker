FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Set up dependencies
RUN apt-get update && apt-get install -y \
    sudo git wget diffstat unzip texinfo gcc g++ build-essential chrpath socat \
    cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    libsdl1.2-dev xterm curl locales nano passwd \
    file gawk zstd lz4 \
    && rm -rf /var/lib/apt/lists/*

# Optional: Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ARG USERNAME=yocto
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_PASSWORD=yoctopass
# Robust user/group creation: if UID/GID 1000 is taken, reuse or pick new
RUN set -eux; \
  if id "$USERNAME" >/dev/null 2>&1; then \
    echo "User $USERNAME already exists."; \
    usermod -aG sudo $USERNAME; \
    echo "$USERNAME:$USER_PASSWORD" | chpasswd; \
  else \
    # Check if UID exists, if so, use next available UID
    if getent passwd $USER_UID >/dev/null; then \
      echo "UID $USER_UID already exists, finding next available UID"; \
      USER_UID=$(awk -F: '($3>=1000)&&($3!=65534){print $3}' /etc/passwd | sort -n | tail -1); \
      USER_UID=$((USER_UID+1)); \
    fi; \
    # Check if GID exists, if so, use next available GID
    if getent group $USER_GID >/dev/null; then \
      echo "GID $USER_GID already exists, finding next available GID"; \
      USER_GID=$(awk -F: '($3>=1000)&&($3!=65534){print $3}' /etc/group | sort -n | tail -1); \
      USER_GID=$((USER_GID+1)); \
    fi; \
    groupadd -g $USER_GID $USERNAME; \
    useradd -m -u $USER_UID -g $USER_GID $USERNAME; \
    echo "$USERNAME:$USER_PASSWORD" | chpasswd; \
    usermod -aG sudo $USERNAME; \
  fi; \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME; \
  chmod 0440 /etc/sudoers.d/$USERNAME
RUN cat /etc/passwd

# Set working directory
WORKDIR /home/${USERNAME}

# Set bash as default shell for all users with home directories and for root
RUN awk -F: '($7!="/bin/bash" && ($6 ~ /^\/home\// || $1=="root")) {print $1}' /etc/passwd | xargs -r -I{} usermod -s /bin/bash {} || true

# Switch to non-root user
USER $USERNAME
