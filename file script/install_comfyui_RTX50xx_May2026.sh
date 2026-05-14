#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# ComfyUI installer for RunPod RTX 50xx / Blackwell
# Target image example:
#   runpod/pytorch:1.0.3-cu1300-torch291-ubuntu2404
#
# Key rule:
#   Keep the RunPod-provided torch 2.9.1+cu130.
#   Do NOT install torch nightly.
#   Force torchvision to the matching CUDA 13 wheel before installing ComfyUI.
# -----------------------------------------------------------------------------

PYTORCH_CUDA_INDEX="https://download.pytorch.org/whl/cu130"
WORKSPACE_DIR="/workspace"
COMFY_DIR="${WORKSPACE_DIR}/ComfyUI"
CONSTRAINT_FILE="/tmp/comfy-torch-constraints.txt"

run_python_check() {
python - <<'PY'
import sys
print("python:", sys.executable)
if sys.prefix == sys.base_prefix:
    raise SystemExit("❌ venv is not active. Run: source /workspace/venv/bin/activate")
print("✅ venv active")
PY
}

check_cuda() {
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
}

check_torchvision_nms() {
python - <<'PY'
import torch
import torchvision
print("torch:", torch.__version__, torch.__file__)
print("torchvision:", torchvision.__version__, torchvision.__file__)
from torchvision.ops import nms
print("torchvision nms OK")
x = torch.zeros(1, device="cuda")
print("CUDA still OK:", x)
print("device:", torch.cuda.get_device_name(0))
PY
}

echo "🧪 Checking virtual environment..."
run_python_check

# NumPy is required by many ComfyUI dependencies and avoids torch import warnings.
echo "📦 Ensuring NumPy is installed..."
pip install numpy --no-cache-dir

cd "${WORKSPACE_DIR}"

if [ -d "ComfyUI" ]; then
    echo "📂 ComfyUI exists. Pulling latest..."
    cd "${COMFY_DIR}"
    git pull || true
else
    echo "🚀 Cloning official ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI.git
    cd "${COMFY_DIR}"
fi

echo "🧪 Checking existing RunPod PyTorch/CUDA..."
check_cuda

echo "🧩 Ensuring torchvision matches torch CUDA 13 build..."
# If PyPI torchvision was installed inside the venv, it can shadow the CUDA wheel
# from the base image and cause: RuntimeError: operator torchvision::nms does not exist
pip uninstall -y torchvision || true
pip install torchvision==0.24.1 \
  --index-url "${PYTORCH_CUDA_INDEX}" \
  --no-deps \
  --no-cache-dir

check_torchvision_nms

echo "🔒 Creating torch/vision/audio constraints..."
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

cat > "${CONSTRAINT_FILE}" <<EOF_CONSTRAINTS
torch==${TORCH_VERSION}
torchvision==${TORCHVISION_VERSION}
EOF_CONSTRAINTS

if [ -n "${TORCHAUDIO_VERSION}" ]; then
  echo "torchaudio==${TORCHAUDIO_VERSION}" >> "${CONSTRAINT_FILE}"
fi

echo "🔒 Torch constraints:"
cat "${CONSTRAINT_FILE}"

echo "📦 Installing official ComfyUI requirements without changing torch stack..."
pip install -r requirements.txt \
  --constraint "${CONSTRAINT_FILE}" \
  --no-cache-dir

echo "🧪 Re-checking CUDA and torchvision after ComfyUI requirements..."
check_cuda
check_torchvision_nms

echo "✨ Installing selected custom nodes..."
mkdir -p custom_nodes
cd custom_nodes

install_node() {
    local repo_url="$1"
    local folder_name
    folder_name=$(basename "${repo_url}" .git)

    if [ -d "${folder_name}" ]; then
        echo "⏭️  ${folder_name} exists. Pulling latest..."
        cd "${folder_name}"
        git pull || true
        cd ..
    else
        echo "⬇️  Cloning ${folder_name}"
        git clone "${repo_url}"
    fi

    if [ -f "${folder_name}/requirements.txt" ]; then
        echo "💊 Installing dependencies for ${folder_name} without changing torch stack..."
        pip install -r "${folder_name}/requirements.txt" \
          --constraint "${CONSTRAINT_FILE}" \
          --no-cache-dir
    fi

    echo "🧪 CUDA check after ${folder_name}..."
    check_cuda
}

# Do not clone ComfyUI-Manager into custom_nodes for Manager v4.
# Launch ComfyUI with --enable-manager instead.

install_node "https://github.com/MoonGoblinDev/Civicomfy.git"
install_node "https://github.com/kijai/ComfyUI-KJNodes.git"
install_node "https://github.com/rgthree/rgthree-comfy.git"

cd "${COMFY_DIR}"

echo "🧪 Final CUDA and torchvision checks..."
check_cuda
check_torchvision_nms

echo "✅ Installation Complete!"
echo "------------------------------------------------"
echo "Run:"
echo "cd /workspace/ComfyUI"
echo "source /workspace/venv/bin/activate"
echo "python main.py --listen 0.0.0.0 --port 8188 --enable-manager"
