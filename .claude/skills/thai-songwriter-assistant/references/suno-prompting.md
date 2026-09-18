# Suno AI Prompting — แปลงเนื้อเพลงเป็น prompt ที่ควบคุมได้

ใช้ไฟล์นี้ในเฟส 4 ของ workflow (ตอนเนื้อเพลงเสร็จครบทุกท่อนแล้ว และ user ต้องการ prompt สำหรับ Suno AI)

> ⚠️ Suno อัปเดตโมเดล/ฟีเจอร์บ่อยมาก ข้อมูลนี้เช็กล่าสุด (ดูวันที่ใน `learned-additions.md` ถ้ามีการอัปเดตเพิ่ม) ถ้าคำถามเกี่ยวกับฟีเจอร์ใหม่ที่ไม่อยู่ในนี้ ให้ web search ก่อนตอบ (ดูเฟส 5 ใน SKILL.md หลัก)

## กฎการใช้วงเล็บ
- **`[ ]` วงเล็บเหลี่ยม** → โครงสร้าง/สไตล์/เอฟเฟกต์เท่านั้น เช่น `[Verse, Female Vocals, Rapped, Fast-Paced Vocals]`
- **`( )` วงเล็บกลม** → เสียงร้องที่ไม่ใช่เนื้อร้องหลัก เช่น เสียงประสาน/ad-lib `(Oh-oh, oh-oh)`
- ❌ ห้ามสลับใช้ผิดแบบ ทุกแท็กในกลุ่มเดียวกันต้องอยู่ใน `[ ]` เดียว คั่นด้วยคอมมา ไม่ใช่แยกวงเล็บทีละแท็ก

## Style Formula: 9 Descriptors (ใส่ในช่อง Style prompt)
1. **Sonic Fidelity** คุณภาพเสียง
2. **Separation & Clarity** ความคมชัดแยกชั้นเสียง
3. **Frequency Balance** สมดุลความถี่
4. **Era/Production Style** ยุคสมัย/สไตล์การโปรดิวซ์
5. **Energy & Dynamics** พลังงาน/ไดนามิก
6. **Tempo & Groove/Feel** จังหวะ/ฟีล
7. **Space/Environment** บรรยากาศเสียง (Cathedral, Stadium Echo, Small Room ฯลฯ)
8. **Vocal Direction** ทิศทางเสียงร้อง (Breathy, Husky, Operatic ฯลฯ)
9. **Negative Prompt** สิ่งที่ไม่ต้องการ (Muddy, Harsh, Generic ฯลฯ)

**กติกา:** คำ 20-30 คำแรกสำคัญที่สุด ใส่คำสำคัญไว้ต้น ๆ / genre anchor สูงสุด 2 / เครื่องดนตรีระบุชื่อสูงสุด 3-4 ชิ้น / mood-energy สูงสุด 2 คำ / ยาวได้ถึง 1,000 ตัวอักษร แนะนำ 200-300 คำ

## Vocal Anchor — ตั้งเสียงนักร้องตั้งแต่ต้น
Suno ตัดสินใจคาแรกเตอร์เสียงภายใน 1-2 วินาทีแรก ต้องวางไว้บนสุดของช่องเนื้อเพลง **ก่อน** section tag ใด ๆ:
```
[Vocal: male, deep husky timbre, relaxed but intense delivery, clear diction, minimal vibrato]
```

## Phonetics — สะกดคำใหม่คุมการออกเสียง
ถ้า Suno ออกเสียงคำติดขัด ให้สะกดคำใหม่ตามเสียงที่ต้องการ เช่น `bureaucracy → byoo-ROCK-ruh-see` (ใช้บ่อยกับคำภาษาไทยที่มีเสียงเฉพาะ หรือคำยากในท่อนแร็พเร็ว)

## เครื่องหมายวรรคตอน = คำสั่งการแสดง
ในเนื้อเพลง Suno เครื่องหมายวรรคตอนไม่ใช่แค่ไวยากรณ์ แต่คือคำสั่งกำกับนักแสดง (จุดไข่ปลา = เว้นจังหวะ/ลากเสียง, ตัวพิมพ์ใหญ่ = เน้นพลัง)

## Sliders คุมผลลัพธ์
| Setting | ช่วงค่า | ผลลัพธ์ |
|---|---|---|
| Weirdness | 0-100% | ความทดลอง/คาดเดายาก |
| Style Influence | 0-100% | ความเชื่อฟัง Style prompt |
| Audio Influence (Remix) | 0-100% | สัดส่วนที่คงจากต้นฉบับ |

