### วิธีใช้
1. โยน wanvideo_WanAnimate_example_01.json, install missing nodes ต่าง ๆ
2. restart จะมี error บาน
3. ถ้าเปิด terminal ใหม่ ให้ activate VIRTUAL VENV ก่อน ถ้ามีแล้วไม่ต้อง

## Wan 2.2 (Kijai) One-shot Setup for ComfyUI

สคริปต์ไฟล์เดียวสำหรับ:

ติดตั้งไลบรารีที่จำเป็น (onnx, onnxruntime-gpu, opencv-python-headless, ฯลฯ)

ตั้งค่า WAS Node Suite ให้รู้จัก ffmpeg

ดาวน์โหลด Wan2.2 Animate 14B FP8 (เลือก e4m3fn สำหรับ 40xx / e5m2 สำหรับ 30xx ให้อัตโนมัติ)

ดาวน์โหลด LoRA ที่เกี่ยวข้อง (Relight, Lightx2v, FastWan 480p, Lightning I2V 4-steps, PusaV1, FunReward)

แสดงเวอร์ชัน Python/Torch/CUDA/ONNX และสตาร์ท ComfyUI

โครงสร้างโฟลเดอร์อ้างอิง:
ComfyUI อยู่ที่ /workspace/ComfyUI และ venv ที่ /workspace/venv

⬇️ Download

setup_wan22_kijai.sh
Download

บันทึกไฟล์ไว้ในเครื่อง/เซิร์ฟเวอร์ Runpod ของคุณ (เช่น /workspace/setup_wan22_kijai.sh)
```bash
🚀 Usage
### 0) เข้า venv (หากยังไม่ได้ active)
source /workspace/venv/bin/activate

### 1) ให้สิทธิ์รัน

chmod +x /workspace/setup_wan22_kijai.sh

### 2) (ไม่บังคับ) ติดตั้ง SageAttention ด้วย ตั้งค่านี้เป็น 1

export INSTALL_SAGEATTENTION=0

### 3) รันสคริปต์

/workspace/setup_wan22_kijai.sh
```
สคริปต์จะ:

ติดตั้งแพ็กเกจ Python จำเป็นบน venv

ค้นหา ffmpeg (ถ้าไม่มีจะติดตั้งผ่าน apt) แล้วเขียนพาธลง
/workspace/ComfyUI/custom_nodes/was-ns/was_suite_config.json

ตรวจรุ่นการ์ดจอผ่าน nvidia-smi เพื่อเลือก FP8 e4m3fn (40xx/ADA) หรือ FP8 e5m2 (30xx/อื่น ๆ)

ดาวน์โหลดโมเดล/LoRA ไปไว้ที่:

models/diffusion_models/

models/loras/

models/vae/ (ดึง VAE 2.1 ถ้าคุณยังไม่มี)

สรุปเวอร์ชันสำคัญ (Python, Torch, CUDA, ONNX/ORT, OpenCV)

ปิด ComfyUI ตัวเก่า (ถ้ามี) แล้วรัน main.py --listen

📦 What it installs

Python deps: onnx, onnxruntime-gpu, onnxruntime-tools, opencv-python-headless, numpy, scipy

(ตัวเลือก) sageattention หากตั้ง INSTALL_SAGEATTENTION=1

Diffusion (เลือกอัตโนมัติ):

40xx/ADA → Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors

30xx/อื่น ๆ → Wan2_2-Animate-14B_fp8_e5m2_scaled_KJ.safetensors

LoRA:

WanAnimate_relight_lora_fp16.safetensors

lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank64_bf16.safetensors

FastWan_T2V_14B_480p_lora_rank_128_bf16.safetensors

Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors

Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors

Wan2.2-Fun-A14B-InP-LOW-HPS2.1_resized_dynamic_avg_rank_15_bf16.safetensors

🧩 Notes

สคริปต์จะเขียนค่า ffmpeg_bin_path ให้อัตโนมัติ แก้คำเตือนของ WAS Node Suite

ถ้าต้องการใช้ onnx nodes (DWPose/FantasyPortrait ฯลฯ) ให้แน่ใจว่า onnxruntime-gpu ถูกโหลดด้วย provider ที่รองรับ CUDA (สคริปต์จะแสดง provider ที่ใช้ไว้ให้ท้ายรัน)

ถ้า sageattention คอมไพล์ไม่ผ่าน ให้ปล่อย INSTALL_SAGEATTENTION=0 ไปก่อน (ไม่บังคับ)

🔍 Verify

หลังรันเสร็จ คุณจะเห็นบล็อกนี้ในคอนโซล:

🐍 Python: x.y.z
🔥 Torch: 2.x.x
🎯 CUDA (PyTorch reports): 12.x
✅ CUDA available: True
🧠 GPU: NVIDIA XXX
🔷 onnx: ...
🟦 onnxruntime: ... providers: ['CUDAExecutionProvider', 'CPUExecutionProvider']
📦 opencv: ...


และ ComfyUI จะเริ่มทำงานด้วย --listen.
