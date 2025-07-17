## บทนี้เราจะมาเริ่ม Install ComfyUI บน Runpod กัน  
ผมได้เตรียมไฟล์ไว้แล้ว เพื่อนๆ สามารถไปโหลดได้ที่  

### updat ใหม่
  ```
ComfyUI: The latest version, v0.3.44,  Python 3.12.10 and Torch 2.7.1+cu128, for NVIDIA RTX 5000 series compatibility
  ```
[![Watch on YouTube](https://img.youtube.com/vi/oDSnH_nAhvY/0.jpg)](https://www.youtube.com/watch?v=oDSnH_nAhvY)

### 1. ดาวน์โหลดไฟล์ Install ComfyUI  
- เพื่อน ๆ สามารถโหลดไฟล์ **Install_ComfyUI (test1) (1).ipynb** จากโฟลเดอร์ **file script**  
  ![image](https://github.com/user-attachments/assets/8a9ae345-ad6e-46ca-b94e-f81ec57dc72e)  

### 2. อัปโหลดไฟล์ไปยัง JupyterLab  
- ลากไฟล์ไปวางในช่อง **file manager** ทางซ้าย  
  ![image](https://github.com/user-attachments/assets/fb325063-88af-4b9f-9813-3a853e1b96fc)  

### 3. เปิดและรันไฟล์  
- ดับเบิ้ลคลิกไฟล์ **Install_ComfyUI** แล้วกด **Run script** ทีละเซล (เหมือน Google Colab)  
  ![image](https://github.com/user-attachments/assets/525dc36d-2cba-47a9-bb9e-5dfa34b85b90)  

### 4. หากขึ้นตามภาพ แสดงว่าเสร็จแล้ว  
- กด **Cell ที่ 2** แล้วกด **Run** ทำต่อไปเรื่อยๆ  
  ![image](https://github.com/user-attachments/assets/e3032a9f-a2e1-424c-b710-5799c908aad0)  

### 5. รัน Script ใน Cell ที่ 2  
- สังเกตแถบ **สีน้ำเงิน** ทางซ้าย แล้วกดปุ่ม **Run script**  
  ![image](https://github.com/user-attachments/assets/58bbd817-63f9-4229-9f4b-fb2e0c364e86)  

### 6. ตรวจสอบโฟลเดอร์ ComfyUI  
- Cell ที่ 2 จะถาม **Yes/No**  
- ดูว่า **โฟลเดอร์ ComfyUI ปรากฏอยู่ทางซ้าย** หรือไม่  
- หากมี **ให้พิมพ์ Yes** แล้วกด Enter  
  ![image](https://github.com/user-attachments/assets/595f29fe-d0c5-4272-9f89-f97d5c8a6f37)  

### 7. รัน Script ใน Cell ที่ 3  
- หากเห็นโฟลเดอร์ **venv** ทางซ้าย ให้กด **Yes**  

### 8. ทดสอบ activate venv  
- เปิดแท็บใหม่ (กดเครื่องหมาย +)  
- ไปที่ **Terminal**  
  ![image](https://github.com/user-attachments/assets/8570d70c-7dab-4d8a-91df-c28d5ad54f8a)  

- คัดลอกคำสั่งนี้ไปวางใน **Terminal** แล้วกด Enter  
  ```
  source /workspace/venv/bin/activate
  ```
  ![image](https://github.com/user-attachments/assets/56ab29b2-6666-42f4-b303-f61ad8af8214)  
  ![image](https://github.com/user-attachments/assets/b42854c3-474d-4756-b313-9b450467eb77)  

- หากขึ้นแบบนี้ ถือว่า **ผ่าน**  
- กลับไปที่ **Script Cell 4** แล้วพิมพ์ **Yes**  

### 9. รอให้ Script ทำงาน (5-10 นาที)  
- Script จะโหลดแพ็กเกจต่าง ๆ หากขึ้น **Yes/No** ให้ตอบ **Yes**  
  ![image](https://github.com/user-attachments/assets/23fbd4e3-e210-4e29-a45f-f2c2db73eb76)  

- หากขึ้นแบบนี้ ถือว่า **Step 5 เสร็จแล้ว**  
- ตอบ **Yes** เพื่อไป **เซลถัดไป**  
  ![image](https://github.com/user-attachments/assets/d5e6bfc9-e47c-43de-995e-81f10b8a5d3f)  

### 10. ติดตั้ง Requirement.txt  
- รัน **Cell 6** เพื่อติดตั้ง dependencies ของ ComfyUI  

### 11. ตรวจสอบการติดตั้ง  
- กลับไปหน้า **Terminal**  
- พิมพ์คำสั่งนี้  
  ```
  pip list
  ```
- หากเห็นรายการแพ็กเกจ **แสดงว่าการติดตั้ง ComfyUI สำเร็จ**  

---

## 🔧 ติดตั้ง Custom Manager  
### 1. รัน **Cell 6**  
- กด **Run** แล้วตอบ **Yes** เพื่อยืนยัน  
  ![image](https://github.com/user-attachments/assets/74284539-a871-4f0c-8d8c-5b0f81a65b26)  

### 2. **การติดตั้ง ComfyUI และ Custom Nodes Manager เสร็จสิ้น!**  

### 3. ทดสอบรัน ComfyUI  
- ไปที่ **Cell 8** แล้วกด **Run**  
  - ครั้งแรกอาจใช้เวลานาน  
  ![image](https://github.com/user-attachments/assets/65c647e3-8a43-4223-a758-d104fa2f7e83)  

- หากเห็นแบบนี้ **แสดงว่าระบบพร้อมใช้งาน**  
  ![image](https://github.com/user-attachments/assets/87256a4e-b2f4-40ee-b972-23ebc0151be2)  

---

## 🚀 เปิดใช้งาน ComfyUI  
1. ไปที่หน้า **Runpod ของเรา**  
2. คัดลอก **IP Address และ Port (8188)**  
  ![image](https://github.com/user-attachments/assets/11ade639-7bf8-4c9c-8e14-cea059caf9c4)  

3. เปิด **เว็บเบราว์เซอร์**  
4. วาง IP Address เช่น  
   ```
   78.130.201.2:18814
   ```
   ![image](https://github.com/user-attachments/assets/143776b5-7e37-41f6-9e0b-9ce31e91bfc3)  

---

🎉 **ตอนนี้คุณมี ComfyUI ติดตั้งเรียบร้อยบน Runpod GPU Server แล้ว!** 🎉  

**หากคุณต้องการสนับสนุนผม**  
คุณสามารถใช้ลิงก์แนะนำนี้:  
[runpod.io](https://runpod.io?ref=c0v5p0ys)  

**ขอบคุณครับ! >D**
