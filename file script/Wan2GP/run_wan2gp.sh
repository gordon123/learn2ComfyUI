cat > run_wan2gp.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Wan2GP"
echo "=================="

# Check if installed
if [ ! -d "/workspace/Wan2GP" ]; then
    echo "❌ Wan2GP not found. Please run ./install_wan2gp.sh first"
    exit 1
fi

cd /workspace/Wan2GP

# Activate conda environment
eval "$(/root/miniconda3/bin/conda shell.bash hook)"
conda activate wan2gp

# Fix environment variables (improved)
export XDG_RUNTIME_DIR=/tmp/runtime-root
export PULSE_RUNTIME_PATH=/tmp/pulse-runtime
export ALSA_PCM_CARD=0
export ALSA_PCM_DEVICE=0

# Create proper runtime directories
mkdir -p /tmp/runtime-root
mkdir -p /tmp/pulse-runtime
chmod 700 /tmp/runtime-root
chmod 700 /tmp/pulse-runtime

# Install net-tools if needed (for netstat)
apt update && apt install -y net-tools > /dev/null 2>&1 || true

# Check if port is available (improved)
PORT=7860
if command -v netstat >/dev/null 2>&1; then
    while netstat -tuln 2>/dev/null | grep -q ":$PORT "; do
        PORT=$((PORT+1))
        if [ $PORT -gt 7870 ]; then
            echo "❌ No available ports found"
            exit 1
        fi
    done
else
    # Fallback: check if port is in use with ss or lsof
    while ss -tuln 2>/dev/null | grep -q ":$PORT " || lsof -i:$PORT >/dev/null 2>&1; do
        PORT=$((PORT+1))
        if [ $PORT -gt 7870 ]; then
            PORT=7860  # Use default if check fails
            break
        fi
    done
fi

echo "🌐 Starting Wan2GP on port $PORT"
echo "📱 Public URL will be displayed below:"
echo "====================================="

# Start Wan2GP
python wgp.py --i2v --share --server-port $PORT
EOF

chmod +x run_wan2gp.sh
