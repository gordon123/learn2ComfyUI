#!/bin/bash
set -euo pipefail

# Simple ComfyUI + ComfyUI-Manager installer for RunPod RTX 50xx / CUDA 13
# Recommended image: runpod/pytorch:1.0.3-cu1300-torch291-ubuntu2404
# Strategy: use a normal venv and install torch stack inside the venv.

WORKSPACE="/workspace"
VENV_DIR="$WORKSPACE/venv"
COMFY_DIR="$WORKSPACE/ComfyUI"
PYTORCH_INDEX="https://download.pytorch.org/whl/cu130"

TORCH_VERSION="2.9.1"
TORCHVISION_VERSION="0.24.1"
TORCHAUDIO_VERSION="2.9.1"

log() { echo -e "\n$1"; }

log "🧪 Checking GPU with nvidia-smi..."
nvidia-smi

log "📦 Creating clean venv..."
cd "$WORKSPACE"
python -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip setuptools wheel

log "🔥 Installing PyTorch CUDA 13 stack inside venv..."
pip install \
  "torch==${TORCH_VERSION}" \
  "torchvision==${TORCHVISION_VERSION}" \
  "torchaudio==${TORCHAUDIO_VERSION}" \
  --index-url "$PYTORCH_INDEX" \
  --no-cache-dir

log "📦 Installing base Python packages..."
pip install numpy pillow packaging --no-cache-dir

log "🧪 Testing torch / torchvision / torchaudio / CUDA..."
python - <<'PY'
import torch, torchvision, torchaudio
from torchvision.ops import nms

print("torch:", torch.__version__, torch.__file__)
print("torchvision:", torchvision.__version__, torchvision.__file__)
print("torchaudio:", torchaudio.__version__, torchaudio.__file__)
print("cuda build:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())

x = torch.zeros(1, device="cuda")
print("CUDA tensor OK:", x)
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
print("torchvision nms OK")
PY

log "🚀 Cloning / updating ComfyUI..."
if [ -d "$COMFY_DIR/.git" ]; then
  cd "$COMFY_DIR"
  git pull || true
else
  rm -rf "$COMFY_DIR"
  git clone https://github.com/Comfy-Org/ComfyUI.git "$COMFY_DIR"
  cd "$COMFY_DIR"
fi

log "🔒 Creating torch constraints..."
cat > /tmp/comfy-torch-constraints.txt <<EOF2
torch==${TORCH_VERSION}+cu130
torchvision==${TORCHVISION_VERSION}+cu130
torchaudio==${TORCHAUDIO_VERSION}+cu130
EOF2
cat /tmp/comfy-torch-constraints.txt

log "📦 Installing ComfyUI requirements..."
pip install -r requirements.txt \
  --constraint /tmp/comfy-torch-constraints.txt \
  --no-cache-dir

log "📦 Installing ComfyUI manager requirements if present..."
if [ -f manager_requirements.txt ]; then
  pip install -r manager_requirements.txt \
    --constraint /tmp/comfy-torch-constraints.txt \
    --no-cache-dir
fi

log "✨ Installing ComfyUI-Manager custom node..."
mkdir -p custom_nodes
cd custom_nodes
if [ -d comfyui-manager/.git ]; then
  cd comfyui-manager
  git pull || true
  cd ..
else
  rm -rf comfyui-manager
  git clone https://github.com/Comfy-Org/ComfyUI-Manager.git comfyui-manager
fi

if [ -f comfyui-manager/requirements.txt ]; then
  pip install -r comfyui-manager/requirements.txt \
    --constraint /tmp/comfy-torch-constraints.txt \
    --no-cache-dir
fi

cd "$COMFY_DIR"

log "🧪 Final sanity check..."
python - <<'PY'
import torch, torchvision, torchaudio
from torchvision.ops import nms

print("torch:", torch.__version__, torch.__file__)
print("torchvision:", torchvision.__version__, torchvision.__file__)
print("torchaudio:", torchaudio.__version__, torchaudio.__file__)
assert torch.__version__ == "2.9.1+cu130", torch.__version__
assert torchvision.__version__ == "0.24.1+cu130", torchvision.__version__
assert torchaudio.__version__ == "2.9.1+cu130", torchaudio.__version__
assert "/workspace/venv/" in torch.__file__, torch.__file__
assert torch.cuda.is_available(), "CUDA is not available"
x = torch.zeros(1, device="cuda")
print("CUDA OK:", x)
print("device:", torch.cuda.get_device_name(0))
print("torchvision nms OK")
PY

log "✅ Done! Launch ComfyUI with:"
echo "cd /workspace/ComfyUI"
echo "source /workspace/venv/bin/activate"
echo "python main.py --listen 0.0.0.0 --port 8188 --enable-manager"
