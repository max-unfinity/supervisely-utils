ARG IMAGE
FROM $IMAGE

# RUN rm /etc/apt/sources.list.d/cuda.list
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list
# RUN apt-key del 7fa2af80
# RUN apt-get update && apt-get install -y --no-install-recommends wget
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
# RUN dpkg -i cuda-keyring_1.0-1_all.deb

# SSH-server
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo openssh-server
RUN mkdir -p /run/sshd

RUN apt update && apt install -y sudo wireguard iproute2

RUN pip config set global.disable-pip-version-check true
