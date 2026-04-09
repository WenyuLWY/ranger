#!/bin/bash
set -e

currentDir=$(dirname "$(realpath "$0")")
cd "${currentDir}/../" || exit 1

export DISPLAY=:0.0

echo "===================================="
echo "[1/2] Loading environment..."
echo "===================================="
source devel/setup.bash

echo "===================================="
echo "[2/2] Launching RViz..."
echo "===================================="
roslaunch ranger_bringup rviz.launch &
RVIZ_PID=$!

trap "echo 'Stopping RViz...'; kill $RVIZ_PID" SIGINT SIGTERM
wait
