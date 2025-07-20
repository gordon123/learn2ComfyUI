cat > install_wan2gp.sh << 'EOF'
#!/bin/bash

echo "🚀 Installing Wan2GP on RunPod (Robust Version for RTX 30xx/40xx)"
echo "================================================================="
set -e

cd /workspace

# Install Miniconda
echo "🐍 Installing Miniconda..."
if [ ! -d "/root/miniconda3" ]; then
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p /root/miniconda3
    rm miniconda.sh
    echo "✅ Miniconda installed"
else
    echo "✅ Miniconda already installed"
fi

# Initialize conda properly
export PATH="/root/miniconda3/bin:$PATH"
eval "$(/root/miniconda3/bin/conda shell.bash hook)"

# Initialize conda in bashrc (non-critical)
/root/miniconda3/bin/conda init bash
source ~/.bashrc || true

# Accept ToS
echo "📋 Accepting Conda Terms of Service..."
conda config --set channel_priority strict
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main || true
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r || true

# Clone Wan2GP
echo "📦 Cloning Wan2GP repository..."
if [ ! -d "Wan2GP" ]; then
    git clone https://github.com/deepbeepmeep/Wan2GP.git
    echo "✅ Repository cloned"
else
    echo "✅ Repository already exists"
fi

cd Wan2GP

# Setup model storage
echo "💾 Setting up model storage..."
mkdir -p /workspace/models
if [ ! -L "ckpts" ]; then
    [ -d "ckpts" ] && mv ckpts ckpts_backup
    ln -sf /workspace/models ckpts
fi

# Create conda environment
echo "🐍 Creating Python 3.10.9 environment..."
if ! conda info --envs | grep -q "wan2gp"; then
    conda create -n wan2gp python=3.10.9 -y
    echo "✅ Environment 'wan2gp' created"
else
    echo "✅ Environment 'wan2gp' already exists"
fi

# Critical: Activate environment reliably in the script
echo "🔄 Activating wan2gp environment..."
source /root/miniconda3/bin/activate wan2gp
export CONDA_DEFAULT_ENV="wan2gp"
export PATH="/root/miniconda3/envs/wan2gp/bin:$PATH"

# Verify we're in the right environment
echo "🔍 Verifying environment activation..."
if [[ "$(which python)" != *"wan2gp"* ]]; then
    echo "❌ CRITICAL ERROR: Environment not activated properly! Aborting."
    exit 1
fi
echo "✅ Environment activated successfully: $(which python)"

# Install PyTorch for RTX 40xx (Ada) / 30xx (Ampere)
echo "🔥 Installing PyTorch 2.3.1 with CUDA 12.1..."
pip install --root-user-action=ignore torch==2.3.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install Triton
echo "⚡ Installing Triton..."
pip install --root-user-action=ignore triton

# Install core dependencies
echo "📦 Installing core dependencies from requirements.txt..."
if [ -f "requirements.txt" ]; then
    pip install --root-user-action=ignore -r requirements.txt
fi

# Install FFmpeg and Audio Libraries through conda
echo "🎬 Installing FFmpeg and media tools..."
conda install -y ffmpeg imagemagick libsndfile sox libflac libogg libvorbis -c conda-forge

# System packages (some libraries need this)
echo "📦 Installing system packages..."
apt-get update && apt-get install -y --no-install-recommends libsm6 libxext6 libfontconfig1 libxrender1 libsndfile1-dev

# Install Python audio processing libraries
echo "🔊 Installing audio processing libraries..."
pip install --root-user-action=ignore soundfile librosa

# Install SageAttention 2
echo "🧠 Installing SageAttention 2..."
if [ ! -d "SageAttention" ]; then
    git clone https://github.com/thu-ml/SageAttention
fi
cd SageAttention
pip install --root-user-action=ignore -e . || echo "⚠️  SageAttention compilation failed, but continuing..."
cd ..

# Comprehensive Test of Installation
echo "🧪 Running comprehensive installation test..."
python -c "
import torch
import sys
import os

print(f'--- Test Results ---')
print(f'✅ Python: {sys.version.split()[0]}')
print(f'✅ Python Path: {sys.executable}')
print(f'✅ PyTorch: {torch.__version__}')

env_name = os.environ.get('CONDA_DEFAULT_ENV', 'None')
if 'wan2gp' in env_name:
    print(f'✅ Properly running in conda env: {env_name}')
else:
    print(f'⚠️  Warning: Not running in wan2gp env. Current env: {env_name}')

print(f'✅ CUDA Available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✅ GPU: {torch.cuda.get_device_name()}')
    print(f'✅ CUDA Version (PyTorch): {torch.version.cuda}')
    capability = torch.cuda.get_device_capability()
    print(f'✅ GPU Compute Capability: {capability[0]}.{capability[1]}')
else:
    print('⚠️  CUDA not available. Check GPU and CUDA driver.')

try:
    import triton
    print(f'✅ Triton: {triton.__version__}')
except ImportError:
    print('⚠️  Triton: Not installed or failed to import.')

try:
    import sageattention
    print('✅ SageAttention: Available')
except ImportError:
    print('⚠️  SageAttention: Not available or compilation failed.')
"

echo ""
echo "🎉 Installation Complete!"
echo "========================"
echo "📍 Location: /workspace/Wan2GP"
echo "🌟 Environment: wan2gp (conda)"
echo "🚀 To run, create and use your run_wan2gp.sh script."
echo ""
echo "🔧 To manually activate the environment later:"
echo "   conda activate wan2gp"
echo ""
EOF

chmod +x install_wan2gp.sh
