FROM nvidia/opengl:1.0-glvnd-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
#base
# RUN apt update && apt upgrade -y

# RUN apt-get update && apt-get install -y ca-certificates
# RUN rm -f /etc/apt/sources.list.d/* \
#  && printf 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse\n' \
#  > /etc/apt/sources.list \
#  && apt-get update \
#  && apt-get install -y ca-certificates \
#  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y lsb-release curl wget ca-certificates git gnupg gdb

#ros-noetic-desktop-full
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update && apt-get install -y ros-noetic-desktop-full
RUN apt-get update && apt-get install -y python3-pip python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc   
RUN echo "export DISABLE_ROS1_EOL_WARNINGS=1" >> ~/.bashrc  
 



WORKDIR /root
RUN apt-get update && apt-get install -y libceres-dev libgmock-dev lua5.2 liblua5.2-dev ninja-build stow
RUN git clone https://github.com/abseil/abseil-cpp.git && cd abseil-cpp && \
    git checkout 215105818dfde3174fe799600bb0f3cae233d0bf && \
    mkdir build && cd build && \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl .. && \
    ninja && ninja install && cd /usr/local/stow && stow absl  && rm -rf /root/abseil-cpp

RUN apt-get update && apt-get install -y libasio-dev

RUN mkdir -p dependencies_catkin_ws/src
RUN git clone https://github.com/agilexrobotics/ranger_ros.git dependencies_catkin_ws/src/ranger_ros
RUN git clone https://github.com/agilexrobotics/ugv_sdk.git dependencies_catkin_ws/src/ugv_sdk





#base
# RUN apt-get update && apt-get install -y ros-noetic-hector-trajectory-server  ros-noetic-tf2-sensor-msgs 

# ros workspace








# #DSV planner
# RUN apt-get update && apt-get install -y ros-noetic-octomap-ros libgoogle-glog-dev libgflags-dev

# RUN apt-get update && apt-get install -y ros-noetic-explore-lite


RUN cd dependencies_catkin_ws && \
    bash -c "source /opt/ros/noetic/setup.bash && catkin_make" && \
    echo "source ~/dependencies_catkin_ws/devel/setup.bash" >> ~/.bashrc

   
RUN apt-get update && apt-get install -y ros-noetic-navigation ros-noetic-teb-local-planner \
                                            ros-noetic-sick-scan-xd \
                                            ros-noetic-point-cloud2-filters ros-noetic-pointcloud-to-laserscan

#autonomous_exploration_development_environment
RUN apt-get update && apt-get install -y libusb-dev

#rtabmap
RUN apt-get update && apt-get install -y ros-noetic-rtabmap-ros ros-noetic-libpointmatcher ros-noetic-libg2o ros-noetic-gtsam

#DLO
RUN apt-get update && apt-get install -y libomp-dev libpcl-dev libeigen3-dev 

#speed
RUN apt-get update && apt-get install -y ros-noetic-interactive-marker-twist-server ros-noetic-twist-mux 

#husky
RUN apt-get update && apt-get install -y ros-noetic-husky-simulator

RUN apt-get update && apt-get install -y ros-noetic-ur-description

RUN apt-get update && apt-get install -y ros-noetic-sensor-filters

RUN mkdir -p catkin_ws/src && \
    cd catkin_ws && \
    bash -c "source /opt/ros/noetic/setup.bash && catkin build" && \
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc   

RUN echo "#!/bin/bash" > /root/start.sh && \
    echo "cd /root/catkin_ws" >> /root/start.sh && \
    echo "source /opt/ros/noetic/setup.bash" >> /root/start.sh && \
    echo "source ~/dependencies_catkin_ws/devel/setup.bash" >> /root/start.sh && \
    echo "CORES=\$(nproc)" >> /root/start.sh && \
    echo "JOBS=\$((CORES>1 ? CORES-1 : 1))" >> /root/start.sh && \
    echo "catkin build -j\$JOBS" >> /root/start.sh && \
    echo "source ~/catkin_ws/devel/setup.bash" >> /root/start.sh && \
    echo "exec \"\$@\"" >> /root/start.sh && \
    chmod +x /root/start.sh

    
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
RUN mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

ENTRYPOINT ["/root/start.sh"]

CMD ["/bin/bash"]
