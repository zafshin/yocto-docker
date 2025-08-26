FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Set up dependencies
RUN apt-get update && apt-get install -y \
    sudo git wget diffstat unzip texinfo gcc g++ build-essential chrpath socat \
    cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    libsdl1.2-dev xterm curl locales nano passwd \
    file gawk zstd \
    && rm -rf /var/lib/apt/lists/*

# Optional: Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install whois for mkpasswd (to hash password)
RUN apt-get update && apt-get install -y whois && rm -rf /var/lib/apt/lists/*

ARG USERNAME=yocto
ARG USER_UID=1000
ARG USER_GID=1000

RUN set -eux; \
    # Create group if needed
    if ! getent group "$USER_GID" >/dev/null; then \
      groupadd -g "$USER_GID" "$USERNAME"; \
    fi; \
    # If UID exists, rename user; else, create new user
    if id -u "$USER_UID" >/dev/null 2>&1; then \
      EXISTING_USER=$(getent passwd "$USER_UID" | cut -d: -f1); \
      usermod -l "$USERNAME" -d /home/"$USERNAME" -m -g "$USER_GID" "$EXISTING_USER"; \
      groupmod -n "$USERNAME" "$EXISTING_USER"; \
    elif id "$USERNAME" >/dev/null 2>&1; then \
      usermod -u "$USER_UID" -g "$USER_GID" "$USERNAME"; \
    else \
      useradd -m -u "$USER_UID" -g "$USER_GID" -s /bin/bash -p '' "$USERNAME"; \
    fi; \
    usermod -aG sudo "$USERNAME"; \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/"$USERNAME"; \
    chmod 0440 /etc/sudoers.d/"$USERNAME"

# Set working directory
WORKDIR /workspace

# Set bash as default shell for all users with home directories and for root
RUN awk -F: '($7!="/bin/bash" && ($6 ~ /^\/home\// || $1=="root")) {print $1}' /etc/passwd | xargs -r -I{} usermod -s /bin/bash {} || true

# Switch to non-root user
USER $USERNAME