cmake_minimum_required(VERSION 3.0.2)
project(nav)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE "Release")

find_package(catkin REQUIRED COMPONENTS
    roscpp
    rospy
    cv_bridge
    nodelet
    dynamic_reconfigure
    tf
    pcl_conversions
    pcl_ros
    std_msgs
    sensor_msgs
    geometry_msgs
    nav_msgs
    gazebo_msgs
)

find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(OpenMP REQUIRED)
find_package(Boost REQUIRED)
find_package(PCL REQUIRED)
find_package(SQLite3 REQUIRED)

catkin_package(
)


include_directories(
    include
    ${catkin_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
    ${EIGEN3_INCLUDE_DIR}
    ${PCL_INCLUDE_DIRS}
    ${SQLite3_INCLUDE_DIRS}
)


set(COMMON_LIBRARIES ${catkin_LIBRARIES} ${OpenCV_LIBRARIES} ${PCL_LIBRARIES} ${SQLite3_LIBRARIES} 
    OpenMP::OpenMP_CXX)

add_library(msp_nodelets 
    src/sim/sensor_input_nodelet.cpp
  src/sim/localization_sim_nodelet.cpp
  )
target_compile_definitions(msp_nodelets PRIVATE PCL_NO_PRECOMPILE)
target_link_libraries(msp_nodelets ${COMMON_LIBRARIES})
