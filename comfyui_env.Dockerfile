FROM supervisely/yolov8:1.0.31

# SSH-server
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo openssh-server
RUN mkdir -p /run/sshd

RUN pip config set global.disable-pip-version-check true

# ComfyUI
WORKDIR /tmp
RUN git clone https://github.com/comfyanonymous/ComfyUI
RUN pip install -r ComfyUI/requirements.txt
WORKDIR /tmp/ComfyUI


# -- Extensions --
# ComfyUI Manager
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
RUN pip install -r custom_nodes/ComfyUI-Manager/requirements.txt

# IPAdapter Plus
# RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/ComfyUI_IPAdapter_plus

# Impact-Pack
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack custom_nodes/ComfyUI-Impact-Pack
RUN python3 custom_nodes/ComfyUI-Impact-Pack/install.py
RUN python3 custom_nodes/ComfyUI-Impact-Pack/install-manual.py
RUN pip install -r custom_nodes/ComfyUI-Impact-Pack/requirements.txt

# rgthree-comfy
# RUN git clone https://github.com/rgthree/rgthree-comfy custom_nodes/rgthree-comfy

WORKDIR /root/volume/ComfyUI

EXPOSE 8188
ENTRYPOINT ["python3", "main.py", "--listen", "0.0.0.0"]