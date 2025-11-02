#  สร้าง workspace ก่อน
mkdir -p /workspace
cd /workspace

# สร้าง virtual environment ก่อน clone
python3 -m venv vnev
source vnev/bin/activate

# === 1️⃣ ติดตั้งระบบพื้นฐานและ ffmpeg ===
apt update && apt install -y git python3-venv python3-pip ffmpeg libgl1

# === 2️⃣ สร้าง workspace และ clone ComfyUI ===
git clone https://github.com/comfyanonymous/ComfyUI.git .

# === 4️⃣ ติดตั้ง PyTorch cu126 และ dependency หลัก ===
pip install --upgrade pip
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0
pip install torchsde==0.2.6

# === 5️⃣ ติดตั้ง Triton และ SageAttention ===
pip install "triton==3.3.0"
pip install "sageattention==2.2.0" --no-build-isolation

# === 6️⃣ ทดสอบ SageAttention ===
python - <<'PY'
from sageattention import sageattn
print("✅ SageAttention ready:", callable(sageattn))
PY

# === 7️⃣ เพิ่ม ComfyUI Manager (ทางเลือกแต่แนะนำ) ===

cd /workspace/ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git

cd /workspace/ComfyUI

# === 8️⃣ ตั้งค่า memory allocator ป้องกัน VRAM error ===
export PYTORCH_ALLOC_CONF=max_split_size_mb:128

# === 9️⃣ รัน ComfyUI (เปิดพอร์ต 8188 ให้ RunPod เห็นได้) ===
python main.py --listen 0.0.0.0 --port 8188
