#!/bin/bash
set -e

# 🎨 ฟังก์ชันสี
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

echo -e "${CYAN}⬇️ กำลังตรวจสอบ Virtual Environment...${RESET}"
if [ ! -d "/workspace/venv" ]; then
    echo -e "${YELLOW}⚠️ ไม่พบ venv — กำลังสร้าง...${RESET}"
    python3 -m venv /workspace/venv
fi
echo -e "${GREEN}✅ พบ venv แล้ว — กำลัง activate...${RESET}"
source /workspace/venv/bin/activate

# ติดตั้ง Ollama
echo -e "${CYAN}⬇️ กำลังติดตั้ง Ollama...${RESET}"
curl -fsSL https://ollama.com/install.sh | sh
ollama --version

# ตั้งค่าตัวแปร Ollama
export OLLAMA_MODELS=/workspace/ollama
export OLLAMA_LLM_LIBRARY=cublas
export OLLAMA_FLASH_ATTENTION=1

# เริ่ม Ollama server
echo -e "${CYAN}🚀 กำลังเริ่ม Ollama server...${RESET}"
nohup ollama serve > /workspace/ollama.log 2>&1 &
sleep 5

# ดาวน์โหลดโมเดล
echo -e "${CYAN}⬇️ กำลังดาวน์โหลดโมเดล Ollama...${RESET}"
ollama pull qwen2.5vl:7b
ollama pull mistral:latest

# ตรวจสอบ GPU
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
echo -e "${CYAN}🖥️ ตรวจพบการ์ดจอ: ${YELLOW}${GPU_NAME}${RESET}"

INSTALL_COMFYUI=false

if echo "$GPU_NAME" | grep -E "RTX 30|RTX 40"; then
    echo -e "${GREEN}✅ ตรวจพบ RTX 30xx/40xx — ติดตั้ง ComfyUI เวอร์ชัน 30/40xx${RESET}"
    INSTALL_COMFYUI=true
    COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx30_40.sh"

elif echo "$GPU_NAME" | grep -E "RTX 50"; then
    echo -e "${GREEN}✅ ตรวจพบ RTX 50xx — ติดตั้ง ComfyUI เวอร์ชัน 50xx${RESET}"
    INSTALL_COMFYUI=true
    COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx50.sh"

else
    echo -e "${YELLOW}⚠️ การ์ดจอไม่ใช่ RTX 30xx/40xx/50xx — อาจมี custom node บางตัวที่ใช้งานไม่ได้${RESET}"
    read -p "คุณต้องการติดตั้ง ComfyUI แบบอัตโนมัติสำหรับ RTX 30/40 แทนหรือไม่? (y/n): " yn
    if [[ "$yn" == "y" ]]; then
        INSTALL_COMFYUI=true
        COMFY_SCRIPT="https://github.com/gordon123/learn2ComfyUI/raw/main/file%20script/install_rtx30_40.sh"
    else
        echo -e "${RED}❌ ข้ามการติดตั้ง ComfyUI${RESET}"
    fi
fi

# ติดตั้ง ComfyUI
if $INSTALL_COMFYUI; then
    echo -e "${CYAN}⬇️ กำลังติดตั้ง ComfyUI...${RESET}"
    bash <(curl -fsSL "$COMFY_SCRIPT")
fi

# ติดตั้ง comfyui-ollama ถ้ามี ComfyUI อยู่
if [ -d "/workspace/ComfyUI" ]; then
    echo -e "${CYAN}⬇️ กำลังติดตั้ง comfyui-ollama...${RESET}"
    cd /workspace/ComfyUI/custom_nodes
    if [ ! -d "comfyui-ollama" ]; then
        git clone https://github.com/stavsap/comfyui-ollama.git
    fi
else
    echo -e "${YELLOW}⚠️ ไม่มี ComfyUI — ไม่สามารถติดตั้ง comfyui-ollama ได้${RESET}"
fi

# 🎯 สรุปการติดตั้งพร้อมคำแนะนำ
echo -e "${GREEN}🎉 การติดตั้งเสร็จสิ้น พร้อมใช้งาน!${RESET}\n"
echo -e "${CYAN}📌 เริ่มใช้งาน ComfyUI พิมพ์คำสั่งต่อไปนี้:${RESET}"
echo -e "  ${YELLOW}source /workspace/venv/bin/activate${RESET}"
echo -e "  ${YELLOW}cd ComfyUI${RESET}"
echo -e "  ${YELLOW}python main.py --listen${RESET}\n"

echo -e "${CYAN}📌 วิธีใช้ Ollama พิมพ์คำสั่งต่อไปนี้:${RESET}"
echo -e "  ${YELLOW}ollama help${RESET}        # ดูคู่มือคำสั่ง"
echo -e "  ${YELLOW}ollama list${RESET}        # ดูรายชื่อโมเดลที่ติดตั้ง"
echo -e "  ${YELLOW}ollama run <model>${RESET} # รันโมเดล เช่น ollama run qwen2.5vl:7b"
