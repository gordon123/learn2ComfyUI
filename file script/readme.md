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

```
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda build:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())

x = torch.zeros(1, device="cuda")
print("cuda tensor:", x)
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
PY
```

หลังสร้าง VENV เช็ดอีกรอบ แบบ เพิ่ม site packages

```
cd /workspace
python -m venv --system-site-packages /workspace/venv
source /workspace/venv/bin/activate
```


```
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.version.cuda)
print("available:", torch.cuda.is_available())
x = torch.zeros(1, device="cuda")
print(x)
print(torch.cuda.get_device_name(0))
PY
```
