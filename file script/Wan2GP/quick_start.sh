cat > quick_run.sh << 'EOF'
#!/bin/bash
echo "🚀 Quick Start Wan2GP"
echo "===================="

cd /workspace/Wan2GP
eval "$(/root/miniconda3/bin/conda shell.bash hook)"
conda activate wan2gp

# Simple environment fix
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# Start without port checking
echo "🌐 Starting Wan2GP on port 7860..."
python wgp.py --i2v --share --server-port 7860
EOF

chmod +x quick_run.sh
