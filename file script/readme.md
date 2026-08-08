In this folder is my script for Jupyter to setup on [Runpod.io](https://runpod.io?ref=c0v5p0ys)  for comfyUI and here are FLUX collection download link


บางครั้ง Runpod เซิพเวอร์ ไม่มี CUDA driver ทดลอง เชคด้วยคำสั่งต่อไปนี้ ก่อนจะ สร้าง VENV
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
