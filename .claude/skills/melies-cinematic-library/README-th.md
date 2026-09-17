# melies-cinematic-library

*[English](README.md)*

คลัง mirror ในเครื่องของ [melies.co/cinematic-techniques](https://melies.co/cinematic-techniques)
— เทคนิคกล้อง/ภาพยนตร์ที่มีชื่อจริง 424 เทคนิค แบ่งเป็น 13 หมวด แต่ละเทคนิคมีคำนิยามและ
prompt fragment พร้อมนำไปปรับใช้ สาเหตุที่ต้อง mirror เพราะเว็บต้นทางถูกบล็อกโดย network
egress proxy ของ environment นี้ ดึงข้อมูลสดไม่ได้

นี่คือคลังอ้างอิง ไม่ใช่ตัวเขียน prompt มันแค่ส่งชื่อเทคนิคพร้อมคำนิยาม/prompt fragment กลับมา
ส่วนการเขียน prompt จริงสุดท้ายยังคงเป็นหน้าที่ของ skill ปลายทาง (`reelbench-skills`,
`minimax-h3-prompt-writing`, `seedance-*`, `google-flow-shotlist-director` หรือตัวอื่นที่ใช้อยู่)

## ใช้เมื่อไหร่

- ก่อนเขียนหรือแก้ shot/scene ที่ต้องการมุมกล้อง, การเคลื่อนกล้อง, framing, แสง, สีเกรด,
  เลนส์, บรรยากาศ, transition, genre look หรือ "viral" aesthetic แบบเจาะจง — ให้ใช้เทคนิคที่มี
  ชื่อจริงจากที่นี่แทนคำคุณศัพท์กำกวม ("low angle แบบหนึ่ง", "แสงหม่นๆ")
- เมื่อถูกถามว่า "what techniques would fit this scene" หรือ "หา technique ที่เหมาะกับซีนนี้"
- เมื่อตรวจสอบ prompt/shotlist เดิม แล้ว camera-emotion pairing (`camera-emotion.md` ของ
  `reelbench-skills`) ต้องการคำที่แม่นยำแทนคำกำกวม

## วิธีใช้

1. อ่าน `library/INDEX.md` ก่อน — มีครบทั้ง 13 หมวด จำนวนเทคนิคแต่ละหมวด และชื่อเทคนิคทุกตัว
2. ระบุว่าโจทย์ต้องการหมวดไหน (หรือ 2-3 หมวด)
3. เปิดไฟล์ `library/cinematic-techniques-<หมวด>.md` ที่ตรงกัน แล้วอ่าน entry ที่ต้องการ —
   แต่ละอันมี `### ชื่อเทคนิค`, `**Definition:**`, และ `**Prompt:**` fragment
4. ปรับ prompt fragment ให้เข้ากับโครงสร้างประโยคของ shot จริงและ field format ของแพลตฟอร์ม
   ปลายทาง — ห้ามส่ง template ดิบๆ กลับไปเป็น prompt สำเร็จรูป
5. เอ่ยชื่อเทคนิคให้ชัดเจนตอนนำเสนอ เพื่อให้ตรวจสอบย้อนกลับได้ว่ามาจากไหน

## หมวดหมู่ (ดูรายชื่อเทคนิคเต็มในแต่ละหมวดที่ `library/INDEX.md`)

| ไฟล์ | หมวด | จำนวน |
|---|---|---|
| `cinematic-techniques-camera-angles.md` | มุมกล้อง | 19 |
| `cinematic-techniques-camera-movement.md` | การเคลื่อนกล้อง | 86 |
| `cinematic-techniques-framing-and-shot-size.md` | Framing / ขนาดช็อต | 25 |
| `cinematic-techniques-composition.md` | องค์ประกอบภาพ | 32 |
| `cinematic-techniques-lighting.md` | แสง | 41 |
| `cinematic-techniques-color-and-film-look.md` | สี / ฟิล์มลุค | 19 |
| `cinematic-techniques-lenses-and-optics.md` | เลนส์ / ออปติก | 17 |
| `cinematic-techniques-atmosphere-and-weather.md` | บรรยากาศ / สภาพอากาศ | 13 |
| `cinematic-techniques-time-and-motion.md` | เวลาและการเคลื่อนไหว | 21 |
| `cinematic-techniques-editing-and-transitions.md` | การตัดต่อ / transition | 23 |
| `cinematic-techniques-in-camera-and-optical-effects.md` | เอฟเฟกต์ในกล้อง / ออปติก | 57 |
| `cinematic-techniques-genre-looks.md` | ลุคตามแนวหนัง | 27 |
| `cinematic-techniques-viral-looks.md` | ลุคไวรัล | 44 |

## หมายเหตุการดูแลรักษา

ไฟล์นี้กับ `README.md` (ภาษาอังกฤษ) ต้องอัปเดตคู่กันเสมอ ห้ามแก้ entry เทคนิคใน
`library/*.md` เอง — มันคือข้อมูล export ตรงจากเว็บต้นทาง
