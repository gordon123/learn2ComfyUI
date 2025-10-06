วิธีการ install WAN2.2 ANIMATE บน Comfyui [RunPod](https://runpod.io?ref=c0v5p0ys)

=== Model list == <br>

activate virtual venv ก่อนเสมอ เวลาจะ install อะไร
```
cd /workspace/
source venv/bin/activate
```

เริ่ม run comfyui server
```
cd ComfyUI/
python main.py --listen
```

== Download Model <br>

### Wan animate model
```
cd /workspace/ComfyUI/models/diffusion_models/
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors
```
==Download Lora <br>

```
cd /workspace/ComfyUI/models/loras
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22_relight/WanAnimate_relight_lora_fp16.safetensors

wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors

wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Pusa/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors

wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/ffc8175b07b79f430a1495d086e39e83d59729e0/Wan22_FunReward/Wan2.2-Fun-A14B-InP-LOW-MPS_resized_dynamic_avg_rank_22_bf16.safetensors
```
== Text encoder <br>
```
cd /workspace/ComfyUI/models/text_encoders
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors
```
=== Install Sageattention <br>

ACTIVATE VENV ก่อน เสมอ

# 0) อัปเดตพื้นฐาน <br>
```
pip install --upgrade pip setuptools wheel ninja
```
# 1) ติดตั้ง ONNX ชุดที่รองรับ CUDA 12.x และ Python 3.12 <br>
```
pip install "onnx>=1.16" "onnxruntime-gpu==1.22.0" opencv-python-headless
```

# 3) คอมไพล์และติดตั้ง SageAttention 2.x/2++ จากซอร์ส <br>
```
cd /workspace
git clone https://github.com/thu-ml/SageAttention.git
cd SageAttention
```

# เพิ่มตัวเลือกเร่งคอมไพล์ (ปลอดภัยจะเว้นก็ได้) <br>
```
export EXT_PARALLEL=4
export NVCC_APPEND_FLAGS="--threads 8"
export MAX_JOBS=32
```

# ติดตั้ง (เลือกวิธีใดวิธีหนึ่ง) <br>
```
python setup.py install
```

### install ffmpeg driver
```
apt-get update
apt-get install -y libsndfile1 ffmpeg
```

### check installed sageattention correct <br>
```
/workspace/venv/bin/python -c "import platform, torch, sys; print('🐍 Python:', platform.python_version()); print('🔥 Torch:', torch.__version__); print('🎯 CUDA (Torch reports):', torch.version.cuda); print('✅ CUDA available:', torch.cuda.is_available()); print('🧠 GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU'); \
import importlib, pkgutil; m=importlib.util.find_spec('sageattention'); print('🌿 SageAttention:', 'installed' if m else 'NOT installed')"
```

Force restart kill process
```
pkill -f "python main.py" || true
/workspace/venv/bin/python /workspace/ComfyUI/main.py --listen
```
