=== z-image model ===
```
export HF_HUB_ENABLE_HF_TRANSFER=1
pip install -U huggingface_hub hf_transfer
```


### Download z_image_turbo_bf16.safetensors
```
cd /workspace/ComfyUI/models/diffusion_models/

wget -O z_image_turbo_bf16.safetensors \
https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors
  ```

### Download VAE
  ```
cd /workspace/ComfyUI/models/vae/

wget -O zimage-vae.safetensors \
https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors
  ```

### text encoder
  ```
cd /workspace/ComfyUI/models/text_encoders/

wget -O qwen_3_4b.safetensors \
https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors
  ```
