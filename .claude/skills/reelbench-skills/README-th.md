# reelbench-skills

*[English](README.md)*

โค้ช cinematic-continuity และตัวจัดเส้นทาง (router) สำหรับกลุ่ม skill เขียน prompt วิดีโอ AI
ในโปรเจกต์นี้ ตัวมันเองไม่ได้เขียน prompt MiniMax H3 หรือ Seedance เอง — แต่ทำหน้าที่
บรีฟ skill เหล่านั้นด้วยหลักไวยากรณ์ภาพจริงที่เรียนรู้มาจากฟุตเทจอ้างอิง แล้ว QA ผลลัพธ์
ของมันก่อนที่คุณจะเสีย render credit ไปกับมัน

## ใช้เมื่อไหร่

- คุณมีฟุตเทจอ้างอิง (คลิป, ซีนจากหนัง, mood reel) และต้องการเอาภาษาภาพของมัน
  ("ตัดแบบนี้") ไปใช้กับ prompt ใหม่
- คุณกำลังจะเขียน prompt แบบหลาย shot และต้องการให้มี continuity (ตัวละครที่กลับมาซ้ำ,
  แสง/สีสม่ำเสมอ, จังหวะตัดที่เข้ากัน) แทนที่จะเขียนแต่ละ shot แบบแยกส่วน
- คุณไม่แน่ใจว่าจะส่งซีนไปทาง MiniMax H3 หรือ Seedance
- คุณมี shotlist/prompt อยู่แล้วและต้องการให้ตรวจสอบก่อน generate
- คุณมีทั้งคลิปอ้างอิงและคลิปที่ skill ปลายทาง generate ออกมาจริง และต้องการเช็คว่า
  ตรงกับที่ตั้งใจไว้แค่ไหน
- คุณมีคลิปที่ generate แล้วและอยากให้วิเคราะห์แบบ shot-by-shot — งานนี้จะได้ HTML
  report แบบคลิกดูได้เสมอ (ดู `references/comparison-report-guide.md`) ไม่ใช่คำตอบ
  แบบข้อความล้วน เว้นแต่คุณจะขอสรุปแบบปากเปล่าสั้น ๆ ตรง ๆ

ข้ามการใช้ skill นี้ถ้าแค่ต้องการ prompt เดียวจบ ไม่มีเรื่อง continuity หรือฟุตเทจอ้างอิง
ให้ไปที่ skill ปลายทางที่เกี่ยวข้องตรง ๆ ได้เลย

## Workflow (ดู `SKILL.md` สำหรับรายละเอียดเต็ม)

1. **Learn (เรียนรู้)** — ถ้ามีฟุตเทจอ้างอิง ให้วัดด้วย ffprobe/ffmpeg
   (`references/footage-analysis-guide.md`) แล้วแปลงเป็น Continuity & Style Brief,
   narrative-rhythm map, camera-emotion read และ — สำหรับซีนแอ็กชัน/ต่อสู้ —
   การอ่าน pacing/damage-continuity
2. **Route (จัดเส้นทาง)** — กำหนด duration และ aspect ratio ให้ชัดเจนก่อนเสมอ จากนั้น
   นับจำนวน shot จาก story beat จริงของฉาก (ห้ามยึดตาราง duration→shot-count ทั่วไปของ
   skill ปลายทางเป็นจุดตั้งต้น — prompt จริงในโปรเจคนี้ใช้ 5 กับ 6 shot กับสองฉากที่
   โครงสร้างต่างกันชัดเจน แต่ตัวเลขทั้งคู่ดันอยู่ในช่วง "~15s → 5-6 shots" ของ
   `minimax-h3-prompt-writing` พอดี ซึ่งเป็นสัญญาณว่ายึดตารางแทนที่จะนับจาก beat จริง)
   แล้วส่งต่อไปยัง skill ปลายทางที่ถูกต้อง (`references/routing-matrix.md`) พร้อม brief, rhythm
   map และ camera-emotion pairing เป็นคำสั่งรูปธรรมต่อ shot ก่อนส่ง draft ให้ user —
   ทุกครั้ง ไม่ใช่แค่ตอนถูกขอ — ต้องรัน `scripts/validate_shotlist.py` สำหรับ 6
   deterministic gate (duration ซ้ำติดกัน, duration รวมเทียบกับ platform, บทพูดพอดีกับ
   ความยาว shot, ความบริสุทธิ์ของภาษา, จำนวนตัวละครสูงสุดในเฟรม, beat coverage — ดู
   `references/shot-manifest-convention.md`) แล้วแก้ทุกจุดที่มันเจอ — นี่คือ gate
   ก่อนส่ง ไม่ใช่ QA หลัง generate — prompt จริงในโปรเจคนี้มีบั๊กเชิงโครงสร้าง 2 จุด
   (duration ของ shot ชนกัน, บทพูดยาวเกิน shot) ค้างอยู่ตลอด 6 รอบการแก้ไข ก่อนจะมี
   ใครรัน script จริงๆ
