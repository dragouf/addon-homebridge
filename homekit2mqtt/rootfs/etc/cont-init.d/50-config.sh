#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: homekit2mqtt
# Generates the Homekit2Mqtt configuration file
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Configuration paths
readonly HOMEKIT2MQTT_CONFIG_FILE=/config/homekit2mqtt/config.json
readonly HOMEKIT2MQTT_TEMPLATE_CONFIG_FILE=/root/homekit2mqtt-config.json

# ------------------------------------------------------------------------------
# Generates a random pin number for HomeKit (###-##-### format)
#
# Arguments:
#   None
# Returns:
#   The generated random pin number
# ------------------------------------------------------------------------------
generate_homekit_pin() {
  local pin

  pin=$(< /dev/urandom tr -dc 0-9 | head -c3)
  pin+="-"
  pin+=$(< /dev/urandom tr -dc 0-9 | head -c2)
  pin+="-"
  pin+=$(< /dev/urandom tr -dc 0-9 | head -c3)

  echo "$pin"
}

# ------------------------------------------------------------------------------
# Finds the MAC address of the main interface
#
# Arguments:
#   None
# Returns:
#   MAC address of the main interface (upper-cased)
# ------------------------------------------------------------------------------
get_mac_addr() {
  local interface
  local mac

  interface=$(ip route show default | awk '/default/ {print $5}')
  mac=$(cat "/sys/class/net/$interface/address")

  echo "${mac^^}"
}

# Create Homekit2Mqtt configuration directory when it is missing
if ! hass.directory_exists "$(dirname "${HOMEKIT2MQTT_CONFIG_FILE}")"; then
    mkdir -p "$(dirname "${HOMEKIT2MQTT_CONFIG_FILE}")" \
        || hass.die 'Failed to create Homebrige configuration directory'
fi

# Generate Homekit2Mqtt configuration file, when missing
if ! hass.file_exists "${HOMEKIT2MQTT_CONFIG_FILE}"; then
    cp "${HOMEKIT2MQTT_TEMPLATE_CONFIG_FILE}" "${HOMEKIT2MQTT_CONFIG_FILE}" \
        || hass.die 'Failed creating Homekit2Mqtt configuration file'

    sed -i "s/%%USERNAME%%/$(get_mac_addr)/g" "${HOMEKIT2MQTT_CONFIG_FILE}" \
        || hass.die 'Failed setting Homekit2Mqtt username'
fi
