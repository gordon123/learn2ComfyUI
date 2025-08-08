#!/usr/bin/env bash
set -euo pipefail

# ===============================================
#  ติดตั้ง Ollama + ดึงโมเดล + ติดตั้ง ComfyUI (อัตโนมัติสำหรับ RTX30/40/50)
#  และติดตั้ง custom node: comfyui-ollama
#  เหมาะกับ RunPod / โฮสต์แบบไม่มี systemd (root)
# ===============================================

# ---------- helpers ----------
msg(){ echo -e "\n\033[1;36m[ข้อมูล]\033[0m $*"; }
ok(){  echo -e "\033[1;32m[สำเร็จ]\033[0m $*"; }
warn(){ echo -e "\033[1;33m[เตือน]\033[0m $*"; }
err(){ echo -e "\033[1;31m[ผิดพลาด]\033[0m $*" >&2; }

# ---------- 0) venv ----------
VENV_PATH="/workspace/venv"
msg "ตรวจสอบ virtual environment ที่ $VENV_PATH"
if [[ ! -d "$VENV_PATH" ]]; then
  msg "ไม่พบ venv → สร้างใหม่"
  if ! command -v python3 >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y && apt-get install -y python3 python3-venv
    else
      err "ไม่มี python3 และไม่ใช่ระบบที่ใช้ apt-get"; exit 1
    fi
  fi
  python3 -m venv "$VENV_PATH"
  ok "สร้าง venv สำเร็จ"
fi
# shellcheck disable=SC1090
source "$VENV_PATH/bin/activate"
ok "เปิดใช้งาน venv แล้ว → $VENV_PATH"

# ---------- 1) tools ----------
msg "ตรวจสอบ curl / git"
if ! command -v curl >/dev/null 2>&1; then
  apt-get update -y && apt-get install -y curl
fi
if ! command -v git >/dev/null 2>&1; then
  apt-get install -y git
fi
ok "พร้อมใช้งาน: curl + git"

# ---------- 2) Ollama env ----------
OLLAMA_DIR="/workspace/ollama"
msg "ตั้งค่าโฟลเดอร์โมเดล: $OLLAMA_DIR"
mkdir -p "$OLLAMA_DIR"
export OLLAMA_MODELS="$OLLAMA_DIR"
export OLLAMA_LLM_LIBRARY="cublas"
export OLLAMA_FLASH_ATTENTION="1"
grep -q 'export OLLAMA_MODELS=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_MODELS=$OLLAMA_DIR" >> ~/.bashrc
grep -q 'export OLLAMA_LLM_LIBRARY=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_LLM_LIBRARY=cublas" >> ~/.bashrc
grep -q 'export OLLAMA_FLASH_ATTENTION=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_FLASH_ATTENTION=1" >> ~/.bashrc

# ---------- 3) Install Ollama ----------
msg "ติดตั้ง Ollama (สคริปต์ทางการ)"
if command -v sudo >/dev/null 2>&1; then
  curl -fsSL https://ollama.com/install.sh | sudo sh
else
  curl -fsSL https://ollama.com/install.sh | sh
fi
ok "Ollama: $(ollama --version || echo unknown)"

# ---------- 4) Start Ollama ----------
msg "สตาร์ท Ollama server (background) @11434"
pkill -f "ollama serve" >/dev/null 2>&1 || true
nohup ollama serve > "$OLLAMA_DIR/ollama.log" 2>&1 &
sleep 2
# wait ready
READY=0
for _ in {1..30}; do
  if curl -sSf http://127.0.0.1:11434/ >/dev/null 2>&1; then READY=1; break; fi
  sleep 1
done
[[ "$READY" -eq 1 ]] || { err "Ollama server ยังไม่พร้อม → tail -n 200 $OLLAMA_DIR/ollama.log"; exit 1; }
ok "พร้อมแล้ว: http://127.0.0.1:11434"

# ---------- 5) Pull models ----------
msg "ดึงโมเดลที่จำเป็น: qwen2.5vl:7b และ mistral:latest"
ollama pull qwen2.5vl:7b || warn "ดึง qwen2.5vl:7b ไม่สำเร็จ (ลองใหม่ด้วยตนเอง: ollama pull qwen2.5vl:7b)"
ollama pull mistral:latest || warn "ดึง mistral:latest ไม่สำเร็จ (ลองใหม่ด้วยตนเอง: ollama pull mistral:latest)"
ok "ขั้นตอนโมเดลเสร็จ"

# ---------- 6) Install ComfyUI (auto for RTX30/40/50) ----------
GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo 'UNKNOWN')"
msg "ตรวจพบ GPU: $GPU_NAME"

AUTO_COMFY=0
DL_DIR="/workspace"
INSTALL_SCRIPT=""
if [[ "$GPU_NAME" == *"RTX 30"* || "$GPU_NAME" == *"RTX 40"* ]]; then
  INSTALL_SCRIPT="$DL_DIR/install_comfyui_rtx30_40.sh"
  msg "ดาวน์โหลดและรันสคริปต์ ComfyUI สำหรับ RTX30/40"
  curl -L -o "$INSTALL_SCRIPT" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx30_40.sh"
  chmod +x "$INSTALL_SCRIPT"
  bash "$INSTALL_SCRIPT"
  AUTO_COMFY=1