3. **QA** — พอมีคลิปที่ generate จริงแล้ว ไล่ 15 qualitative gate ที่เหลือ
   (`references/quality-gates.md`) บวก rhythm-fidelity, camera-emotion-fidelity และ
   (สำหรับซีนแอ็กชัน) การเช็ค pacing/damage
4. **Report (รายงาน)** — พอมีคลิปที่ generate จริงแล้ว ให้สร้าง before/after (หรือ
   single-clip) HTML report เป็น Artifact: คลิปเล่นได้, กราฟ scene-change ต่อเฟรม,
   ตาราง shot-by-shot และคำตัดสิน prompt-fidelity

## ไฟล์อ้างอิง

| ไฟล์ | ใช้ทำอะไร |
|---|---|
| `footage-analysis-guide.md` | คำสั่ง ffprobe/ffmpeg จริงสำหรับตรวจจับขอบเขต shot, สถิติต่อ shot, การสุ่มเฟรม และรูปแบบตารางข้อมูลต่อ shot ที่ใช้ในรายงาน |
| `quality-gates.md` | checklist continuity 15 ข้อที่ผลลัพธ์จาก skill ปลายทางต้องผ่าน |
| `routing-matrix.md` | skill ปลายทางไหน (กลุ่ม MiniMax H3 หรือกลุ่ม Seedance) เหมาะกับงานแบบไหน |
| `narrative-rhythm.md` | ระบบแท็ก 8 ตัว (hook/setup/escalation/beat/pivot/payoff/breath/closure) สำหรับหน้าที่ของแต่ละ shot ใน sequence |
| `camera-emotion.md` | คำศัพท์มุมกล้อง/การเคลื่อนกล้อง/เลนส์ที่แม่นยำ ผูกกับอารมณ์ที่ shot นั้นต้องสื่อ — ไม่ใช้คำกำกวมอย่าง "side-angle" |
| `action-sequence-craft.md` | กฎเรื่อง pacing ที่ไม่สม่ำเสมอโดยตั้งใจ, ความเสียหายของสภาพแวดล้อมที่ต้องสะสมต่อเนื่อง, cumulative drift, causal-order inversion และ combat-context bleed สำหรับซีนต่อสู้/ทำลายล้างโดยเฉพาะ |
| `micro-expression-physics.md` | การบรรยาย beat ที่มีอารมณ์หรือการหลบเลี่ยงเป็น physical reflex chain แบบไม่สมมาตร แทนคำ mood label หรือ negative constraint เปล่า ๆ — วิธีแก้ beat ที่มักเรนเดอร์ออกมาเป็นภาพนิ่งค้าง |
| `comparison-report-guide.md` | โครงสร้างเต็มของ before/after หรือ single-clip HTML report (player, กราฟ scene-change, ตาราง shot, คำตัดสิน fidelity) |
| `shot-manifest-convention.md` | ข้อตกลง `SCRIPTED_DURATION:` และ beats-manifest ที่ validator แบบ deterministic ต้องใช้ พร้อมคำอธิบายว่าทำไม gate ทั้ง 6 ตัวเช็คอะไรและทำไม |
| `h3-official-spec-corrections.md` | บั๊ก syntax เชิงโครงสร้าง 3 อย่างที่ยืนยันแล้วตรงกับ official spec ของ MiniMax H3 เอง — ไม่มี field "Negative constraints" แยก, `retention_analysis` ต้องเป็น comma-list ไม่ใช่ dash-range, ประโยค style ของ Ref2VA ต้องอยู่ก่อน `[Shot 1]` |
| `path-annotated-reference-images.md` | วิธีแก้ที่ยืนยันแล้ว (หลังจากลอง 3 รอบ) สำหรับภาพอ้างอิงที่มีเส้น path/ลูกศร/waypoint วาดทับตัวแบบอยู่ — ห้ามเอ่ยถึงเส้นนั้นใน `subject_definitions`/`retention_analysis` เลยแม้แต่คำเดียว และต้องเขียนคำห้าม "ห้ามเห็นตัวสิ่งมีชีวิตที่เป็น POV" แยกจากคำห้ามเรื่องเส้น |
| `action-beat-defaults.md` | 3 บั๊กที่เกี่ยวกันจากการเจนครั้งเดียว พร้อมผลตอนเจนซ้ำ — beat ท้ายๆที่สั่ง "หันหลังเดิน กล้องยังจับหน้าตัวเอง" กลับเรนเดอร์เป็นช็อต third-person ทั่วไปแทน — **ยืนยันแก้สำเร็จแล้ว** ด้วยการระบุ shot type ซ้ำตรง beat นั้นเลย; "จักรยาน" กลายเป็นคนขับมอเตอร์ไซค์สวมหมวกกันน็อค — **ยืนยันแก้สำเร็จแล้ว** ด้วยการระบุสิ่งที่มันต้องไม่มี; คำสั่ง style แบบ "กล้อง camcorder ย้อนยุค" ไม่มีผลต่อภาพเลยทั้งคลิป — **แก้ได้บางส่วน** การผูก texture cue แต่ละอันเข้ากับ beat/วัตถุเฉพาะเจาะจงได้ผล แต่ประโยค style ทั่วไปอย่างเดียวยังไม่ได้ผล |
| `multi-pose-fashion-sequence.md` | 3 บั๊กจากหนังแฟชั่น 4 ตอน 20 ท่า — beat ที่ค้างนานเกินสคริปต์ทำให้ pose ถัดไปหายไปทั้ง pose ไม่ใช่แค่ล่าช้า; ของที่ไม่มีอยู่ในภาพอ้างอิง (รองเท้า) ถูกเดาไม่ซ้ำกันใน 3 ช็อต; การต่อคลิปแบบ "seamless" ด้วยคำบรรยายอย่างเดียวระหว่าง 2 การเจนแยกกัน ได้ผลแค่จุดเดียวไม่ใช่ทุกจุด ยืนยันว่าต้องใช้ last-frame `<Picture N>` จริงถึงจะต่อเนื่องแบบเป๊ะ |
| `character-reveal-montage.md` | รูปแบบ shot สำหรับ intro/เปิดตัวตัวละคร (นำเข้ามาจากภายนอก ไม่ได้มาจากประวัติโปรเจคนี้เอง) — ซ่อนใบหน้าไว้เป็น open loop จนถึง shot เดียวที่เป็น payoff, เขียนเป็นการเคลื่อนไหวเดียวต่อเนื่องแล้วสไลซ์ตามส่วนร่างกายเพื่อกัน body state รีเซ็ตข้าม cut, match cut ผ่านรูปทรง/motion vector, และจังหวะกล้องที่จงใจไม่สม่ำเสมอระหว่าง locked กับ dynamic |
| `rapid-transformation-intro.md` | รูปแบบเปิดฉากแบบเปลี่ยนโลก/ลุคเร็วหลายจังหวะ (นำเข้ามาจากภายนอก ไม่ได้มาจากประวัติโปรเจคนี้) — เปลี่ยนชุด+โลเคชัน+composition พร้อมกันทุก beat, กฎห้ามใช้สไตล์ตัวอักษรซ้ำ, ชื่อ 2 ภาษาต่อ beat ที่ผูกกับ mood, และ finale collage ที่ดึงภาพทุก beat ก่อนหน้ากลับมา |
| `combat-environment-reactivity.md` | VFX ของฉากต่อสู้ (แสงเรือง, การกระแทก, ระเบิด) ควรส่องสว่างใส่ environment รอบตัวอย่างไร — เอฟเฟกต์เป็นแสง motivated/practical, ควัน/ฝุ่นเป็น medium ที่แสงพุ่งผ่าน, เศษซากเป็นอนุภาคนับได้ทีละชิ้น, เงาสั่นไหวตามเอฟเฟกต์, Light Flash ตอน peak impact, และ bounce light สะท้อนไปยังพื้นผิวใกล้เคียง — ใช้ชื่อเทคนิกจริงจาก `melies-cinematic-library` แยกจากเรื่องความเสียหายที่ต้องคงอยู่ (`action-sequence-craft.md`) และโครงสร้างภายในของเอฟเฟกต์เดี่ยวๆ (`minimax-h3-prompt-writing`) |

