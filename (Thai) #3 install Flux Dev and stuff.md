## การโหลดโมเดล Flux ต่าง ๆ และการต่อ Nodes  

[![Watch on YouTube](https://img.youtube.com/vi/hpuM1499emI/0.jpg)](https://www.youtube.com/watch?v=hpuM1499emI)

### 1. ดาวน์โหลดไฟล์ Install_Model_Flux_ON_Runpod.ipynb  
- ไฟล์นี้อยู่ในโฟลเดอร์ [**File script**](https://github.com/gordon123/learn2ComfyUI/tree/main/file%20script)  

### 2. อัปโหลดไฟล์ไปยัง JupyterLab  
- ดาวน์โหลดไฟล์ลงเครื่องก่อน  
- จากนั้น **ลากไฟล์ไปที่ JupyterLab file manager**  

### 3. เปิดใช้งานไฟล์  
- **ดับเบิ้ลคลิก** ไฟล์นี้เพื่อเปิดใช้งาน  

### 4. Flux Model  
- ไฟล์นี้จะ **โหลดทุกโมเดล Flux** จาก **Hugging Face**  

### 5. ต้องมี **Hugging Face ID**  
- แนะนำให้สมัคร **Hugging Face ID** ก่อน  
- ใช้ **Access Token** ของตัวเองในการโหลดไฟล์  

### 6. วิธีขอ Access Token  
- สามารถดูขั้นตอนใน **ช่อง YouTube**  

### 7. ตัวอย่าง Token Key  
- ได้รับ **Token Key** ที่หน้าตาแบบนี้  
  ```
  hf_NKauyIDgxfkabnvclDkCkKLfQlYDk 
  ```

### 8. **Grant Access ก่อนโหลดโมเดล**  
- ต้องไป **กด Grant Access** ที่หน้าโมเดล **Flux** ทุกตัว  
- สามารถทำได้ที่ **Hugging Face Repo**  

### 9. เริ่มโหลดโมเดล Flux  
- เปิดไฟล์ **Install_Model_Flux_ON_Runpod.ipynb** ที่อยู่ในโฟลเดอร์ **File script**  

### 10. รัน Cell 1  
- กด **Run Cell 1**  

### 11. รัน Cell 2 และใส่ **Hugging Face Token Key**  
- กด **Run Cell 2**  
- จากนั้น **ใส่ Hugginface Token Key**  

### 12. **Grant Access แต่ละโมเดลก่อนโหลด**  
- ก่อนรัน Cell 3 ต้องไปกด **Grant Access**  
- ลิงก์ Repo:  
  [Black Forest Labs - Flux Models](https://huggingface.co/collections/black-forest-labs/flux1-679d013aee236841c0e9d38a)  

### 13. รัน Cell 3 และรอ...  
- กด **Run Cell 3**  
- **รอ... นานมากกกกกกกกกกกกกกกกกกกกกกกกกกกกกกกกก**  
- เพราะต้องโหลดไฟล์ขนาด **60 - 80GB!!!**  
