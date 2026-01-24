#!/usr/bin/env bash
# install.sh — Flash-Attention auto-installer for RunPod + ComfyUI (venv-aware)
# เป้าหมาย: เช็คเวอร์ชันทีละ step → สรุปสเปค → พยายามหา wheel ที่ match อัตโนมัติ → ถ้าไม่มีค่อย fallback ไป build จาก source
# English: Step-by-step version probe → pick matching prebuilt wheel if available → fallback to source build.

set -euo pipefail

# -----------------------------
# Pretty helpers
# -----------------------------
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_RED="\033[31m"
C_CYAN="\033[36m"

log()   { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
info()  { echo -e "${C_CYAN}[INFO]${C_RESET} $*"; }
warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
err()   { echo -e "${C_RED}[ERR]${C_RESET} $*"; }
die()   { err "$*"; exit 1; }

ask() {
  local prompt="$1"
  local default="${2:-}"
  local ans=""
  if [[ -n "$default" ]]; then
    read -r -p "$(echo -e "${C_BOLD}${prompt}${C_RESET} [default: ${default}] : ")" ans
    echo "${ans:-$default}"
  else
    read -r -p "$(echo -e "${C_BOLD}${prompt}${C_RESET} : ")" ans
    echo "$ans"
  fi
}

pause() {
  read -r -p "$(echo -e "${C_BOLD}Press Enter to continue...${C_RESET}")"
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

# -----------------------------
# 0) Basic requirements
# -----------------------------
info "Flash-Attention auto installer starting..."

if ! have_cmd python; then
  die "python not found in PATH. Activate your venv first: source /workspace/venv/bin/activate"
fi

PY_BIN="$(command -v python)"
info "Using python: ${PY_BIN}"

# Detect venv
VENV_PATH="${VIRTUAL_ENV:-}"
if [[ -z "$VENV_PATH" ]]; then
  warn "VIRTUAL_ENV is not set. You might NOT be inside a venv."
  warn "This script will still proceed, but it may install into system python."
  yn="$(ask "Continue anyway? (y/n)" "n")"
  [[ "$yn" == "y" || "$yn" == "Y" ]] || die "Aborted. Activate your ComfyUI venv first."
else
  log "Detected venv: ${VENV_PATH}"
fi

# Ensure pip works
python -m pip --version >/dev/null 2>&1 || die "pip not working. Try: python -m ensurepip --upgrade"

# -----------------------------
# 1) Probe versions (step-by-step)
# -----------------------------
info "Step 1/6: Probing Python version..."
PY_VER="$(python -c "import sys; print('{}.{}.{}'.format(*sys.version_info[:3]))")"
PY_CP="$(python -c "import sys; print(f'{sys.version_info[0]}{sys.version_info[1]}')")"  # e.g. 312
log "Python: ${PY_VER} (cp${PY_CP})"

pause

info "Step 2/6: Probing PyTorch + CUDA runtime + GPU..."
TORCH_PROBE="$(python - <<'PY'
import sys
try:
    import torch
except Exception as e:
    print("TORCH_IMPORT_ERROR:", repr(e))
    sys.exit(2)

torch_ver = torch.__version__
cuda_runtime = torch.version.cuda
cuda_ok = torch.cuda.is_available()
gpu_name = torch.cuda.get_device_name(0) if cuda_ok else "NO_GPU"
# ABI flag (important for wheel name)
try:
    abi = "TRUE" if getattr(torch._C, "_GLIBCXX_USE_CXX11_ABI", False) else "FALSE"
except Exception:
    abi = "TRUE"  # conservative default for most official CUDA wheels

print(torch_ver)
print(cuda_runtime if cuda_runtime else "None")
print("CUDA_AVAILABLE" if cuda_ok else "CUDA_NOT_AVAILABLE")
print(gpu_name)
print(abi)
PY
)" || true

if echo "$TORCH_PROBE" | grep -q "TORCH_IMPORT_ERROR"; then
  echo "$TORCH_PROBE"
  die "PyTorch import failed in this python. Install torch in this venv first."
fi

TORCH_VER="$(echo "$TORCH_PROBE" | sed -n '1p')"
TORCH_CUDA="$(echo "$TORCH_PROBE" | sed -n '2p')"
CUDA_AVAIL="$(echo "$TORCH_PROBE" | sed -n '3p')"
GPU_NAME="$(echo "$TORCH_PROBE" | sed -n '4p')"
CXX11_ABI="$(echo "$TORCH_PROBE" | sed -n '5p')"

log "Torch: ${TORCH_VER}"
log "Torch CUDA runtime: ${TORCH_CUDA}"
log "CUDA availability: ${CUDA_AVAIL}"
log "GPU: ${GPU_NAME}"
log "CXX11 ABI: ${CXX11_ABI}"

if [[ "$CUDA_AVAIL" != "CUDA_AVAILABLE" ]]; then
  warn "torch.cuda.is_available() is FALSE. Flash-Attention won't be useful without a CUDA GPU runtime."
fi

# Parse torch major.minor (2.7) from "2.7.0+cu126" etc.
TORCH_MM="$(python - <<PY
import re
s="${TORCH_VER}"
m = re.match(r"^(\d+)\.(\d+)", s)
print(f"{m.group(1)}.{m.group(2)}" if m else "")
PY
)"
[[ -n "$TORCH_MM" ]] || die "Cannot parse torch major.minor from: ${TORCH_VER}"

