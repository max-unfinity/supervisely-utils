#!/bin/bash

# Specify the log file path
LOG_FILE="gpu_processes.log"

# Infinite loop to monitor processes using GPU every second
while true; do
    # Get the count of processes using the GPU, excluding the header line
    GPU_PROCESS_COUNT=$(nvidia-smi pmon -c 1 | tail -n +3 | wc -l)
    
    # Log the count with a timestamp to the file
    echo "$(date '+%Y-%m-%d %H:%M:%S') - GPU Processes, $GPU_PROCESS_COUNT" >> "$LOG_FILE"
    
    # Wait for a second before the next iteration
    sleep 1
done
