cat > quick_start.sh << 'EOF'
#!/bin/bash

echo "⚡ Wan2GP Quick Start"
echo "===================="

# Quick environment setup and run
cd /workspace/Wan2GP
eval "$(/root/miniconda3/bin/conda shell.bash hook)"
conda activate wan2gp
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# Find available port
for port in 7860 7861 7862 7863; do
    if ! netstat -tuln | grep -q ":$port "; then
        echo "🌐 Using port $port"
        python wgp.py --i2v --share --server-port $port
        break
    fi
done
EOF

chmod +x quick_start.sh
