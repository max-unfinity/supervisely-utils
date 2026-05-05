FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV DEBIAN_FRONTEND=noninteractive
ENV TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6 8.9 9.0 12.0+PTX"

# Install build dependencies and Python 3.10 exactly
RUN apt-get update && apt-get install -y --no-install-recommends -qq \
    build-essential \
    python3.10 \
    python3.10-dev \
    python3-pip \
    git \
    curl \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libmagic-dev \
    libexiv2-dev \
    libgomp1 \
    && ln -sf /usr/bin/python3.10 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade setuptools, wheel
RUN pip install --no-cache-dir --upgrade setuptools==69.5.1 wheel

# Install PyTorch (cached layer if versions don't change)
RUN pip install --no-cache-dir \
    torch==2.7.1 \
    torchvision==0.22.1 \
    --index-url https://download.pytorch.org/whl/cu128

    
# Install Python packages (for supervisely)
RUN pip install --no-cache-dir \
    tensorboard \
    jsonlines \
    scipy \
    shapely==2.1.2 \
    six \
    terminaltables \
    matplotlib \
    fastapi==0.119.1 \
    uvicorn==0.38.0 \
    pydantic==2.12.3 \
    starlette==0.47.3 \
    urllib3==2.2.3 \
    pillow==10.4.0 \
    SimpleITK==2.4.1 \
    pandas==2.3.3 \
    plotly==5.22.0 \
    markdown \
    pymdown-extensions==10.19 \
    tbparse \
    kaleido==0.2.1


RUN apt-get update && apt-get install -y --no-install-recommends -qq \
    wget \
    ffmpeg \