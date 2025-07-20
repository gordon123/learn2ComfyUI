#!/bin/bash
echo "🚀 Installing Wan2GP on RunPod (RTX 50xx Series)"
echo "==============================================="
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

# Initialize conda in bashrc
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

# Critical: Activate environment in the current shell
echo "🔄 Activating wan2gp environment..."
source /root/miniconda3/bin/activate wan2gp

# Alternative activation method (more reliable in scripts)
export CONDA_DEFAULT_ENV="wan2gp"
export PATH="/root/miniconda3/envs/wan2gp/bin:$PATH"

# Verify we're in the right environment
echo "🔍 Verifying environment activation..."
echo "Current Python path: $(which python)"
echo "Current pip path: $(which pip)"  
echo "Conda environment: $CONDA_DEFAULT_ENV"

# Double check - must contain 'wan2gp' in path
if [[ "$(which python)" != *"wan2gp"* ]]; then
    echo "❌ CRITICAL ERROR: Environment not activated properly!"
    echo "Expected Python path to contain 'wan2gp'"
    echo "Current path: $(which python)"
    exit 1
fi

echo "✅ Environment activated successfully!"

# Install PyTorch for RTX 50xx (now using activated environment)
echo "🔥 Installing PyTorch 2.7.0 with CUDA 12.8 (RTX 50xx)..."
pip install --root-user-action=ignore torch>=2.7.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# Install Triton for RTX 50xx (now using activated environment)
echo "⚡ Installing Triton 3.3.0 (RTX 50xx support)..."
pip install --root-user-action=ignore triton>=3.3.0

# Install core dependencies (now using activated environment)
echo "📦 Installing core dependencies..."
if [ -f "requirements.txt" ]; then
    pip install --root-user-action=ignore -r requirements.txt
fi

# Install FFmpeg and Audio Libraries through conda (in the environment)
echo "🎬 Installing FFmpeg and media tools..."
conda install -y ffmpeg imagemagick libsndfile sox libflac libogg libvorbis -c conda-forge

# System packages (these need to be installed system-wide)
echo "📦 Installing system packages..."
apt update && apt install -y libsm6 libxext6 libfontconfig1 libxrender1 libsndfile1 libsndfile1-dev

# Install audio processing libraries (now using activated environment)
echo "🔊 Installing audio processing libraries..."
pip install --root-user-action=ignore soundfile librosa

# Install SageAttention 2 (now using activated environment)
echo "🧠 Installing SageAttention 2..."
if [ ! -d "SageAttention" ]; then
    git clone https://github.com/thu-ml/SageAttention
fi
cd SageAttention
pip install --root-user-action=ignore -e . || echo "⚠️  SageAttention compilation failed, but continuing..."
cd ..

# Note: run_wan2gp.sh should be created separately by user
echo "📜 Note: Use your existing run_wan2gp.sh or create one separately"

# Test installation in the activated environment
echo "🧪 Testing installation..."
python -c "
import torch
import sys
print(f'✅ Python: {sys.version}')
print(f'✅ Python path: {sys.executable}')
print(f'✅ PyTorch: {torch.__version__}')
print(f'✅ CUDA Available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✅ GPU: {torch.cuda.get_device_name()}')
    print(f'✅ CUDA Version: {torch.version.cuda}')
    # Check RTX 50xx support
    capability = torch.cuda.get_device_capability()
    if capability[0] >= 12:
        print('🎉 RTX 50xx (Blackwell) detected and supported!')
    else:
        print(f'⚠️  GPU Compute Capability: {capability[0]}.{capability[1]}')
else:
    print('⚠️  CUDA not available')

try:
    import triton
    print(f'✅ Triton: {triton.__version__}')
except ImportError as e:
    print(f'⚠️  Triton: Not available - {e}')

try:
    import sageattention
    print('✅ SageAttention: Available')
except ImportError as e:
    print(f'⚠️  SageAttention: Not available - {e}')

# Check if we're really in the environment
import os
env_name = os.environ.get('CONDA_DEFAULT_ENV', 'None')
if 'wan2gp' in env_name:
    print('✅ Properly running in wan2gp environment')
else:
    print(f'⚠️  Warning: Environment might not be activated properly: {env_name}')
"

echo ""
echo "🎉 Installation Complete!"
echo "========================"
echo "📍 Location: /workspace/Wan2GP"
echo "🌟 Environment: wan2gp (conda)"
echo "🚀 To run: ./run_wan2gp.sh"
echo ""
echo "📋 RTX 50xx Features Enabled:"
echo "   • PyTorch 2.7+ with CUDA 12.8"
echo "   • Triton 3.3+ for Blackwell support"  
echo "   • Full SM 12.0 compute capability"
echo ""
echo "🔧 To manually activate environment:"
echo "   conda activate wan2gp"
echo ""
echo "📦 All packages installed in: /root/miniconda3/envs/wan2gp/"
