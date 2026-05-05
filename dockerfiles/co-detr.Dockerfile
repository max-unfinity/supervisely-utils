FROM nvidia/cuda:11.5.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    ninja-build \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip install torch==1.11.0+cu115 torchvision==0.12.0+cu115 --extra-index-url https://download.pytorch.org/whl/cu115
# RUN pip install openmim
RUN pip install mmcv-full==1.5.0 -f https://download.openmmlab.com/mmcv/dist/cu115/torch1.11.0/index.html

# mmdet
# RUN mim install mmdet[multimodal]