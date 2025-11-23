https://github.com/smthemex/ComfyUI_DiffuEraser

mkdir -p /workspace/ComfyUI/models/DiffuEraser/brushnet

mkdir -p /workspace/ComfyUI/models/DiffuEraser/unet_main

mkdir -p /workspace/ComfyUI/models/DiffuEraser/propainter

wget -O /workspace/ComfyUI/models/DiffuEraser/brushnet/config.json \
https://huggingface.co/lixiaowen/diffuEraser/resolve/main/brushnet/config.json

wget -O /workspace/ComfyUI/models/DiffuEraser/brushnet/diffusion_pytorch_model.safetensors \
https://huggingface.co/lixiaowen/diffuEraser/resolve/main/brushnet/diffusion_pytorch_model.safetensors

wget -O /workspace/ComfyUI/models/DiffuEraser/unet_main/config.json \
https://huggingface.co/lixiaowen/diffuEraser/resolve/main/unet_main/config.json

wget -O /workspace/ComfyUI/models/DiffuEraser/unet_main/diffusion_pytorch_model.safetensors \
https://huggingface.co/lixiaowen/diffuEraser/resolve/main/unet_main/diffusion_pytorch_model.safetensors

wget -O /workspace/ComfyUI/models/DiffuEraser/propainter/ProPainter.pth \
https://github.com/sczhou/ProPainter/releases/download/v0.1.0/ProPainter.pth

wget -O /workspace/ComfyUI/models/DiffuEraser/propainter/raft-things.pth \
https://github.com/sczhou/ProPainter/releases/download/v0.1.0/raft-things.pth

wget -O /workspace/ComfyUI/models/DiffuEraser/propainter/recurrent_flow_completion.pth \
https://github.com/sczhou/ProPainter/releases/download/v0.1.0/recurrent_flow_completion.pth
