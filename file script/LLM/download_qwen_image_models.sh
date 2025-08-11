# save as: /workspace/download_qwen_image_models.sh
#!/usr/bin/env bash
set -Eeuo pipefail
[ -n "${BASH_VERSION:-}" ] || exec bash "$0" "$@"

say() { printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }

ROOT="/workspace/ComfyUI/models"
VAE_DIR="${ROOT}/vae"
TE_DIR="${ROOT}/text_encoders"
DM_DIR="${ROOT}/diffusion_models"
LORA_DIR="${ROOT}/loras"

# สร้างโฟลเดอร์ปลายทาง
mkdir -p "$VAE_DIR" "$TE_DIR" "$DM_DIR" "$LORA_DIR"

# ฟังก์ชันดาวน์โหลดแบบทนถึก: resume + retry + fail fast
dl() {
  local url="$1" dest="$2"
  say "Downloading -> ${dest}"
  curl -fL --retry 5 --retry-delay 2 --continue-at - -o "${dest}.part" "$url"
  mv -f "${dest}.part" "$dest"
}

# --- VAE ---
dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" \
   "${VAE_DIR}/qwen_image_vae.safetensors"

# --- Text Encoders ---
dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" \
   "${TE_DIR}/qwen_2.5_vl_7b_fp8_scaled.safetensors"

# --- Diffusion Models ---
dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors" \
   "${DM_DIR}/qwen_image_fp8_e4m3fn.safetensors"

dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_bf16.safetensors" \
   "${DM_DIR}/qwen_image_bf16.safetensors"

# --- Loras ---
dl "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors" \
   "${LORA_DIR}/Qwen-Image-Lightning-4steps-V1.0.safetensors"

say "All done. Summary:"
ls -lh "$VAE_DIR" "$TE_DIR" "$DM_DIR" "$LORA_DIR" || true
