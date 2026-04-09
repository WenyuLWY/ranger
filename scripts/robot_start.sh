#!/bin/bash
set -e

currentDir=$(dirname "$(realpath "$0")")
cd "${currentDir}/../" || exit 1

export DISPLAY=:0.0

echo "===================================="
echo "[1/4] Enabling gs_usb kernel module..."
echo "===================================="
sudo modprobe gs_usb || echo "⚠️  Failed to load gs_usb (might already be loaded)"

echo "===================================="
echo "[2/4] Setting up CAN-to-USB interface..."
echo "===================================="

FIRST_TIME=false

# if [ "$FIRST_TIME" = true ]; then
#   echo "Running setup_can2usb.bash (first-time setup)..."
#   source devel/setup.bash
#   rosrun ranger_bringup setup_can2usb.bash
# else
#   echo "Running bringup_can2usb.bash (normal startup)..."
#   source devel/setup.bash
#   rosrun ranger_bringup bringup_can2usb.bash
# fi

echo "===================================="
echo "[3/4] Launching ranger_bringup..."
echo "===================================="
source devel/setup.bash
roslaunch ranger_bringup ranger.launch &
RANGER_PID=$!

sleep 2

echo "===================================="
echo "[4/4] Launching sick_scan_xd..."
echo "===================================="
source install_isolated/setup.bash
roslaunch sick_scan_xd sick_multiscan.launch &
SICK_PID=$!

trap "echo 'Stopping all...'; kill $RANGER_PID $SICK_PID" SIGINT SIGTERM
wait
