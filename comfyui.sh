# f5814fe67dc1e23398de1194252f1e0c -- civitai
# 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 -- huggingface


# -- Extensions --
# ComfyUI Manager
git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
pip install -r custom_nodes/ComfyUI-Manager/requirements.txt

# IPAdapter Plus
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/ComfyUI_IPAdapter_plus
pip install insightface onnxruntime-gpu==1.18

# InstantID
git clone https://github.com/cubiq/ComfyUI_InstantID custom_nodes/ComfyUI_InstantID

# Impact-Pack
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack custom_nodes/ComfyUI-Impact-Pack
python3 custom_nodes/ComfyUI-Impact-Pack/install.py
pip install -r custom_nodes/ComfyUI-Impact-Pack/requirements.txt

# rgthree-comfy
git clone https://github.com/rgthree/rgthree-comfy custom_nodes/rgthree-comfy


mkdir -p ./models/clip/
mkdir -p ./models/clip_vision/
mkdir -p ./models/ipadapter/
mkdir -p ./models/upscale_models/

# InstantID
wget https://huggingface.co/InstantX/InstantID/resolve/main/ip-adapter.bin?download=true -P ./models/instantid
wget https://huggingface.co/InstantX/InstantID/resolve/main/ControlNetModel/diffusion_pytorch_model.safetensors?download=true -P ./models/controlnet
# antelopev2 

# Checkpoints
# ponyRealism_V22MainVAE.safetensors
wget "https://civitai.com/api/download/models/914390?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/

wget "https://huggingface.co/latent-consistency/lcm-lora-sdxl/resolve/main/pytorch_lora_weights.safetensors" -P ./models/loras/lcm-lora-sdxl.safetensors
wget "https://civitai.com/api/download/models/351306?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/
wget "https://civitai.com/api/download/models/798204?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/
wget "https://civitai.com/api/download/models/501240?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/
wget "https://civitai.com/api/download/models/501286?type=Model&format=SafeTensor&size=full&fp=fp16&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/checkpoints/

# Flux.1-dev
wget --header="Authorization: Bearer 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" "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors" -P ./models/unet/
wget --header="Authorization: Bearer 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" "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors" -P ./models/vae/
wget --header="Authorization: Bearer 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" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" -P ./models/clip/
wget --header="Authorization: Bearer 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" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" -P ./models/clip/

# Flux.1-dev fp8 (comfyui)
wget https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors -P ./models/checkpoints/

# Flux LoRAs
wget "https://civitai.com/api/download/models/736227?type=Model&format=SafeTensor&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/loras
wget "https://civitai.com/api/download/models/780667?type=Model&format=SafeTensor&token=f5814fe67dc1e23398de1194252f1e0c" --content-disposition -P ./models/loras


#sd_xl and refiner
# wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors -P ./models/checkpoints/
# wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors -P ./models/checkpoints/
