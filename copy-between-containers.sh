#!/bin/bash

set -x
SRC_ID=875f564a0c62a5ecae8d13f5b5709615b212198c19124981431ff1f8f1e51264
DST_ID=cad0cbf356bc85a5ebd3134e62f5f89c6357396b28353fd900e5db833d935894
SRC_PATH=/root/mmdetection3d-v1.x/cuda_12.0.1_525.85.12_linux.run
DST_PATH=/root/mmdetection3d-v1.x/cuda_12.0.1_525.85.12_linux.run

mkdir -p ./docker_share

docker cp $SRC_ID:$SRC_PATH ./docker_share
docker cp "./docker_share/$(basename $SRC_PATH)" $DST_ID:$DST_PATH

rm -rf ./docker_share