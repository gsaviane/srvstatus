#!/bin/bash
set -e

EQIVA_MAC_1="00:1A:22:1C:4D:DC"

echo "Enable Bluetooth device for scanning ..."

# Ensure Bluetooth is powered on and scanning is enabled
bluetoothctl power on

sleep 2  # Give time to discover devices

if ! bluetoothctl paired-devices | grep -q -i "$EQIVA_MAC_1" ; then

  # NOTE: no PIN is entered, as bluetoothctl has a poor way to control the prompt
  bluetoothctl agent DisplayOnly
  
  echo "Attempt paring with device ($EQIVA_MAC_1) ..."
  # Try pairing

  TIMEOUT=30  # Set timeout in seconds
  START_TIME=$SECONDS

  DEV_FOUND=false
  while read -t $TIMEOUT line; do
    # echo "$line"
    if [[ "${line,,}" == *"${EQIVA_MAC_1,,}"* ]]; then
        echo "Device ($EQIVA_MAC_1) found!"
        DEV_FOUND=true
        break
    fi
  done < <(stdbuf -oL bluetoothctl -- scan on)

  # scan off throws an error!
  bluetoothctl scan off || true
  if ! $DEV_FOUND; then
    echo "Device ($EQIVA_MAC_1) not discoverable! $DEV_FOUND"
    exit 1
  fi

  TIMEOUT=10
  # bluetoothctl pair "$EQIVA_MAC_1"
  # CATCH [agent] Enter passkey (number in 0-999999): 832974
  bluetoothctl <<EOF
  trust $EQIVA_MAC_1
  pair $EQIVA_MAC_1
EOF
# while read -t $TIMEOUT line; do
#    echo "$line"
#    if [[ "$line" == *"Enter passkey (number in 0-999999):"* ]]; then
#        printf "832974"
#        break
#    fi
#  done

  echo "Paired!"

fi

echo "Connecting to Bluetooth device ($EQIVA_MAC_1) ..."

bluetoothctl connect "$EQIVA_MAC_1"


echo "Bluetooth device ($EQIVA_MAC_1) should now be paired and connected!"
