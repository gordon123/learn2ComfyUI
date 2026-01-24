#!/usr/bin/env bash
# forge_sageattention_all_gpus.sh
# Install SageAttention for ComfyUI venv — supports (best-effort) ALL NVIDIA CUDA GPUs.
# Strategy:
#   1) If nvcc (CUDA Toolkit) exists -> install from official source (SageAttention2/2++ + kernels + SA3 code present in repo)
#   2) If nvcc missing -> fallback to SageAttention v1 (Triton) from PyPI (sageattention==1.0.6)
#
# Notes:
# - Official repo: install from source is the most reliable now because sageattention==2.2.0 was removed from PyPI. :contentReference[oaicite:2]{index=2}
# - Repo includes SageAttention, SageAttention2, SageAttention2++, and SageAttention3 code (Blackwell folder). :contentReference[oaicite:3]{index=3}

set -euo pipefail

# -------- pretty --------
C_RESET="\033[0m"; C_BOLD="\033[1m"
C_GREEN="\033[32m"; C_YELLOW="\033[33m"; C_RED="\033[31m"; C_CYAN="\033[36m"
log()  { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
info() { echo -e "${C_CYAN}[INFO]${C_RESET} $*"; }
warn() { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
err()  { echo -e "${C_RED}[ERR]${C_RESET} $*"; }
die()  { err "$*"; exit 1; }
have_cmd(){ command -v "$1" >/dev/null 2>&1; }

ask() {
  local prompt="$1"; local default="${2:-}"; local ans=""
  if [[ -n "$default" ]]; then
    read -r -p "$(echo -e "${C_BOLD}${prompt}${C_RESET} [default: ${default}] : ")" ans
    echo "${ans:-$default}"
  else
    read -r -p "$(echo -e "${C_BOLD}${prompt}${C_RESET} : ")" ans
    echo "$ans"
  fi
}
pause(){ read -r -p "$(echo -e "${C_BOLD}Press Enter to continue...${C_RESET}")"; }

# -------- 0) venv sanity --------
info "SageAttention (All NVIDIA GPUs) installer starting..."

have_cmd python || die "python not found. Activate your ComfyUI venv first: source /workspace/venv/bin/activate"
PY_BIN="$(command -v python)"
info "Using python: ${PY_BIN}"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
  warn "VIRTUAL_ENV is not set. You might NOT be in a venv."
  yn="$(ask "Continue anyway? (y/n)" "n")"
  [[ "$yn" =~ ^[Yy]$ ]] || die "Aborted. Activate your ComfyUI venv first."
else
  log "Detected venv: ${VIRTUAL_ENV}"
fi

python -m pip --version >/dev/null 2>&1 || die "pip not working. Try: python -m ensurepip --upgrade"

# -------- 1) Probe versions (step-by-step) --------
info "Step 1/6: Probing Python..."
PY_VER="$(python -c "import sys; print('{}.{}.{}'.format(*sys.version_info[:3]))")"
log "Python: ${PY_VER}"
pause

info "Step 2/6: Probing PyTorch + CUDA runtime + GPU..."
TORCH_PROBE="$(python - <<'PY'
import sys
try:
    import torch
except Exception as e:
    print("TORCH_IMPORT_ERROR:", repr(e))
    sys.exit(2)

print(torch.__version__)
print(torch.version.cuda or "None")
print("CUDA_AVAILABLE" if torch.cuda.is_available() else "CUDA_NOT_AVAILABLE")
if torch.cuda.is_available():
    print(torch.cuda.get_device_name(0))
    print("CC", ".".join(map(str, torch.cuda.get_device_capability(0))))
else:
    print("NO_GPU")
    print("CC", "None")
try:
    abi = "TRUE" if getattr(torch._C, "_GLIBCXX_USE_CXX11_ABI", False) else "FALSE"
except Exception:
    abi = "TRUE"
print("CXX11_ABI", abi)
PY
)" || true

if echo "$TORCH_PROBE" | grep -q "TORCH_IMPORT_ERROR"; then
  echo "$TORCH_PROBE"
  die "PyTorch import failed in this python. Install torch in this venv first."
fi

echo "$TORCH_PROBE"
TORCH_VER="$(echo "$TORCH_PROBE" | sed -n '1p')"
TORCH_CUDA="$(echo "$TORCH_PROBE" | sed -n '2p')"
CUDA_AVAIL="$(echo "$TORCH_PROBE" | sed -n '3p')"
GPU_NAME="$(echo "$TORCH_PROBE" | sed -n '4p')"
GPU_CC="$(echo "$TORCH_PROBE" | sed -n '5p' | sed 's/^CC //')"
CXX11_ABI="$(echo "$TORCH_PROBE" | sed -n '6p' | sed 's/^CXX11_ABI //')"

if [[ "$CUDA_AVAIL" != "CUDA_AVAILABLE" ]]; then
  die "torch.cuda.is_available() is FALSE. SageAttention needs an NVIDIA CUDA GPU runtime in this environment."
fi

log "Torch: ${TORCH_VER} | Torch CUDA: ${TORCH_CUDA} | GPU: ${GPU_NAME} | CC: ${GPU_CC} | CXX11 ABI: ${CXX11_ABI}"
pause

info "Step 3/6: Checking Triton (required by SageAttention)..."
TRITON_PROBE="$(python - <<'PY'
try:
    import triton
    print("TRITON_OK", triton.__version__)
except Exception as e:
    print("TRITON_MISSING", repr(e))
PY
)"
echo "$TRITON_PROBE" | grep -q "TRITON_OK" && log "$TRITON_PROBE" || warn "$TRITON_PROBE"
pause

