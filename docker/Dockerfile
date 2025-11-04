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



# ros workspace
RUN mkdir -p /root/catkin_ws/src && \
    cd /root/catkin_ws && \
    bash -c "source /opt/ros/noetic/setup.bash && catkin build" && \
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN echo "#!/bin/bash" > /root/start.sh && \
    echo "cd /root/catkin_ws" >> /root/start.sh && \
    echo "source /opt/ros/noetic/setup.bash" >> /root/start.sh && \
    echo "catkin build -j" >> /root/start.sh && \ 
    echo "source ~/catkin_ws/devel/setup.bash" >> /root/start.sh && \
    echo "exec \"\$@\"" >> /root/start.sh && \
    chmod +x /root/start.sh

    
ENTRYPOINT ["/root/start.sh"]

CMD ["/bin/bash"]