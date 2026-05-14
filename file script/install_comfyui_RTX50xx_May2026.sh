#!/bin/bash
set -euo pipefail

echo "🧪 Checking virtual environment..."
python - <<'PY'
import sys
print("python:", sys.executable)
if sys.prefix == sys.base_prefix:
    raise SystemExit("❌ venv is not active. Run: source /workspace/venv/bin/activate")
print("✅ venv active")
PY

cd /workspace

if [ -d "ComfyUI" ]; then
    echo "📂 ComfyUI exists. Pulling latest..."
    cd ComfyUI
    git pull
else
    echo "🚀 Cloning official ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI.git
    cd ComfyUI
fi

echo "🧪 Checking existing RunPod PyTorch/CUDA..."
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())
x = torch.zeros(1, device="cuda")
print("CUDA tensor OK:", x)
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
PY

TORCH_VERSION=$(python - <<'PY'
import torch
print(torch.__version__)
PY
)

TORCHVISION_VERSION=$(python - <<'PY'
try:
    import torchvision
    print(torchvision.__version__)
except Exception:
    print("")
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

cat > /tmp/comfy-torch-constraints.txt <<EOF
torch==$TORCH_VERSION
EOF

if [ -n "$TORCHVISION_VERSION" ]; then
  echo "torchvision==$TORCHVISION_VERSION" >> /tmp/comfy-torch-constraints.txt
fi

if [ -n "$TORCHAUDIO_VERSION" ]; then
  echo "torchaudio==$TORCHAUDIO_VERSION" >> /tmp/comfy-torch-constraints.txt
fi

echo "🔒 Torch constraints:"
cat /tmp/comfy-torch-constraints.txt

echo "📦 Installing official ComfyUI requirements without changing torch..."
pip install -r requirements.txt \
  --constraint /tmp/comfy-torch-constraints.txt \
  --no-cache-dir

echo "✨ Installing selected custom nodes..."
mkdir -p custom_nodes
cd custom_nodes

install_node() {
    repo_url="$1"
    folder_name=$(basename "$repo_url" .git)

    if [ -d "$folder_name" ]; then
        echo "⏭️  $folder_name exists. Pulling latest..."
        cd "$folder_name"
        git pull || true
        cd ..
    else
        echo "⬇️  Cloning $folder_name"
        git clone "$repo_url"
    fi

    if [ -f "$folder_name/requirements.txt" ]; then
        echo "💊 Installing dependencies for $folder_name without changing torch..."
        pip install -r "$folder_name/requirements.txt" \
          --constraint /tmp/comfy-torch-constraints.txt \
          --no-cache-dir
    fi
}

# อย่า clone ComfyUI-Manager เข้า custom_nodes บน Manager v4
# ใช้ --enable-manager ตอนรันแทน

install_node "https://github.com/MoonGoblinDev/Civicomfy.git"
install_node "https://github.com/kijai/ComfyUI-KJNodes.git"
install_node "https://github.com/rgthree/rgthree-comfy.git"

cd /workspace/ComfyUI

echo "🧪 Final CUDA check after installs..."
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())
x = torch.zeros(1, device="cuda")
print("CUDA still OK:", x)
print("device:", torch.cuda.get_device_name(0))
PY

echo "✅ Installation Complete!"
echo "Run:"
echo "cd /workspace/ComfyUI"
echo "source /workspace/venv/bin/activate"
echo "python main.py --listen 0.0.0.0 --port 8188 --enable-manager"
