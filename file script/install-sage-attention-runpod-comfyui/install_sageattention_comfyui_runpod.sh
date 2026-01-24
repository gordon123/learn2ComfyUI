#!/usr/bin/env bash
# install_sageattention_comfyui_runpod.sh
# Thai+EN: Step-by-step probe → install SageAttention for the CURRENT venv → verify.
# Modes:
#   - auto  : try PyPI first, fallback to source if needed
#   - pypi  : pip install sageattention (recommended for most users)
#   - source: build/install from thu-ml/SageAttention repo

set -euo pipefail

# ---------- pretty ----------
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

pause() { read -r -p "$(echo -e "${C_BOLD}Press Enter to continue...${C_RESET}")"; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

# ---------- 0) sanity ----------
info "SageAttention installer starting..."

if ! have_cmd python; then
  die "python not found. Activate your ComfyUI venv first: source /workspace/venv/bin/activate"
fi

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

# ---------- 1) probe versions ----------
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
print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "NO_GPU")
try:
    abi = "TRUE" if getattr(torch._C, "_GLIBCXX_USE_CXX11_ABI", False) else "FALSE"
except Exception:
    abi = "TRUE"
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
  warn "No CUDA GPU available in torch. SageAttention won't accelerate without CUDA."
fi
pause

info "Step 3/6: Checking Triton..."
TRITON_PROBE="$(python - <<'PY'
import sys
try:
    import triton
    print("TRITON_OK", triton.__version__)
except Exception as e:
    print("TRITON_MISSING", repr(e))
PY
)"
echo "$TRITON_PROBE" | grep -q "TRITON_OK" && log "$TRITON_PROBE" || warn "$TRITON_PROBE"
pause

info "Step 4/6: Checking nvcc (optional for SageAttention; needed for some source builds)..."
if have_cmd nvcc; then
  log "nvcc found: $(nvcc --version | tail -n 1 || true)"
else
  warn "nvcc not found. PyPI install usually still works (Triton JIT), but some source builds may require CUDA toolkit."
fi
pause

# ---------- 2) choose mode ----------
info "Step 5/6: Choosing install mode..."
MODE="$(ask "Install mode: pypi / source / auto ?" "auto")"
MODE="$(echo "$MODE" | tr '[:upper:]' '[:lower:]')"
[[ "$MODE" == "pypi" || "$MODE" == "source" || "$MODE" == "auto" ]] || die "Invalid mode: ${MODE}"

# version pin optional
PIN_VER="$(ask "Pin sageattention version? (e.g. 1.0.6) or leave blank for latest" "")"

# optional: triton preference
TRITON_MODE="$(ask "Triton mode: keep / upgrade / nightly (advanced) ?" "keep")"
TRITON_MODE="$(echo "$TRITON_MODE" | tr '[:upper:]' '[:lower:]')"
[[ "$TRITON_MODE" == "keep" || "$TRITON_MODE" == "upgrade" || "$TRITON_MODE" == "nightly" ]] || die "Invalid triton mode: ${TRITON_MODE}"

# ---------- 3) deps ----------
install_deps() {
  info "Installing base python build tools (safe)..."
  python -m pip install -U pip setuptools wheel packaging >/dev/null

  if have_cmd apt-get; then
    info "Installing OS deps (git/build-essential/python headers)..."
    if [[ "$(id -u)" -ne 0 ]] && have_cmd sudo; then
      sudo apt-get update
      sudo apt-get install -y git build-essential python3-dev
    elif [[ "$(id -u)" -eq 0 ]]; then
      apt-get update
      apt-get install -y git build-essential python3-dev
    else
      warn "No sudo/root. Skipping apt-get deps. If source build fails, install them manually."
    fi
  else
    warn "apt-get not found. Ensure git + compiler toolchain are installed if you use source mode."
  fi
}

maybe_adjust_triton() {
  case "$TRITON_MODE" in
    keep)
      info "Keeping current Triton (recommended)."
      ;;
    upgrade)
      info "Upgrading Triton to latest stable..."
      python -m pip install -U triton
      ;;
    nightly)
      warn "Installing triton-nightly (advanced; may break compatibility on some setups)."
      python -m pip install -U triton-nightly
      ;;
  esac
}

# ---------- 4) installers ----------
install_pypi() {
  info "Installing SageAttention from PyPI..."
  python -m pip uninstall -y sageattention >/dev/null 2>&1 || true
  maybe_adjust_triton

  if [[ -n "$PIN_VER" ]]; then
    python -m pip install -U "sageattention==${PIN_VER}"
  else
    python -m pip install -U sageattention
  fi
}

install_source() {
  info "Installing SageAttention from source (thu-ml/SageAttention)..."
  install_deps
  maybe_adjust_triton

  local tmpdir
  tmpdir="$(mktemp -d)"
  info "Cloning repo into: ${tmpdir}"
  git clone --depth 1 https://github.com/thu-ml/SageAttention.git "${tmpdir}/SageAttention"
  pushd "${tmpdir}/SageAttention" >/dev/null

  python -m pip uninstall -y sageattention >/dev/null 2>&1 || true
  # Many python packages build fine with normal pip install .
  python -m pip install --no-build-isolation --no-cache-dir -v .

  popd >/dev/null
  rm -rf "$tmpdir"
}

# ---------- 5) execute ----------
install_deps

if [[ "$MODE" == "pypi" ]]; then
  install_pypi
elif [[ "$MODE" == "source" ]]; then
  install_source
else
  # auto
  info "Auto mode: try PyPI first, fallback to source if needed..."
  if install_pypi; then
    log "PyPI install succeeded."
  else
    warn "PyPI install failed. Falling back to source build..."
    install_source
  fi
fi

# ---------- 6) verify ----------
info "Step 6/6: Verifying installation..."
python - <<'PY'
import sys
try:
    import sageattention
    from sageattention import sageattn
    import torch
    print("sageattention OK:", getattr(sageattention, "__version__", "unknown"))
    print("torch:", torch.__version__)
    print("torch cuda:", torch.version.cuda)
    print("cuda available:", torch.cuda.is_available())
    # quick smoke test (won't benchmark, just checks callable)
    if torch.cuda.is_available():
        # minimal tensors; only checks import/call path doesn't explode immediately
        q = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        k = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        v = torch.randn(1, 2, 8, 64, device="cuda", dtype=torch.float16)
        out = sageattn(q, k, v, tensor_layout="HND", is_causal=False, smooth_k=True)
        print("smoke test OK, out shape:", tuple(out.shape))
    else:
        print("smoke test skipped (no CUDA).")
except Exception as e:
    print("VERIFY_FAILED:", repr(e))
    sys.exit(2)
PY

log "Done. SageAttention installed for this venv."
echo "Tip: Always launch ComfyUI from the SAME venv you installed into."
