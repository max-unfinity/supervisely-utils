#!/bin/bash
# set -a # automatically export all variables
mkdir -p /root/app
if [ -f "/workspaces/supervisely.env" ]; then
    while read -r line; do
        echo "export $line" >> ~/.bashrc
    done < "/workspaces/supervisely.env"
else
    echo "Environment file not found."
fi
