#!/bin/bash

# Clone ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI || exit

# ลง PyTorch สำหรับ CUDA 12.6
# pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126

# update 1/10/2025
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130

# ติดตั้ง requirements ของ ComfyUI
pip install -r requirements.txt

# เข้าไปใน custom_nodes
cd custom_nodes || exit

# Clone ComfyUI Manager
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git

# ออกมานอก custom_nodes
cd ..

echo "run comfyui with python main.py --listen"