info "Step 4/6: Checking CUDA Toolkit (nvcc)..."
if have_cmd nvcc; then
  log "nvcc found: $(nvcc --version | tail -n 1 || true)"
  HAS_NVCC="yes"
else
  warn "nvcc not found. We'll fallback to SageAttention v1 (Triton) from PyPI (1.0.6)."
  HAS_NVCC="no"
fi
pause

# -------- 2) Install deps --------
install_os_deps() {
  if ! have_cmd apt-get; then
    warn "apt-get not found. Skipping OS deps. Ensure git + build toolchain + python headers are present if source build is used."
    return 0
  fi
  if [[ "$(id -u)" -eq 0 ]]; then
    apt-get update
    apt-get install -y git build-essential python3-dev curl
  elif have_cmd sudo; then
    sudo apt-get update
    sudo apt-get install -y git build-essential python3-dev curl
  else
    warn "No sudo/root. Skipping apt-get deps."
  fi
}

install_py_deps() {
  python -m pip install -U pip setuptools wheel packaging >/dev/null
  # Triton must exist (repo requires triton>=3.0.0). :contentReference[oaicite:4]{index=4}
  if ! python -c "import triton" >/dev/null 2>&1; then
    info "Installing triton..."
    python -m pip install -U triton
  fi
}

info "Step 5/6: Installing prerequisites..."
install_os_deps
install_py_deps
log "Prerequisites OK."
pause

# -------- 3) Install SageAttention (best-effort for all NVIDIA GPUs) --------
install_from_source_official() {
  info "Installing SageAttention from official source repo (recommended for broad GPU support)..."
  local jobs
  jobs="$(ask "MAX_JOBS for build (lower if RAM is limited)" "4")"

  # Optional env flags recommended by repo (safe defaults)
  export EXT_PARALLEL="${EXT_PARALLEL:-4}"
  export NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS:---threads 8}"
  export MAX_JOBS="${jobs}"

  # Install from git (pep517 off sometimes helps legacy setups; we keep default pip behavior here)
  python -m pip uninstall -y sageattention >/dev/null 2>&1 || true

  # Use repo root. This is the most reliable path now. :contentReference[oaicite:5]{index=5}
  python -m pip install --no-build-isolation --no-cache-dir -v "git+https://github.com/thu-ml/SageAttention.git"
}

install_v1_pypi_triton() {
  info "Installing SageAttention v1 (Triton) from PyPI (fallback)..."
  python -m pip uninstall -y sageattention >/dev/null 2>&1 || true
  # Official repo notes v1 is in SageAttention-1 branch and available as pip==1.0.6. :contentReference[oaicite:6]{index=6}
  python -m pip install -U --no-cache-dir "sageattention==1.0.6"
}

# Decide path
if [[ "$HAS_NVCC" == "yes" ]]; then
  install_from_source_official || {
    warn "Source install failed. Falling back to v1 (Triton) from PyPI..."
    install_v1_pypi_triton
  }
else
  install_v1_pypi_triton
fi

# -------- 4) Verify --------
info "Step 6/6: Verifying installation..."
python - <<'PY'
import sys
try:
    import torch
    import sageattention
    from sageattention import sageattn
    print("sageattention OK:", getattr(sageattention, "__version__", "unknown"))
    print("torch:", torch.__version__)
    print("cuda available:", torch.cuda.is_available(), "| torch cuda:", torch.version.cuda)

    if torch.cuda.is_available():
        # Smoke test: tiny tensors, just ensure the callable path works.
        q = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        k = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        v = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        out = sageattn(q, k, v, tensor_layout="HND", is_causal=False)
        print("smoke test OK, out shape:", tuple(out.shape))
    else:
        print("smoke test skipped (no CUDA).")
except Exception as e:
    print("VERIFY_FAILED:", repr(e))
    sys.exit(2)
PY

log "Done. SageAttention installed into THIS venv."
echo "Tip: Always launch ComfyUI from the same venv."
