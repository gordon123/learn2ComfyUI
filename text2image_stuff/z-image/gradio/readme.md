# Z-Image Turbo + Nunchaku (INT4) Installation Guide on RunPod

WARNING: EXPERIMENTAL / UNSTABLE  
This setup is intended for R&D and internal testing only.  
Upstream APIs, behaviors, and internal structures may change at any time.

=====================================================================

REQUIREMENTS

GPU: RunPod RTX 4090 (24GB recommended)  
Pod Type: MUST have Network Volume enabled  
Python: 3.12  
CUDA Runtime: 12.8  
Target Precision: INT4 (auto-selected by GPU)  
Nunchaku Rank: 128  
UI: Gradio (port 7860)

=====================================================================

STEP 1: CREATE PYTHON VIRTUAL ENVIRONMENT

```bash
cd /workspace
python3 -m venv venv_zimage
source /workspace/venv_zimage/bin/activate
pip install -U pip setuptools wheel
```

=====================================================================

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

EXPECTED OUTPUT (example):

```
torch: 2.9.1+cu128
cuda: True
gpu: NVIDIA GeForce RTX 4090
```

=====================================================================

STEP 3: INSTALL DIFFUSERS (GITHUB MAIN REQUIRED)

IMPORTANT:
Nunchaku Z-Image requires a newer Diffusers structure that is NOT available
in current PyPI releases.

```bash
pip uninstall -y diffusers
pip install git+https://github.com/huggingface/diffusers.git
```

VERIFY REQUIRED MODULE EXISTS:

```bash
python - <<'EOF'
import diffusers
print("diffusers:", diffusers.__version__)
from diffusers.models.transformers.transformer_z_image import FeedForward
print("OK: transformer_z_image exists")
EOF
```

=====================================================================

STEP 4: INSTALL RUNTIME DEPENDENCIES

```bash
pip install \
  transformers \
  accelerate \
  safetensors \
  huggingface_hub \
  hf_transfer \
  gradio \
  pillow
```

=====================================================================

STEP 5: INSTALL NUNCHAKU (GITHUB MAIN ONLY)

IMPORTANT:
Nunchaku does NOT provide CUDA wheels.
It is pure Python with PyTorch backend.
Z-Image support exists ONLY in the GitHub main branch.

```bash
pip install git+https://github.com/nunchaku-tech/nunchaku.git
```

VERIFY NUNCHAKU:

```bash
python - <<'EOF'
from nunchaku import NunchakuZImageTransformer2DModel
from nunchaku.utils import get_precision
print("precision:", get_precision())
EOF
```

EXPECTED:
```
precision: int4
```

=====================================================================

STEP 6: CONFIGURE HUGGINGFACE CACHE (CRITICAL ON RUNPOD)

Without Network Volume + cache redirect, models will be re-downloaded
and may cause memory spikes.

```bash
mkdir -p /workspace/.cache/huggingface

echo 'export HF_HOME=/workspace/.cache/huggingface' >> ~/.bashrc
echo 'export HF_HUB_CACHE=/workspace/.cache/huggingface/hub' >> ~/.bashrc
echo 'export HF_DATASETS_CACHE=/workspace/.cache/huggingface/datasets' >> ~/.bashrc
echo 'export HF_HUB_ENABLE_HF_TRANSFER=1' >> ~/.bashrc
echo 'export PYTORCH_ALLOC_CONF=expandable_segments:True' >> ~/.bashrc

source ~/.bashrc
```

=====================================================================

STEP 7: PREPARE PROJECT STRUCTURE

```bash
mkdir -p /workspace/zimage_nunchaku/output
cd /workspace/zimage_nunchaku
```

COPY REQUIRED FILES INTO THIS DIRECTORY:

- gradio_zimage.py
- run_zimage.py

FINAL STRUCTURE:

```
/workspace/zimage_nunchaku
├── gradio_zimage.py
├── run_zimage.py
└── output/
```

=====================================================================

STEP 8: RUN GRADIO UI

```bash
source /workspace/venv_zimage/bin/activate
python gradio_zimage.py
```

IF YOU SEE:

```
Running on local URL: http://0.0.0.0:7860
```

THEN:

- Open RunPod HTTP Services
- Expose port 7860
- Click the generated link to access the UI

=====================================================================

NOTES

- INT4 precision is selected automatically based on GPU
- guidance_scale MUST be 0.0 for Z-Image Turbo
- Recommended inference steps: 6–10
- Recommended rank: 128
- First run will download models and weights (disk cache)

=====================================================================

NOT REQUIRED / DO NOT INSTALL

- triton
- xformers
- flash-attn
- bitsandbytes
- custom CUDA toolkit

=====================================================================

DISCLAIMER

This setup is experimental.
Upstream repositories may change internal APIs at any time.
Use only for research, testing, or controlled internal environments.