---

## เทคนิคขั้นเทพ 8 แบบ (เสนอให้ user เลือกใช้ตามอารมณ์เพลง ไม่ต้องยัดทุกอันพร้อมกัน)

### 1. Live Concert / Crowd Ambience
`[Intro: stadium crowd ambience, big applause, cheering, distant chanting "HEY! HEY!", stage reverb]`
ปิดท้ายด้วย `[end]` เพื่อบอก Suno ให้จบเพลงจริง ไม่ไหลต่อ

### 2. Emotion-Tag Acting
กฎเหล็ก: **1 บรรทัด = 1 อารมณ์** เขียนสั้น เช่น `[CRYING VOICE]` `[ANGRY TONE - controlled]` `[SPOKEN WORD - calm, intimate]` — ท่าไม้ตาย: เปิดเพลงด้วย Spoken Word + อารมณ์ขัดแย้งกัน (ร้องไห้+หัวเราะ) ดึงอารมณ์คนฟังทันที

### 3. Instrumental Break (Call & Response)
แทรก `[Instrumental Break - Saxophone]` กลางประโยค ให้ดนตรี "ตอบโต้" นักร้อง — เหมาะกับ Saxophone (โรแมนติก), Guitar (indie/rock), Violin (cinematic), Trumpet (soul/funk) อย่าใส่ทุกบรรทัด ใช้เฉพาะจุดเด่น

### 4. SATB Chorus Boost (คอรัสใหญ่)
ใส่เฉพาะใน `[Chorus]`: `[Chorus: multiple voice chorus SATB, layered vocals, big singalong]` — Soprano/Alto/Tenor/Bass รวมกันเป็นกำแพงเสียง **ห้ามใช้ใน Verse**

### 5. Capital Letter Emphasis
ตัวพิมพ์ใหญ่ = เน้นพลัง/อารมณ์ ไม่ใช่กรีดร้องเสมอไป ใช้ดีที่สุดใน Pre-Chorus/Bridge กฎเหล็ก 1-3 คำต่อ section พอ ใช้เยอะใน Verse จะล้า

### 6. Vocal Drone + Atmospheric Narrative
`[vocal drone] (deep resonant, airy, distant)` = เสียงมนุษย์ไม่มีเมโลดี้ชัด ยาวต่อเนื่อง ทำหน้าที่เหมือน pad/synth ให้ฟีล "เสียงในหัว/ความทรงจำ" เหมาะเป็น Intro cinematic

### 7. Build-up → Drop (แบบ EDM)
- Build-up: risers up, snare roll faster, filter opening, tension rising, crowd energy building
- Drop: FULL drums, sub bass hit hard, heavy sidechain, ตัวพิมพ์ใหญ่ (BOOM/LET'S GO)
- Build-up ต้องอยู่ก่อน Drop ทันที ห้ามคั่นด้วย Verse ยาว

### 8. Vocal Effects / Ad-libs (Onomatopoeia)
เขียนเสียงลงเนื้อเพลงตรง ๆ เช่น `[Ad-lib] CLICK!` `[Ad-lib] BOOM!` เขียน ALL CAPS สั้น 1-2 คำ วางระหว่าง/ท้ายบรรทัด อย่าใส่ถี่เกิน ใช้เป็น accent เท่านั้น

---

## Checklist ก่อนส่งให้ user ไป generate

1. Vocal Anchor อยู่บนสุดของช่องเนื้อเพลงหรือยัง
2. Style prompt ครบ 9 descriptors คำสำคัญอยู่ต้นประโยคหรือยัง
3. ทุก section มี stacked meta tag กำกับต้นท่อน (กัน Suno หลุดธีม)
4. ใส่ Negative Prompt ท้าย Style prompt แล้วหรือยัง
5. เทคนิคขั้นเทพที่เลือกใช้ตรงกับอารมณ์เพลงจริงไหม (ไม่ใช่ใส่เพราะอยากโชว์ทุกเทคนิค)
6. ปิดเพลงด้วย `[Outro]` + `[end]` ชัดเจน

## รูปแบบ output สุดท้ายที่ควรส่งให้ user
แยกเป็น 2 กล่องชัดเจน:
```
=== STYLE PROMPT (ใส่ในช่อง Style) ===
[เนื้อหา 9 descriptors]

=== LYRICS (ใส่ในช่อง Lyrics) ===
[Vocal: ...]
[Intro]
...
[end]
```
