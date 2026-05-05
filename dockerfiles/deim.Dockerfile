FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \    
    python3-dev \
    python3-pip \
    git \
    curl \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libmagic-dev \
    libexiv2-dev \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir torch==2.7.1 torchvision==0.22.1 --index-url https://download.pytorch.org/whl/cu128
RUN pip install --no-cache-dir PyYAML tensorboard imgaug==0.4.0 transformers==4.50.3 calflops==0.3.2 scipy==1.15.2 faster-coco-eval==1.6.5

RUN git clone https://github.com/Intellindust-AI-Lab/DEIM /root/DEIM
RUN git clone https://github.com/Intellindust-AI-Lab/DEIMv2 /root/DEIMv2
WORKDIR /root/DEIM