cat > install_wan2gp.sh << 'EOF'
#!/bin/bash

echo "🚀 Installing Wan2GP on RunPod"
echo "=============================="

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

# Initialize conda
eval "$(/root/miniconda3/bin/conda shell.bash hook)"
/root/miniconda3/bin/conda init bash
source ~/.bashrc

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
fi
conda activate wan2gp

# Install PyTorch
echo "🔥 Installing PyTorch 2.6.0..."
pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124

# Install Triton
echo "⚡ Installing Triton 3.2.0..."
pip install triton==3.2.0

# Install core dependencies
echo "📦 Installing core dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Install FFmpeg
echo "🎬 Installing FFmpeg and media tools..."
conda install -y ffmpeg imagemagick -c conda-forge
apt update && apt install -y libsm6 libxext6 libfontconfig1 libxrender1

# Install SageAttention 2
echo "🧠 Installing SageAttention 2..."
if [ ! -d "SageAttention" ]; then
    git clone https://github.com/thu-ml/SageAttention
fi
cd SageAttention
pip install -e . || echo "⚠️  SageAttention compilation failed"
cd ..

# Test installation
echo "🧪 Testing installation..."
python -c "
import torch
print(f'✅ PyTorch: {torch.__version__}')
print(f'✅ CUDA: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✅ GPU: {torch.cuda.get_device_name()}')
try:
    import sageattention
    print('✅ SageAttention: Available')
except:
    print('⚠️  SageAttention: Not available')
"

echo "🎉 Installation Complete!"
echo "========================"
echo "📍 Location: /workspace/Wan2GP"
echo "🌟 Environment: wan2gp"
echo "🚀 To run: ./run_wan2gp.sh"
EOF

chmod +x install_wan2gp.sh
