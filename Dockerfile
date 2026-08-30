FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    x11-xserver-utils \
    chromium \
    curl \
    sudo \
    iptables \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update && apt-get install -y tailscale && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -G sudo admin \
    && echo "admin:AdminPass1234" | chpasswd \
    && echo "xfce4-session" > /home/admin/.xsession \
    && chown admin:admin /home/admin/.xsession

RUN adduser xrdp ssl-cert || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3389

CMD ["/entrypoint.sh"]
