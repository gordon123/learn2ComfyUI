import torch
from nunchaku import NunchakuZImageTransformer2DModel
from nunchaku.utils import get_precision
from diffusers.pipelines.z_image.pipeline_z_image import ZImagePipeline

def main():
    precision = get_precision()   # RTX 4090 -> int4
    rank = 128

    print("precision:", precision, "rank:", rank)

    transformer = NunchakuZImageTransformer2DModel.from_pretrained(
        f"nunchaku-tech/nunchaku-z-image-turbo/svdq-{precision}_r{rank}-z-image-turbo.safetensors"
    )

    pipe = ZImagePipeline.from_pretrained(
        "Tongyi-MAI/Z-Image-Turbo",
        transformer=transformer,
        torch_dtype=torch.bfloat16,
        low_cpu_mem_usage=False,
    ).to("cuda")

    image = pipe(
        prompt="cinematic portrait photo, dramatic rim light, shallow depth of field",
        width=1024,
        height=1024,
        num_inference_steps=8,
        guidance_scale=0.0,
        generator=torch.Generator(device="cuda").manual_seed(12345),
    ).images[0]

    out = "/workspace/zimage_nunchaku/z-image-turbo-int4_r128.png"
    image.save(out)
    print("saved:", out)

if __name__ == "__main__":
    main()
