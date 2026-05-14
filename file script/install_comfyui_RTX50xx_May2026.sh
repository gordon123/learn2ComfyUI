#!/bin/bash
set -euo pipefail

# ComfyUI installer for RunPod RTX 50xx / CUDA 13 / torch 2.9.1+cu130
# Assumes venv was created with:
#   python -m venv --system-site-packages /workspace/venv
#   source /workspace/venv/bin/activate

PYTORCH_CUDA_INDEX="https://download.pytorch.org/whl/cu130"
TORCHVISION_VERSION_PIN="0.24.1"
MANAGER_DIR_NAME="comfyui-manager"

log() { echo -e "$1"; }


cleanup_venv_torch_stack() {
    log "🧹 Removing torch/torchaudio/triton accidentally installed inside venv..."
    python - <<'PYCLEAN'
import glob, os, shutil, sysconfig
site = sysconfig.get_paths()["purelib"]
print("venv site-packages:", site)
# Keep torchvision in venv. Remove only packages that must come from RunPod system image.
patterns = [
    "torch", "torch-*",
    "torchaudio", "torchaudio-*",
    "triton", "triton-*",
    "pytorch_triton", "pytorch_triton-*",
]
for pat in patterns:
    for path in glob.glob(os.path.join(site, pat)):
        print("removing", path)
        if os.path.isdir(path):
            shutil.rmtree(path, ignore_errors=True)
        else:
            try:
                os.remove(path)
            except FileNotFoundError:
                pass
PYCLEAN
}

log "🧪 Checking virtual environment..."
python - <<'PY'
import sys
print("python:", sys.executable)
if sys.prefix == sys.base_prefix:
    raise SystemExit("❌ venv is not active. Run: source /workspace/venv/bin/activate")
print("✅ venv active")
PY

log "📦 Ensuring base Python packages are installed..."
# Pillow is required by torchvision import; install it before torchvision smoke tests.
pip install --no-cache-dir numpy pillow packaging

cd /workspace

if [ -d "ComfyUI" ]; then
    log "📂 ComfyUI exists. Pulling latest..."
    cd ComfyUI
    git pull || true
else
    log "🚀 Cloning official ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI.git
    cd ComfyUI
fi

log "🧪 Checking existing RunPod PyTorch/CUDA..."
python - <<'PY'
import torch
print("torch:", torch.__version__, torch.__file__)
print("cuda build:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())
x = torch.zeros(1, device="cuda")
print("CUDA tensor OK:", x)
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
PY

log "🧩 Ensuring torchvision matches torch CUDA 13 build..."
# Remove any CPU/PyPI torchvision from venv; keep torch from system site-packages.
pip uninstall -y torchvision || true
pip install "torchvision==${TORCHVISION_VERSION_PIN}" \
  --index-url "${PYTORCH_CUDA_INDEX}" \
  --no-deps \
  --no-cache-dir

python - <<'PY'
import torch
import torchvision
from torchvision.ops import nms
print("torch:", torch.__version__, torch.__file__)
print("torchvision:", torchvision.__version__, torchvision.__file__)
print("torchvision nms OK")
x = torch.zeros(1, device="cuda")
print("CUDA still OK:", x)
print("device:", torch.cuda.get_device_name(0))
PY

TORCH_VERSION=$(python - <<'PY'
import torch
print(torch.__version__)
PY
)

TORCHVISION_VERSION=$(python - <<'PY'
import torchvision
print(torchvision.__version__)
PY
)

TORCHAUDIO_VERSION=$(python - <<'PY'
try:
    import torchaudio
    print(torchaudio.__version__)
except Exception:
    print("")
PY
)

cat > /tmp/comfy-torch-constraints.txt <<EOF2
torch==$TORCH_VERSION
torchvision==$TORCHVISION_VERSION
EOF2

if [ -n "$TORCHAUDIO_VERSION" ]; then
  echo "torchaudio==$TORCHAUDIO_VERSION" >> /tmp/comfy-torch-constraints.txt
fi

log "🔒 Torch constraints:"
cat /tmp/comfy-torch-constraints.txt

log "📦 Installing official ComfyUI requirements without changing torch stack..."
pip install -r requirements.txt \
  --constraint /tmp/comfy-torch-constraints.txt \
  --no-cache-dir

if [ -f "manager_requirements.txt" ]; then
    log "📦 Installing ComfyUI manager_requirements.txt..."
    pip install -r manager_requirements.txt \
      --constraint /tmp/comfy-torch-constraints.txt \
      --no-cache-dir
fi

log "✨ Installing ComfyUI-Manager and selected custom nodes..."
mkdir -p custom_nodes
cd custom_nodes

install_node() {
    repo_url="$1"
    folder_name="$2"

    if [ -d "$folder_name" ]; then
        log "⏭️  $folder_name exists. Pulling latest..."
        cd "$folder_name"
        git pull || true
        cd ..
    else
        log "⬇️  Cloning $folder_name"
        git clone "$repo_url" "$folder_name"
    fi

    if [ -f "$folder_name/requirements.txt" ]; then
        log "💊 Installing dependencies for $folder_name without changing torch stack..."
        pip install -r "$folder_name/requirements.txt" \
          --constraint /tmp/comfy-torch-constraints.txt \
          --no-cache-dir
    fi
}

# Required: ComfyUI-Manager
install_node "https://github.com/Comfy-Org/ComfyUI-Manager.git" "$MANAGER_DIR_NAME"

# Selected custom nodes
install_node "https://github.com/MoonGoblinDev/Civicomfy.git" "Civicomfy"
install_node "https://github.com/kijai/ComfyUI-KJNodes.git" "ComfyUI-KJNodes"
install_node "https://github.com/rgthree/rgthree-comfy.git" "rgthree-comfy"

cd /workspace/ComfyUI

# ComfyUI-Manager may use uv/pip operations during install/startup.
# If any dependency accidentally installed torch/torchaudio/triton into the venv,
# remove them so the venv falls back to RunPod system torch 2.9.1+cu130.
cleanup_venv_torch_stack

log "🧩 Re-installing torchvision CUDA 13 build after cleanup..."
pip install "torchvision==${TORCHVISION_VERSION_PIN}" \
  --index-url "${PYTORCH_CUDA_INDEX}" \
  --no-deps \
  --no-cache-dir

log "🧪 Final CUDA + torchvision + torchaudio check after installs..."
python - <<'PY'
import torch
import torchvision
import torchaudio
from torchvision.ops import nms
print("torch:", torch.__version__, torch.__file__)
print("torchvision:", torchvision.__version__, torchvision.__file__)
print("torchaudio:", torchaudio.__version__, torchaudio.__file__)
print("cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())
assert torch.__version__.startswith("2.9.1+cu130"), "Unexpected torch version/path; torch stack was modified"
assert "/usr/local/lib/python3.12/dist-packages/torch/" in torch.__file__, "torch must come from RunPod system packages"
assert torchvision.__version__.endswith("+cu130"), "torchvision must be CUDA 13 build"
assert torchaudio.__version__.startswith("2.9.1+cu130"), "torchaudio must match system torch"
x = torch.zeros(1, device="cuda")
print("CUDA still OK:", x)
print("device:", torch.cuda.get_device_name(0))
print("torchvision nms OK")
PY

log "✅ Installation Complete!"
log "Run:"
log "cd /workspace/ComfyUI"
log "source /workspace/venv/bin/activate"
log "python main.py --listen 0.0.0.0 --port 8188 --enable-manager"
