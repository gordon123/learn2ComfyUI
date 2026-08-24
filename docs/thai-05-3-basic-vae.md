# Stable diffusion คืออะไร

![what is stable diffusion](image/img/stable-diffusion.png)
 ถ้าอธิบายภาษาบ้าน ๆ ดูตามรูปเลย คือ เขียนข้อความ แล้วใช้โมเดล ของ Stable diffusion  หลัก ๆ สามตัวนี้ คือ CLIP, U-Net และ VAE
 เพื่อให้ได้ภาพจากข้อความที่เราเขียน ซึ่งจินตนาการล้วน ๆ เป็นสิ่งที่ไม่มีจริงในโลกนี้ก็ได้ .... จบ การอธิบาย แบบง่าย ๆ เข้าใจแค่นี้ เจนรูป(ย่อจาก Image Generative AI) ได้แล้ว

---
แต่ถ้าใครอยากเข้าใจมากขึ้น (ปวดหัวมากกว่านี้) ลองตามอ่านต่อ เรื่อง VAE บทสุดท้าย แต่ไม่ท้ายสุด กันต่อเลย

# VAE คืออะไร
📌 **V**ariational **A**uto**E**ncoder (VAE) เป็นโมเดลประเภทหนึ่งของ Autoencoder ที่ใช้สำหรับการเรียนรู้ของ AI (Generative Learning) <br>
📌 เป็นโมเดลสำคัญใน Stable Diffusion ที่ใช้แปลงข้อมูลระหว่าง Latent Space และ Pixel Space <br>
📌 VAE ใช้ในการบีบอัด (Encode) และสร้างใหม่ (Decode) ข้อมูลในลักษณะที่ควบคุมได้

💡 ใน Stable Diffusion, VAE ทำหน้าที่แปลงข้อมูลใน Latent Space (4×64×64) กลับไปเป็นภาพจริง (512×512x3 RGB) <br>

## โครงสร้างของ VAE

VAE ประกอบด้วย 2 ส่วนหลัก
1️⃣ Encoder → บีบอัดภาพให้เป็นตัวแทนใน Latent Space
2️⃣ Decoder → สร้างภาพใหม่จากข้อมูล Latent Space

🔹 แสดงเป็นแผนภาพ <br>
```
Input Image → Encoder → Latent Space → Decoder → Reconstructed Pixel Image
```

วิธีการทำงานของ VAE <br>
📌 VAE ใช้ความน่าจะเป็นในการเรียนรู้การแจกแจงของข้อมูล (Probability Distribution Learning) <br>
📌 แทนที่จะ Map ข้อมูลไปยังค่าคงที่, VAE Map ข้อมูลเป็นค่าที่มีการกระจาย (Mean, Variance)

🔹 1️⃣ Encoding Phase (บีบอัดข้อมูล) <br>
📌 เปลี่ยนภาพเป็นเวกเตอร์ที่อยู่ใน Latent Space <br>
✅ ใช้ CNN ดึง Features จากภาพ <br>
✅ ได้ผลลัพธ์เป็นค่า Mean (μ) และ Variance (σ²) ของ Latent Representation <br>
✅ ใช้ Reparameterization Trick เพื่อสุ่มค่า Latent Vector <br>

🔹 2️⃣ Sampling (สุ่มค่า Latent Vector) <br>
📌 VAE ไม่ได้ Map ข้อมูลเป็นจุดเดียว แต่กระจายค่าออกไปเป็น Distribution <br>
✅ ใช้สมการ: <br>


ϵ∼N(0,I) เป็น Noise ที่สุ่มขึ้นมา

🔹 3️⃣ Decoding Phase (สร้างภาพใหม่) <br>
📌 แปลง Latent Vector กลับเป็นภาพใน Pixel Space <br>
✅ ใช้ Decoder (CNN Transposed) ในการ Upscale ข้อมูลกลับไปเป็นภาพ <br>
✅ ค่าที่ได้จาก Decoder คือ Reconstructed Image <br>

📜 4. สมการของ VAE <br>
📌 VAE ใช้ Loss Function พิเศษที่ประกอบด้วย 2 ส่วน: <br>


🔹 1️⃣ Reconstruction Loss → ใช้ตรวจสอบว่าภาพที่ได้จาก Decoder ใกล้เคียงกับ Input มากแค่ไหน <br>
🔹 2️⃣ KL Divergence Loss (Regularization Term) → บังคับให้ Latent Space มีการกระจายแบบปกติ <br>

​
 (q(z∣x)∣∣p(z))
✅ ช่วยให้ Latent Space ของ VAE เป็นระเบียบและสามารถ Sampling ได้ดีขึ้น

VAE จริง ๆ เราไม่ต้องเปลี่ยนอะไรมาก แค่ใช้ให้ถูกเวอร์ชั่น ของโฒเดลก็พอ
