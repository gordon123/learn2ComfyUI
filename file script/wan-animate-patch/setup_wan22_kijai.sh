# ⛳ สร้างไฟล์และรันทันที (ก๊อปทั้งบล็อกนี้ไปวางได้เลย)
cat > setup_wan22_kijai.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# ---------- paths ----------
COMFY_ROOT="/workspace/ComfyUI"
VENV_BIN="/workspace/venv/bin"
PY="$VENV_BIN/python"

DIFF_DIR="$COMFY_ROOT/models/diffusion_models"
LORA_DIR="$COMFY_ROOT/models/loras"
VAE_DIR="$COMFY_ROOT/models/vae"
WAS_CFG="$COMFY_ROOT/custom_nodes/was-ns/was_suite_config.json"

# ---------- helpers ----------
have() { command -v "$1" >/dev/null 2>&1; }

install_py() {
  # prefer uv if present, else pip
  if have uv; then
    uv pip install --upgrade "$@"
  else
    "$VENV_BIN/pip" install --upgrade "$@"
  fi
}

download() {
  # download <url> <outpath>
  local url="$1"; shift
  local out="$1"; shift
  mkdir -p "$(dirname "$out")"
  if have aria2c; then
    aria2c -x8 -s8 -o "$(basename "$out")" -d "$(dirname "$out")" --allow-overwrite=true "$url"
  elif have curl; then
    curl -L --retry 5 --retry-delay 2 -o "$out" "$url"
  else
    wget -O "$out" --tries=5 --timeout=30 "$url"
  fi
}