`scripts/validate_shotlist.py` คือตัว validator แบบ deterministic เอง — รันตรง ๆ
(`python3 scripts/validate_shotlist.py --platform h3|seedance PROMPT.md`) ก่อนไล่
qualitative gate เสมอ

## ตัวอย่าง (Examples)

`examples/` เก็บ prompt/report จริงจากการ generate จริง ไว้เป็นตัวอย่างอ้างอิง ไม่ใช่
เอกสารที่ต้องเชื่อตามทุกจุด — ดู `examples/README.md` ว่ามีอะไรอยู่บ้างและทำไม

## หมายเหตุการดูแลรักษา

ไฟล์นี้กับ `README.md` (ภาษาอังกฤษ) ต้องอัปเดตคู่กันเสมอ — เวลามีการแก้ไขไฟล์ใดไฟล์หนึ่ง
ต้องอัปเดตอีกไฟล์ในการเปลี่ยนแปลงเดียวกัน ไม่ปล่อยให้ตามหลังทีหลัง

## Credits

รูปแบบตารางข้อมูลต่อ shot ใน `footage-analysis-guide.md` §6 (แยก field ที่วัดด้วยโค้ด
ออกจาก field ที่ตีความ, label หมวดหมู่ที่ต้องมีหลักฐานอ้างอิง, ข้อตกลง frame-pair ที่
15%/85%) และชุดแท็ก narrative-rhythm ใน `narrative-rhythm.md` ดัดแปลงมาจาก field
convention และคำศัพท์ rhythm ที่บันทึกไว้ใน
[eternityspring/reelbench-skills](https://github.com/eternityspring/reelbench-skills)
(โดยเฉพาะเครื่องมือ `skills/video-shots` ของโปรเจกต์นั้น) — ให้เครดิตโปรเจกต์นั้นสำหรับ
วิธีการดั้งเดิมที่ reference นี้สร้างต่อ

Deterministic gate ทั้ง 6 ตัวใน `shot-manifest-convention.md` และ
`scripts/validate_shotlist.py` (duration ซ้ำติดกัน, duration รวมเทียบกับ platform,
บทพูดพอดีกับ shot, ความบริสุทธิ์ของภาษา, จำนวนตัวละครสูงสุดในเฟรม, และข้อตกลง "cuts
claim beats" สำหรับ beat coverage) ดัดแปลงมาจาก code-enforced validation gate ใน
[eternityspring/shuohao-skills](https://github.com/eternityspring/shuohao-skills)
(โดยเฉพาะคำสั่ง `validate` แบบ 17-gate ของ `novel-storyboard`) — สรุปทั่วไปจาก
`storyboard.json` แบบมีโครงสร้างของโปรเจกต์นั้น มาเป็น prompt แบบ prose อิสระของ MiniMax
H3 / Seedance ที่ skill ปลายทางของโปรเจกต์นี้เขียนจริง
