#!/bin/bash

# ❌ ถ้ามีคำสั่งไหนพลาด ให้หยุดสคริปต์ทันที
set -e

# ---------------------------
# 🔹 CONFIG PATH
# ---------------------------
COMFYUI_DIR="/workspace/ComfyUI"
VENV_PATH="/workspace/venv/bin/activate"
NODE_REPO_URL="https://github.com/CY-CHENYUE/ComfyUI-Molmo.git"
NODE_INSTALL_DIR="${COMFYUI_DIR}/custom_nodes/ComfyUI-Molmo"
MODEL_HF_REPO="cyan2k/molmo-7B-O-bnb-4bit"
MODEL_INSTALL_DIR="${COMFYUI_DIR}/models/llm/molmo-7b-4bit"

# ---------------------------
# 🛠 1) ACTIVATE VENV
# ---------------------------
echo "🔹 กำลังตรวจสอบ Virtual Environment..."
if [ -f "$VENV_PATH" ]; then
    echo "✅ พบ virtual environment แล้ว"
    source "$VENV_PATH"
else
    echo "⚠️ ไม่พบ virtual environment — กำลังสร้าง..."
    python -m venv /workspace/venv
    source "$VENV_PATH"
fi

# ---------------------------
# 🛠 2) INSTALL COMFYUI-MOLMO NODE
# ---------------------------
echo -e "\n=== [1/3] ติดตั้ง Custom Node: ComfyUI-Molmo ==="
if [ -d "$NODE_INSTALL_DIR" ]; then
    echo "ℹ️ โฟลเดอร์ ComfyUI-Molmo มีอยู่แล้ว, ข้ามการโคลน"
else
    git clone "$NODE_REPO_URL" "$NODE_INSTALL_DIR"
fi

# ติดตั้ง dependencies ล่วงหน้า เพื่อเลี่ยง error รีสตาร์ท ComfyUI
echo "📦 ติดตั้ง dependencies ที่จำเป็น..."
pip install --upgrade pip
pip install "transformers>=4.43.3" \
            "torchvision>=0.19.1" \
            "accelerate>=0.26.0" \
            "numpy>=1.24.4"

# ถ้ามี requirements.txt ใน repo ให้ติดตั้งเพิ่ม
if [ -f "${NODE_INSTALL_DIR}/requirements.txt" ]; then
    pip install -r "${NODE_INSTALL_DIR}/requirements.txt"
fi

# ---------------------------
# 🛠 3) DOWNLOAD MOLMO MODEL
# ---------------------------
echo -e "\n=== [2/3] ดาวน์โหลดโมเดล Molmo 4-bit ==="
pip install -q huggingface_hub[cli]

huggingface-cli download \
    "$MODEL_HF_REPO" \
    --local-dir "$MODEL_INSTALL_DIR" \
    --local-dir-use-symlinks False

# ---------------------------
# 🛠 4) สรุปการติดตั้ง
# ---------------------------
echo -e "\n----------------------------------------------------"
echo "✅ การติดตั้ง ComfyUI-Molmo + โมเดล 4bit เสร็จสมบูรณ์!"
echo "⚠️ กรุณารีสตาร์ท ComfyUI หรือรีสตาร์ท Pod เพื่อให้ Node โหลดได้ถูกต้อง"
echo "หลังจากรีสตาร์ทแล้ว ให้มองหา Node ในหมวด 'Molmo'"
echo "----------------------------------------------------"