elif [[ "$GPU_NAME" == *"RTX 50"* ]]; then
  INSTALL_SCRIPT="$DL_DIR/install_comfyui_rtx50.sh"
  msg "ดาวน์โหลดและรันสคริปต์ ComfyUI สำหรับ RTX50"
  curl -L -o "$INSTALL_SCRIPT" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx50.sh"
  chmod +x "$INSTALL_SCRIPT"
  bash "$INSTALL_SCRIPT"
  AUTO_COMFY=1
else
  warn "ไม่ใช่ RTX30/40/50 → จะไม่ติดตั้ง ComfyUI อัตโนมัติ"
  echo "แนะนำให้ติดตั้ง ComfyUI เองก่อน แล้วค่อยรันสคริปต์นี้อีกครั้งเพื่อเพิ่ม comfyui-ollama"
  echo "ลิงก์สคริปต์ (ดาวน์โหลดไว้ให้):"
  curl -L -o "$DL_DIR/install_comfyui_rtx30_40.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx30_40.sh" || true
  curl -L -o "$DL_DIR/install_comfyui_rtx50.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx50.sh" || true
  echo "ไฟล์อยู่ที่: $DL_DIR/install_comfyui_rtx30_40.sh และ $DL_DIR/install_comfyui_rtx50.sh"
fi

# ---------- 7) comfyui-ollama custom node ----------
# หา ComfyUI หลังติดตั้ง (หรือมีอยู่แล้ว)
COMFY_DIR=""
for d in "/workspace/ComfyUI" "$HOME/ComfyUI" "/opt/ComfyUI"; do
  if [[ -d "$d" ]]; then COMFY_DIR="$d"; break; fi
done

if [[ -n "$COMFY_DIR" ]]; then
  ok "พบ ComfyUI ที่: $COMFY_DIR"
  # ถ้ามี venv ของ ComfyUI เอง ให้ใช้ venv นั้น (บางสคริปต์ติดตั้งจะสร้างให้)
  if [[ -f "$COMFY_DIR/venv/bin/activate" ]]; then
    msg "พบ venv ของ ComfyUI → activate"
    # shellcheck disable=SC1090
    source "$COMFY_DIR/venv/bin/activate"
  else
    msg "ไม่พบ venv ภายใน ComfyUI → ใช้ venv ปัจจุบัน: $VENV_PATH"
  fi

  CN_DIR="$COMFY_DIR/custom_nodes"
  mkdir -p "$CN_DIR"
  if [[ -d "$CN_DIR/comfyui-ollama" ]]; then
    msg "อัปเดต comfyui-ollama"
    git -C "$CN_DIR/comfyui-ollama" pull || true
  else
    msg "ติดตั้ง comfyui-ollama"
    git clone https://github.com/stavsap/comfyui-ollama "$CN_DIR/comfyui-ollama"
  fi

  if [[ -f "$CN_DIR/comfyui-ollama/requirements.txt" ]]; then
    msg "ติดตั้ง dependencies ของ comfyui-ollama"
    pip install -r "$CN_DIR/comfyui-ollama/requirements.txt"
  fi

  ok "ติดตั้ง custom node: comfyui-ollama เสร็จ ✅  (รีสตาร์ท ComfyUI เพื่อให้โหนดแสดงผล)"
else
  warn "ยังไม่พบโฟลเดอร์ ComfyUI หลังขั้นตอนนี้"
  if [[ "$AUTO_COMFY" -eq 1 ]]; then
    warn "สคริปต์ติดตั้ง ComfyUI อาจใช้ path อื่น—โปรดตรวจด้วยตนเอง แล้วรันส่วน comfyui-ollama อีกครั้ง"
  else
    echo "เมื่อติดตั้ง ComfyUI เสร็จ ให้รันสคริปต์นี้ซ้ำเพื่อเพิ่ม comfyui-ollama"
  fi
fi

# ---------- 8) Thai tips ----------
cat <<'TIP'

================= ตัวอย่างใช้งาน (ภาษาไทย) =================
[ทดสอบคุยกับ Mistral]
  echo "สรุปข่าว AI วันนี้ 5 บรรทัด" | ollama run mistral:latest

[ทดสอบ Qwen2.5-VL-7B อธิบายรูปเป็นพรอมต์]
  python - <<'PY'
import base64, requests, os
img = "/workspace/sample.jpg"  # เปลี่ยนเป็นรูปของคุณ
if not os.path.exists(img):
    print(">> โปรดเตรียมไฟล์รูปไว้ที่", img); raise SystemExit(0)
b64 = base64.b64encode(open(img,'rb').read()).decode()
payload = {"model":"qwen2.5vl:7b","prompt":"Describe this image as a cinematic prompt.","images":[b64],"stream":False}
r = requests.post("http://127.0.0.1:11434/api/generate", json=payload, timeout=600)
print("สถานะ:", r.status_code); print(r.text[:1200])
PY

[ดูโมเดลทั้งหมด]
  ollama list

[ดูบันทึก Ollama]
  tail -n 200 /workspace/ollama/ollama.log

[ComfyUI]
  - ถ้ารันอัตโนมัติแล้ว โฟลเดอร์มักอยู่ที่ ~/ComfyUI หรือ /workspace/ComfyUI
  - รีสตาร์ท ComfyUI เพื่อให้โหนด comfyui-ollama โผล่ใน UI
===========================================================

TIP

ok "เสร็จสิ้น 🎉  พร้อมใช้งาน Ollama + โมเดล + (ComfyUI อัตโนมัติสำหรับ RTX30/40/50) + comfyui-ollama"
