import os
import gc
import torch
import gradio as gr
import time

from nunchaku import NunchakuZImageTransformer2DModel
from nunchaku.utils import get_precision
from diffusers.pipelines.z_image.pipeline_z_image import ZImagePipeline

PORT = int(os.environ.get("PORT", "7860"))
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
DTYPE = torch.bfloat16 if DEVICE == "cuda" else torch.float32
OUTPUT_DIR = "/workspace/zimage_nunchaku/output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# --- ปรับรายการโมเดลตรงนี้ได้ตามใจ ---
BASE_MODELS = {
    "Tongyi-MAI/Z-Image-Turbo": "Tongyi-MAI/Z-Image-Turbo",
    # ถ้ามีตัวอื่นในอนาคต เพิ่มได้เลย เช่น
    # "SomeOrg/Z-Image-Whatever": "SomeOrg/Z-Image-Whatever",
}

# Nunchaku weights (จาก repo nunchaku-tech/nunchaku-z-image-turbo)
# รูปแบบชื่อไฟล์: svdq-{precision}_r{rank}-z-image-turbo.safetensors
RANK_OPTIONS = [32, 128, 256]  # ถ้าไม่มี 256 จริง ให้เอาออกได้

# cache เพื่อสลับกลับเร็ว
_PIPE_CACHE = {}
_CURRENT_KEY = None

def cleanup_cuda():
    gc.collect()
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
        torch.cuda.ipc_collect()

def load_pipe(base_model: str, rank: int):
    """โหลดหรือดึงจาก cache"""
    global _CURRENT_KEY

    precision = get_precision()  # 4090 -> int4
    key = (base_model, precision, int(rank))

    if key in _PIPE_CACHE:
        _CURRENT_KEY = key
        return _PIPE_CACHE[key], f"✅ Loaded from cache: base={base_model}, precision={precision}, rank={rank}"

    # ถ้าไม่อยู่ใน cache: โหลดใหม่
    weight_id = f"nunchaku-tech/nunchaku-z-image-turbo/svdq-{precision}_r{rank}-z-image-turbo.safetensors"
    transformer = NunchakuZImageTransformer2DModel.from_pretrained(weight_id)

    pipe = ZImagePipeline.from_pretrained(
        base_model,
        transformer=transformer,
        torch_dtype=DTYPE,
        low_cpu_mem_usage=True,
    ).to(DEVICE)

    pipe.set_progress_bar_config(disable=True)

    _PIPE_CACHE[key] = pipe
    _CURRENT_KEY = key
    return pipe, f"✅ Loaded: base={base_model}, precision={precision}, rank={rank} (cached now)"

def _clear_vram():
    gc.collect()
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
        torch.cuda.ipc_collect()

def generate(prompt, width, height, steps, seed):
    if _CURRENT_KEY is None:
        return None, "❌ ยังไม่ได้กด Load / Switch Model"

    try:
        pipe = _PIPE_CACHE[_CURRENT_KEY]
        g = torch.Generator(device=DEVICE).manual_seed(int(seed))

        img = pipe(
            prompt=prompt,
            width=int(width),
            height=int(height),
            num_inference_steps=int(steps),
            guidance_scale=0.0,  # Turbo
            generator=g,
        ).images[0]

        ts = time.strftime("%Y%m%d_%H%M%S")
        fname = f"zimage_{ts}_w{int(width)}_h{int(height)}_s{int(steps)}_seed{int(seed)}.png"
        save_path = os.path.join(OUTPUT_DIR, fname)

        # PNG lossless (compress_level=0 = ใหญ่ขึ้น แต่เร็ว/ไม่บีบ)
        img.save(save_path, format="PNG", compress_level=0)

        return img, f"✅ Saved: {save_path}"

    finally:
        _clear_vram()

    
def unload_all():
    global _PIPE_CACHE, _CURRENT_KEY
    for k, p in list(_PIPE_CACHE.items()):
        try:
            del p
        except:
            pass
    _PIPE_CACHE = {}
    _CURRENT_KEY = None
    _clear_vram()
    return "🧹 Cleared all cached models (VRAM cleared)"

with gr.Blocks(title="Z-Image Turbo (Nunchaku) - Model Switcher") as demo:
    gr.Markdown("## 🧠 Z-Image Turbo + Nunchaku (INT4) — เลือก/สลับโมเดลได้")
    gr.Markdown("**Tip:** Turbo ใช้ steps 6–10 และ `guidance_scale=0`")

    with gr.Row():
        with gr.Column(scale=1):
            base_model = gr.Dropdown(
                choices=list(BASE_MODELS.keys()),
                value="Tongyi-MAI/Z-Image-Turbo",
                label="Base model (diffusers)"
            )
            rank = gr.Dropdown(
                choices=RANK_OPTIONS,
                value=128,
                label="Nunchaku rank (r32/r128/r256)"
            )
            load_btn = gr.Button("Load / Switch Model", variant="primary")
            clear_btn = gr.Button("Clear All Cached Models", variant="secondary")
            status = gr.Textbox(label="Status", interactive=False)

        with gr.Column(scale=2):
            prompt = gr.Textbox(
                label="Prompt",
                value="cinematic portrait photo, dramatic rim light, shallow depth of field"
            )
            with gr.Row():
                width = gr.Slider(512, 1536, value=1024, step=64, label="Width")
                height = gr.Slider(512, 1536, value=1024, step=64, label="Height")
            with gr.Row():
                steps = gr.Slider(4, 12, value=8, step=1, label="Steps")
                seed = gr.Number(value=12345, label="Seed")
            gen_btn = gr.Button("Generate", variant="primary")
            out_img = gr.Image(label="Result", height=512)
            out_msg = gr.Textbox(label="Output", interactive=False)

    def _on_load(bm, rk):
        pipe, msg = load_pipe(BASE_MODELS[bm], int(rk))
        # ไม่คืน pipe ออก UI; แค่รายงานสถานะ
        return msg

    load_btn.click(_on_load, inputs=[base_model, rank], outputs=[status])
    clear_btn.click(unload_all, outputs=[status])
    gen_btn.click(generate, inputs=[prompt, width, height, steps, seed], outputs=[out_img, out_msg])

demo.launch(server_name="0.0.0.0", server_port=PORT)
