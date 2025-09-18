#!/usr/bin/env bash
set -euo pipefail

echo "=== ComfyUI + VibeVoice setup for Torch 2.4.1 + CUDA 12.4 (Python 3.11) ==="

# -------------------------------------------
# 0) (แนะนำ) ใช้ venv ภายนอกสคริปต์ก่อนรันไฟล์นี้
#    python -m venv venv && source venv/bin/activate
# -------------------------------------------

# 1) เตรียมระบบและเครื่องมือ build ที่จำเป็น
apt-get update -y
apt-get install -y git build-essential ninja-build cmake python3-dev ffmpeg

# 2) Clone ComfyUI (ถ้ายังไม่มี)
cd /workspace
if [ ! -d "ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git
fi
cd ComfyUI

# 3) ติดตั้ง PyTorch ให้ตรงชุดกับ CUDA 12.4
pip install --upgrade pip
pip install \
  torch==2.4.1+cu124 \
  torchvision==0.19.1+cu124 \
  torchaudio==2.4.1+cu124 \
  --index-url https://download.pytorch.org/whl/cu124

# 4) ติดตั้ง requirements ของ ComfyUI core
pip install -r requirements.txt

# 5) ติดตั้ง ComfyUI Manager
mkdir -p custom_nodes
cd custom_nodes
if [ ! -d "ComfyUI-Manager" ]; then
  git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
fi

# 6) ติดตั้ง ComfyUI‑VibeVoice
if [ ! -d "ComfyUI-VibeVoice" ]; then
  git clone https://github.com/wildminder/ComfyUI-VibeVoice.git
fi
cd ComfyUI-VibeVoice
pip install -r requirements.txt
cd ..

# 7) ตัวเลือกเร่งความเร็ว + ประหยัด VRAM
pip install --no-deps bitsandbytes
pip install sageattention

# FlashAttention 2
export CUDA_HOME=/usr/local/cuda
export MAX_JOBS="$(nproc)"
pip install -U wheel setuptools packaging
pip install --no-build-isolation "flash-attn==2.*" || echo "!! flash-attn build failed -> use sdpa/sage instead"

# 8) ตรวจสอบเวอร์ชันสุดท้าย
python - <<'PY'
import sys, importlib, torch
def has(m): import importlib; return importlib.util.find_spec(m) is not None
print("---- FINAL ENV ----")
print("Python:", sys.version.split()[0])
print("Torch:", torch.__version__, "| Torch CUDA:", torch.version.cuda)
print("CUDA Avail:", torch.cuda.is_available(), "| GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "N/A")
print("torchvision:", importlib.import_module('torchvision').__version__)
print("bitsandbytes:", has("bitsandbytes"))
print("sageattention:", has("sageattention"))
print("flash-attn:", has("flash_attn"))
print("--------------------")
PY

# 9) แสดงวิธีรัน ComfyUI
cd ..
echo
echo "=== READY ==="
echo "Run ComfyUI with:"
echo "  cd /workspace/ComfyUI"
echo "  python main.py --listen"
echo
echo "VibeVoice tips:"
echo "- เริ่มจาก attention_mode='sdpa'"
echo "- ถ้าติดตั้งสำเร็จ ลอง flash_attention_2 หรือ sage"
echo "- เปิด Quantize LLM (4-bit) ในโหนด หากต้องการประหยัด VRAM"
