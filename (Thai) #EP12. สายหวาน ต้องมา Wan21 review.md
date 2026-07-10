1. สำหรับ ใครจะ install ComfyUI บน [Runpod](https://tinyurl.com/register2runpod) สามารถดูวิธีกาลใช้แบบละเอียดได้ใน [youtube ep.1](https://youtu.be/Rs0LaYKLcL0?t=340s) ผ่าน Script ด้วย Jupyter, หรือ ทำตาม ep.12 ใช้ script แบบ command line ตามอ่านได้ในบทนี้

### สำหรับใครที่ vram < 8GB-12GB ลองใช้ GGUF น่าจะเร็วขึ้น
Download จาก  <br>
[T2V](https://huggingface.co/city96/Wan2.1-T2V-14B-gguf/tree/main)    <br>
แนะนำสำหรับ ram 8GB VGA[i2V 480p](https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/tree/main)   <br>
แนะนำสำหรับ ram 12GB VGA[i2v 720p](https://huggingface.co/city96/Wan2.1-I2V-14B-720P-gguf/tree/main)  <br>

### 2. สร้าง vritual environment ชื่อ venv
```
python -m venv venv

และก็ activate venv

source venv/bin/activate
```

3. ดาวโหลด Script จาก [learn2comfyUI](https://github.com/gordon123/learn2ComfyUI/tree/main/file%20script)
```
สำหรับ การ์ดจอ RTX30xx 40xx
install_rtx30_40.sh

หรือ 

สำหรับ RTX50xx
install_rtx50.sh

ใช้ คำสั่ง bash ตามด้วยชื่อไฟล์ เช่น

bash install_rtx50.sh
```

4. รอ 3-5 นาที แล้ว เริ่ม start comfyUI 
```
cd ComfyUI

python main.py --listen
```

1.3B parameter เร็วคุณภาพ น้อย เอาไว้ทดสอบ
14B Parameter ช้ามากกกกกกกก เอาไว้ Final project

### สูตรคำนวณ FPS & Video Length
ตัวอย่าง 
เช่น 16 FPS  สำหรับ คลิป 5 วินาที

```
16FPS x 5sec +1 =  81 Length ใส่เลขนี้ ใน Latent node
```
### สรุป คลิป T2V
1. การ Install WAN, Download models
2. อธิบายการเซตค่าต่างๆ
3. เปรียบเทียบ ความเร็วในการ Generate Video
4. แนะนำ Prompt คร่าวๆ
5. Technique ในการลดความเร็วในการ Generate
6. Use case
```
====== Testing Generated SPEED =======

RTX 5000 Ada 32GB
CPU 62 GB RAM
-------------------------------
T2V 1.3B
30 steps
              เวลา-ความเร็วในการเจน
8  FPS - 5s =  67s generate
16 FPS - 5s = 160s generate
16 FPS - 5s+ Teacache = 118s

24 FPS - 5s = 288s
--------------------------------
T2V 14B.     เวลา-ความเร็วในการเจน
8  FPS - 5s = 352s 🐢🐢  
16 FPS - 5s = 827s 🐢🐢🐢

----------------------------------
= Length = 81, 5sec
16 FPS - 5s + Teacache = 317s 🔥

14B T2V - 30 Steps
16 FPS - 5s + Teacache + Tiled Vae decode = 247s 🔥🔥

1.3B T2V - 30steps
16 FPS - 5s + Teacache + Tiled Vae decode = 50s 🔥🔥🔥🔥

---------------
GGUF
14B Q3-s- 30steps - 243s
```
## Teacache setting guide
![alt text](</image/img/teacache-table.png>)
# Todo-List ราย การที่จะสอน ใน Wan The series (To be continue)

## 🎯Wan2.1 Basic
### T2V = Text to video
✅ อัดคลิปแล้ว  ✅ ตัดต่อเสร็จแล้ว
### i2V = Image to video
✅ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว

## 🎯Wan2.1 Fun
### FLF2V First & Last Frame to Video
✅ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Control: Control net
✅ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Inpaint 
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Control Camera
✅ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว

## 🎯Wan2.1 Advance technique
### In Context 
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### VACE
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Wan Lip sync
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Framepack
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Wan Frame Interpolation + Upscale
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว

## 🎯Wan Apply Project
### Create Music video
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Create Music Short film
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
### Create Music, Asses, etc and Selling to stock Photo, ecomerce
❌ อัดคลิปแล้ว  ❌ ตัดต่อเสร็จแล้ว
