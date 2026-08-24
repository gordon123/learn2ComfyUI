# 📦 Basic Structure for ComfyUI Custom Node

This is a minimal working structure to create a custom node in [ComfyUI](https://github.com/comfyanonymous/ComfyUI) 

---

## 🗂 Folder Structure
```
ComfyUI/
└── custom_nodes/
  └── MyCustomNodeFolder/
    ├── init.py # ต้องมี เพื่อให้ comfy รู้จัก
    └── my_node.py # ชื่อ custom node
```

---

## 🧩 my_node.py (example)

```python
class MyNode: # ชื่อ customnode
    @classmethod # เริ่มแรก ประกาศ classmethod เสมอ
    def INPUT_TYPES(cls): #สร้าง function เพื่อให้ comfy รู้จัก
    return { #ตัวอย่าง input ต่าง ๆ ของ node 
        "required": {
            "text_input": ("STRING", {"default": "Hello world", "multiline": True}),
            "step_count": ("INT", {"default": 30, "min": 1, "max": 100}),
            "strength": ("FLOAT", {"default": 0.8, "min": 0.0, "max": 1.0}),
            "apply_mask": ("BOOLEAN", {"default": False}),
            "quality": ("CHOICE", {"choices": ["low", "medium", "high"], "default": "medium"}),
            "input_image": ("IMAGE",),
            "latent_input": ("LATENT",),
            "mask_input": ("MASK",),
            "prompt_embedding": ("CONDITIONING",),
        },
        "optional": {
            "comment": ("STRING", {"default": "", "multiline": True})
        }
    } # จบตัวอย่าง input ต่าง ๆ ของ node 
```
###### 🧠 ComfyUI `RETURN_TYPES` Reference

| `RETURN_TYPE`           | Description                                                      | Example Use Case                       |
|-------------------------|------------------------------------------------------------------|----------------------------------------|
| `"STRING"`              | Plain text string                                                | Prompts, captions, parameters          |
| `"INT"`                 | Integer number                                                   | Seed values, steps                     |
| `"FLOAT"`               | Floating point number                                            | Strength, scale                        |
| `"BOOLEAN"`             | Boolean value (`True` / `False`)                                 | Toggle features                        |
| `"IMAGE"`               | Rendered RGB image (as tensor)                                   | Display, save, or post-process         |
| `"LATENT"`              | Latent image tensor (used in generation process)                 | Decode with VAE, upscaling             |
| `"MASK"`                | Mask image (binary or greyscale)                                 | Use for inpainting or selective edits  |
| `"CONDITIONING"`        | Prompt embeddings from text encoder                              | Feed into KSampler                     |
| `"MODEL"`               | Checkpoint model object                                          | Used by generation nodes               |
| `"VAE"`                 | VAE model object                                                 | For encoding/decoding latent/images    |
| `"CLIP"`                | CLIP model object                                                | Used to embed text into CONDITIONING   |
| `"UNET"`                | UNet model object                                                | Required by samplers like KSampler     |
| `"LORA_STACK"`          | List/stack of LoRA models                                        | Merge multiple LoRAs into model        |
| `"CONTROL_NET_STACK"`   | Stack of ControlNet model inputs                                 | ControlNet input (like edge/sketch)    |
#####  ตัวอย่าง RETURN ต่างๆ
```




    RETURN_TYPES = ("IMAGE", "STRING")
    RETURN_NAMES = ("image_output", "caption_text")
    FUNCTION = "process" #เรียกใช้งาน function ที่เราเขียน
    CATEGORY = "MyCategory" # ตั้งชื่อ ให้ custom node เรา เวลา เรา click ขวา ใน comfyui

    def process(self, text): # function code ที่เราจะสร้าง เริ่มจากนี้
        return (text.upper(),)
```
###################file __init__.py เอาไว้ ทำโครงสร้าง #####################

```__init__.py # โครงสร้าง init จะประมาณนี้ เพื่อทำให้สามารถ โหลด custom node ได้

from .my_node #ชื่อไฟล์ import MyNode #ชื่อ class

NODE_CLASS_MAPPINGS = {
    "MyNode": MyNode
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MyNode": "🧩 My Custom Node" # ชื่อใน comfyui 
}
```

## check process runing
```
apt update && apt install -y lsof
```

```
lsof -i :8188

COMMAND  PID USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
python  4303 root   49u  IPv4 33705799      0t0  TCP *:8188 (LISTEN)

kill process ที่ค้าง เช่น
kill -9 4303

```

Shell script
``` 
#!/bin/bash
PORT=8188
PID=$(lsof -t -i:$PORT)

if [ -n "$PID" ]; then
    echo "⚠️ Port $PORT already in use by PID $PID. Killing it..."
    kill -9 $PID
else
    echo "✅ Port $PORT is free."
fi

echo "🚀 Starting ComfyUI..."
python main.py --listen
```

---

# ตั้งค่า Ollama CLI และโมเดล `gemma3:latest` บน Linux (runpod container)

1. **ติดตั้ง Ollama ด้วยสคริปต์อย่างเป็นทางการ**
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh

    ```
## 2. เปิดใช้งาน Ollama API server
```bash
ollama serve --console &
sleep 3  # รอให้ server พร้อมรับคำสั่ง
```
```
ollama --version
ollama list
```
```
ollama pull gemma3:latest
```

👉 ถ้าวิธีข้างบนใช้ไม่ได้ (เช่น ระบบไม่เชื่อมเน็ตตรงกับ ollama.com) ให้ใช้วิธี manual:
```
# 1) ดึง URL จาก GitHub Releases
RELEASE_URL=$(
  curl -s https://api.github.com/repos/ollama/ollama/releases/latest \
    | grep browser_download_url \
    | grep 'linux-amd64\.tgz' \
    | cut -d '"' -f 4
)
echo "$RELEASE_URL"

# 2) ดาวน์โหลด + แตกไฟล์
curl -L "$RELEASE_URL" -o ollama.tgz
tar -xzf ollama.tgz

# 3) ย้าย binary ไปใน PATH
mv bin/ollama /usr/local/bin/ollama
chmod +x /usr/local/bin/ollama

# 4) สตาร์ท server
ollama serve --console &
sleep 3

# 5) ทดสอบ & pull โมเดล
ollama --version
ollama list
ollama pull gemma3:latest
```

```
# แสดงความช่วยเหลือทุกคำสั่ง
ollama help
ollama --help

# เริ่มต้น Ollama API server (ต้องรันค้างไว้)
ollama serve

# ดูรายชื่อโมเดลที่ติดตั้งบนเครื่อง
ollama list

# ดาวน์โหลดโมเดลจากคลังกลางลงมา
ollama pull <model>:<tag>
# ตัวอย่าง:
ollama pull gemma3:latest

# ลบโมเดลที่ไม่ใช้แล้ว
ollama rm <model>:<tag>
# หรือจะใช้ alias “delete” ก็ได้
ollama delete <model>:<tag>

# รันโมเดลด้วย prompt ที่ป้อน
ollama run <model>:<tag> --prompt "ข้อความของเธอ"
# ถ้าต้องการสตรีมผลลัพธ์:
ollama run <model>:<tag> --stream --prompt "ข้อความของเธอ"

# ดูเวอร์ชันของ CLI
ollama --version

# เช็คสถานะ server, logs เบื้องต้น
ollama logs      # ข้อความจาก server stdout/stderr
ollama status    # รายละเอียดการเชื่อมต่อ และพอร์ต

# ตั้งค่า Default port หรือ host ถ้าต้องการ
OLLAMA_HOST=127.0.0.1 OLLAMA_PORT=11434 ollama run ...

# ส่งไฟล์เข้าโมเดล (บางโมเดลรองรับไฟล์ภาพ เอกสาร ฯลฯ)
ollama run <model>:<tag> --file path/to/file.png

# คำสั่งขั้นสูง
ollama retag <model>:<oldtag> <model>:<newtag>   # เปลี่ยน tag
ollama prune                                     # ลบข้อมูลเก่าที่ไม่ใช้แล้ว

```