# Parse CUDA major from torch.version.cuda (e.g. 12.6 -> 12)
CUDA_MAJOR="$(python - <<PY
s="${TORCH_CUDA}"
if s in ("None", "", "null"):
    print("")
else:
    print(s.split(".")[0])
PY
)"
if [[ -z "$CUDA_MAJOR" ]]; then
  warn "torch.version.cuda is empty. Will still try source build fallback if needed."
fi

pause

info "Step 3/6: Probing CUDA Toolkit (nvcc)..."
if have_cmd nvcc; then
  NVCC_VER="$(nvcc --version | tail -n 1 || true)"
  log "nvcc found: ${NVCC_VER}"
else
  warn "nvcc not found. Prebuilt wheel may still work; source build will require nvcc."
fi

pause

# -----------------------------
# 2) Choose install mode
# -----------------------------
info "Step 4/6: Choosing installation mode..."
MODE="$(ask "Install mode: wheel / source / auto ?" "auto")"
MODE="$(echo "$MODE" | tr '[:upper:]' '[:lower:]')"
[[ "$MODE" == "wheel" || "$MODE" == "source" || "$MODE" == "auto" ]] || die "Invalid mode: ${MODE}"

# flash-attn version target
TARGET_VER="$(ask "Target flash-attn version (e.g. 2.8.3 or 'latest')" "latest")"
TARGET_VER="$(echo "$TARGET_VER" | tr '[:upper:]' '[:lower:]')"

pause

# -----------------------------
# 3) Prepare build deps (only if needed)
# -----------------------------
maybe_install_build_deps() {
  info "Installing build dependencies..."
  python -m pip install -U pip setuptools wheel packaging ninja >/dev/null
  if have_cmd apt-get; then
    if [[ "$(id -u)" -ne 0 ]] && have_cmd sudo; then
      sudo apt-get update
      sudo apt-get install -y build-essential python3-dev git ninja-build curl
    elif [[ "$(id -u)" -eq 0 ]]; then
      apt-get update
      apt-get install -y build-essential python3-dev git ninja-build curl
    else
      warn "No root/sudo. Skipping apt-get dependencies install. If build fails, install them manually."
    fi
  else
    warn "apt-get not found. Ensure build tools exist: gcc/g++, make, python headers, git, ninja, curl"
  fi
}

# -----------------------------
# 4) Find matching wheel from GitHub releases
# -----------------------------
GITHUB_REPO="Dao-AILab/flash-attention"

find_wheel_url() {
  local want_ver="$1"     # "latest" or "2.8.3"
  local cu_major="$2"     # "12"
  local torch_mm="$3"     # "2.7"
  local cp="$4"           # "312"
  local abi="$5"          # "TRUE"/"FALSE"

  [[ -n "$cu_major" ]] || return 1

  local needle="cu${cu_major}torch${torch_mm}cxx11abi${abi}-cp${cp}-cp${cp}-linux_x86_64.whl"
  info "Wheel match pattern: *${needle}"

  if ! have_cmd curl; then
    warn "curl not found; cannot query GitHub releases API."
    return 1
  fi

  # Use GitHub API. Parse JSON via python (no jq required).
  local api_url=""
  if [[ "$want_ver" == "latest" ]]; then
    api_url="https://api.github.com/repos/${GITHUB_REPO}/releases/latest"
  else
    # We'll fetch releases list and find matching tag vX.Y.Z
    api_url="https://api.github.com/repos/${GITHUB_REPO}/releases"
  fi

  local json
  json="$(curl -fsSL "$api_url" || true)"
  [[ -n "$json" ]] || return 1

  local url=""
  if [[ "$want_ver" == "latest" ]]; then
    url="$(python - <<PY
import json, sys
needle="${needle}"
data=json.loads(sys.stdin.read())
for a in data.get("assets", []):
    name=a.get("name","")
    if needle in name:
        print(a.get("browser_download_url",""))
        break
PY
<<<"$json")"
  else
    url="$(python - <<PY
