#!/bin/bash
set -e

map_name=$1
use_sim=false

if [ -z "$map_name" ]; then
  echo "❌ Usage: $0 <map_name>"
  echo "Example: $0 factory_floor"
  exit 1
fi

currentDir=$(dirname "$(realpath "$0")")
cd "${currentDir}/../" || exit 1
source devel/setup.bash

echo "===================================="
echo "Launching move_base with map: ${map_name}"
echo "Simulation mode: ${use_sim}"
echo "===================================="

roslaunch ranger_bringup move_base.launch \
  sim:=${use_sim} \
  map_name:=${map_name}
