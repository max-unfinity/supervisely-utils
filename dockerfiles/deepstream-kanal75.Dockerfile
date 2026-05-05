# Race-vision Development Container
#
# Base: NVIDIA DeepStream 8.0 (Ubuntu 22.04, CUDA 12.x, TensorRT 10.9, Python 3.12)
#
# Build:
#   docker build -f Dockerfile-dev -t race-vision-dev .
#
# Run (see setup.md for full instructions):
#   docker run --gpus all --rm -it \
#     -v $(pwd):/workspace \
#     -v /path/to/pyds-wheel:/opt/pyds \
#     --net=host \
#     race-vision-dev

FROM nvcr.io/nvidia/deepstream:8.0-gc-triton-devel

# ── System packages ───────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build tools (for C++ plugins)
    build-essential \
    pkg-config \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    # Dev utilities
    vim \
    gdb \
    strace \
    curl \
    wget \
    jq \
    tree \
    # For CuPy GPU support
    && rm -rf /var/lib/apt/lists/*

# ── Python packages ───────────────────────────────────────────────────────────
# kafka-python-ng is the maintained fork of kafka-python
RUN pip3 install --no-cache-dir \
    kafka-python-ng \
    scipy \
    numpy \
    opencv-python-headless \
    pynvml \
    psutil \
    # CuPy for CUDA 12.x (used by raw_color_probe for GPU HSV extraction)
    cupy-cuda12x

# ── pyds (DeepStream Python bindings) ────────────────────────────────────────
# pyds is a binary wheel tied to DS version + Python version + arch.
# Required wheel: pyds-1.2.2-cp312-cp312-linux_x86_64.whl
#
# Option A (recommended): mount wheel at runtime and install on first run.
#   See setup.md § "Install pyds".
#
# Option B: copy wheel into build context and uncomment below.
#   cp /path/to/pyds-1.2.2-cp312-cp312-linux_x86_64.whl ./pyds.whl
# COPY pyds.whl /tmp/pyds.whl
# RUN pip3 install /tmp/pyds.whl && rm /tmp/pyds.whl

# ── Environment ───────────────────────────────────────────────────────────────
# GStreamer finds DeepStream plugins and any extra plugins mounted at /opt/gst-extra
ENV GST_PLUGIN_PATH=/opt/gst-extra:/usr/lib/x86_64-linux-gnu/gstreamer-1.0
# DeepStream lib path (nvdsinfer, nvmsgbroker, etc.)
ENV LD_LIBRARY_PATH=/opt/nvidia/deepstream/deepstream/lib:${LD_LIBRARY_PATH}
# Suppress TensorFlow/TRT warnings that are irrelevant to inference
ENV TF_CPP_MIN_LOG_LEVEL=3

WORKDIR /workspace

CMD ["/bin/bash"]
