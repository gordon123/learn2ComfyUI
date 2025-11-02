#!/bin/bash
set -euo pipefail

echo "🌟 [1/8] เตรียมระบบพื้นฐาน..."
apt update && apt install -y git python3-venv python3-pip ffmpeg libgl1

echo "🌟 [2/8] สร้างและเปิดใช้งาน venv..."
cd /workspace
python3 -m venv vnev || true
source /workspace/vnev/bin/activate
pip install -U pip setuptools wheel packaging

echo "🌟 [3/8] ติดตั้ง PyTorch (CUDA 12.6 build สำหรับ RTX 4090)..."
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0

echo "🌟 [4/8] ติดตั้งโมดูลพื้นฐาน..."
pip install scipy==1.16.3 trampoline==0.1.2
pip install torchsde==0.2.6 triton==3.3.0
pip install pyyaml

echo "🌟 [5/8] ติดตั้ง SageAttention..."
pip install sageattention==2.2.0 --no-build-isolation

echo "🧪 ตรวจสอบโมดูลสำคัญ..."
python - <<'PY'
import sys
try:
    import torch, torchsde, yaml
    from sageattention import sageattn
    print(f"✅ torch {torch.__version__} | ✅ torchsde {torchsde.__version__} | ✅ pyyaml ok | ✅ SageAttention callable:", callable(sageattn))
except Exception as e:
    print("❌ Module test failed:", e)
    sys.exit(1)
PY

echo "🌟 [6/8] Clone ComfyUI..."
cd /workspace
if [ ! -d "ComfyUI/.git" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git
fi

echo "🌟 [7/8] ติดตั้ง requirements.txt ของ ComfyUI..."
cd /workspace/ComfyUI
pip install -r requirements.txt || echo "⚠️ requirements.txt บางส่วนอาจติดตั้งไม่ครบ (จะยังรันได้)"

echo "🌟 [8/8] ติดตั้ง ComfyUI-Manager..."
mkdir -p custom_nodes
if [ ! -d "custom_nodes/ComfyUI-Manager/.git" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
fi

echo
echo "🚀 ติดตั้งเสร็จสิ้น!"
echo "รัน ComfyUI ได้ด้วยคำสั่งนี้:"
echo
echo "source /workspace/vnev/bin/activate"
echo "export PYTORCH_ALLOC_CONF=max_split_size_mb:128"
echo "cd /workspace/ComfyUI"
echo "python main.py --listen 0.0.0.0 --port 8188"
echo
echo "✨ เปิดเบราว์เซอร์ไปที่: http://<RunPod-IP>:8188/"
