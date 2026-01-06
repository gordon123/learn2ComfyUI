#!/bin/bash

# Clone ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI || exit

# ลง PyTorch nightly version (CUDA 12.8)
#pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130

# ติดตั้ง requirements ของ ComfyUI
pip install -r requirements.txt

# เข้าไปใน custom_nodes
cd custom_nodes || exit

# Clone ComfyUI Manager
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git

# ออกมานอก custom_nodes
cd ..

echo "run comfyui > python main.py --listen"
