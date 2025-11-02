#!/bin/bash
set -euo pipefail

echo "🌟 [1/7] พื้นฐานระบบ + ffmpeg"
apt update && apt install -y git python3-venv python3-pip ffmpeg libgl1

echo "🌟 [2/7] สร้าง/เปิดใช้งาน venv"
cd /workspace
python3 -m venv vnev || true
source /workspace/vnev/bin/activate
pip install -U pip setuptools wheel packaging

echo "🌟 [3/7] ติดตั้ง PyTorch (CUDA 12.6 build for 4090)"
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0

echo "🌟 [4/7] ติดตั้งโมดูลพื้นฐาน (มี torchsde ชัดเจน)"
# pin dependency ที่ torchsde ใช้ เพื่อกัน build ล้ม
pip install scipy==1.16.3 trampoline==0.1.2
pip install torchsde==0.2.6 triton==3.3.0

echo "🌟 [5/7] ติดตั้ง SageAttention (ไม่ต้อง build แยก)"
pip install sageattention==2.2.0 --no-build-isolation

echo "🧪 เทสโมดูลสำคัญ"
python - <<'PY'
ok = True
try:
    import torch, torchsde
    from sageattention import sageattn
    print("✅ torch:", torch.__version__)
    print("✅ torchsde:", torchsde.__version__)
    print("✅ SageAttention callable:", callable(sageattn))
except Exception as e:
    ok = False
    print("❌ Import test failed:", e)
import sys; sys.exit(0 if ok else 1)
PY

echo "🌟 [6/7] Clone ComfyUI (ถ้ามีอยู่แล้วจะข้าม)"
cd /workspace
if [ ! -d "ComfyUI/.git" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git
fi

echo "🌟 [7/7] ติดตั้ง ComfyUI-Manager (ถ้ายังไม่มี)"
mkdir -p /workspace/ComfyUI/custom_nodes
if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Manager/.git" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
fi

echo
echo "🚀 เสร็จแล้ว! เริ่มรัน ComfyUI ด้วย:"
echo "source /workspace/vnev/bin/activate && export PYTORCH_ALLOC_CONF=max_split_size_mb:128 && cd /workspace/ComfyUI && python main.py --listen 0.0.0.0 --port 8188"
