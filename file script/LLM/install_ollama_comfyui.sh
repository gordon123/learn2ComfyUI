#!/usr/bin/env bash
set -euo pipefail

# ================================
#  Install Ollama + models + (auto) ComfyUI + comfyui-ollama
#  Quiet mode: เอาท์พุตยาวๆ เก็บใน /workspace/setup.log
# ================================

LOG="/workspace/setup.log"
touch "$LOG"

msg(){  echo -e "\033[1;36m[ข้อมูล]\033[0m $*"; }
ok(){   echo -e "\033[1;32m[สำเร็จ]\033[0m $*"; }
warn(){ echo -e "\033[1;33m[เตือน]\033[0m $*"; }
err(){  echo -e "\033[1;31m[ผิดพลาด]\033[0m $*" >&2; }

# ---------- 0) venv ----------
VENV="/workspace/venv"
msg "ตรวจสอบ virtual environment: $VENV"
if [[ ! -d "$VENV" ]]; then
  msg "ไม่พบ venv → สร้างใหม่ (อาจใช้เวลานิดหน่อย)"
  if ! command -v python3 >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      DEBIAN_FRONTEND=noninteractive apt-get update -qq >>"$LOG" 2>&1
      DEBIAN_FRONTEND=noninteractive apt-get install -qq -y python3 python3-venv >>"$LOG" 2>&1
    else
      err "ไม่พบ python3 และไม่มี apt-get"; exit 1
    fi
  fi
  python3 -m venv "$VENV" >>"$LOG" 2>&1
  ok "สร้าง venv สำเร็จ"
fi
# shellcheck disable=SC1090
source "$VENV/bin/activate"
ok "เปิดใช้งาน venv แล้ว"

# ---------- 1) tools ----------
msg "ตรวจเครื่องมือพื้นฐาน (curl, git)"
if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive apt-get update -qq >>"$LOG" 2>&1
    command -v curl >/dev/null 2>&1 || DEBIAN_FRONTEND=noninteractive apt-get install -qq -y curl >>"$LOG" 2>&1
    command -v git  >/dev/null 2>&1 || DEBIAN_FRONTEND=noninteractive apt-get install -qq -y git  >>"$LOG" 2>&1
  else
    err "ไม่มี apt-get เพื่อติดตั้ง curl/git"; exit 1
  fi
fi
ok "พร้อมใช้งาน curl + git"

# ---------- 2) Ollama env ----------
OLLAMA_DIR="/workspace/ollama"
msg "ตั้งค่าโฟลเดอร์โมเดล Ollama: $OLLAMA_DIR"
mkdir -p "$OLLAMA_DIR"
export OLLAMA_MODELS="$OLLAMA_DIR"
export OLLAMA_LLM_LIBRARY="cublas"
export OLLAMA_FLASH_ATTENTION="1"
grep -q 'export OLLAMA_MODELS=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_MODELS=$OLLAMA_DIR" >> ~/.bashrc
grep -q 'export OLLAMA_LLM_LIBRARY=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_LLM_LIBRARY=cublas" >> ~/.bashrc
grep -q 'export OLLAMA_FLASH_ATTENTION=' ~/.bashrc 2>/dev/null || echo "export OLLAMA_FLASH_ATTENTION=1" >> ~/.bashrc

# ---------- 3) Install Ollama ----------
msg "ติดตั้ง Ollama (โหมดเงียบ)"
if command -v sudo >/dev/null 2>&1; then
  curl -fsSL https://ollama.com/install.sh | sudo sh >>"$LOG" 2>&1
else
  curl -fsSL https://ollama.com/install.sh | sh >>"$LOG" 2>&1
fi
ok "Ollama: $(ollama --version 2>/dev/null || echo unknown)"

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
msg "ดึงโมเดล: qwen2.5vl:7b และ mistral:latest (ซ่อนเอาต์พุต)"
ollama pull qwen2.5vl:7b >>"$LOG" 2>&1 || warn "pull qwen2.5vl:7b ไม่สำเร็จ (ดู $LOG)"
ollama pull mistral:latest >>"$LOG" 2>&1 || warn "pull mistral:latest ไม่สำเร็จ (ดู $LOG)"
ok "ขั้นตอนโมเดลเสร็จ"

# ---------- 6) Install ComfyUI (auto for RTX30/40/50) ----------
GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo 'UNKNOWN')"
msg "ตรวจพบ GPU: $GPU_NAME"
AUTO_COMFY=0
DL_DIR="/workspace"

