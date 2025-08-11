#!/usr/bin/env bash
set -Eeuo pipefail
[ -n "${BASH_VERSION:-}" ] || exec bash "$0" "$@"

echo "=============================="
echo "Start: venv -> download GPU installer -> install ComfyUI -> Ollama -> comfyui-ollama"
echo "=============================="

WORKDIR="/workspace"
VENVDIR="${WORKDIR}/venv"
COMFY_DIR="${WORKDIR}/ComfyUI"
LOG_DIR="${WORKDIR}/logs"
OLLAMA_DIR="${WORKDIR}/ollama"
mkdir -p "${LOG_DIR}" "${OLLAMA_DIR}"
OLLAMA_LOG="${LOG_DIR}/ollama.log"

export OLLAMA_MODELS="${OLLAMA_DIR}"
export OLLAMA_HOST="127.0.0.1:11434"

say() { printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1"; exit 1; }; }

cd "${WORKDIR}" || exit 1

# ---------- Pre-flight ----------
need_cmd python3
need_cmd git
need_cmd curl

# ---------- 1) Create & activate venv ----------
if [ ! -d "${VENVDIR}" ]; then
  say "Creating virtual environment at ${VENVDIR}"
  python3 -m venv "${VENVDIR}"
else
  say "Found existing venv at ${VENVDIR}"
fi
source "${VENVDIR}/bin/activate"
python -V
pip -V
pip install --upgrade pip wheel setuptools

# ---------- 2) Download installer scripts ----------
RTX30_40_URL="https://raw.githubusercontent.com/gordon123/learn2ComfyUI/main/file%20script/install_rtx30_40.sh"
RTX50_URL="https://raw.githubusercontent.com/gordon123/learn2ComfyUI/main/file%20script/install_rtx50.sh"
INSTALLER_30_40="${WORKDIR}/install_rtx30_40.sh"
INSTALLER_50="${WORKDIR}/install_rtx50.sh"

say "Downloading RTX 30/40 installer..."
curl -fsSL "$RTX30_40_URL" -o "$INSTALLER_30_40"
chmod +x "$INSTALLER_30_40"

say "Downloading RTX 50 installer..."
curl -fsSL "$RTX50_URL" -o "$INSTALLER_50"
chmod +x "$INSTALLER_50"

# ---------- 3) Detect GPU ----------
GPU_NAME="$( (nvidia-smi --query-gpu=name --format=csv,noheader | head -n1) 2>/dev/null || echo "Unknown" )"
say "GPU detected: ${GPU_NAME}"

is_rtx50=0
shopt -s nocasematch
if [[ "${GPU_NAME}" =~ (RTX[[:space:]]*50|5090|5080|5070|5060) ]]; then
  is_rtx50=1
fi
shopt -u nocasematch

# ---------- 4) Install ComfyUI + Custom Manager ----------
if [ ${is_rtx50} -eq 1 ]; then
  say "Using RTX 50 installer"
  bash -xe "${INSTALLER_50}"
else
  say "Using RTX 30/40 installer"
  bash -xe "${INSTALLER_30_40}"
fi

# ---------- 5) Install Ollama ----------
say "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

say "Starting ollama serve in background..."
if ! pgrep -x ollama >/dev/null 2>&1; then
  (nohup env OLLAMA_MODELS="${OLLAMA_DIR}" OLLAMA_HOST="${OLLAMA_HOST}" ollama serve >"${OLLAMA_LOG}" 2>&1 &) || true
fi

say "Waiting for Ollama API..."
for i in $(seq 1 40); do
  if curl -fsS "http://${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
    say "Ollama is up"
    break
  fi
  sleep 1
done

# ---------- 6) Install comfyui-ollama ----------
say "Installing comfyui-ollama custom node..."
NODE_DIR="${COMFY_DIR}/custom_nodes/comfyui-ollama"
if [ ! -d "${NODE_DIR}" ]; then
  git clone https://github.com/stavsap/comfyui-ollama "${NODE_DIR}" || true
else
  (cd "${NODE_DIR}" && git pull --ff-only || true)
fi
if [ -f "${NODE_DIR}/requirements.txt" ]; then
  pip install -r "${NODE_DIR}/requirements.txt"
fi

# ---------- 7) Done ----------
cat <<TXT

✅ Installation Complete

Activate venv:
  source "${VENVDIR}/bin/activate"

Run ComfyUI:
  cd "${COMFY_DIR}"
  python main.py --listen 0.0.0.0 --port 8188

Test Ollama:
  ollama run mistral:latest
TXT
