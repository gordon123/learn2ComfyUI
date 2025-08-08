#!/bin/bash
set -e

echo "=============================="
echo "🚀 เริ่มติดตั้ง Ollama + ComfyUI + comfyui-ollama"
echo "=============================="

# ==============================
# 1) เตรียม Python Virtual Environment
# ==============================
if [ ! -d "/workspace/venv" ]; then
    echo "🛠️ ไม่มี virtual environment — สร้างใหม่..."
    python3 -m venv /workspace/venv
else
    echo "✅ พบ virtual environment แล้ว"
fi
source /workspace/venv/bin/activate

# ==============================
# 2) ติดตั้ง Ollama
# ==============================
echo "⬇️ ติดตั้ง Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

export OLLAMA_MODELS=/workspace/ollama
export OLLAMA_LLM_LIBRARY=cublas
export OLLAMA_FLASH_ATTENTION=1

# ==============================
# 3) ดาวน์โหลดโมเดล Ollama
# ==============================
echo "⬇️ ดาวน์โหลดโมเดล qwen2.5vl:7b และ mistral:latest..."
ollama pull qwen2.5vl:7b
ollama pull mistral:latest

# ==============================
# 4) ตรวจสอบ GPU
# ==============================
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1 || echo "Unknown")
echo "🖥️ ตรวจพบการ์ดจอ: $GPU_NAME"

INSTALL_COMFYUI="no"

if echo "$GPU_NAME" | grep -E "RTX 30|RTX 40" > /dev/null; then
    echo "✅ เลือกติดตั้ง ComfyUI รุ่น RTX 30xx/40xx"
    INSTALL_COMFYUI="yes"
    COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx30_40.sh"
elif echo "$GPU_NAME" | grep -E "RTX 50" > /dev/null; then
    echo "✅ เลือกติดตั้ง ComfyUI รุ่น RTX 50xx"
    INSTALL_COMFYUI="yes"
    COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx50.sh"
else
    echo "⚠️ การ์ดจอ '$GPU_NAME' ไม่ใช่ RTX Series — แนะนำใช้สคริปต์ RTX 30xx/40xx"
    read -p "ติดตั้ง ComfyUI อัตโนมัติ? (y/N): " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        INSTALL_COMFYUI="yes"
        COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx30_40.sh"
    else
        echo "❌ ข้ามการติดตั้ง ComfyUI"
    fi
fi

# ==============================
# 5) ติดตั้ง ComfyUI (ถ้าผู้ใช้ยอมรับ)
# ==============================
if [ "$INSTALL_COMFYUI" == "yes" ]; then
    echo "⬇️ กำลังติดตั้ง ComfyUI..."
    bash <(curl -sSL "$COMFY_SCRIPT")
else
    echo "⚠️ ไม่มี ComfyUI — จะไม่ติดตั้ง comfyui-ollama"
fi

# ==============================
# 6) ติดตั้ง comfyui-ollama (ถ้ามี ComfyUI)
# ==============================
if [ -d "/workspace/ComfyUI" ]; then
    echo "⬇️ กำลังติดตั้ง comfyui-ollama..."
    git clone https://github.com/stavsap/comfyui-ollama /workspace/ComfyUI/custom_nodes/comfyui-ollama || true
    echo "📦 ติดตั้ง dependencies ของ comfyui-ollama..."
    pip install --upgrade pip
    pip install -r /workspace/ComfyUI/custom_nodes/comfyui-ollama/requirements.txt
else
    echo "⚠️ ไม่มี ComfyUI — ข้ามการติดตั้ง comfyui-ollama"
fi

# ==============================
# 7) คำแนะนำการใช้งาน
# ==============================
echo "🎉 การติดตั้งเสร็จสิ้น พร้อมใช้งาน!"
echo
echo "📌 เริ่มใช้งาน ComfyUI:"
echo "source /workspace/venv/bin/activate"
echo "cd /workspace/ComfyUI"
echo "python main.py --listen"
echo
echo "📌 คำสั่งใช้งาน Ollama:"
echo "ollama help"
echo "ollama list"
echo "ollama run qwen2.5vl:7b"
echo "ollama run mistral:latest"
