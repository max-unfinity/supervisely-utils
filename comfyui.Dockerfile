FROM supervisely/yolov8:1.0.31

# SSH-server
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo openssh-server
RUN mkdir -p /run/sshd

RUN pip config set global.disable-pip-version-check true

# ComfyUI
WORKDIR /root/volume
RUN git clone https://github.com/comfyanonymous/ComfyUI
RUN pip install -r ComfyUI/requirements.txt
WORKDIR /root/volume/ComfyUI

# Extensions
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
RUN pip install -r custom_nodes/ComfyUI-Manager/requirements.txt

RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/ComfyUI_IPAdapter_plus

RUN mkdir -p ./models/clip/
RUN mkdir -p ./models/clip_vision/
RUN mkdir -p ./models/ipadapter/
RUN mkdir -p ./models/upscale_models/
 
# Base models
RUN wget "https://civitai.com/api/download/models/914390?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/
 
# Flux 1.D
RUN wget --header="Authorization: Bearer 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" "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors" -P ./models/unet/
RUN wget --header="Authorization: Bearer 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" "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors" -P ./models/vae/
RUN wget --header="Authorization: Bearer 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" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" -P ./models/clip/
RUN wget --header="Authorization: Bearer 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" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" -P ./models/clip/

# Flux LoRAs
RUN wget "https://civitai.com/api/download/models/736227?type=Model&format=SafeTensor&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/loras
RUN wget "https://civitai.com/api/download/models/780667?type=Model&format=SafeTensor&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/loras


#sd_xl and refiner
# wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors -P ./models/checkpoints/
# wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors -P ./models/checkpoints/
