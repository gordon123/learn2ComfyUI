In this folder is my script for Jupyter to setup on [Runpod.io](https://runpod.io?ref=c0v5p0ys)  for comfyUI and here are FLUX collection download link

### Install Sol Attention

เริ่มจาก Activate version environment ก่อนเสมอ Official Runpod Comfyui เก็บไว้ใน
```
# 1. ต้อง activate venv ที่ ComfyUI ใช้ก่อน (เหมือนเดิม)
source /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/activate
```

```
# 2. cd เข้า custom_nodes
cd /workspace/runpod-slim/ComfyUI/custom_nodes

# 3. clone repo
git clone https://github.com/kijai/ComfyUI-SolAttn_triton.git

# 4. restart ComfyUI

บางครั้ง Runpod เซิพเวอร์ ไม่มี CUDA driver ทดลอง เชคด้วยคำสั่งต่อไปนี้ ก่อนจะ สร้าง VENV
```

```
nvidia-smi
```

```
python --version
which python
pip --version

python - <<'PY'
import sys
print("python:", sys.version)
print("executable:", sys.executable)
PY
```

หลังสร้าง VENV เช็ดอีกรอบ แบบ เพิ่ม site packages

```
cd /workspace
python -m venv --system-site-packages /workspace/venv
source /workspace/venv/bin/activate
```


```
# 1. เช็ค Python version
python3 --version
which python3

# 2. เช็ค CUDA (driver-level, จาก nvidia-smi)
nvidia-smi
# ดูมุมขวาบนของ output จะมีบรรทัด "CUDA Version: xx.x" 
# นี่คือ CUDA driver รองรับสูงสุด ไม่ใช่ CUDA toolkit ที่ลงจริง

# 3. เช็ค CUDA toolkit ที่ compile ไว้ (nvcc, ถ้ามี)
nvcc --version

# 4. เช็ค PyTorch + CUDA build ที่ python เห็น (สำคัญสุด)
python3 -c "import torch; print('torch:', torch.__version__); print('cuda available:', torch.cuda.is_available()); print('cuda build:', torch.version.cuda); print('gpu:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'none')"

# 5. เช็ค GPU compute capability (สำคัญสำหรับ sm_xx ของ SageAttention)
python3 -c "import torch; print(torch.cuda.get_device_capability(0))"

# 6. เช็ค pip / packaging tools
pip3 --version
python3 -c "import sys; print(sys.version_info)"

# 7. เช็ค Triton (ถ้าลงแล้ว)
python3 -c "import triton; print(triton.__version__)"
```

## Install sage attention

check version
```
# หา venv ที่ ComfyUI ใช้จริง
find /workspace -maxdepth 4 -iname "*.venv*" -type d

# activate แล้วเช็คใหม่
source /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/activate
python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.get_device_capability(0))"
python --version
which python
deactivate
```

ตัวอย่างนี้ install สำหรับ Comfyui runpod official cuda 13 และเลือก การ์ดจอ rtx5090
จะได้ เวอชั่น ประมาณนี้ ```Python 3.12.3 / Torch 2.10.0+cu130 / CUDA 13.0 / sm_120 (Blackwell)```

คำสั่ง Install Sage attention สำรับ เวอชั่น นี้เท่านั้น !! ```Python 3.12.3 / Torch 2.10.0+cu130 / CUDA 13.0 / sm_120 (Blackwell)```

```
# 1. activate venv ที่ ComfyUI ใช้จริง (สำคัญ ต้องทำก่อนทุกครั้ง)
source /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/activate

# 2. เช็คว่า torch เห็น GPU (ควรได้ผลเหมือนที่เช็คไปแล้ว)
python -c "import torch; print(torch.__version__, torch.cuda.get_device_capability(0))"

# 3. ติดตั้ง build dependencies
pip install ninja packaging wheel

# 4. clone official repo
cd /workspace
git clone https://github.com/thu-ml/SageAttention.git
cd SageAttention

# 5. pin ให้ compile เฉพาะ sm_120 (Blackwell) — ไม่งั้นมันอาจ build หลาย arch แล้วช้ามาก/พลาด kernel
export TORCH_CUDA_ARCH_LIST="12.0"
export EXT_PARALLEL=4
export NVCC_APPEND_FLAGS="--threads 8"
export MAX_JOBS=32

# 6. build + install เข้า venv (ใช้เวลานานหลายนาที)
python setup.py install
```