json_set_ffmpeg() {
  local ffmpeg_bin="$1"
  # create/config JSON even if jq ไม่มี โดยใช้ python
  "$PY" - "$WAS_CFG" "$ffmpeg_bin" << 'PYCODE'
import json, os, sys
cfg_path, ff = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(cfg_path):
    try:
        with open(cfg_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception:
        data = {}
data.setdefault("ffmpeg_bin_path", ff)
with open(cfg_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print(f"✅ wrote ffmpeg_bin_path = {ff} into {cfg_path}")
PYCODE
}

ascii_name() {
  # normalize Unicode dashes to ASCII '-' for filenames
  python - << 'PY'
import sys
s = sys.stdin.read()
s = s.replace('\u2013','-').replace('\u2014','-').replace('\u2011','-').replace('\u2212','-')
print(s, end='')
PY
}

# ---------- 0) activate venv ----------
if [ ! -x "$PY" ]; then
  echo "❌ Python in $VENV_BIN not found. Please create venv at /workspace/venv first."; exit 1
fi
source "/workspace/venv/bin/activate"

# ---------- 1) core python deps ----------
echo "==> Installing core deps (onnx, onnxruntime-gpu, opencv, numpy, scipy, onnxruntime-tools) ..."
install_py onnx onnxruntime-gpu onnxruntime-tools opencv-python-headless numpy scipy

# optional: SageAttention (ถ้าคอมไพล์ไม่ผ่าน ให้ข้าม)
if [ "${INSTALL_SAGEATTENTION:-0}" = "1" ]; then
  echo "==> Installing SageAttention (optional) ..."
  install_py sageattention || echo "⚠️  SageAttention install failed — skipping."
fi

# ---------- 2) fix WAS Node Suite: ffmpeg path ----------
echo "==> Configuring WAS Node Suite ffmpeg path ..."
if ! have ffmpeg; then
  echo "   ffmpeg not found. Installing system ffmpeg (apt) ..."
  sudo apt-get update -y && sudo apt-get install -y ffmpeg
fi
FFMPEG_BIN="$(command -v ffmpeg)"
mkdir -p "$(dirname "$WAS_CFG")"
json_set_ffmpeg "$FFMPEG_BIN"

# ---------- 3) make model dirs ----------
mkdir -p "$DIFF_DIR" "$LORA_DIR" "$VAE_DIR"

# ---------- 4) pick proper FP8 diffusion model (40xx => e4m3fn; 30xx => e5m2) ----------
GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n1 || true)"
echo "==> Detected GPU: ${GPU_NAME:-unknown}"

DIFF_URL=""
DIFF_OUT=""
if echo "$GPU_NAME" | grep -Eqi '4090|4080|4070|4060|RTX 40|L4|ADA'; then
  echo "   -> Using fp8_e4m3fn_scaled_KJ (best for 40xx/ADA)"
  DIFF_URL="https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"
  DIFF_OUT="$DIFF_DIR/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"
else
  echo "   -> Using fp8_e5m2_scaled_KJ (safer for 30xx/Turing/Ampere)"
  DIFF_URL="https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e5m2_scaled_KJ.safetensors"
  DIFF_OUT="$DIFF_DIR/Wan2_2-Animate-14B_fp8_e5m2_scaled_KJ.safetensors"
fi

if [ ! -f "$DIFF_OUT" ]; then
  echo "==> Download diffusion model ..."
  download "$DIFF_URL" "$DIFF_OUT"
else
  echo "   (skip) already exists: $DIFF_OUT"
fi

# ---------- 5) Download LoRAs ----------
echo "==> Download LoRAs ..."
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/WanAnimate_relight_lora_fp16.safetensors" \
         "$LORA_DIR/WanAnimate_relight_lora_fp16.safetensors"

download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank64_bf16.safetensors" \
         "$LORA_DIR/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank64_bf16.safetensors"

download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/FastWan/FastWan_T2V_14B_480p_lora_rank_128_bf16.safetensors" \
         "$LORA_DIR/FastWan_T2V_14B_480p_lora_rank_128_bf16.safetensors"

download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan22-Lightning/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors" \
         "$LORA_DIR/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors"

download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Pusa/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors" \
         "$LORA_DIR/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors"

FUN_NAME="$(printf '%s' 'Wan2.2-Fun-A14B-InP-LOW-HPS2.1_resized_dynamic_avg_rank_15_bf16.safetensors' | ascii_name)"
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan22_FunReward/Wan2.2-Fun-A14B-InP-LOW-HPS2.1_resized_dynamic_avg_rank_15_bf16.safetensors" \
         "$LORA_DIR/$FUN_NAME"

# ---------- 6) (optional) VAE files ifคุณยังไม่มี ----------
if [ ! -f "$VAE_DIR/Wan2_1_VAE_fp32.safetensors" ]; then
  echo "==> (optional) pulling Wan2_1_VAE_fp32 ..."
  download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/VAE/Wan2_1_VAE_fp32.safetensors" \
           "$VAE_DIR/Wan2_1_VAE_fp32.safetensors" || true
fi

# ---------- 7) Show versions ----------
echo "==> Python/Torch/CUDA/ONNX versions"
"$PY" - << 'PY'
import platform, torch, sys
print("🐍 Python:", platform.python_version())
print("🔥 Torch:", torch.__version__)
print("🎯 CUDA (PyTorch reports):", getattr(torch.version, "cuda", None))
print("✅ CUDA available:", torch.cuda.is_available())
print("🧠 GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "CPU")
try:
    import onnx, onnxruntime as ort, cv2, numpy, scipy
    print("🔷 onnx:", onnx.__version__)
    print("🟦 onnxruntime:", ort.__version__, "providers:", ort.get_available_providers())
    print("📦 opencv:", cv2.__version__)
except Exception as e:
    print("⚠️  import check error:", e)
try:
    import importlib.util
    print("🌿 SageAttention:", "installed" if importlib.util.find_spec("sageattention") else "NOT installed")
except Exception:
    pass
PY

# ---------- 8) Kill previous ComfyUI (if any) & run ----------
echo "==> Restarting ComfyUI ..."
pkill -f "python main.py" || true
exec "$PY" "$COMFY_ROOT/main.py" --listen
EOF

chmod +x setup_wan22_kijai.sh
./setup_wan22_kijai.sh
