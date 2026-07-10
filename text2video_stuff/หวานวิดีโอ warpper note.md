# กำลังเขียน ไม่เสร็จ เด้อ
<img src="https://github.com/gordon123/learn2ComfyUI/blob/main/image/img/underconstruction.png?raw=true" alt="WanVideo Sampler" width="300"/>

## WAN2.1 Video wrapper note
https://huggingface.co/Kijai/WanVideo_comfy/tree/main
https://github.com/kijai/ComfyUI-WanVideoWrapper

T2V
## == Model Custom node

### WanVideo BlockSwap - สวิช GPU -CPU

### WanVideo Lora Select - lora 
https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-T2V-14B_CausVid_fp8_e4m3fn.safetensors
### WanVideo VACE Model Select - VACE model 
1. https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-VACE_module_14B_bf16.safetensors
2. https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-VACE_module_14B_fp8_e4m3fn.safetensors
3. https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-VACE_module_1_3B_bf16.safetensors

### WanVideo Torch Compile Settings - ใช้ Triton ช่วย ทำให้ speed เร็วขึ้น โดย การ บีบอัด tensors

### WanVideo Sampler

<img src="https://github.com/gordon123/learn2ComfyUI/blob/main/image/img/wanvideo-sampler.png?raw=true" alt="WanVideo Sampler" width="300"/>

### Model ==
<img src="https://github.com/gordon123/learn2ComfyUI/blob/main/image/img/wanvideo-model-loader.png?raw=true" alt="WanVideo Sampler" width="300"/> <br>
Note: sageatten speed up, than spda

--- 
## T2V

== หลักการเขียน Prompt
การใช้ Prompt ที่

```
{Prompt word = + subject (subject description) 
                 + scene (scene description) 
                 + movement (movement description) 
                 + lens language + atmosphere word 
                 + stylization}
```


## I2V

## V2V (VACE)