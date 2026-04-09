map_name=$1
num_expand=$2
currentDir=`dirname "$(realpath $0)"`
cd ${currentDir}/../
source install_isolated/setup.bash
MAP_DIR=${PWD}/map/map_${map_name}
mkdir -p $MAP_DIR
if [ $num_expand -gt 0 ]
then
    extend_map_state_file="-load_state_filename ${MAP_DIR}/map.pbstream"
    record_bag_name="${MAP_DIR}/record${num_expand}.bag"
else
	extend_map_state_file=""
    record_bag_name="${MAP_DIR}/record.bag"
fi
echo ${record_bag_name}
roslaunch cartographer_ros mapping_sick.launch use_sim_time:=false record_path:="record -O ${record_bag_name} /odom /cloud_all_fields_fullframe/filtered /multiScan/imu /tf /tf_static" extend_map_state_file:="${extend_map_state_file}"