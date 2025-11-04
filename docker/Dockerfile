FROM nvidia/opengl:1.0-glvnd-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y lsb-release curl wget ca-certificates git gnupg

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update && apt install -y ros-noetic-desktop-full
RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools 
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc   
RUN echo "export DISABLE_ROS1_EOL_WARNINGS=1" >> ~/.bashrc   

#agilex ranger
RUN apt install -y libasio-dev libboost-all-dev ros-noetic-teleop-twist-keyboard

#localization cartographer
RUN apt update && apt install -y libceres-dev libgmock-dev lua5.2 liblua5.2-dev ninja-build stow
RUN cd /root && git clone https://github.com/abseil/abseil-cpp.git && cd abseil-cpp && \
    git checkout 215105818dfde3174fe799600bb0f3cae233d0bf && \
    mkdir build && cd build && \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl .. && \
    ninja && ninja install && cd /usr/local/stow && stow absl  && rm -rf /root/abseil-cpp

# ros workspace
RUN mkdir -p /root/catkin_ws/src && \
    cd /root/catkin_ws && \
    bash -c "source /opt/ros/noetic/setup.bash && catkin_make" && \
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN echo "#!/bin/bash" > /root/start.sh && \
    echo "cd /root/catkin_ws" >> /root/start.sh && \
    echo "source /opt/ros/noetic/setup.bash" >> /root/start.sh && \
    echo "catkin_make -j" >> /root/start.sh && \ 
    echo "source ~/catkin_ws/devel/setup.bash" >> /root/start.sh && \
    echo "exec \"\$@\"" >> /root/start.sh && \
    chmod +x /root/start.sh

    
ENTRYPOINT ["/root/start.sh"]

CMD ["/bin/bash"]