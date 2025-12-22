==== test z-image Nunchaku EXPERIMENTAL!!! a lot of bug!! warning😈

https://huggingface.co/mit-han-lab/nunchaku

https://huggingface.co/Tongyi-MAI/Z-Image-Turbo

https://huggingface.co/nunchaku-tech/nunchaku-z-image-turbo

อันนี้ทดสอบ nunchaku บน gradio ตั้ง port 7860 สำหรับไว้ run gradio webui บน runpod

🔥 RunPod + RTX 4090 + Nunchaku Z-Image Turbo + Gradio (nunchaku-only)

🧱 ภาพรวมก่อนเริ่ม (สำคัญ)

ใช้ RunPod GPU Pod (RTX 4090 / 24GB)

ต้องเป็น Pod ที่มี Network Volume (ไม่งั้น restart แล้วหาย)

ใช้ Python 3.12

ใช้ Nunchaku INT4 (rank 128) เท่านั้น

### STEP 1️⃣ สร้าง virtualenv ใหม่ 
```
cd /workspace
python3 -m venv venv_zimage
source /workspace/venv_zimage/bin/activate
```
### 2
```
pip install -U pip setuptools wheel
```

### STEP 2️⃣ ลง PyTorch (CUDA 12.8)
```
pip uninstall -y torch torchvision torchaudio
pip install torch torchvision torchaudio \
  --index-url https://download.pytorch.org/whl/cu128
```

### check GPU
```
python - <<'EOF'
import torch
print(torch.__version__)
print(torch.cuda.is_available(), torch.cuda.get_device_name(0))
EOF
```

### install library
```
pip install \
  diffusers \
  transformers \
  accelerate \
  safetensors \
  huggingface_hub \
  hf_transfer \
  gradio \
  pillow
```

### install nunchaku
```
cd /workspace/zimage_nunchaku
source /workspace/venv_zimage/bin/activate

# 1) ลบ nunchaku ตัวที่ลงผิด/ไม่ตรง build ออกก่อน
pip uninstall -y nunchaku

# 2) (แนะนำ) downgrade torch ให้ตรงกับ wheel torch2.7 (เลือก cu128 ไม่จำเป็นสำหรับ 4090; เอา cu126 ก็ได้)
pip uninstall -y torch torchvision torchaudio

# ตัวเลือก A: ใช้ cu126 (เข้ากับของเดิมใน log ComfyUI บ่อยสุด)
pip install torch==2.7.* torchvision==0.22.* torchaudio==2.7.* --index-url https://download.pytorch.org/whl/cu126

# 3) ติดตั้ง nunchaku "จากไฟล์ wheel ของ nunchaku-tech" ให้ตรง torch2.7 + cp312 + linux
pip install "https://huggingface.co/nunchaku-tech/nunchaku/resolve/main/nunchaku-0.2.0%2Btorch2.7-cp312-cp312-linux_x86_64.whl"

# 4) เช็กว่า import ได้จริง
python -c "from nunchaku import NunchakuZImageTransformer2DModel; print('✅ nunchaku class OK')"

```

### STEP 5️⃣ ตั้ง HuggingFace cache ให้อยู่ใน workspace (สำคัญมาก)
```
mkdir -p /workspace/.cache/huggingface
```

### ป้องกัน cache หาย ถ้า researt Runpod
```
echo 'export HF_HOME=/workspace/.cache/huggingface' >> ~/.bashrc
echo 'export HF_HUB_CACHE=/workspace/.cache/huggingface/hub' >> ~/.bashrc
echo 'export TRANSFORMERS_CACHE=/workspace/.cache/huggingface/hub' >> ~/.bashrc
echo 'export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True' >> ~/.bashrc
source ~/.bashrc
```

### STEP 6️⃣ เตรียมโฟลเดอร์โปรเจกต์
```
mkdir -p /workspace/zimage_nunchaku/output
cd /workspace/zimage_nunchaku
```

### copy file นี้
```gradio_zimage.py``` และ ```run_zimage.py```
ไว้ใน ```/workspace/zimage_nunchaku```

### STEP 7️⃣ รัน Gradio
```
source /workspace/venv_zimage/bin/activate
python gradio_zimage.py
```
เห็น ip address Running on local URL:  http://0.0.0.0:7860 ถือว่า ผ่าน ไป จิ้มที่ลิ้ง บน runpod ที่เซ็ตไว้
