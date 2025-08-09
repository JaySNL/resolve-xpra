FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive \
    USERNAME=pod HOME=/home/pod DISPLAY=:100 XPRA_HTML=1 \
    WORKSPACE=/workspace WEBDAV_URL= WEBDAV_VENDOR=nextcloud \
    WEBDAV_USER= WEBDAV_PASS= WEBDAV_MOUNT=/mnt/webdav WEBDAV_MODE=rclone
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal dbus-x11 policykit-1 \
    xpra xpra-html5 pulseaudio alsa-utils \
    xserver-xorg-video-all mesa-utils \
    rclone fuse3 libfuse2 \
    gvfs gvfs-backends \
    wget curl git sudo ca-certificates unzip xz-utils file locales \
    libnss3 libasound2 libxkbcommon0 libxkbcommon-x11-0 libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*
# allow rclone --allow-other if FUSE is present
RUN sed -i 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf || echo user_allow_other >> /etc/fuse.conf
RUN useradd -m -s /bin/bash ${USERNAME} && \
    usermod -aG audio,video,sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    mkdir -p ${WORKSPACE} ${WEBDAV_MOUNT} /opt/scripts && \
    chown -R ${USERNAME}:${USERNAME} ${WORKSPACE} ${WEBDAV_MOUNT} /opt/scripts
RUN git clone --depth=1 https://github.com/alahak/MakeResolveDeb /opt/MakeResolveDeb
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/mount-webdav.sh /opt/scripts/mount-webdav.sh
COPY docker/install-resolve.sh /opt/scripts/install-resolve.sh
RUN chmod +x /entrypoint.sh /opt/scripts/*.sh
EXPOSE 8080
USER ${USERNAME}
WORKDIR ${WORKSPACE}
ENTRYPOINT ["/entrypoint.sh"]
