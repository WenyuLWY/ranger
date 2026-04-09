#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <map_name>"
  exit 1
fi

map_name=$1
sim=false

currentDir=$(dirname "$(realpath "$0")")
cd "${currentDir}/../" || exit 1

if [ -f "install_isolated/setup.bash" ]; then
  source install_isolated/setup.bash
elif [ -f "devel/setup.bash" ]; then
  source devel/setup.bash
else
  echo "Error: setup.bash not found!"
  exit 1
fi

MAP_DIR="${PWD}/map/map_${map_name}"

if [ ! -d "${MAP_DIR}" ]; then
  echo "Error: Map directory not found: ${MAP_DIR}"
  exit 1
fi

BAG_FILE="${MAP_DIR}/record.bag"
PBSTREAM_FILE="${MAP_DIR}/map.pbstream"

if [ ! -f "${BAG_FILE}" ]; then
  echo "Warning: ${BAG_FILE} not found!"
fi
if [ ! -f "${PBSTREAM_FILE}" ]; then
  echo "Warning: ${PBSTREAM_FILE} not found!"
fi

echo "Launching localization with map: ${map_name}"
roslaunch cartographer_ros localization_sick.launch \
  sim:=${sim} \
  bag_filename:=${BAG_FILE} \
  load_state_filename:=${PBSTREAM_FILE}

exit 0
