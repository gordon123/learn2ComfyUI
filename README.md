## ห้องสมุดส่วนตัวเล็ก ๆ สำหรับเรียนรู้ ComfyUI 🎨

อ่านสรุปบทความเกี่ยวกับ Generative AI ได้ที่ [หน้า Wiki](https://github.com/gordon123/learn2ComfyUI/wiki)
📺 My YouTube Channel: [@iimate2485](https://www.youtube.com/@iimate2485)
📚 [บทเรียนทั้งหมด (docs)](docs/00-index.md)

ใครอยากให้ทำคลิปสอนการใช้อะไร ทิ้งข้อความได้ที่ [หน้าเฟสบุค iimate24](https://www.facebook.com/iimate24/) เด้อ DM มาบางทีไม่เห็น เพราะไม่ได้เป็นเพื่อน

☕ สามารถ support ค่ากาแฟได้ที่ <a href="https://ko-fi.com/iimate24"><img src="https://raw.githubusercontent.com/gordon123/learn2ComfyUI/main/image/img/kofi_symbol.png" alt="Donate" width="70"></a>

---

## 📑 สารบัญ

- [▶️ Playlist แนะนำ](#️-playlist-แนะนำ)
- [⭐ Custom Node จำเป็น (ต้องลงก่อนเลย)](#-custom-node-จำเป็น-ต้องลงก่อนเลย)
- [🖼️ Image Edit & Retouch](#️-image-edit--retouch)
- [🧑 Character Consistency](#-character-consistency)
- [🎬 Video & Animation](#-video--animation)
- [🔊 Audio](#-audio)
- [🧠 LLM / VLM (caption, prompt generator)](#-llm--vlm-caption-prompt-generator)
- [⚙️ Model Optimization (Nunchaku)](#️-model-optimization-nunchaku)
- [🧰 Tools เบ็ดเตล็ด](#-tools-เบ็ดเตล็ด)
- [✍️ คลัง Prompt](#️-คลัง-prompt)

---

## ▶️ Playlist แนะนำ

การใช้ ComfyUI ทั่วไป — ผมไม่มีสอน ไม่มีเปิดคอส ใครเอาคลิปไปแอบอ้างไม่ใช่ผมเด้อ มีแค่ YouTube

| ปี | หัวข้อ | ลิงก์ |
|---|---|---|
| 2025 | การใช้ ComfyUI ทั่วไป | [เปิด playlist](https://www.youtube.com/playlist?list=PLSPWSpkmItyKRoaAHRMbXVf70yb_2utLi) |
| 2025 | หัด animation ด้วย WAN series | [เปิด playlist](https://www.youtube.com/playlist?list=PLSPWSpkmItyLFCZBAXi4YSLHC9xBx5h6t) |
| 2026 | การใช้ ComfyUI ทั่วไป | [เปิด playlist](https://www.youtube.com/playlist?list=PLSPWSpkmItyIdj0d0IKJf7As3SqikPjry) |

---

## ⭐ Custom Node จำเป็น (ต้องลงก่อนเลย)

| Node | ลิงก์ |
|---|---|
| ComfyUI-Manager | จัดการติดตั้ง/อัปเดต custom node ทั้งหมด |
| comfyui_controlnet_aux | [GitHub](https://github.com/Fannovel16/comfyui_controlnet_aux) |
| ComfyUI Impact Pack | [GitHub](https://github.com/ltdrdata/ComfyUI-Impact-Pack) |
| rgthree-comfy | [GitHub](https://github.com/rgthree/rgthree-comfy) |
| ComfyUI-Easy-Use | [GitHub](https://github.com/yolain/ComfyUI-Easy-Use) |
| ComfyUI-KJNodes | [GitHub](https://github.com/kijai/ComfyUI-KJNodes) |
| ComfyUI-Florence2 | [GitHub](https://github.com/kijai/ComfyUI-Florence2) |
| comfyui-portrait-master | [GitHub](https://github.com/florestefano1975/comfyui-portrait-master) |
| cg-use-everywhere | [GitHub](https://github.com/chrisgoringe/cg-use-everywhere) |
| Comfyui_TTP_Toolset | [GitHub](https://github.com/TTPlanetPig/Comfyui_TTP_Toolset) |
| comfyui-ollama | [GitHub](https://github.com/stavsap/comfyui-ollama) |
| Flux-Prompt-Generator | [GitHub](https://github.com/fairy-root/Flux-Prompt-Generator) |
| ControlAltAI_Nodes | [GitHub](https://github.com/gseth/ControlAltAI-Nodes) |
| KayTool | [GitHub](https://github.com/kk8bit/kaytool) |
| ComfyUI-WildPromptor | [GitHub](https://github.com/1038lab/ComfyUI-WildPromptor) |
| ComfyUI-TeaCache | [GitHub](https://github.com/welltop-cn/ComfyUI-TeaCache) |
| ComfyUI_Custom_Nodes_AlekPet Translate | [GitHub](https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet) |

---

## 🖼️ Image Edit & Retouch

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI-Photopea | เปิดเว็บ Photopea ใน load image | [GitHub](https://github.com/coolzilj/ComfyUI-Photopea) |
| ComfyUI_LayerStyle | layer effect แบบ Photoshop | [GitHub](https://github.com/chflame163/ComfyUI_LayerStyle) |
| ComfyUI-DDColor | ลงสีภาพขาวดำอัตโนมัติ | [GitHub](https://github.com/kijai/ComfyUI-DDColor) |
| Qwen-Image-Edit-F2P | แก้ไขภาพด้วย Qwen Image Edit | [Hugging Face](https://huggingface.co/DiffSynth-Studio/Qwen-Image-Edit-F2P) |
| Qwen Image Edit 2511 – Interaction node | 🔥 แนะนำต้องมีเลย ขอร้อง | [GitHub](https://github.com/jtydhr88/ComfyUI-qwenmultiangle) |
| qwen image edit advance | ช่วย Qwen Image Edit ทำ inpaint | [GitHub](https://github.com/lrzjason/Comfyui-QwenEditUtils) |
| comfyui-upscale-by-model | upscale ด้วยโมเดล upscaler | [GitHub](https://github.com/TheBill2001/comfyui-upscale-by-model) |
| ComfyUI-SeedVR2_VideoUpscaler | upscale วิดีโอด้วย SeedVR2 | [GitHub](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) |
| UniLumos ใน ComfyUI | re-light วิดีโอ | [YouTube demo](https://www.youtube.com/watch?v=5ik6tPs6Yq8) |
| LatentUtils HFEPostProcessor | ปรับรายละเอียดภาพ เหมาะกับ highres fix | [GitHub](https://github.com/lrzjason/Comfyui-LatentUtils) |
| Image compression Jpeg | ย่อขนาดไฟล์ตอน upscale | [GitHub](https://github.com/KookYn9404/KOOK_ImageCompression) |

</details>

---

## 🧑 Character Consistency

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI_StableHair_ll | คงลักษณะทรงผมให้เหมือนเดิม | [GitHub](https://github.com/lldacing/ComfyUI_StableHair_ll) |
| comfyui-portrait-master | ควบคุม portrait ให้หน้าคงที่ | [GitHub](https://github.com/florestefano1975/comfyui-portrait-master) |
| Grounded SAM2 | segment วัตถุแบบแม่นยำ | [GitHub](https://github.com/neverbiasu/ComfyUI-SAM2) |
| Grounded-SAM-2 (เปเปอร์) | อ่านต้นฉบับงานวิจัย | [GitHub](https://github.com/IDEA-Research/Grounded-SAM-2) |
| Segment Anything (Kijai) | segment ภาพทั่วไป | [GitHub](https://github.com/kijai/ComfyUI-segment-anything-2) |

</details>

---

## 🎬 Video & Animation

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI-Frame-Interpolation | เพิ่มเฟรมให้วิดีโอลื่นขึ้น | [GitHub](https://github.com/Fannovel16/ComfyUI-Frame-Interpolation) |
| ComfyUI-GIMM-VFI | frame interpolation อีกตัว | [GitHub](https://github.com/kijai/ComfyUI-GIMM-VFI) |
| Smooth Mix Wan 2.2 | เทคนิค mix สำหรับ WAN 2.2 i2v/t2v 14B | [Civitai](https://civitai.com/models/1995784/smooth-mix-wan-22-i2vt2v-14b) |
| FlashSVR (KJ) | เร่งความเร็ว video upscaler | — |
| StoryBoardDiffusion | สร้าง storyboard อัตโนมัติ | [GitHub](https://github.com/smthemex/ComfyUI_StoryDiffusion) |
| ComfyUI_FlashVSR (smthemex) | video super-resolution แบบเร็ว | [GitHub](https://github.com/smthemex/ComfyUI_FlashVSR) |
| ComfyUI-FlashVSR (1038lab) | video super-resolution | [GitHub](https://github.com/1038lab/ComfyUI-FlashVSR) |
| ComfyUI-FlashVSR_Ultra_Fast | เวอร์ชันเร็วขึ้นอีก | [GitHub](https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast) |
| Wan22FMLF | เครื่องมือเสริมสำหรับ WAN 2.2 | [GitHub](https://github.com/wallen0322/ComfyUI-Wan22FMLF) |
| Bindweave-KJ | เครื่องมือ workflow วิดีโอ | [Hugging Face](https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/tree/main/Bindweave) |
| สร้าง MV ด้วย LTX2.3 อัตโนมัติ | workflow สร้าง Music Video ด้วย LTX 2.3 | [Hugging Face](https://huggingface.co/vrgamedevgirl84/LTX_2.3_Music_Video_Creator_ComfyUI) |
| เครื่องมือสร้าง Video | รวม tool สร้างวิดีโอ | [GitHub](https://github.com/WhatDreamsCost/WhatDreamsCost-ComfyUI) |
| รวมมิตร LTX2.3 | รวม resource LTX 2.3 | [GitHub](https://github.com/wildminder/awesome-ltx2) |
| เครื่องมือช่วยต่อคลิป Minimax H3 | เชื่อมหลายคลิปสำหรับ Minimax H3 | [GitHub](https://github.com/NikoDemon80/ComfyUI-H3-Motion-Context) |
| Node ช่วยต่อ Minimax H3 (prompt ง่ายขึ้น) | ต่อ prompt Minimax H3 ให้ง่ายขึ้น | [GitHub](https://github.com/nkxx188/ComfyUI-MiniMaxH3-Easy) |

</details>

---

## 🔊 Audio

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI_pyannote | แยกเสียงพูดตามผู้พูด (diarization) | [GitHub](https://github.com/ramesh-x90/ComfyUI_pyannote) |
| ComfyUI-Speaker-Isolation | แยกเสียงคนพูดออกจากเสียงรบกวน | [GitHub](https://github.com/pmarmotte2/ComfyUI-Speaker-Isolation) |
| ComfyUI_RyanOnTheInside | node เสริมด้าน audio-reactive | [GitHub](https://github.com/ryanontheinside/ComfyUI_RyanOnTheInside) |
| ComfyUI-MMAudio | generate เสียงประกอบจากวิดีโอ | [GitHub](https://github.com/kijai/ComfyUI-MMAudio) |
| ComfyUI-ThinkSound | generate sound effect | [GitHub](https://github.com/Yuan-ManX/ComfyUI-ThinkSound) |
| แยก Audio - Vocal | แยกเสียงร้องออกจากดนตรี | [GitHub](https://github.com/kijai/ComfyUI-MelBandRoFormer) |
| Audiotools | รวม tool จัดการเสียง | [GitHub](https://github.com/billwuhao/ComfyUI_AudioTools) |
| SongBloom (ComfyUI) | แต่งเพลงด้วย AI | [GitHub](https://github.com/fredconex/ComfyUI-SongBloom) / [ต้นฉบับ](https://github.com/tencent-ailab/SongBloom) |
| Maya1 | TTS ภาษาอังกฤษ เหมาะทำหนังสือเสียง/นิยาย | [GitHub](https://github.com/Saganaki22/ComfyUI-Maya1_TTS) |
| Audio editor (RealRebelAI) | เครื่องมือ edit เสียง | [GitHub](https://github.com/RealRebelAI/Rebels_Audio_Nodes) · [📺 YouTube](https://www.youtube.com/watch?v=Yi8pbWyr4zA) |

</details>

---

## 🧠 LLM / VLM (caption, prompt generator)

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI_Qwen3-VL-Instruct | gen prompt จาก video/image ทำ VQA ได้ | [GitHub](https://github.com/IuvenisSapiens/ComfyUI_Qwen3-VL-Instruct) |
| Florence 2 (kijai) | caption ภาพอัตโนมัติ | [GitHub](https://github.com/kijai/ComfyUI-Florence2) |
| ComfyUI-Florence-2 (spacepxl) | caption ภาพอัตโนมัติ | [GitHub](https://github.com/spacepxl/ComfyUI-Florence-2) |
| comfyui-ollama | เรียกใช้ LLM local ผ่าน Ollama | [GitHub](https://github.com/stavsap/comfyui-ollama) |
| ComfyUI_SLK_joy_caption_two | caption ภาพแบบละเอียด | [GitHub](https://github.com/EvilBT/ComfyUI_SLK_joy_caption_two) |
| ComfyUI-WD14-Tagger | tag ภาพแบบ anime/booru style | [GitHub](https://github.com/pythongosssss/ComfyUI-WD14-Tagger) |
| ComfyUI-Blip | caption ภาพด้วย BLIP | [GitHub](https://github.com/smthemex/ComfyUI_Pic2Story) |
| ComfyUI_Searge_LLM | prompt helper ด้วย LLM | [GitHub](https://github.com/SeargeDP/ComfyUI_Searge_LLM) |
| ComfyUI_molmo | VLM สำหรับ caption/VQA | [GitHub](https://github.com/CY-CHENYUE/ComfyUI-Molmo) |
| ComfyUI-MiniCPM | VLM ขนาดเล็กสำหรับ caption | [GitHub](https://github.com/1038lab/ComfyUI-MiniCPM) |
| ComfyUI-Kolors-MZ | node เสริมสำหรับ Kolors | [GitHub](https://github.com/MinusZoneAI/ComfyUI-Kolors-MZ) |

</details>

---

## ⚙️ Model Optimization (Nunchaku)

<details>
<summary>ดูรายการทั้งหมด</summary>

| Node/Model | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI-nunchaku | inference โมเดล quantized เร็วขึ้นมาก | [GitHub](https://github.com/mit-han-lab/ComfyUI-nunchaku) |
| svdq-in4-shuttle-jarguar | โมเดล quantized 4-bit | [Hugging Face](https://huggingface.co/mit-han-lab/svdq-fp4-shuttle-jaguar) |
| svdq-int4-jibMixFlux_v8Accentueight | โมเดล Flux quantized 4-bit | [Hugging Face](https://huggingface.co/theunlikely/svdq-int4-jibMixFlux_v8Accentueight/tree/main) |
| ICEdit | image edit ร่วมกับ Nunchaku | [GitHub](https://github.com/River-Zhang/ICEdit/issues/1#issuecomment-2846568411) |

</details>

---

## 🧰 Tools เบ็ดเตล็ด

<details>
<summary>ดูรายการทั้งหมด</summary>

| Tool | คำอธิบาย | ลิงก์ |
|---|---|---|
| Muti-area conditioning | คุม conditioning หลายพื้นที่ในภาพเดียว | [GitHub](https://github.com/Davemane42/ComfyUI_Dave_CustomNode) |
| AdvancedReduxControl | ควบคุม Redux แบบละเอียด | [GitHub](https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl) |
| catvton-flux-lora-alpha | เปลี่ยนเสื้อผ้าในภาพ | [Hugging Face](https://huggingface.co/xiaozaa/catvton-flux-lora-alpha) |
| vton-ic-v3-lora | เปลี่ยนเสื้อผ้า (เวอร์ชันอื่น) | [Hugging Face](https://huggingface.co/Patil/vton-ic-lora/tree/main) |
| ComfyUI-enricos-nodes | จัด composition/ตำแหน่ง object แบบ realtime | [GitHub](https://github.com/erosDiffusion/ComfyUI-enricos-nodes) |
| ComfyUI_Local_Lora_Gallery | เบราว์ LoRA ที่มีในเครื่องแบบ gallery | [GitHub](https://github.com/Firetheft/ComfyUI_Local_Lora_Gallery) |
| Bjornulf custom nodes | เครื่องมือให้ใช้เป็นร้อย ลองเล่นกันดู | [GitHub](https://github.com/justUmen/Bjornulf_custom_nodes) |
| RES4LYF | ทดสอบค่า sigma/sampler | [GitHub](https://github.com/ClownsharkBatwing/RES4LYF) |
| CRT-Nodes | UI สวยเรืองแสง + เครื่องมือยิบย่อยใช้กับ video | [GitHub](https://github.com/PGCRT/CRT-Nodes) |
| Comfyui-LatentUtils | ทดลองค่า sigma ต่างๆ | [GitHub](https://github.com/lrzjason/Comfyui-LatentUtils) |
| Kiko tools | XYZ test z-image | [GitHub](https://github.com/ComfyAssets/ComfyUI-KikoTools) |
| Z-image lora fuse | เช็ค/merge/ปั่นรวม LoRA block | [GitHub](https://github.com/destinyfaux/Z-Fuse) |
| Display Status (RealRebelAI) | โชว์สถานะการรันแบบสวยงาม | [GitHub](https://github.com/RealRebelAI/Rebels_Matrix_Monitor_Node) |
| PIXORAMA Tools | image compositor หรูหรา | [GitHub](https://github.com/pixaroma/ComfyUI-Pixaroma) |
| OPEN POSE Studio | UI จัดท่า OpenPose หรูหรา | [GitHub](https://github.com/andreszs/ComfyUI-OpenPose-Studio) |
| ComfyUI_Comfyroll_CustomNodes | รวม utility node ยอดฮิต | [GitHub](https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes) |
| เครื่องมือ edit ภาพ | โปรไฟล์ตัวเลือก node แก้ไขภาพเพิ่มเติม | [GitHub](https://github.com/o-l-l-i) |
| RGB Color Picker | อ้างอิงค่าสี RGB | [rapidtables.com](https://www.rapidtables.com/web/color/RGB_Color.html) |

</details>

---

## ✍️ คลัง Prompt

<details>
<summary>ดูรายการทั้งหมด</summary>

**ComfyUI-native:**

| Node | คำอธิบาย | ลิงก์ |
|---|---|---|
| ComfyUI Prompt Styler / PromptStyler | โหนดช่วยแต่ง prompt ในตัว | [GitHub](https://github.com/NidAll/ComfyUI_PromptStyler) |

**เว็บ/คลัง prompt ภายนอก:**

| แหล่ง | เนื้อหา | ลิงก์ |
|---|---|---|
| Snapmingle | คลัง prompt สนับสนุนของคนไทย | [เปิด](https://snapmingle.online/ai-prompt-gallery/search) |
| Opennana | คลัง prompt 1000+ ของคนจีน (ใช้ Chrome แปลหน้าเว็บ) | [เปิด](https://opennana.com/awesome-prompt-gallery) |
| localbanana.io | คลัง prompt Nano Banana | [เปิด](https://www.localbanana.io/) |
| tihubb.com | AI prompt รวม + prompt cinematic คุณภาพดี | [เปิด](https://tihubb.com/ai-prompt) |
| youmind.com | Nano Banana Pro prompts 3000+ | [เปิด](https://youmind.com/nano-banana-pro-prompts) |
| nanobananaprompt.org | คลัง prompt Nano Banana | [เปิด](https://nanobananaprompt.org/prompts) |
| GitHub awesome-nano-banana-pro-prompts | คลัง prompt รวม 1000+ | [เปิด](https://github.com/YouMind-OpenLab/awesome-nano-banana-pro-prompts) |
| iimate24.com | แจก Prompt สำหรับ Cinematic โค้ดดี | [เปิด](https://iimate24.com/prompt-cinematic-support/) |
| promptsref.com | LTX, Nanobanana, ChatGPT prompt | [เปิด](https://promptsref.com/library/nano-banana-pro) |
| Yesand IA | รวม prompt ตัวอย่าง ฯลฯ | [เปิด](https://yesand.ai/portrait) |

</details>
