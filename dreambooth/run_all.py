import json, os, tqdm, torch

from JDiffusion.pipelines import StableDiffusionPipeline
os.environ["HF_ENDPOINT"] = "https://hf-mirror.com"
max_num = 15
dataset_root = "../styleid/data/sty/A_style"
lora_weights = "../styleid/data/weight/"
with torch.no_grad():
    for tempid in tqdm.tqdm(range(0, max_num)):
        taskid = "{:0>2d}".format(tempid)
        pipe = StableDiffusionPipeline.from_pretrained("stabilityai/stable-diffusion-2-1").to("cuda")
        pipe.load_lora_weights(f"{lora_weights}{taskid}")

        # load json
        with open(f"{dataset_root}/{taskid}/prompt.json", "r") as file:
            prompts = json.load(file)

        for id, prompt in prompts.items():
            print(prompt)
            image = pipe(prompt + f" in style_{taskid}", num_inference_steps=50, width=512, height=512).images[0]
            os.makedirs(f"../styleid/data/cnt/{taskid}", exist_ok=True)
            image.save(f"../styleid/data/cnt/{taskid}/{prompt}.png")
