#!/bin/bash


source config.env

if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

PKG_ROOT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")
mkdir -p $PKG_ROOT_DIR/tmp/{devel,build,logs}
MOUNT_ARGS=""
for path in "$PKG_ROOT_DIR"/*; do
    name=$(basename "$path")
    if [ "$name" != "tmp" ] && [ "$name" != "docker" ]; then
        MOUNT_ARGS="$MOUNT_ARGS -v $path:/root/catkin_ws/src/$name"
    fi
done
# MOUNT_ARGS="$MOUNT_ARGS -v $PKG_ROOT_DIR/tmp/build:/root/catkin_ws/build"
# MOUNT_ARGS="$MOUNT_ARGS -v $PKG_ROOT_DIR/tmp/devel:/root/catkin_ws/devel"
# MOUNT_ARGS="$MOUNT_ARGS -v $PKG_ROOT_DIR/tmp/logs:/root/catkin_ws/logs"

# -v ~/models:/root/.gazebo/models \

docker run -it --name $CONTAINER_NAME \
        --gpus all --device=/dev/dxg \
        -e DISPLAY=$DISPLAY \
        -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
        -e PULSE_SERVER=$PULSE_SERVER \
        -e XDG_RUNTIME_DIR=/tmp/runtime-root \
        -e LD_LIBRARY_PATH=/usr/lib/wsl/lib \
        -v /mnt/wslg:/mnt/wslg \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /usr/lib/wsl:/usr/lib/wsl \
        $MOUNT_ARGS \
        $IMAGE_NAME bash