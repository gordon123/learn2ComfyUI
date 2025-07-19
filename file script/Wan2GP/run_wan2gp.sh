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
# Fix environment variables
export XDG_RUNTIME_DIR=/tmp/runtime-root
export PULSE_RUNTIME_PATH=/dev/null
export ALSA_PCM_CARD=1
mkdir -p /tmp/runtime-root
chmod 700 /tmp/runtime-root
# Check if port is available
PORT=7860
while netstat -tuln | grep -q ":$PORT "; do
   PORT=$((PORT+1))
   if [ $PORT -gt 7870 ]; then
       echo "❌ No available ports found"
       exit 1
   fi
done
echo "🌐 Starting Wan2GP on port $PORT"
echo "📱 Public URL will be displayed below:"
echo "====================================="
# Start Wan2GP
python wgp.py --i2v --share --server-port $PORT
EOF
chmod +x run_wan2gp.sh
