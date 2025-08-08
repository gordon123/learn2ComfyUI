#!/bin/bash
set -e

echo "🚀 เริ่มติดตั้งระบบ Ollama + ComfyUI แบบอัตโนมัติ"

# 1) สร้าง venv ถ้ายังไม่มี
if [ ! -d "/workspace/venv" ]; then
    echo "📦 สร้าง Python virtual environment..."
    python3 -m venv /workspace/venv
fi

# 2) activate venv เสมอ
echo "🔑 เปิดใช้งาน virtual environment..."
source /workspace/venv/bin/activate

# 3) ติดตั้ง Ollama ถ้ายังไม่มี
if ! command -v ollama &> /dev/null; then
    echo "⬇️ ติดตั้ง Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# 4) เริ่ม Ollama server (background)
echo "🖥️ เริ่ม Ollama server..."
pkill -f "ollama serve" || true
OLLAMA_MODELS=/workspace/ollama \
OLLAMA_LLM_LIBRARY=cublas \
OLLAMA_FLASH_ATTENTION=1 \
nohup ollama serve > /workspace/ollama.log 2>&1 &

sleep 5

# 5) ดาวน์โหลดโมเดล
echo "⬇️ ดาวน์โหลดโมเดล qwen2.5vl:7b และ mistral:latest..."
ollama pull qwen2.5vl:7b
ollama pull mistral:latest

# 6) ตรวจสอบการ์ดจอ
GPU_MODEL=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
echo "🖥️ ตรวจพบการ์ดจอ: $GPU_MODEL"

if echo "$GPU_MODEL" | grep -qE "30|40"; then
    INSTALL_SCRIPT="install_rtx30_40.sh"
elif echo "$GPU_MODEL" | grep -q "50"; then
    INSTALL_SCRIPT="install_rtx50.sh"
else
    echo "⚠️ ไม่พบการ์ด RTX series 30xx, 40xx, หรือ 50xx — ข้ามติดตั้ง ComfyUI"
    INSTALL_SCRIPT=""
fi

# 7) ติดตั้ง ComfyUI (ถ้ายังไม่มีและการ์ดจอรองรับ)
if [ ! -d "/workspace/ComfyUI" ] && [ -n "$INSTALL_SCRIPT" ]; then
    echo "⬇️ ติดตั้ง ComfyUI ตามรุ่น GPU..."
    wget -q https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/$INSTALL_SCRIPT -O /workspace/$INSTALL_SCRIPT
    chmod +x /workspace/$INSTALL_SCRIPT
    /bin/bash /workspace/$INSTALL_SCRIPT
else
    echo "✅ ComfyUI มีอยู่แล้ว หรือไม่รองรับ GPU — ข้ามขั้นตอนติดตั้ง"
fi

# 8) ติดตั้ง comfyui-ollama ถ้ามี ComfyUI
if [ -d "/workspace/ComfyUI" ]; then
    echo "🔌 ติดตั้ง comfyui-ollama..."
    cd /workspace/ComfyUI/custom_nodes
    if [ ! -d "comfyui-ollama" ]; then
        git clone https://github.com/stavsap/comfyui-ollama.git
    else
        echo "📂 พบ comfyui-ollama แล้ว — ข้ามการติดตั้ง"
    fi
else
    echo "⚠️ ไม่มี ComfyUI — ไม่สามารถติดตั้ง comfyui-ollama ได้"
fi

echo "🎉 ติดตั้งเสร็จสิ้น พร้อมใช้งาน!"