if [[ "$GPU_NAME" == *"RTX 30"* || "$GPU_NAME" == *"RTX 40"* ]]; then
  msg "ดาวน์โหลด + รันสคริปต์ ComfyUI (RTX30/40)"
  curl -fsSL -o "$DL_DIR/install_comfyui_rtx30_40.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx30_40.sh"
  chmod +x "$DL_DIR/install_comfyui_rtx30_40.sh"
  bash "$DL_DIR/install_comfyui_rtx30_40.sh" >>"$LOG" 2>&1
  AUTO_COMFY=1
elif [[ "$GPU_NAME" == *"RTX 50"* ]]; then
  msg "ดาวน์โหลด + รันสคริปต์ ComfyUI (RTX50)"
  curl -fsSL -o "$DL_DIR/install_comfyui_rtx50.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx50.sh"
  chmod +x "$DL_DIR/install_comfyui_rtx50.sh"
  bash "$DL_DIR/install_comfyui_rtx50.sh" >>"$LOG" 2>&1
  AUTO_COMFY=1
else
  warn "ไม่ใช่ RTX30/40/50 → ข้ามการติดตั้ง ComfyUI อัตโนมัติ"
  curl -fsSL -o "$DL_DIR/install_comfyui_rtx30_40.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx30_40.sh" >>"$LOG" 2>&1 || true
  curl -fsSL -o "$DL_DIR/install_comfyui_rtx50.sh" \
    "https://raw.githubusercontent.com/gordon123/learn2ComfyUI/refs/heads/main/file%20script/install_rtx50.sh" >>"$LOG" 2>&1 || true
  echo "→ ถ้าจะติดตั้ง ComfyUI ทีหลัง: ดูไฟล์ที่ $DL_DIR/install_comfyui_rtx30_40.sh หรือ $DL_DIR/install_comfyui_rtx50.sh"
fi

# ---------- 7) comfyui-ollama custom node ----------
COMFY_DIR=""
for d in "/workspace/ComfyUI" "$HOME/ComfyUI" "/opt/ComfyUI"; do
  [[ -d "$d" ]] && COMFY_DIR="$d" && break
done

if [[ -n "$COMFY_DIR" ]]; then
  ok "พบ ComfyUI ที่: $COMFY_DIR"
  # ใช้ venv ของ ComfyUI ถ้ามี
  if [[ -f "$COMFY_DIR/venv/bin/activate" ]]; then
    # shellcheck disable=SC1090
    source "$COMFY_DIR/venv/bin/activate"
  fi
  CN="$COMFY_DIR/custom_nodes"
  mkdir -p "$CN"
  if [[ -d "$CN/comfyui-ollama" ]]; then
    msg "อัปเดต comfyui-ollama (quiet)"
    git -C "$CN/comfyui-ollama" pull --quiet >>"$LOG" 2>&1 || true
  else
    msg "ติดตั้ง comfyui-ollama (quiet)"
    git clone --quiet https://github.com/stavsap/comfyui-ollama "$CN/comfyui-ollama" >>"$LOG" 2>&1
  fi
  if [[ -f "$CN/comfyui-ollama/requirements.txt" ]]; then
    pip install -q --progress-bar off -r "$CN/comfyui-ollama/requirements.txt" >>"$LOG" 2>&1 || true
  fi
  ok "ติดตั้ง custom node เสร็จ ✅  (โปรดรีสตาร์ท ComfyUI)"
else
  warn "ยังไม่พบโฟลเดอร์ ComfyUI หลังการติดตั้งอัตโนมัติ (ดู $LOG หากสงสัย)"
fi

# ---------- 8) Tips ----------
cat <<'TIP'

================ วิธีทดสอบแบบเงียบ (ไทย) ================
[คุยกับ Mistral]
  echo "สรุปข่าว AI วันนี้ 5 บรรทัด" | ollama run mistral:latest

[Qwen2.5-VL-7B อธิบายรูปเป็นพรอมต์]
  python - <<'PY'
import base64,requests,os
img="/workspace/sample.jpg"   # เปลี่ยนเป็นรูปของคุณ
if not os.path.exists(img): print(">> ใส่รูปไว้ที่",img); raise SystemExit
b64=base64.b64encode(open(img,'rb').read()).decode()
payload={"model":"qwen2.5vl:7b","prompt":"Describe this image as a cinematic prompt.","images":[b64],"stream":False}
r=requests.post("http://127.0.0.1:11434/api/generate",json=payload,timeout=600)
print("สถานะ:",r.status_code); print(r.text[:1000])
PY

[ดูโมเดล / ดูบันทึก]
  ollama list
  tail -n 200 /workspace/ollama/ollama.log
  tail -n 200 /workspace/setup.log
===========================================================
TIP

ok "เสร็จสิ้น 🎉  (log อยู่ที่ $LOG)"
