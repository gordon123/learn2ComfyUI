# แนะนำวิธีการโหลด Upload, Download Loras จาก เว๊ป Repo อื่น ๆ  (กำลังเขียนจ้า ยังไม่เสร็จ)

ใน EP 4. วิธีการดาวโหลดต่าง ๆ นี้ผมจะแนะนำคร่าว ๆ ในคลิป ดังนี้  
- Quick setup runpod <br>
- Quick Install <br>
[![ดูตัวอย่างวิดีโอ](https://img.youtube.com/vi/qcH7g1FnMHg/0.jpg)](https://youtu.be/qcH7g1FnMHg)

## 1. Civitai.com
[CivitAI Models](https://civitai.com/models) <br>
หลังจากสมัครและล็อกอินบน CivitAI แล้ว ให้ไปที่หน้าหมวด Models และใช้ Filter เพื่อค้นหาโมเดล Lora ที่ต้องการ โดยในตัวอย่างนี้จะเน้น Lora ที่เหมาะสำหรับ Flux1.dev หรือ Flux1.d เพื่อให้ได้ผลลัพธ์ที่เข้ากันกับโปรเจคของคุณ <br>
<img width="576" alt="Screenshot 2025-02-11 at 13 35 21" src="https://github.com/user-attachments/assets/fed9f819-a8a4-40e6-ab4e-a7352f5654dd" />

และก็การขอ API key ไปที่ settings เลื่อนลงไปด้านล่าง [หรือดูตัวอย่างในคลิปนี้](https://youtu.be/qcH7g1FnMHg?si=D32L3u5Z0GceOy87)

## 2. Hugging Face
[Hugging Face](https://huggingface.co/) <br>
บน Hugging Face มีโมเดลและไฟล์ Lora ให้เลือกมากมาย คุณสามารถค้นหาและทดลองใช้งานได้ตามความต้องการ โดยศึกษารายละเอียดเพิ่มเติมจากหน้าเว็บหรือเอกสารที่มีให้

## 3. Dropbox
ถ้าคุณต้องการสำรองไฟล์ model ต่าง ๆ ใน Dropbox สามารถใช้ฟีเจอร์ Copy Share Link ของ Dropbox แล้วนำลิงก์นั้นไปใส่ใน downloader script เพื่อจัดการไฟล์ได้อย่างรวดเร็วและปลอดภัย

## 4. Shakker.ai
[Shakker AI](https://www.shakker.ai/th/home) <br>
เว็บ Shakker.ai มี Loras ที่สวยงามและหลากหลาย ให้คุณเลือกดาวน์โหลดตามสไตล์ที่ต้องการ โดยใช้ฟีเจอร์กรองเพื่อเลือกโมเดลฟรีที่เหมาะสมกับการใช้งาน <br>
<img width="434" alt="Screenshot 2025-02-10 at 04 15 37" src="https://github.com/user-attachments/assets/7fa67d93-157c-4dae-828c-1e30c03bb70c" />

## 5. runpodctl
[Install RunpodCTL](https://docs.runpod.io/runpodctl/install-runpodctl) <br>
เครื่องมือ runpodctl สามารถใช้สำหรับส่งออกไฟล์รูปภาพหรือ folder ได้

**คำสั่งติดตั้ง runpodctl สำหรับ macOS และ Windows (Local)**  
**Mac (Local)**
```
Mac
brew install runpod/runpodctl/runpodctl
Windows
wget https://github.com/runpod/runpodctl/releases/download/v1.14.3/runpodctl-windows-amd64.exe -O runpodctl.exe
```

สำหรับการติดตั้งบนเซิร์ฟเวอร์ (Linux - Server runpod) ให้ใช้คำสั่ง:
```
wget -qO- cli.runpod.net |  bash
```

ส่งไฟล์จากเซิร์ฟเวอร์มายังเครื่องคุณ
ส่งไฟล์เดี่ยว:
```
runpodctl send data.txt
```

ส่งทั้ง folder:
```
runpodctl send /workspace/ComfyUI/output
```

ผลลัพธ์จะมีลักษณะประมาณนี้:
```
Sending 'data.txt' (5 B)
Code is: 8338-galileo-collect-fidel
```

On the other computer run
```
runpodctl receive 8338-galileo-collect-fidel
```

## 6. SSH (Advance commandline!)
Runpod Pod SSH Configuration <br> สำหรับผู้ที่ชำนาญใน command-line สามารถเชื่อมต่อไปยัง pod ผ่าน SSH เพื่อเข้าถึงระบบและปรับแต่ง configuration ได้อย่างยืดหยุ่น

## 7. Copy แปะ บน Jupyter โดยตรง ง่าย แต่ช้า
วิธีนี้เหมาะสำหรับผู้ที่ไม่ค่อยชำนาญใน command-line เพียงแค่ copy และ paste คำสั่งลงใน Jupyter Notebook ก็สามารถอัปโหลดหรือดาวน์โหลดไฟล์ได้ แต่ความเร็วจะต่ำกว่าเครื่องมืออื่น ๆ

## 8. wget, curl (commandline ADVANCE)
สำหรับผู้ที่ชื่นชอบการใช้คำสั่ง command-line ขั้นสูง สามารถใช้ wget หรือ curl ในการดาวน์โหลดไฟล์จาก URL โดยตรง ซึ่งเป็นวิธีที่มีความยืดหยุ่นและปรับใช้งานได้ง่าย

โดยส่วนมาก curl/wget จะใช้ได้เมื่อดาวน์โหลดลิงก์ที่ไม่ redirect หรือไม่ต้องการการ login
ถ้ามีปัญหาอาจต้องแก้ไขเพิ่มเติม แต่ลองใช้คำสั่งง่าย ๆ ดังนี้:

ใช้ Jupyter navigate ไปยังโฟลเดอร์ที่ต้องการ จากนั้นเปิด terminal ใหม่ขึ้นมา ตรวจสอบ path ว่าอยู่ในโฟลเดอร์นั้น แล้วใช้คำสั่ง:
```
wget (ลิ้งที่จะดาวโหลด)
curl (ลิ้งที่จะดาวโหลด)
```

## 9. My downloader script!! EASY!! โหลดอย่างไว!!
สคริปต์ดาวน์โหลดของฉันออกแบบมาให้ใช้งานง่ายและรวดเร็ว สามารถดาวน์โหลดไฟล์จากหลาย ๆ แหล่งในครั้งเดียว ช่วยให้การจัดการไฟล์ Loras ของคุณเป็นไปอย่างราบรื่นและมีประสิทธิภาพ <br> ดาวน์โหลด File Script

## download from Hugginface when need permission, create your Access token from Huggin face
```
wget --header="Authorization: Bearer hf_xxxxxxxxxxxxxxxxxxxxxxxx" \
"https://huggingface.co/xxxxxxxxxxxxxxxxx.safetensors"
```

## 10. การ install Git LFS บน RunPod เพื่อทำการ Clone Repo Hugginface

1. update package manager บน Runpod
```
apt-get update
```
2. ติดตั้ง Git LFS
```
apt-get install git-lfs -y
```
3. เริ่มต้นใช้งาน Git LFS
```
git lfs install
```
4. เช็คสถานะการติดตั้ง:
```
git lfs env
```
5. clone Repo ของ Hugginface เช่น จะดาวโหลดโมเดล Nunchaku อันนี้ ต้องดาวโหลด ทั้งโฟล์เด้อ เข้าไปใน Unet ก่อน แล้วตามด้วยคำสั่งนี้
```
git clone https://huggingface.co/theunlikely/svdq-int4-jibMixFlux_v8Accentueight
```

