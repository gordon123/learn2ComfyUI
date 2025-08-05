#!/bin/bash

# สคริปต์นี้จะหยุดทำงานทันทีหากมีคำสั่งใดล้มเหลว เพื่อป้องกันความผิดพลาด
set -e

# --- ตั้งค่าตัวแปรและตำแหน่งไฟล์ ---
# ตำแหน่งของ ComfyUI บน RunPod
COMFYUI_DIR="/workspace/ComfyUI"

# --- ส่วนที่ 1: รายละเอียดของ Custom Node ---
NODE_REPO_URL="https://github.com/CY-CHENYUE/ComfyUI-Molmo.git"
NODE_INSTALL_DIR="${COMFYUI_DIR}/custom_nodes/ComfyUI-Molmo"

# --- ส่วนที่ 2: รายละเอียดของโมเดล ---
MODEL_HF_REPO="cyan2k/molmo-7B-O-bnb-4bit"
MODEL_INSTALL_DIR="${COMFYUI_DIR}/models/llm/molmo-7b-4bit"

# -------------------------------------------------------------------
# --- เริ่มการทำงานของสคริปต์ ---
# -------------------------------------------------------------------

echo "### เริ่มต้นกระบวนการติดตั้ง ComfyUI-Molmo และโมเดล ###"

# --- ส่วนที่ 1: ติดตั้ง Custom Node และ Dependencies ---
echo ""
echo "--- [ส่วนที่ 1] กำลังติดตั้ง Custom Node: ComfyUI-Molmo ---"

if [ -d "${NODE_INSTALL_DIR}" ]; then
    echo "โฟลเดอร์ Custom Node '${NODE_INSTALL_DIR}' มีอยู่แล้ว, ข้ามการโคลน"
else
    echo "กำลังโคลน ComfyUI-Molmo จาก ${NODE_REPO_URL}..."
    git clone "${NODE_REPO_URL}" "${NODE_INSTALL_DIR}"
fi

echo "กำลังติดตั้ง Dependencies ที่จำเป็นจาก requirements.txt..."
if [ -f "${NODE_INSTALL_DIR}/requirements.txt" ]; then
    pip install -r "${NODE_INSTALL_DIR}/requirements.txt"
else
    echo "คำเตือน: ไม่พบไฟล์ requirements.txt, อาจต้องติดตั้ง dependencies เอง"
fi

# --- ส่วนที่ 2: ดาวน์โหลดโมเดล 4-bit ---
echo ""
echo "--- [ส่วนที่ 2] กำลังดาวน์โหลดโมเดล: ${MODEL_HF_REPO} ---"

echo "ตรวจสอบและติดตั้ง huggingface-cli..."
pip install -q huggingface_hub[cli]

echo "กำลังดาวน์โหลดไฟล์โมเดลไปที่: ${MODEL_INSTALL_DIR}"
# ใช้ huggingface-cli เพื่อดาวน์โหลดไฟล์ทั้งหมดจาก repo
huggingface-cli download \
    "${MODEL_HF_REPO}" \
    --local-dir "${MODEL_INSTALL_DIR}" \
    --local-dir-use-symlinks False

# --- สิ้นสุดการทำงาน ---
echo ""
echo "----------------------------------------------------"
echo "✅✅✅ การติดตั้งเสร็จสมบูรณ์! ✅✅✅"
echo "ขั้นตอนต่อไปที่สำคัญมาก:"
echo "คุณต้อง RESTART Pod ของคุณเพื่อให้ ComfyUI รู้จัก Node และโมเดลใหม่"
echo "หลังจากรีสตาร์ทแล้ว ให้มองหา Node ในหมวดหมู่ 'Molmo'"
echo "----------------------------------------------------"
