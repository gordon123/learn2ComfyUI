# Flash-Attention Installation Guide (RunPod + ComfyUI) สำหรับค่อย ๆ install ทีละขั้น เพื่อเช็ค เวอชั่น แล้ว ค่อย ๆinstall

> Tested & confirmed working  
> ✅ **RTX 3090**  
> ✅ **RunPod (Docker / VM)**  
> ✅ **ComfyUI 0.10.0**  
> ✅ **Python 3.12.3**  
> ✅ **PyTorch 2.7.0 + CUDA 12.6 (cu126)**  
> ✅ **CUDA Toolkit / nvcc 12.8**

---

## 📌 Required Versions (IMPORTANT)

This guide is **ONLY guaranteed** for the following versions:

- **GPU**: NVIDIA RTX 3090 (Ampere, SM80)
- **Python**: `3.12.x`
- **PyTorch**: `2.7.0+cu126`
- **CUDA Toolkit (nvcc)**: `12.8`
- **flash-attn**: `2.8.3`
- **OS**: Linux (RunPod Ubuntu-based image)
- **ComfyUI**: `0.10.0`

⚠️ If **any version differs**, wheel availability may change and build may fail.

---

### 1️⃣ Activate ComfyUI Virtual Environment

```bash
source /workspace/venv/bin/activate
```

Verify:
```
which python
python -V
```

ควรมีแบบนี้
```
/workspace/venv/bin/python
Python 3.12.x
```

### 2️⃣ Verify PyTorch & GPU
```
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.get_device_name(0))"
```
ควรมีแบบนี้ ```2.7.0+cu126 12.6 NVIDIA GeForce RTX 3090```

### 3️⃣ Verify CUDA Toolkit (nvcc)
```
nvcc --version
```
ควรมีแบบนี้ ```Cuda compilation tools, release 12.8```


### 4️⃣ Set CUDA Environment Variables (REQUIRED)
```
export CUDA_HOME=/usr/local/cuda-12.8
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH}
```

### 5️⃣ Install Build Dependencies
```
python -m pip install -U pip setuptools wheel packaging ninja
sudo apt-get update
sudo apt-get install -y build-essential python3-dev git
```

### 6️⃣ Install Flash-Attention (Recommended: Prebuilt Wheel)
```
python -m pip install -U \
https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl \
--no-cache-dir
```
✔ This wheel matches: <br>
Python 3.12<br>
Torch 2.7<br>
CUDA 12.x<br>
CXX11 ABI enabled<br>


### 7️⃣ Verify Installation
```
python -c "import flash_attn; print('flash-attn OK:', flash_attn.__version__)"
```

ควรมีแบบนี้ ```flash-attn OK: 2.8.3```

### 🧠 Notes & Pitfalls

flash-attn will NOT work without nvcc<br>
torch cu126 works fine with CUDA toolkit 12.8<br>
If import flash_attn fails later → ComfyUI is likely using wrong Python binary<br>
Always launch ComfyUI from the same venv<br>

## อีกวิธี สำหรับ save whl จาก repo เราต้องรู้ว่า Runpod เรา pytorch อะไร เวอชั่นอะไร etc. เสี่ยงพัง ถ้าดาวโหลดมาผิด
```
mkdir -p /workspace/wheels
cd /workspace/wheels
wget https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
```

```
python -m pip install ./flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
```


