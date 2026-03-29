## ==== Workflow และ download โมเดล ต่าง ๆ สำหรับ LTX2.3====

Runpod template สำหรับ Cuda13 เพื่อใช้ การ์ดจอ RTX50xx <br>
Runpod template ชื่อ iimate24_cuda13 https://console.runpod.io/deploy?template=3morvvn62r&ref=c0v5p0ys

https://blog.comfy.org/p/ltx-23-day-0-supporte-in-comfyui

https://huggingface.co/RuneXX/LTX-2.3-Workflows/tree/main

https://github.com/Lightricks/ComfyUI-LTXVideo/tree/master/example_workflows/2.3

https://huggingface.co/Kijai/MelBandRoFormer_comfy

https://huggingface.co/QuantStack/LTX-2.3-GGUF/tree/main/LTX-2.3-distilled

https://huggingface.co/mradermacher/gemma-3-12b-it-qat-q4_0-unquantized-GGUF/tree/main

### checkpoints
```
cd ComfyUI/models/checkpoints/
wget -O ltx-2.3-22b-dev-fp8.safetensors \
https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors

# หรือตัวเต็ม
# wget -O ltx-2.3-22b-dev.safetensors \
# https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-dev.safetensors
```

### Kijai diffusion model
```
cd ComfyUI/models/diffusion_models/
wget -O ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors \
https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors
```

### loras
```
cd /workspace/ComfyUI/models/loras/
# 1) LTX distilled LoRA
wget -c -O ltx-2.3-22b-distilled-lora-384.safetensors \
https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-distilled-lora-384.safetensors
# 2) Gemma LoRA
wget -c -O gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors \
https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors
```

### latent_upscale_models
```
cd /workspace/ComfyUI/models/latent_upscale_models/
wget -c -O ltx-2.3-spatial-upscaler-x2-1.0.safetensors \
https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
```

### text encoder
```
cd /workspace/ComfyUI/models/text_encoders/
# 1) gemma text encoder (fp4)
wget -c -O gemma_3_12B_it_fp4_mixed.safetensors \
https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
# 2) ltx text projection
wget -c -O ltx-2.3_text_projection_bf16.safetensors \
https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
```

### VAE
```
cd /workspace/ComfyUI/models/vae/

# 1) Video VAE
wget -c --tries=10 --timeout=60 -O LTX23_video_vae_bf16.safetensors \
https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors

# 2) Audio VAE
wget -c --tries=10 --timeout=60 -O LTX23_audio_vae_bf16.safetensors \
https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors

# 3) TAELTX VAE
wget -c --tries=10 --timeout=60 -O taeltx2_3.safetensors \
https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/taeltx2_3.safetensors
```

### Extra

cd /workspace/ComfyUI/models/vae_approx/
```
# โหลดตัว Decoder
wget https://github.com/madebyollin/taesd/raw/main/taesd_decoder.pth

# โหลดตัว Encoder
wget https://github.com/madebyollin/taesd/raw/main/taesd_encoder.pth
```

### Custom node ที่ ต้อง install เอง ไม่มีใน Custom manager

https://github.com/gordon123/ComfyUI-SoundFlow
```
cd /workspace/ComfyUI/custom_nodes/

git clone https://github.com/gordon123/ComfyUI-SoundFlow.git

ComfyUI-SoundFlow

pip install -r requirements.txt

apt update && apt install -y ffmpeg

pip install torchcodec
```




