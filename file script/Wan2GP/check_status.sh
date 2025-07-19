cat > check_status.sh << 'EOF'
#!/bin/bash

echo "📊 Wan2GP Status Check"
echo "====================="

# Check installation
if [ -d "/workspace/Wan2GP" ]; then
    echo "✅ Wan2GP directory exists"
else
    echo "❌ Wan2GP not installed"
    exit 1
fi

# Check conda environment
eval "$(/root/miniconda3/bin/conda shell.bash hook)"
if conda info --envs | grep -q "wan2gp"; then
    echo "✅ Conda environment exists"
    conda activate wan2gp
    
    # Check Python packages
    python -c "
import sys
print(f'✅ Python: {sys.version}')

try:
    import torch
    print(f'✅ PyTorch: {torch.__version__}')
    print(f'✅ CUDA: {torch.cuda.is_available()}')
    if torch.cuda.is_available():
        print(f'✅ GPU: {torch.cuda.get_device_name()}')
except:
    print('❌ PyTorch not available')

try:
    import triton
    print(f'✅ Triton: {triton.__version__}')
except:
    print('❌ Triton not available')

try:
    import sageattention
    print('✅ SageAttention: Available')
except:
    print('❌ SageAttention not available')
"
else
    echo "❌ Conda environment not found"
fi

# Check running processes
if pgrep -f "wgp.py" > /dev/null; then
    echo "✅ Wan2GP is running"
    echo "🌐 Check ports: $(netstat -tuln | grep ':786[0-9]' | awk '{print $4}' | cut -d: -f2)"
else
    echo "⚠️  Wan2GP is not running"
fi
EOF

chmod +x check_status.sh
