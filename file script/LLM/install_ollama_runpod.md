# Step-by-step Install Ollama บน Runpod

### 1. Update & Install Tools
```
apt-get update && apt-get install -y pciutils lshw curl
```

### 2. Setup Storage (กัน Model หาย)
```
mkdir -p /workspace/ollama_models
echo 'export OLLAMA_MODELS="/workspace/ollama_models"' >> ~/.bashrc
export OLLAMA_MODELS="/workspace/ollama_models"
```

### 3. Install Ollama
```
curl -fsSL https://ollama.com/install.sh | sh
```

### 4. Start Server (Background & Open Port)
```
OLLAMA_HOST=0.0.0.0:11434 ollama serve > /workspace/ollama.log 2>&1 &
```

### 5. Pull Model: Qwen3-VL
```
ollama pull qwen3-vl:8b
```
gemini-3-flash-preview:latest

ollama help เพื่อดูคำสั่งอื่นๆ

