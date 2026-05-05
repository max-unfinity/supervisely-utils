# ============================================
# Stage 1: Builder - Contains build tools
# ============================================
FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04 AS builder
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
RUN pip install --no-cache-dir --upgrade setuptools==59.8.0 wheel

# Install PyTorch (cached layer if versions don't change)
RUN pip install --no-cache-dir \
    torch==2.7.1 \
    torchvision==0.22.1 \
    --index-url https://download.pytorch.org/whl/cu128

# Clone and build mmcv from specific version tag
RUN pip install --no-cache-dir \
    opencv-python==4.6.0.66 \
    numpy==1.26.4 \
    PyYAML \
    Pillow==10.4.0 \
    yapf==0.32.0 \
    addict \
    packaging==22.0 \
    ninja
RUN git clone --depth 1 --branch v1.6.2 https://github.com/open-mmlab/mmcv.git /mmcv
WORKDIR /mmcv
RUN sed -i "s/'-std=c++14'/'-std=c++17'/g" setup.py
RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip install --no-cache-dir -e . -v

# Clean up build artifacts to reduce image size
RUN rm -rf /mmcv/build \
    && rm -rf /mmcv/.git \
    && rm -rf /mmcv/docs \
    && rm -rf /mmcv/tests

# Install Python packages
RUN pip install --no-cache-dir \
    tensorboard \
    scipy \
    termcolor  \
    prettytable \
    matplotlib \
    timm==0.6.11 \
    mmcls==0.20.1 \
    mmsegmentation==0.27.0

RUN git clone https://github.com/OpenGVLab/InternImage.git /InternImage
WORKDIR /InternImage/segmentation/ops_dcnv3

# Apply all compatibility fixes for PyTorch 2.7.1
RUN sed -i 's/if torch.cuda.is_available() and CUDA_HOME is not None:/if (torch.cuda.is_available() or os.getenv("FORCE_CUDA", "0") == "1") and CUDA_HOME is not None:/' setup.py && \
    sed -i 's/input\.type(), "ms_deform_attn_forward_cuda"/input.scalar_type(), "ms_deform_attn_forward_cuda"/' src/cuda/dcnv3_cuda.cu && \
    sed -i 's/input\.type(), "ms_deform_attn_backward_cuda"/input.scalar_type(), "ms_deform_attn_backward_cuda"/' src/cuda/dcnv3_cuda.cu && \
    sed -i 's/\.type()\.is_cuda()/.is_cuda()/g' src/cuda/dcnv3_cuda.cu && \
    sed -i 's/\.type()\.is_cuda()/.is_cuda()/g' src/dcnv3.h && \
    sed -i 's/opmath_t/at::opmath_type<scalar_t>/g' src/cuda/dcnv3_cuda.cu

# Build the extension
RUN FORCE_CUDA=1 bash make.sh

RUN pip install --no-cache-dir mmdet==2.28.1

# ============================================
# Stage 2: Runtime - Minimal runtime image
# ============================================
FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends -qq \
    python3.10 \
    python3.10-distutils \
    python3-pip \
    wget \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libmagic1 \
    libexiv2-27 \
    libgomp1 \
    && ln -sf /usr/bin/python3.10 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /usr/local/lib/python3.10/dist-packages /usr/local/lib/python3.10/dist-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy mmcv and InternImage
COPY --from=builder /mmcv /mmcv
COPY --from=builder /InternImage /InternImage
WORKDIR /InternImage/segmentation
