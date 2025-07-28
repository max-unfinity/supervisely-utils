ARG IMAGE
FROM $IMAGE

RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-get update && apt-get install -y --no-install-recommends wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb

# SSH-server
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo openssh-server
RUN mkdir -p /run/sshd

# RUN apt update && apt install -y sudo wireguard iproute2

RUN pip config set global.disable-pip-version-check true




# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
    autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip \
    patch rsync meson ninja-build \
    openssh-server sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    ca-certificates \
    libssl-dev \
    pkg-config \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install patchelf >= 0.18.x
RUN wget https://github.com/NixOS/patchelf/releases/download/0.18.0/patchelf-0.18.0-x86_64.tar.gz && \
    tar -xzf patchelf-0.18.0-x86_64.tar.gz && \
    mv bin/patchelf /usr/local/bin/ && \
    chmod +x /usr/local/bin/patchelf && \
    rm -rf patchelf-0.18.0-x86_64.tar.gz bin

# Create directory for sysroot
RUN mkdir -p /opt/sysroot

# Download Ubuntu 20.04 libraries directly from the repository
# This approach is more reliable as it gets the current versions
RUN cd /opt/sysroot && \
    # Enable Ubuntu 20.04 repository temporarily
    echo "deb http://archive.ubuntu.com/ubuntu focal main" > /tmp/focal.list && \
    apt-get update -o Dir::Etc::sourcelist="/tmp/focal.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" && \
    # Download the packages without installing them
    apt-get download -o Dir::Etc::sourcelist="/tmp/focal.list" -o Dir::Etc::sourceparts="-" \
        libc6:amd64 libstdc++6:amd64 libgcc-s1:amd64 gcc-10-base:amd64 && \
    # Extract the debs
    for deb in *.deb; do dpkg-deb -x "$deb" .; done && \
    rm *.deb && \
    # Create proper directory structure
    mkdir -p lib/x86_64-linux-gnu && \
    # Move libraries to expected locations
    if [ -d usr/lib/x86_64-linux-gnu ]; then \
        cp -r usr/lib/x86_64-linux-gnu/* lib/x86_64-linux-gnu/ || true; \
    fi && \
    if [ -d lib/x86_64-linux-gnu ]; then \
        find lib/x86_64-linux-gnu -name "ld-*.so" -exec cp {} lib/ \; || true; \
    fi && \
    # Create symlinks for the dynamic linker
    cd lib && \
    if [ -f ld-2.31.so ]; then \
        ln -sf ld-2.31.so ld-linux-x86-64.so.2; \
    else \
        # Find any ld-*.so file and create symlink
        for ld in ld-*.so; do \
            [ -f "$ld" ] && ln -sf "$ld" ld-linux-x86-64.so.2 && break; \
        done; \
    fi && \
    cd /opt/sysroot && \
    # Clean up
    rm -f /tmp/focal.list && \
    apt-get clean

# Verify the sysroot was created properly
RUN ls -la /opt/sysroot/lib/ && \
    ls -la /opt/sysroot/lib/x86_64-linux-gnu/ | head -20

# Set environment variables for VS Code Server
ENV VSCODE_SERVER_CUSTOM_GLIBC_LINKER=/opt/sysroot/lib/ld-linux-x86-64.so.2
ENV VSCODE_SERVER_CUSTOM_GLIBC_PATH=/opt/sysroot/lib/x86_64-linux-gnu:/opt/sysroot/lib
ENV VSCODE_SERVER_PATCHELF_PATH=/usr/local/bin/patchelf
