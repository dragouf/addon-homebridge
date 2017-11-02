#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Homekit2Mqtt
# Runs Homekit2Mqtt
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly HOMEKITCONFIG_FILE=/config/homekit2mqtt/config.json

# Wait at least 5 seconds before staring Homebridge
# Avahi might need some time.
sleep 5

if hass.debug; then
  homekit2mqtt -u "mqtt://192.168.1.12" -m "$(dirname "$HOMEKITCONFIG_FILE")"
else
  homekit2mqtt -u "mqtt://192.168.1.12" -m "$(dirname "$HOMEKITCONFIG_FILE")"
fi
