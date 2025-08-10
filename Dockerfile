FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    USERNAME=pod \
    HOME=/home/pod \
    DISPLAY=:100 \
    WORKSPACE=/workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal dbus dbus-x11 policykit-1 \
    xpra pulseaudio alsa-utils \
    xserver-xorg-video-all mesa-utils \
    wget curl git sudo ca-certificates unzip xz-utils file locales \
    libnss3 libasound2 libxkbcommon0 libxkbcommon-x11-0 libglu1-mesa \
    xfce4-goodies xfce4-notifyd xfce4-power-manager \
    gvfs gvfs-daemons gvfs-backends \
    tumbler ffmpegthumbnailer \
    dbus-user-session xdg-user-dirs \
    policykit-1-gnome \
 && rm -rf /var/lib/apt/lists/*

# HTML5 client assets for Xpra
RUN rm -rf /usr/share/xpra/www && \
    mkdir -p /tmp/xpra-html5 && \
    curl -L https://codeload.github.com/Xpra-org/xpra-html5/tar.gz/refs/heads/master \
      | tar xz -C /tmp/xpra-html5 --strip-components=1 && \
    mv /tmp/xpra-html5/html5 /usr/share/xpra/www && \
    rm -rf /tmp/xpra-html5

# Unprivileged user + scripts
RUN useradd -m -s /bin/bash ${USERNAME} && \
    usermod -aG audio,video,sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    mkdir -p ${WORKSPACE} /opt/scripts && \
    chown -R ${USERNAME}:${USERNAME} ${WORKSPACE} /opt/scripts

# Runtime scripts
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/install-resolve.sh /opt/scripts/install-resolve.sh
RUN chmod +x /entrypoint.sh /opt/scripts/*.sh

EXPOSE 8080
USER ${USERNAME}
WORKDIR ${WORKSPACE}
ENTRYPOINT ["/entrypoint.sh"]
