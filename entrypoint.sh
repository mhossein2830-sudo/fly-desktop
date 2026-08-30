#!/bin/bash
set -e

if [ ! -d /dev/net ]; then
    mkdir -p /dev/net
fi
if [ ! -e /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
    chmod 600 /dev/net/tun
fi

tailscaled &
sleep 3

echo "Connecting to Tailscale..."
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="fly-desktop" --accept-routes

service dbus start
/usr/sbin/xrdp-sesman
/usr/sbin/xrdp -n
