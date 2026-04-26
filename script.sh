#!/bin/bash
# this is a custom script that automates the steps needed to build and flash
# a firmware image onto the nrf52840dongle from the zephyr rtos repository
# the process includes the follwoing main steps
# 1) west -p -b nrf52840dongle
# 2) building the package with the nrfutil
# 3) flashing using the nrfutil
#
#   NOTE: to use this script, the dongle should be in dfu mode (reset button)
# 
# Author: Omid Kandelusy
# =============================================================================

echo "building ..."
west build -p -b nrf52840dongle

set -e

echo "going to the binaries path ..."
cd ./build/zephyr

echo "creating the app package for nrfutil ... "
nrfutil pkg generate --hw-version 52 --sd-req=0x00  --application zephyr.hex --application-version 1 app.zip


echo "flashing ..."
nrfutil device program --firmware app.zip --traits nordicDfu

echo "Done!"

