#!/bin/bash
cd /workspace


# Clone ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI || exit

# ลง PyTorch สำหรับ CUDA 12.6
# pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0
  
# pip install torchsde==0.2.6 --no-build-isolation

# update 1/10/2025
# pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130

# ติดตั้ง requirements ของ ComfyUI
pip install -r requirements.txt

# เข้าไปใน custom_nodes
cd custom_nodes || exit

# Clone ComfyUI Manager
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git

# ออกมานอก custom_nodes
cd ..

echo "cd /workspace/ComfyUI"
echo "export PYTORCH_ALLOC_CONF=max_split_size_mb:128"
echo "python main.py --listen 0.0.0.0 --port 8188"

