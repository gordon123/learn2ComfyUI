# Flash-Attention Installation Guide (RunPod + ComfyUI)
สำหรับค่อย ๆ install ทีละขั้น → เช็คเวอร์ชัน → แล้วค่อย install อย่างปลอดภัย

Tested & confirmed working
RTX 3090
RunPod (Docker / VM)
ComfyUI 0.10.0
Python 3.12.3
PyTorch 2.7.0 + CUDA 12.6 (cu126)
CUDA Toolkit / nvcc 12.8

Prebuilt wheels (Linux):
https://github.com/Dao-AILab/flash-attention/releases

---

## Required Versions (IMPORTANT)

GPU: NVIDIA RTX 3090 (Ampere, SM80)
Python: 3.12.x
PyTorch: 2.7.0+cu126
CUDA Runtime (torch): 12.6
CUDA Toolkit (nvcc): 12.8
flash-attn: 2.8.3
OS: Linux (RunPod Ubuntu-based)
ComfyUI: 0.10.0

---

## 1 Activate ComfyUI Virtual Environment

```
source /workspace/venv/bin/activate
```

ตรวจสอบ

```
which python
python -V
```

ควรได้

```
/workspace/venv/bin/python
Python 3.12.x
```

---

## 2 Verify PyTorch & GPU

```
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.get_device_name(0))"
```

ควรได้

```
2.7.0+cu126
12.6
NVIDIA GeForce RTX 3090
```

---

## 3 Verify CUDA Toolkit (nvcc)

```
nvcc --version
```

ควรได้

```
Cuda compilation tools, release 12.8
```

---

## 4 Set CUDA Environment Variables (REQUIRED)

```
export CUDA_HOME=/usr/local/cuda-12.8
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH}
```

---

## 5 Install Build Dependencies

```
python -m pip install -U pip setuptools wheel packaging ninja
sudo apt-get update
sudo apt-get install -y build-essential python3-dev git
```

---

## 6 Install Flash-Attention (Prebuilt Wheel)

```
python -m pip install -U \
https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl \
--no-cache-dir
```

---

## 7 Verify Installation

```
python -c "import flash_attn; print('flash-attn OK:', flash_attn.__version__)"
```

ควรได้

```
flash-attn OK: 2.8.3
```


# อีกวิธีใช้ script

ดาวโหลด install_flash_attn_comfyui_runpod.sh

วิธีใช้ (สั้น ๆ): <br>
1) เข้า venv ของ ComfyUI ก่อน<br>
   source /workspace/venv/bin/activate<br>

2) download install_flash_attn_comfyui_runpod.sh แล้วให้สิทธิ์รัน<br>
```
   chmod +x install_flash_attn_comfyui_runpod.sh
```

3) รัน
```
   ./install_flash_attn_comfyui_runpod.sh
```
