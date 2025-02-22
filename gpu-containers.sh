#!/bin/bash

# sudo cat /proc/3018966/environ | xargs -0 -L1 | grep -E '^(APP_NAME|SERVER_ADDRESS|TASK_ID|USER_LOGIN)='

# Get a list of PIDs and their GPU memory usage
pids=$(nvidia-smi pmon -c 1 -s mu | awk 'NR>2 && $3=="C" {print $2, $4}')

# Print table header
printf "%-12s %-15s %-20s %-40s %-30s\n" "PID" "CONTAINER_ID" "GPU_MEMORY_USAGE(MB)" "IMAGE_NAME" "NAMES"

# Iterate over each PID and get the Docker container ID
echo "$pids" | while read pid mem; do
    if [[ ! -z $pid && ! -z $mem ]]; then
        container_id=$(cat /proc/$pid/cgroup | grep 'docker' | awk -F'/' '{print $NF}')
        # for kubepods
        if [ -z "$container_id" ]; then
            container_id=$(cat /proc/$pid/cgroup | head -n1 | sed 's/.*cri-containerd-\([a-f0-9]*\).*/\1/')
        fi
        container_id_short=${container_id:0:12}
        docker_info=$(docker ps --no-trunc | grep $container_id)
        image_name=$(echo $docker_info | awk '{print $2}')
        # for kubepods
        if [ -z "$image_name" ]; then
            image_name=$(sudo crictl inspect cec202aa5a67 | grep '"image": "docker' | head -n1 | awk -F'"' '{print $4}')
        fi
        name=$(echo $docker_info | awk '{print $NF}')
        name_short="${name:0:30}""..."
        printf "%-12s %-15s %-20s %-40s %-30s\n" $pid $container_id_short $mem $image_name $name_short
    fi
done
