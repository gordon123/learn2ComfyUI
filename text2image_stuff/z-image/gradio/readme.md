# Z-Image Turbo + Nunchaku (INT4) + Gradio on RunPod

WARNING: EXPERIMENTAL / UNSTABLE  
This project is for R&D and internal testing only.  
Upstream APIs and behaviors may change without notice.

---------------------------------------------------------------------

REFERENCES

Z-Image Turbo (Base Model)  
https://huggingface.co/Tongyi-MAI/Z-Image-Turbo

Nunchaku Z-Image INT4 Weights  
https://huggingface.co/nunchaku-tech/nunchaku-z-image-turbo

Nunchaku Runtime (GitHub main branch required)  
https://github.com/nunchaku-tech/nunchaku

---------------------------------------------------------------------

ENVIRONMENT REQUIREMENTS

GPU: RunPod RTX 4090 (24GB)  
Python: 3.12  
CUDA Runtime: 12.8  
PyTorch: 2.9.1+cu128  
Quantization: INT4 (auto-selected by GPU)  
Nunchaku Rank: 128  
UI: Gradio (port 7860)

IMPORTANT:
You must use a RunPod Pod with Network Volume enabled.
Otherwise, HuggingFace cache will be lost after restart.

---------------------------------------------------------------------

STEP 1: CREATE VIRTUAL ENVIRONMENT

```bash
cd /workspace
python3 -m venv venv_zimage
source /workspace/venv_zimage/bin/activate
pip install -U pip setuptools wheel
```

---------------------------------------------------------------------

STEP 2: INSTALL PYTORCH (CUDA 12.8)

```bash
pip install torch torchvision torchaudio \
  --index-url https://download.pytorch.org/whl/cu128
```

VERIFY GPU:

```bash
python - <<'EOF'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.cuda.is_available())
print("gpu:", torch.cuda.get_device_name(0))
EOF
```

EXPECTED OUTPUT:

```
torch: 2.9.1+cu128
cuda: True
gpu: NVIDIA GeForce RTX 4090
```

---------------------------------------------------------------------

STEP 3: INSTALL RUNTIME DEPENDENCIES

```bash
pip install \
  diffusers==0.35.1 \
  transformers \
  accelerate \
  safetensors \
  huggingface_hub \
  hf_transfer \
  gradio \
  pillow
```

NOTE:
diffusers must be version 0.35 or newer.
Older versions do NOT include the Z-Image pipeline.

---------------------------------------------------------------------

STEP 4: INSTALL NUNCHAKU (REQUIRED)

```bash
pip install git+https://github.com/nunchaku-tech/nunchaku.git
```

IMPORTANT NOTES ABOUT NUNCHAKU:

- Nunchaku does NOT provide a CUDA wheel
- It is pure Python with a PyTorch backend
- Z-Image support exists ONLY in the GitHub main branch
- Do NOT try to find or install a special .whl file (it does not exist)

---------------------------------------------------------------------

STEP 5: PERSIST HUGGINGFACE CACHE (CRITICAL ON RUNPOD)

```bash
mkdir -p /workspace/.cache/huggingface

echo 'export HF_HOME=/workspace/.cache/huggingface' >> ~/.bashrc
echo 'export HF_HUB_CACHE=/workspace/.cache/huggingface/hub' >> ~/.bashrc
echo 'export TRANSFORMERS_CACHE=/workspace/.cache/huggingface/hub' >> ~/.bashrc
echo 'export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True' >> ~/.bashrc

source ~/.bashrc
```

---------------------------------------------------------------------

STEP 6: PREPARE PROJECT STRUCTURE

```bash
mkdir -p /workspace/zimage_nunchaku/output
cd /workspace/zimage_nunchaku
```

COPY THE FOLLOWING FILES INTO THIS DIRECTORY:

- gradio_zimage.py
- run_zimage.py

FINAL STRUCTURE:

```
/workspace/zimage_nunchaku
├── gradio_zimage.py
├── run_zimage.py
└── output/
```

---------------------------------------------------------------------

STEP 7: RUN GRADIO UI

```bash
source /workspace/venv_zimage/bin/activate
python gradio_zimage.py
```

IF YOU SEE:

```
Running on local URL: http://0.0.0.0:7860
```

THEN:

- Open HTTP Service in RunPod
- Expose port 7860
- Click the generated link to access the UI

---------------------------------------------------------------------

NOTES

- INT4 precision is selected automatically via get_precision() based on GPU
- guidance_scale must be set to 0.0 for Z-Image Turbo
- Recommended inference steps: 6–10
- Most stable Nunchaku rank: 128

---------------------------------------------------------------------

NOT REQUIRED

DO NOT INSTALL THE FOLLOWING PACKAGES:

- triton
- xformers
- flash-attn
- bitsandbytes
- custom CUDA toolkit

---------------------------------------------------------------------

DISCLAIMER

This project is experimental.
Breaking changes may occur at any time due to upstream updates.
Use only for research, testing, or internal experimentation.
