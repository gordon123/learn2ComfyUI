In this folder is my script for Jupyter to setup on [Runpod.io](https://runpod.io?ref=c0v5p0ys)  for comfyUI and here are FLUX collection download link

```
nvidia-smi
```

```
python --version
which python
pip --version

python - <<'PY'
import sys
print("python:", sys.version)
print("executable:", sys.executable)
PY
```

```
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda build:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device count:", torch.cuda.device_count())

x = torch.zeros(1, device="cuda")
print("cuda tensor:", x)
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))
PY
```
