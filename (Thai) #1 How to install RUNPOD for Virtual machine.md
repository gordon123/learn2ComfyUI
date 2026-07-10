# learn2ComfyUI  
(*เพิ่งเริ่มเรียนรู้จากแหล่งความรู้ทั่วไป เหมาะสำหรับมือใหม่ที่อยากลองเล่น ComfyUI*)  

พื้นที่นี้ใช้เก็บรวบรวมความรู้ที่ผมได้เรียนรู้และนำมารวมกัน  
เนื่องจากผมไม่มีคอมพิวเตอร์สเปคแรง จึงใช้บริการ **Cloud Service** เป็นหลัก เช่น [runpod.io](https://runpod.io?ref=c0v5p0ys)  

[![Watch the video](https://img.youtube.com/vi/KvZRuwcZ3Is/0.jpg)](https://www.youtube.com/watch?v=KvZRuwcZ3Is)

## การสมัครใช้งาน Runpod.io  
การใช้ Runpod จะคิดค่าบริการตามทรัพยากรที่ใช้งานต่อชั่วโมง  
ผมมักเลือกใช้ **ราคา $0.2 - $0.4 ต่อชั่วโมง** ซึ่งหากใช้งาน **6 ชั่วโมง** จะเสียค่าบริการประมาณ **$2.5 - $3.5 USD (ประมาณ 85 บาท / 6 ชั่วโมง)**  
ซึ่งถือว่าถูกมากเมื่อเทียบกับการซื้อคอมพิวเตอร์สเปคสูง  

แลกมากับการสามารถสร้าง **ภาพสวย ๆ** ด้วย **FLUX โมเดลขนาดใหญ่** ตามที่เราต้องการ  

**ข้อควรระวัง:**  
หลังจากใช้งานเสร็จแล้ว **ควรลบ Pod** เพื่อไม่ให้เสียค่าบริการเก็บไฟล์โดยไม่จำเป็น  
เดี๋ยวผมจะแนะนำวิธีจัดการอีกที  

---

### **วิธีสมัครและใช้งาน Runpod.io**
#### 1. **สมัครสมาชิกด้วย website [runpod.io](https://runpod.io?ref=c0v5p0ys) ด้วย Gmail**  
   
#### 2. **เติมเงิน**  
ขั้นต่ำ **$10 USD**  
![image](https://github.com/user-attachments/assets/e1aebf51-0476-4ee8-9658-2add9c27726a)

#### 3. **เลือก GPU Cloud Instance**  
![image](https://github.com/user-attachments/assets/27493015-cd49-4fea-89fe-34516a35a452)

#### 4. **เลือก "Community Cloud"**  
- ราคาถูกกว่าตัวเลือกอื่น  
- "Secure Cloud" ก็ดี แต่มีการแข่งขันใช้งานสูง  
- หากต้องการเช่าระยะยาวหรือเปิด **Web Service** อาจเลือกแบบ Secure  
- คู่มือนี้เหมาะสำหรับมือใหม่ที่อยากทดลองใช้ Runpod  

#### 5. **เลือกเครื่องที่ต้องการ**  
ให้มองหาเครื่องที่มีสเปค:  
✅ **VRAM:** 20GB ขึ้นไป  
✅ **RAM:** 60GB ขึ้นไป  
✅ **ราคา:** $0.5 - $0.2 USD ต่อชั่วโมง  

**ระดับความเร็ว (Speed Categories):**  
- **Low, Medium, High** → ความเร็วในการดาวน์โหลดไฟล์  
- ถ้าต้องโหลดโมเดลบ่อย **แนะนำให้ใช้ Medium หรือ High**  
- ถ้ามีแต่ Low ก็สามารถใช้ได้  

**ตัวเลข 2x หน้าชื่อ GPU** = ใช้การ์ดจอสองตัว  
- ส่วนตัวผมเลือก **การ์ดจอตัวเดียวแต่มี VRAM 20GB+** เพราะรู้สึกว่าเร็วกว่ามาก  
- ควรทดลองเลือกและดูความเหมาะสม  
![image](https://github.com/user-attachments/assets/95191c1b-5f0c-44d3-9ec0-a6824b8f2276)

#### 6. **เลือก Template**  
เลื่อนลงมาหา **ปุ่ม Template**  
![image](https://github.com/user-attachments/assets/8ae9a710-35de-4b56-8725-f08b725df780)

ผมใช้เวอร์ชัน:  
**runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04**  
- มี **Jupyter & Web Terminal** ใช้งานง่าย  
![image](https://github.com/user-attachments/assets/6866b2f0-21b7-4dec-8fe4-bb4f71b4e208)

หากใครใช้ **Docker** เป็น อาจเลือกเวอร์ชันอื่น  
แต่ผมยังใช้ **Docker ไม่เป็น** เลยเลือก **Pytorch - Jupyter** ซึ่งคล้ายกับ **Google Colab**  

---

### **ตั้งค่าการใช้งาน Template**
- **Disk Space:** อย่างน้อย **120GB**  
- **Port:** ตั้งค่า **8188** เพื่อเปิด **WebUI**  
![image](https://github.com/user-attachments/assets/7402ed67-3e2e-4418-8871-c28f6bb62daa)

---

### **รอการติดตั้ง**
ระบบจะใช้เวลาสักครู่ในการติดตั้ง **Virtual Machine**  
![image](https://github.com/user-attachments/assets/d7a9a6cb-181e-4a3a-97de-190829ad96a4)

#### 7. **ตรวจสอบว่าเครื่องพร้อมใช้งาน**  
เมื่อเห็นสถานะ **"Running" เป็นสีเขียว** แสดงว่าใช้งานได้แล้ว  
![image](https://github.com/user-attachments/assets/f9a541d3-6a68-4937-8b4a-9e99784ee9ff)

กดที่ปุ่ม **"Running" สีเขียว**  
![image](https://github.com/user-attachments/assets/07acd97c-908e-4b60-a7bb-1bf010b95a60)

จากนั้นกด **Connect**  
![image](https://github.com/user-attachments/assets/6c641237-6332-4924-a94d-6a622cfbf8d4)

เมื่อเห็น **Jupyter เป็นสีเขียว** แสดงว่าพร้อมใช้งานแล้ว  
![image](https://github.com/user-attachments/assets/5a5a93c3-428e-4d77-ade6-0360c9962d95)

---

🎉 **ตอนนี้พร้อมติดตั้ง ComfyUI แล้ว!** 🎉  

🔗 **หากคุณเป็นมือใหม่และต้องการสนับสนุนผม สามารถใช้ลิงก์แนะนำนี้ได้:**  
[runpod.io](https://runpod.io?ref=c0v5p0ys)
