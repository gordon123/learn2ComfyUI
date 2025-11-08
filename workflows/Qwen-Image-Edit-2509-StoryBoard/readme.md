-- DRAFT --

ComfyUI Impact Pack

ComfyUI_LayerStyle

ComfyUI-GGUF

ComfyUI-Easy-Use

ComfyUI-KJNodes

rgthree-comfy

ComfyUI-nunchaku

https://huggingface.co/mit-han-lab/nunchaku/tree/main

download Whl Pythorch, Python, linux version!

pip install .....

ComfyUI-QwenImageLoraLoader

ComfyUI-Jjk-Nodes

ComfyUI_SKBundle

https://github.com/ussoewwin/ComfyUI-QwenImageLoraLoader

https://huggingface.co/nunchaku-tech

https://huggingface.co/mit-han-lab/nunchaku/resolve/main/nunchaku-0.3.1%2Btorch2.7-cp312-cp312-linux_x86_64.whl

https://github.com/nunchaku-tech/nunchaku

https://github.com/obisin/ComfyUI-FSampler

root@5d88e245d1e9:/# git clone https://github.com/gordon123/ComfyUI_StringOps-en.git
cd ComfyUI_StringOps-en/

source /workspace/vnev/bin/activate
pip install -r requirements.txt 


ComfyUI-ShellAgent-Plugin



https://huggingface.co/lightx2v/Qwen-Image-Lightning/tree/main/Qwen-Image-Edit-2509

https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors

Lora

https://huggingface.co/lightx2v/Qwen-Image-Lightning/tree/main/Qwen-Image-Edit-2509

https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-2509/Qwen-Image-Edit-2509-Lightning-8steps-V1.0-bf16.safetensors

https://huggingface.co/lovis93/next-scene-qwen-image-lora-2509

https://huggingface.co/dx8152/Fusion_lora


### Nunchaku

wget https://huggingface.co/nunchaku-tech/nunchaku-qwen-image-edit-2509/resolve/main/svdq-int4_r128-qwen-image-edit-2509-lightningv2.0-8steps.safetensors

https://huggingface.co/nunchaku-tech/nunchaku-qwen-image-edit-2509/resolve/main/svdq-int4_r128-qwen-image-edit-2509-lightningv2.0-8steps.safetensors

https://huggingface.co/QuantStack/Qwen-Image-Edit-2509-GGUF

https://huggingface.co/QuantStack/Qwen-Image-Edit-2509-GGUF/resolve/main/Qwen-Image-Edit-2509-Q4_K_M.gguf


https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors

https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors



# เข้า env เดิม (ถ้าใช้ venv)

source /workspace/venv/bin/activate 2>/dev/null || true


# ติดตั้งตัวเร่งดาวน์โหลด

pip install -U huggingface_hub hf_transfer

pip install -U "huggingface_hub>=0.34,<1.0" hf_transfer==0.1.9


# (ไม่บังคับ) ทดสอบว่าพร้อมยัง

python - << 'PY'

from huggingface_hub.utils import is_hf_transfer_available

print("hf_transfer available:", is_hf_transfer_available())

PY

# รีสตาร์ท ComfyUI

pkill -f "main.py" 2>/dev/null || true

python /workspace/ComfyUI/main.py --listen

Positive prompt
Dissolving the image, Correct perspective, lighting, shadows, and depth ensure your images blend seamlessly with the background, creating stunning visuals.


Negative prompt
色调艳丽，过曝，静态，细节模糊不清，字幕，风格，作品，画作，画面，静止，整体发灰，最差质量，低质量，JPEG压缩残留，丑陋的，残缺的，多余的手指，画得不好的手部，画得不好的脸部，畸形的，毁容的，形态畸形的肢体，手指融合，静止不动的画面，杂乱的背景，三条腿，背景人很多，倒着走



