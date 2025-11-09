-- DRAFT --


[![Watch on YouTube](https://img.youtube.com/vi/VoXgRdotlcA/maxresdefault.jpg)](https://www.youtube.com/watch?v=VoXgRdotlcA "Play on YouTube")

### Workflow 
Download ```"NextScene Storyboard by iimate24.json"``` สำหรับ Tutorial นี้ อื่นๆ ใส่มาเพิ่มสำหรับใครอยากเอาไปใช้

### Custom node lists
```
ComfyUI_LayerStyle เอาไว้ Resize
ComfyUI-nunchaku สำหรับคน แรมน้อย
ComfyUI-QwenImageLoraLoader ตัว loader ของ QWEN nunchaku  https://github.com/ussoewwin/ComfyUI-QwenImageLoraLoader
ComfyUI-GGUF  สำหรับคน แรมน้อย
ComfyUI-Easy-Use สำหรับ ทำ loop CLIP text input
ComfyUI-KJNodes สำหรับ Set - Get โหนด เอาไว้ ต่อโหนด ไร้สาย
rgthree-comfy  ตัวเสริม
ComfyUI-Jjk-Nodes text input

อื่น ๆ 
ComfyUI_SKBundle
ComfyUI-ShellAgent-Plugin
ComfyUI Impact Pack
```


### Install Nunchaku
```
Download file whl สำหรับ install Nunchaku แบบเก่า
https://huggingface.co/mit-han-lab/nunchaku/tree/main

Repo ดาวโหลด nunchaku model เราใช้ตัวเวอชั่น ล่าสุด nunchaku-qwen-image-edit-2509 ใน tutorial นี้
https://huggingface.co/collections/nunchaku-tech/nunchaku-qwen-image

สำหรับใครใช้ Runpod Python version 12, Pytorch 2.7 linux
https://huggingface.co/mit-han-lab/nunchaku/resolve/main/nunchaku-0.3.1%2Btorch2.7-cp312-cp312-linux_x86_64.whl

อื่น ๆ เอาไว้อ่าน ข้อมูล
https://github.com/nunchaku-tech/nunchaku
https://nunchaku.tech/docs/nunchaku/installation/installation.html
```

### เอาไว้ แทน Ksampler ปกติ ถ้าใช้ Qwen Model ตัวเต็มเพื่อเร่งความเร็ว และเพิ่มคุณภาพ
```
https://github.com/obisin/ComfyUI-FSampler
```

# Download Lora

### Next scene lora
```
https://huggingface.co/lovis93/next-scene-qwen-image-lora-2509
```

### Lightning Lora ตัวลด step สำหรับ Qwen Model  
ใครแรมน้อย ใช้ 4 steps แรมมากหน่อย 8 steps
```
https://huggingface.co/lightx2v/Qwen-Image-Lightning/tree/main/Qwen-Image-Edit-2509
```

### Lora เสริมน่าใช้ เอาไว้ใช้ relight และ camera angle (ไว้แนะนำคราวหน้า เพราะคลิปจะยาวเกิน)
หรือดาวโหลด workflow ไปลองเล่นกันเอง
```
อันนี้เอาไว้ relight 
https://huggingface.co/dx8152/Fusion_lora

Lora เปลี่ยน มุมกล้อง
https://huggingface.co/dx8152/Qwen-Edit-2509-Multiple-angles/tree/main
เอา prompt นี้ไปรวมกับ next scene เพิ่มมุมกล้อง สามารถเอาไปใส่ใน WAN, SORA2, Veo3 etc ได้ด้วย

Next Scene: Move the camera forward and slightly upward toward the subject for a dynamic reveal shot.
Next Scene: Move the camera backward while panning left to create a smooth cinematic pull-away.
Next Scene: Slide the camera sideways to the right while keeping focus locked on the subject.
Next Scene: Move the camera downward from above to transition into a low-angle ground perspective.
Next Scene: Rotate the camera 90 degrees around the subject for a dramatic side orbit.
Next Scene: Switch to a top-down view and slowly tilt the camera to follow the subject’s movement below.
Next Scene: Switch to a low-angle view looking up with strong perspective distortion.
Next Scene: Zoom in rapidly for an intense close-up emphasizing emotion or detail.
Next Scene: Zoom out and tilt the camera upward to reveal the surrounding space dramatically.
Next Scene: Orbit the camera 360 degrees around the subject while maintaining a centered focus.

Move forward + tilt upward (dynamic reveal) กล้องเงยขึ้น จากมุมต่ำ เช่น คนมองดูยอดตึก
Move backward + pan left (smooth pull-away) ทำให้เห็นด้านข้าง
Slide sideways right (tracking / lateral move)
Move downward → low-angle (perspective shift)
Rotate 90° around subject (side orbit)
Top-down view + tilt (overhead follow)
Low-angle looking up (heroic / dramatic)
Rapid zoom-in (emotional close-up)
Zoom-out + tilt upward (reveal environment)
Orbit 360° (full circular camera sweep)

```

# Download ตัวเต็ม Qwen Image EDIT 2509

### ตัว Official ComfyUI
```
https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/tree/main/split_files/diffusion_models

แนะนำใช้ตัวนี้ สำหรับ คนมี GPU ram  16GB
qwen_image_edit_2509_fp8_e4m3fn.safetensors

https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors

แนะนำใช้ตัวนี้ สำหรับ คนมี GPU ram  24GB ขึ้นไป
qwen_image_edit_2509_bf16.safetensors
```

# Download Nunchaku Model

### Download Model Nunchaku 8 steps สำหรับคน แรม 12 GB หรือน้อยกว่า
```
wget https://huggingface.co/nunchaku-tech/nunchaku-qwen-image-edit-2509/resolve/main/svdq-int4_r128-qwen-image-edit-2509-lightningv2.0-8steps.safetensors
```

# Download GGUF Model 
### สำหรับใครชอบ GGUF ถ้าลง Nunchaku ไม่ได้ และ สำหรับคน แรม 12 GB หรือน้อยกว่า
```
https://huggingface.co/QuantStack/Qwen-Image-Edit-2509-GGUF

https://huggingface.co/QuantStack/Qwen-Image-Edit-2509-GGUF/resolve/main/Qwen-Image-Edit-2509-Q4_K_M.gguf
```

# Download VAE, CLIP สามารถ โหลดได้โดยตรงจาาก Model Manager หรือจาก ลิ้งค์นี้
```
https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors

https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors
```


### เข้า env เดิม (ถ้าใช้ venv)

```
source /workspace/venv/bin/activate 
```

### ติดตั้งตัวเร่งดาวน์โหลด Hugginface
```
pip install -U huggingface_hub hf_transfer

หรือ

pip install -U "huggingface_hub>=0.34,<1.0" hf_transfer==0.1.9
```

### (ไม่บังคับ) ทดสอบว่าพร้อมยัง
```
python - << 'PY'
from huggingface_hub.utils import is_hf_transfer_available
print("hf_transfer available:", is_hf_transfer_available())
PY
```

### รีสตาร์ท ComfyUI
```
pkill -f "main.py" 2>/dev/null || true
python /workspace/ComfyUI/main.py --listen
```

### ตัวอย่าง prompt สร้าง Character consistency สำหรับ Gemini/Nano Banana
```
### Prompt หลัก
รวมตัวแบบจากภาพ 1 รูปผู้หญิง และภาพ 2 ผู้ชาย เข้าด้วยกัน คงใบหน้าและรูปร่างเดิม 100% ของหนุ่มหล่อและสาวสวยตามภาพอ้างอิง (หู ตา จมูก ปาก), ทั้งคู่ต้องสวมชุดนิสิตนักศึกษาไทย (ผู้หญิง: เสื้อเชิ้ตขาวแขนสั้น/กระโปรงดำฟิตเหนือเข่า/รองเท้าผ้าใบสีขาว, ผู้ชาย: เสื้อเชิ้ตสีขาวแขนยาว/เนคไท สีดำ/กางเกงดำ/รองเท้าผ้าใบสีขาว), การแสดงออกทางสายตาและอารมณ์ที่สื่อถึง อารมณ์แบบ Film Drama, ภาพฟุ้งอ่อนสไตล์ญี่ปุ่น, โทนสีแบบ film ญี่ปุ่น, ความชัด 4K, Color Grading Pastel Japanese Cinematic Style

### Promt เปลี่ยน Action ที่ต้อวการ เปลี่ยนตรงนี้ไปเรื่อย ๆ ตามต้องการ
ความหวัง	ทั้งคู่มองออกไปทางเดียวกัน ที่ขอบฟ้าที่สวยงาม	เสื้อผ้าใส่สบาย นั่งอยู่บน ระเบียง ที่มองเห็นพระอาทิตย์ขึ้น
```

### Positive prompt สำหรับ relight lora (ไม่ได้สอนในคลิปนี้)
```
Dissolving the image, Correct perspective, lighting, shadows, and depth ensure your images blend seamlessly with the background, creating stunning visuals.
```

### Negative prompt
```
色调艳丽，过曝，静态，细节模糊不清，字幕，风格，作品，画作，画面，静止，整体发灰，最差质量，低质量，JPEG压缩残留，丑陋的，残缺的，多余的手指，画得不好的手部，画得不好的脸部，畸形的，毁容的，形态畸形的肢体，手指融合，静止不动的画面，杂乱的背景，三条腿，背景人很多，倒着走
```



