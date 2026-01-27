ใช้ Custom node จาก https://github.com/1038lab/ComfyUI-QwenTTS

Fix error hugginface transfer
```
pip install -U hf_transfer
pip uninstall -y huggingface_hub
pip install "huggingface-hub[cli]>=0.34,<1.0"
export HF_HUB_ENABLE_HF_TRANSFER=1
echo 'export HF_HUB_ENABLE_HF_TRANSFER=1' >> ~/.bashrc
python -c "import huggingface_hub, hf_transfer; print(huggingface_hub.__version__)"
```

Download Models
```
huggingface-cli download Qwen/Qwen3-TTS-Tokenizer-12Hz \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-Tokenizer-12Hz

huggingface-cli download Qwen/Qwen3-TTS-12Hz-1.7B-Base \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-12Hz-1.7B-Base

huggingface-cli download Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-12Hz-1.7B-CustomVoice

huggingface-cli download Qwen/Qwen3-TTS-12Hz-1.7B-VoiceDesign \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-12Hz-1.7B-VoiceDesign

huggingface-cli download Qwen/Qwen3-TTS-12Hz-0.6B-Base \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-12Hz-0.6B-Base

huggingface-cli download Qwen/Qwen3-TTS-12Hz-0.6B-CustomVoice \
  --local-dir /workspace/ComfyUI/models/TTS/Qwen3-TTS/Qwen3-TTS-12Hz-0.6B-CustomVoice

```

## ตัวอย่าง จาก ChatGPT ที่มันให้ แก้ไข เรื่อง version torch ไม่ตรง
```
pip uninstall -y torch torchvision torchaudio

# ติดตั้งให้เป็นชุดเดียวกัน (cu126)
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0
```

