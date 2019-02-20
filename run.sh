#!/bin/sh
set -e

mkdir -p /var/lib/mosquitto

chmod 777 -R /var/lib/mosquitto
chown mosquitto:mosquitto -R /var/lib/mosquitto

echo "Serving with (${HTTP_HOSTNAME:-localhost}) ${HTTP_IP:-127.0.0.1}:${HTTP_PORT:-80} parameters"

sed -i "s/env_http_ip/${HTTP_IP:-127.0.0.1}/" /etc/mosquitto/mosquitto.conf
sed -i "s/env_http_port/${HTTP_PORT:-80}/" /etc/mosquitto/mosquitto.conf
sed -i "s/env_http_hostname/${HTTP_HOSTNAME:-localhost}/" /etc/mosquitto/mosquitto.conf

if [ "$1" = 'mosquitto' ]; then
        exec mosquitto -c /etc/mosquitto/mosquitto.conf
fi

if [ "$1" = 'mosquitto-verbose' ]; then
        exec mosquitto -v -c /etc/mosquitto/mosquitto.conf
fi

exec "$@"