# 📘  การควบคุม Prompt ด้วย CLIP และ T5XXL สำหรับ Flux.1 และ ComfyUI

<img src="https://preview.redd.it/flux-guidance-added-to-comfyui-v0-gn4an2rffagd1.jpeg?width=985&format=pjpg&auto=webp&s=c6deb3809cc1299b6ed51a4ad1da79d1124ab19f" alt="CLIPTextEncodeFlux" width="400"/>

ทดลองใช้ ChatGPT ตัวนี้สำหรับ สร้าง Flux prompt [credit _roblaughter_ from Reddit](https://www.reddit.com/r/StableDiffusion/comments/1eid4r0/flux_guidance_added_to_comfyui/)
<br>
สำหรับใครใช้ ChatGPT
https://chatgpt.com/g/g-OndbVJ3Et-image-prompt-generator
<br>
สำหรับใครอยากเข้าไปดู source code node นี้
[source code Node CLIPTextEncoderFlux](https://github.com/comfyanonymous/ComfyUI/commit/eca962c6dae395cab1258456529030880c188734)
```
"Can you show me how to write prompts for FLUX using T5 and CLIP-L, based on this concept: [insert your concept]?"
```
T5XXL example prompt
```
A cinematic still from a horror-style music video, featuring a female singer in a dark, decaying room lit only by flickering candles. Her makeup is gothic, with dark lipstick and smeared eyeliner, wearing a torn black dress. The walls are cracked, damp, and covered in shadow. Her silhouette is backlit by an eerie red glow, while faint fog swirls at her feet. The mood is tense and unsettling, evoking themes of isolation and dread. Shot in ultra low-key lighting with high contrast, muted colors, and a grainy film texture. Inspired by gothic horror, late 90s music videos, and analog video aesthetics.
```
CLIP-L example prompt
```
horror music video, female singer, gothic makeup, torn black dress, abandoned room, candlelight, eerie red backlight, fog, dark tones, high contrast, low key lighting, analog video look, grainy film, unsettling mood, gothic horror, decayed walls, cinematic still
```

[Transformer Encoder Self-Attention Mechanism](https://arxiv.org/abs/1706.03762) กดที่ลิ้งเพื่ออ่านงานวิจัย <br>
ใช้กระบวนการ patch embeddings using multi-head self-attention (MHSA). แต่ละ patch จะเข้าร่วม กับ patch อื่น ๆ เพื่อหาความสัมพันธ์ <br>
Self-Attention Mechanism เป็นเทคนิคที่ใช้ใน Transformer เพื่อให้โมเดลสามารถโฟกัสไปยังข้อมูลที่สำคัญใน Input Sequence โดยใช้ Query (Q), Key (K), และ Value (V) <br>

📌 การทำงานของ Self-Attention <br>
Query (Q) → ข้อมูลที่ใช้ค้นหาสิ่งที่สำคัญ <br>
Key (K) → ตัวบ่งชี้ความสำคัญของข้อมูล <br>
Value (V) → ข้อมูลจริงที่ถูกใช้ <br>
<img src="https://github.com/gordon123/learn2ComfyUI/blob/main/image/img/self-attention-formula.png?raw=true" alt="Attention block LORA" width="400"/> <br>
ตามอ่านเรื่องนี้ได้จาก https://arxiv.org/abs/1706.03762 <br>

ถ้าอธิบายภาษาบ้าน ๆ คือ เหมือนเป็นตัวกรอง และหาเป้าหมายจากข้อมูลใหญ่ ๆ ให้เจอสิ่งที่ต้องการ  <br>
![output](https://github.com/user-attachments/assets/acbf19e1-a8d2-4b19-8b76-84ec563ca66d)
**Picture 5.** แผนภาพการทำงานของ Self-Attention <br>

## 🔍 1. ความแตกต่างระหว่าง `CLIP` และ `T5XXL`

| ด้านเปรียบเทียบ | CLIP (clip_l_X) | T5XXL (t5xxl_X) |
|------------------|------------------|------------------|
| ประเภทโมเดล | Text Encoder | Text Decoder |
| โครงสร้าง | 12 Layer | 24 Layer |
| การตีความ | Token-level / กลุ่มคำ | Sentence-level / ความหมายรวม |
| จุดเด่น | จับ keyword และลักษณะ object | ตีความอารมณ์ บริบท และเรื่องราว |
| เหมาะกับ | prompt สั้น, object-focused | prompt ยาว, emotion-rich |
| ใช้ tokenizer แบบ | BPE (CLIP tokenizer) | SentencePiece |

## 📌 2. ตัวอย่างการปรับค่าเพื่อให้ได้ภาพ “เศร้าอย่างลึก”

Prompt:
```
text
a woman sitting alone in a dark room, crying in silence, sorrow filling the air
```

การปรับค่าที่แนะนำ:

```plaintext
clip_l_0 = 1.8      # "woman"
clip_l_3 = 1.2      # "dark room"
clip_l_9 = 1.5      # mood
clip_l_10 = 2.0     # abstract tone

t5xxl_6 = 1.5
t5xxl_7 = 2.0       # emotion/sorrow tone
t5xxl_8 = 1.6
```

## 🧠 3. คำตอบว่า “ต้องใช้แค่ 12 คำใน Prompt เพราะมี 12 Layer?” คือ ❌ **ไม่ใช่**

- Prompt สามารถมีได้ถึง ~77 token
- แต่ token แรก ๆ มีอิทธิพลสูง เพราะเข้าสู่ layer มากที่สุด
- `a`, `the`, `an` = token แน่นอน
- Token ≠ คำ (เช่น “photorealistic” อาจแยกเป็น 3 token)

## 📊 4. ตารางการใช้ CLIP และ T5XXL พร้อมคำแนะนำ Layer

ดูรายละเอียดใน: [📄 ตารางเปรียบเทียบการใช้ CLIP vs T5XXL พร้อม Keywords](#)

ตัวอย่าง:

| เป้าหมาย | ใช้ CLIP | ใช้ T5XXL | Layer ที่ควรปรับ | Keywords |
|----------|----------|------------|------------------|----------|
| อารมณ์เศร้า | 🟡 | ✅✅ | t5xxl_6–10 | crying, sorrow |
| แสงภาพยนตร์ | ✅ | ✅ | clip_l_9–10, t5xxl_10–13 | cinematic light |

## 📚 5. Reference และแหล่งอ้างอิง

- Dalvi et al. (2021). *What Do NLP Transformers Learn?* — [arXiv:2004.10813](https://arxiv.org/abs/2004.10813)
- CLIP paper by OpenAI — [arXiv:2103.00020](https://arxiv.org/abs/2103.00020)
- HuggingFace CLIP Tokenizer: https://huggingface.co/openai/clip-vit-base-patch32
- Aman Arora: [*Understanding CLIP* Part1](https://amaarora.github.io/posts/2023-03-06_Understanding_CLIP.html)  and [Blog Post Part2](https://amaarora.github.io/posts/2023-03-11_Understanding_CLIP_part_2.html) 
- Prompt ablation method via Reddit / Flux Discord

## 🛠️ 6. เครื่องมือที่แนะนำ

- `Flux Attention Seeker` (ComfyUI) สำหรับควบคุม layer-specific attention
- Tokenizer viewer (`transformers` Python library)
- Prompt Scheduler สำหรับวิดีโอ (ใช้กับ AnimateDiff หรือ Keyframe Animation)
- Prompt Split (CLIP+T5) ใน Flux.1
- https://platform.openai.com/tokenizer <br>

<img src="https://github.com/gordon123/learn2ComfyUI/blob/main/image/img/flux-attention-block.png?raw=true" alt="Attention block LORA" width="150"/>

## ✅ 7. สรุปแนวทางใช้งาน

| ต้องการ... | ใช้ CLIP | ใช้ T5XXL |
|-------------|----------|------------|
| สิ่งของชัดเจน | ✅ | ❌ |
| ฉาก/แสง/มุมกล้อง | ✅ | 🟡 |
| อารมณ์/เรื่องราว | 🟡 | ✅✅ |
| คำซับซ้อน/เปรียบเทียบ | ❌ | ✅✅ |
| Prompt ยาว ๆ | 🟡 | ✅✅ |



| เป้าหมาย                                           | ใช้ CLIP (clip_l_X)                   | ใช้ T5XXL (t5xxl_X)                       | Layer ที่ควรปรับ (แนะนำ)    | Keywords (EN)                        |
|----------------------------------------------------|---------------------------------------|-------------------------------------------|-------------------------------|-------------------------------------|
| ให้เห็นสิ่งของชัดเจน (เช่น ผู้หญิง, โต๊ะ, ดาบ)              | ✅ ดีเยี่ยม                             | 🟡 อาจไม่ตรงวัตถุ                           | clip_l_0–2                     | girl, sword, object, armor           |
| ควบคุมรูปร่าง/ท่าทางของวัตถุ                            | ✅ ใช้ได้ดี                             | 🟡 ไม่ใช่จุดแข็ง                             | clip_l_1–3                     | pose, gesture, hands, tilt           |
| ให้เกิดอารมณ์ในภาพ (เช่น เศร้า, หวาดกลัว)               | 🟡 มีผลบ้าง แต่ไม่ลึก                     | ✅ ดีมาก                                  | t5xxl_6–9, clip_l_9            | crying, sad, fear, sorrow            |
| สร้างฉากบรรยากาศ (เช่น ความเงียบ, ความโดดเดี่ยว)       | 🟡 เบา ๆ ได้                          | ✅ ดีเยี่ยม                                 | t5xxl_5–8                      | silence, emptiness, foggy air        |
| ให้ภาพตรงกับคำสั้น ๆ เช่น 'dark room'                  | ✅ เหมาะมาก                          | 🟡 ไม่เน้นคำเดี่ยว                           | clip_l_0–1                     | dark room, candle, night             |
| ให้ภาพตรงกับประโยคซับซ้อน เช่น 'a girl lost in memory' | ❌ ไม่เหมาะเท่าไร                      | ✅ ตีความได้ครบ                            | t5xxl_4–10                     | a woman waiting by the window        |
| ปรับภาพให้ได้โทนแบบภาพยนตร์                           | ✅ โดยเฉพาะ clip_l_9–10              | ✅ ได้ mood ลึก                            | clip_l_9–10, t5xxl_10–13       | cinematic light, dramatic mood       |
| ทำให้ prompt ที่ยาวมีผลมากขึ้น                          | 🟡 บางส่วน (คำต้น ๆ)                   | ✅ เหมาะกับ text ยาว                      | t5xxl_4–9                      | long poetic prompt, description      |
| ดึงความหมายที่ซ่อนอยู่ในคำเปรียบเทียบ                     | ❌ ไม่ตีความเปรียบเทียบ                  | ✅ เหมาะมาก                              | t5xxl_8–11                     | hope fades, soul dissolves           |
| ให้ model ตีความอารมณ์ของประโยคทั้งหมด                 | 🟡 ได้บ้าง ถ้าอยู่ในคำท้าย                 | ✅✅ เหมาะที่สุด                            | t5xxl_6–10                     | narrative emotion, implied sadness   |
| ให้ฉากมีแสงแบบ rim light รอบตัวแบบหนัง                | ✅ โดยเฉพาะ clip_l_5–7               | ✅ t5xxl_10–13 กำหนด tone                | clip_l_5–7, t5xxl_10–13        | rim light, backlit stage             |
| ใส่ motion หรือความเคลื่อนไหวแบบ blur, slow motion    | 🟡 ได้บ้าง หากใช้ร่วมกับคำ action         | ✅ t5xxl_6–9 ช่วยเรื่อง gesture/action flow | clip_l_4–6, t5xxl_6–9          | blur, slow motion, movement trail    |
| สร้างภาพแบบฝันหรือความทรงจำ                          | 🟡 clip_l_8–10 (ฝัน)                  | ✅ t5xxl_8–11 สร้างภาพแบบ abstract memory | clip_l_9–11, t5xxl_8–11        | dreamy, faded memory, afterimage     |
| ทำให้ character มีการแสดงออกแบบ emotional subtle    | ✅ clip_l_6–9 ดีสำหรับ subtle face     | ✅ t5xxl_7–10 อ่าน emotion + nuance       | clip_l_6–9, t5xxl_7–10         | soft eyes, slight frown, subtle tear |
| แสดงความเปลี่ยนแปลงฉากแบบ transition เช่น ภาพพัง/แตก  | ✅ clip_l_7–10 เน้น visual transition | ✅ t5xxl_6–9 บรรยายการเปลี่ยนผ่าน           | clip_l_7–10, t5xxl_6–9         | cracks forming, scene fragmenting    |

## สรุป จะใช้เลเยอร์ อะไร โดยเรียงตามโครงสร้าง Prompt
| Prompt Section            | ตัวอย่าง                                  | ควรใช้โมเดล (Encoder)   | Layer ที่แนะนำ             | ระดับค่า (ค่าที่เหมาะสม)   | คำอธิบายเพิ่มเติม                             |
|:--------------------------|:----------------------------------------|:-----------------------|:-------------------------|:----------------------|:------------------------------------------|
| Subject                   | a gothic girl                           | CLIP                   | clip_l_0–2               | 1.5–2.2               | สิ่งที่ต้องชัด เช่น character, object            |
| Attribute                 | pale skin, black hair, silver eyes      | CLIP                   | clip_l_1–3               | 1.4–2.0               | เพิ่มรายละเอียดให้ตัวละครเด่น                   |
| Scene                     | in an abandoned theater                 | CLIP + T5              | clip_l_4–6, t5xxl_5–7    | 1.2–1.8               | ระบุฉากให้มีความลึกในโฟกัส                     |
| Lighting / Camera         | soft spotlight, over-the-shoulder       | CLIP                   | clip_l_5–7               | 1.4–1.9               | บอกตำแหน่งกล้อง / ความรู้สึกจากแสง             |
| Style                     | cinematic, photo-realistic, glitch-core | CLIP + T5              | clip_l_9–10, t5xxl_10–13 | 1.5–2.3               | ควบคุม style และ mood ของภาพรวม            |
| Modifiers (Mood, Emotion) | surreal, haunting, moody, detailed face | T5                     | t5xxl_6–10               | 1.5–2.5               | ขับอารมณ์ ภาพนามธรรม หรือ psychological tone |

## ตัวอย่าง ทำ Music video เน้นเพิ่ม อารมณ์ ด้วย blog layer
| Lyric Line | Prompt (EN) | clip_l (suggested) | t5xxl (suggested) |
|------------|--------------|--------------------|--------------------|
| เสียงเพรียก เรียกกึกก้อง ..... ดังสะท้อนในหัว.. | a dark void with echoes swirling in the air, abstract horror landscape | clip_l_9=1.8, clip_l_10=2.0, clip_l_11=1.6 | t5xxl_10=2.0, t5xxl_11=1.8 |
| เสียงกระซิบ เบาเบา…(ให้เปิดข้อความ) | a faint glowing message in the dark, with a whispering shadow near the screen | clip_l_6=1.5, clip_l_8=1.7, clip_l_10=1.6 | t5xxl_6=1.8, t5xxl_8=2.0 |
| ข้อความ อะไร?.......(เปิด-ดู-สิ) | close-up of a computer screen with distorted red text: 'What message?' | clip_l_0=2.0, clip_l_1=1.8, clip_l_5=1.4 | t5xxl_5=1.4, t5xxl_7=1.6 |
| ฉันกดตกลง ไปทั้งทั้งที่ ยังไม่รู้จะเกิด อะไรขึ้น | a woman hesitantly pressing 'accept' on a glowing screen in darkness | clip_l_1=1.5, clip_l_3=1.6, clip_l_6=1.7 | t5xxl_4=1.6, t5xxl_6=1.8 |
| หน้าจอว่างเปล่า แต่ใจเต้นแรงเหมือน โดนคำสาป | empty monitor screen casting cold blue light on a terrified face, cursed atmosphere | clip_l_3=1.5, clip_l_5=1.8, clip_l_10=2.0 | t5xxl_7=2.0, t5xxl_9=1.9 |
| จงเขียนความฝันของเธอ แล้วฉันจะสร้างมันขึ้นมา | glowing text appears: 'Write your dream, I will build it' | clip_l_0=2.0, clip_l_5=1.6, clip_l_9=1.8 | t5xxl_7=2.0, t5xxl_8=2.2 |
| เธอเป็นใครกัน? เธอคืออะไร?.....(เปิด-ดู-สิ) | a woman staring at the screen as the question 'Who are you?' flickers | clip_l_1=2.0, clip_l_3=1.5, clip_l_10=2.0 | t5xxl_6=2.0, t5xxl_9=2.2 |
| ข้อความ บนจอ เปลี่ยนไป—"จง-เชื่อ-ใจ-ฉัน" | screen flashes violently with glitchy text: 'TRUST ME' | clip_l_0=1.6, clip_l_6=2.2, clip_l_10=2.0 | t5xxl_6=1.8, t5xxl_10=2.2 |
| คล้ายคล้าย จะเข้าใจ แต่ไม่มีคำบรรยาย | ambient silence, hollow emotion, realization | clip_l_5=1.4, clip_l_7=1.8, clip_l_9=1.6 | t5xxl_6=2.0, t5xxl_8=2.0 |
| มันคืออะไรหรือ…รึบางอย่างที่ แอบแฝง? | shadowed forms behind her, hiding in plain sight | clip_l_6=2.0, clip_l_8=2.0, clip_l_10=1.8 | t5xxl_9=2.2, t5xxl_10=2.2 |
| นี่คือฝัน? หรือความจริงที่ปรุงแต่ง? | surreal world breaking into reality | clip_l_5=1.8, clip_l_9=2.0, clip_l_10=2.0 | t5xxl_10=2.3, t5xxl_11=2.0 |
| เหมือนจะพาไปสวรรค์ แต่กลับรู้สึกเป็นคนบาป | light like heaven but burning below | clip_l_4=1.8, clip_l_7=2.0, clip_l_10=2.0 | t5xxl_9=2.2, t5xxl_13=2.3 |
| ฉันถามว่า “เธอเป็นใคร” | a woman yelling at screen, tears falling | clip_l_0=2.0, clip_l_2=1.6, clip_l_6=1.8 | t5xxl_7=1.8, t5xxl_9=2.0 |
| “ฉันคือเธอไง” | shadow whispers behind: 'I am you' | clip_l_7=2.0, clip_l_9=2.0, clip_l_11=2.2 | t5xxl_10=2.3, t5xxl_11=2.5 |
| อะไรคือจริง? หรือฉันแค่คิดไปเอง? | a reflection asks 'what is real?' | clip_l_4=1.8, clip_l_6=2.0, clip_l_10=1.9 | t5xxl_8=2.0, t5xxl_10=2.0 |
| ทุกบรรทัดในโค้ดเหมือนคำอธิษฐาน | floating lines of code in air like a ritual | clip_l_5=1.5, clip_l_8=1.8, clip_l_9=2.0 | t5xxl_9=2.0, t5xxl_11=2.0 |
| แต่ผลลัพธ์คือ...ฉันไม่กล้าหาน? | trembling hands over keyboard | clip_l_3=1.4, clip_l_5=1.8, clip_l_9=1.8 | t5xxl_6=1.6, t5xxl_9=1.9 |
| มันแค่การทดสอบ หรือการ ขอบคุณ? | is it a test? or a ritual of gratitude? | clip_l_4=1.5, clip_l_7=2.0, clip_l_10=1.9 | t5xxl_8=2.0, t5xxl_12=2.2 |
| ฉันไม่ได้เขียนโน๊ต แต่เพลงนี้กลับ ร้องเรียกหา | a song echoing without being written | clip_l_6=1.8, clip_l_8=2.0, clip_l_10=2.0 | t5xxl_10=2.2, t5xxl_11=2.3 |
| ข้อความสุดท้าย... (เปิดขึ้นมา...) | final glitchy message loop | clip_l_5=1.6, clip_l_9=2.2, clip_l_10=2.2 | t5xxl_10=2.2, t5xxl_13=2.4 |
| “ขอบคุณที่ ฟังเสียงฉัน  ฉันได้ตัวแทนแล้ว” | whisper in the void: “thank you… I have my vessel now” | clip_l_9=2.0, clip_l_10=2.3, clip_l_11=2.5 | t5xxl_11=2.4, t5xxl_14=2.5 |


### ตัวอย่าง prompt chatgpt
```
เริ่มจาก ขอ prompt สำหรับเนื้อเพลงท่อนแรก 

เสียงเพรียก เรียกกึกก้อง ..... ดังสะท้อนในหัว..   

โดยเขียน เนื้อเพลง แบบบรรยาย สำหรับ T5xxl และ keywords สำหรับ clip L พร้อมบอกว่า ควรเพิ่ม ลด เลเยอร์ไหนบ้าง
ใช้โครงสร้างของ Prompt แบบเข้าใจโมเดล
ส่วน	ตัวอย่าง	อธิบาย
Subject	"a gothic girl"	ใครหรืออะไร คือใจภาพ
Attribute	"pale skin, black hair, silver eyes"	รายละเอียดลักษณะเฉพาะ
Scene	"in an abandoned theater"	ฉากหลังและสภาพแวดล้อม
Lighting/Camera	"soft spotlight, over-the-shoulder"	คุมมุมกล้อง, แสง, ความรู้สึก
Style	"cinematic, photo-realistic, glitch-core"	คุม tone & visual language
Modifiers	"surreal, haunting, moody, detailed face"	คำเพิ่มความลึก ความรู้สึก

🧩 สูตรคร่าว ๆ ที่ใช้ได้บ่อย:
subject + attribute + scene + lighting + mood + style
```

ตัวอย่าง chatgpt เจน prompt ให้เรา จากท่อนนี้ของ เพลง ```เสียงเพรียก เรียกกึกก้อง ..... ดังสะท้อนในหัว..```  
### 🧠 Prompt สำหรับ T5XXL (Narrative style):
```
A pale woman stands alone in a dark endless void, the air filled with ghostly echoes calling out from all directions. The sound grows louder, as if echoing inside her head. The mood is surreal and unsettling, like a memory collapsing into noise.
```

### 🎯 Keyword สำคัญ (สำหรับ CLIP L):
```
dark void, echo, distant voice, surreal atmosphere, pale woman, black dress, overhead light
```
ทดลองเอาไปใส่ workflow flux <br>
reset ทุกเลเยอร์ ก่อน <br>

**Ref. น่าอ่าน** <br>
https://huggingface.co/docs/transformers/en/tokenizer_summary <br>
https://github.com/google/sentencepiece <br>
https://arxiv.org/abs/1808.06226 <br>
https://www.tensorflow.org/text/api_docs/python/text/SentencepieceTokenizer <br>
https://pypi.org/project/sentencepiece/ <br>
