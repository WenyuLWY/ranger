map_name=$1
num_expand=$2
launch_file=assets_writer_ros_map.launch
currentDir=`dirname "$(realpath $0)"`
cd ${currentDir}/../
source install_isolated/setup.bash
rosservice call /finish_trajectory "trajectory_id: 0"
sleep .5
MAP_DIR=${PWD}/map/map_$map_name
rosservice call /write_state "{filename: '${MAP_DIR}/map.pbstream', include_unfinished_submaps: "true"}"
rosnode kill /rosbag_record_mapping
sleep 2
rosnode kill /cartographer_node
sleep 2
record_bags="${MAP_DIR}/record.bag"
if [ $num_expand -gt 0 ]
then
   for (( c=1; c<=${num_expand}; c++ ))
   do  
      record_bags=${record_bags}","${MAP_DIR}/record${c}.bag
   done
fi
echo ${record_bags}
roslaunch cartographer_ros ${launch_file} bag_filenames:="${record_bags}" pose_graph_filename:=${MAP_DIR}/map.pbstream
sleep .5