import json, sys
needle="${needle}"
want_tag="v${want_ver}"
data=json.loads(sys.stdin.read())
# data is a list of releases
for rel in data:
    if rel.get("tag_name","").lower()==want_tag.lower():
        for a in rel.get("assets", []):
            name=a.get("name","")
            if needle in name:
                print(a.get("browser_download_url",""))
                sys.exit(0)
print("")
PY
<<<"$json")"
  fi

  if [[ -n "$url" ]]; then
    echo "$url"
    return 0
  fi

  return 1
}

install_from_wheel_url() {
  local url="$1"
  info "Installing from wheel URL:"
  echo "$url"
  python -m pip uninstall -y flash-attn >/dev/null 2>&1 || true
  python -m pip install -U "$url" --no-cache-dir
}

# -----------------------------
# 5) Build from source fallback
# -----------------------------
build_from_source() {
  info "Source build selected/fallback."
  if ! have_cmd nvcc; then
    die "nvcc not found. Source build requires CUDA Toolkit (nvcc). Install it first."
  fi
  maybe_install_build_deps

  local tmpdir
  tmpdir="$(mktemp -d)"
  info "Cloning flash-attention into: ${tmpdir}"
  git clone --depth 1 "https://github.com/${GITHUB_REPO}.git" "$tmpdir/flash-attention"
  pushd "$tmpdir/flash-attention" >/dev/null

  # MAX_JOBS can be tuned to reduce RAM usage
  local jobs
  jobs="$(ask "MAX_JOBS for build (lower if RAM is limited)" "8")"
  python -m pip uninstall -y flash-attn >/dev/null 2>&1 || true
  MAX_JOBS="$jobs" python -m pip install --no-build-isolation --no-cache-dir -v .

  popd >/dev/null
  rm -rf "$tmpdir"
}

# -----------------------------
# 6) Execute plan
# -----------------------------
info "Step 5/6: Installing flash-attn..."
info "Summary:"
echo "  python:        ${PY_VER} (cp${PY_CP})"
echo "  torch:         ${TORCH_VER} (mm=${TORCH_MM})"
echo "  torch cuda:    ${TORCH_CUDA} (major=${CUDA_MAJOR})"
echo "  cxx11 abi:     ${CXX11_ABI}"
echo "  gpu:           ${GPU_NAME}"
echo "  mode:          ${MODE}"
echo "  target ver:    ${TARGET_VER}"

if [[ "$MODE" == "source" ]]; then
  build_from_source
elif [[ "$MODE" == "wheel" ]]; then
  maybe_install_build_deps  # ensures curl is present; harmless for wheel installs
  if WHEEL_URL="$(find_wheel_url "$TARGET_VER" "$CUDA_MAJOR" "$TORCH_MM" "$PY_CP" "$CXX11_ABI")"; then
    install_from_wheel_url "$WHEEL_URL"
  else
    die "No matching wheel found for your environment. Try mode=auto or mode=source."
  fi
else
  # auto: try wheel first, fallback to source
  maybe_install_build_deps
  if WHEEL_URL="$(find_wheel_url "$TARGET_VER" "$CUDA_MAJOR" "$TORCH_MM" "$PY_CP" "$CXX11_ABI")"; then
    log "Found matching wheel."
    install_from_wheel_url "$WHEEL_URL"
  else
    warn "No matching wheel found. Falling back to source build..."
    build_from_source
  fi
fi

info "Step 6/6: Verifying installation..."
python - <<'PY'
import sys
try:
    import flash_attn
    import torch
    print("flash-attn OK:", flash_attn.__version__)
    print("torch:", torch.__version__)
    print("torch cuda:", torch.version.cuda)
    print("cuda available:", torch.cuda.is_available())
except Exception as e:
    print("VERIFY_FAILED:", repr(e))
    sys.exit(2)
PY

log "Done. Install completed successfully."
echo
echo "Tip: Always launch ComfyUI from the same venv you installed into."
