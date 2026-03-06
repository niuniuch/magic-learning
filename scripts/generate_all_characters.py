#!/usr/bin/env python3
"""
Generate upgrade images for all remaining characters (fairy, merperson,
superhero, alien, robot) using Leonardo AI Kontext API.

Uses the mage base as a style reference, transforming it into each character
type to ensure consistent art style across all characters.
"""

import json
import os
import sys
import time
import numpy as np
import requests
from pathlib import Path
from PIL import Image

API_KEY = open(os.path.expanduser("~/.leonardo-key")).read().strip()
BASE_URL = "https://cloud.leonardo.ai/api/rest/v1"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
}

# Mage base reference (already uploaded)
MAGE_BASE_REF_ID = "377978eb-27de-4c7f-bc66-ea49e64c2ae2"

WIDTH = 752
HEIGHT = 1392

PROJECT_DIR = Path(__file__).parent.parent
TEMP_DIR = Path("/tmp/character_pipeline")

# Character definitions: base transformation prompt + track variant prompts
CHARACTERS = {
    "fairy": {
        "base_prompt": (
            "Transform this wizard character into a cute cartoon fairy girl. "
            "She should have a pink sparkly dress, small translucent wings on her back, "
            "long flowing hair with a slight pink tint, big friendly eyes, rosy cheeks, "
            "and cute pointed ears. She holds a small magic wand with a star on top. "
            "Same chibi cartoon art style, same proportions, same light gray background. "
            "Full body standing pose facing forward."
        ),
        "tracks": {
            "headwear_1": "Add a simple flower crown made of small wildflowers on her head. Keep everything else exactly the same.",
            "headwear_2": "Add a flower crown made of pink roses on her head. Keep everything else exactly the same.",
            "headwear_3": "Add a glowing magical flower crown that emanates soft pink light on her head. Keep everything else exactly the same.",
            "headwear_4": "Add a majestic crown made of golden flowers and magical gems on her head. Keep everything else exactly the same.",
            "accessory_1": "Add a pattern of small colorful dots on her wings. Keep everything else exactly the same.",
            "accessory_2": "Make her wings shimmer with a pearlescent iridescent glow. Keep everything else exactly the same.",
            "accessory_3": "Add fiery orange and red patterns on her wings that look like flame designs. Keep everything else exactly the same.",
            "accessory_4": "Make her wings display all rainbow colors in a magical gradient pattern. Keep everything else exactly the same.",
            "aura_1": "Add small magical sparkle particles floating around her. Keep everything else exactly the same.",
            "aura_2": "Add colorful butterflies flying and orbiting around her. Keep everything else exactly the same.",
            "aura_3": "Add magical flower petals swirling and floating around her. Keep everything else exactly the same.",
            "aura_4": "Add a full magical stardust aura - glowing pink and gold particles, tiny stars, and sparkles surrounding the entire character. Keep everything else exactly the same.",
        },
    },
    "merperson": {
        "base_prompt": (
            "Transform this wizard character into a cute cartoon mermaid child. "
            "She should have a colorful fish tail (teal/aqua scales) instead of legs, "
            "long flowing aqua-blue hair, a simple seashell top, big friendly eyes, "
            "and a friendly smile. No accessories, no crown. "
            "Same chibi cartoon art style, same proportions, same light gray background. "
            "Full body pose facing forward."
        ),
        "tracks": {
            "headwear_1": "Add a simple headband made of colorful coral pieces on her head. Keep everything else exactly the same.",
            "headwear_2": "Add a crown made of seashells on her head. Keep everything else exactly the same.",
            "headwear_3": "Add a crown decorated with glowing pearls on her head. Keep everything else exactly the same.",
            "headwear_4": "Add a majestic royal golden crown with aqua gems, befitting an ocean ruler, on her head. Keep everything else exactly the same.",
            "accessory_1": "Put a simple wooden trident in her hand. Keep everything else exactly the same.",
            "accessory_2": "Put a trident made of living coral in her hand. Keep everything else exactly the same.",
            "accessory_3": "Put a crystalline trident with glowing sea crystals in her hand. Keep everything else exactly the same.",
            "accessory_4": "Put a legendary golden trident with swirling ocean energy in her hand. Keep everything else exactly the same.",
            "aura_1": "Add small bubbles floating upward around her. Keep everything else exactly the same.",
            "aura_2": "Add glowing pearls orbiting around her. Keep everything else exactly the same.",
            "aura_3": "Add swirling ocean current effects and water streams around her. Keep everything else exactly the same.",
            "aura_4": "Add a powerful water vortex and ocean whirlpool effect surrounding the entire character with bubbles, pearls, and swirling water. Keep everything else exactly the same.",
        },
    },
    "superhero": {
        "base_prompt": (
            "Transform this wizard character into a cute cartoon superhero kid. "
            "He should wear a bright red and blue superhero bodysuit with a yellow belt, "
            "a flowing red cape behind him, no mask, short dark hair, big determined eyes, "
            "and a confident smile. Hands on his hips in a heroic pose. "
            "Same chibi cartoon art style, same proportions, same light gray background. "
            "Full body standing pose facing forward."
        ),
        "tracks": {
            "headwear_1": "Add a simple classic superhero eye mask (domino mask) on his face. Keep everything else exactly the same.",
            "headwear_2": "Add a superhero mask with metallic silver accents on his face. Keep everything else exactly the same.",
            "headwear_3": "Add an advanced tech-looking superhero mask with glowing blue lines on his face. Keep everything else exactly the same.",
            "headwear_4": "Add a legendary full superhero helmet with glowing energy effects and golden accents. Keep everything else exactly the same.",
            "accessory_1": "Add a golden star emblem on the center of his cape. Keep everything else exactly the same.",
            "accessory_2": "Add lightning bolt patterns across his cape. Keep everything else exactly the same.",
            "accessory_3": "Add flame-like patterns along the edges of his cape. Keep everything else exactly the same.",
            "accessory_4": "Make his cape display a cosmic space pattern with stars and galaxies. Keep everything else exactly the same.",
            "aura_1": "Add a glowing star emblem on his chest that shines with light. Keep everything else exactly the same.",
            "aura_2": "Add small lightning bolts crackling from his fists. Keep everything else exactly the same.",
            "aura_3": "Add an energy field surrounding the character with electric sparks. Keep everything else exactly the same.",
            "aura_4": "Add a full golden power aura surrounding the entire character with energy waves, lightning, and golden light. Keep everything else exactly the same.",
        },
    },
    "alien": {
        "base_prompt": (
            "Transform this wizard character into a cute cartoon friendly alien. "
            "It should have light green skin, a slightly larger head, big round black eyes, "
            "small nose and friendly smile, wearing a simple purple space suit, "
            "and small cute feet. No antennae, no visor, no special effects. "
            "Same chibi cartoon art style, same proportions, same light gray background. "
            "Full body standing pose facing forward."
        ),
        "tracks": {
            "headwear_1": "Add a single small antenna with a glowing tip on top of its head. Keep everything else exactly the same.",
            "headwear_2": "Add two antennae on top of its head that glow at the tips. Keep everything else exactly the same.",
            "headwear_3": "Add two antennae that radiate visible energy beams from their glowing tips. Keep everything else exactly the same.",
            "headwear_4": "Add elaborate quantum antennae with swirling energy orbs and holographic projections on its head. Keep everything else exactly the same.",
            "accessory_1": "Add a simple visor/monocle device over one eye. Keep everything else exactly the same.",
            "accessory_2": "Add a scanning visor over both eyes that shows scan lines. Keep everything else exactly the same.",
            "accessory_3": "Add a holographic visor display that projects data around the head. Keep everything else exactly the same.",
            "accessory_4": "Add an advanced cosmic visor with multiple holographic screens floating around the head. Keep everything else exactly the same.",
            "aura_1": "Add a soft bioluminescent glow around the character's body. Keep everything else exactly the same.",
            "aura_2": "Add an energy shield bubble partially visible around the character. Keep everything else exactly the same.",
            "aura_3": "Add holographic geometric projections floating around the character. Keep everything else exactly the same.",
            "aura_4": "Add a full advanced alien technology aura with holographic rings, energy particles, and glowing symbols surrounding the entire character. Keep everything else exactly the same.",
        },
    },
    "robot": {
        "base_prompt": (
            "Transform this wizard character into a cute cartoon friendly robot. "
            "It should have a boxy but rounded silver metal body, a rectangular head "
            "with a friendly digital face (two round blue LED eyes, small smile), "
            "simple mechanical arms and legs with visible joints, and a small antenna. "
            "Simple clean design, no special lights or effects. "
            "Same chibi cartoon art style, same proportions, same light gray background. "
            "Full body standing pose facing forward."
        ),
        "tracks": {
            "headwear_1": "Add a simple rectangular module attached to the top of its head. Keep everything else exactly the same.",
            "headwear_2": "Add an extra processor unit with blinking lights on top of its head. Keep everything else exactly the same.",
            "headwear_3": "Add a turbo-charged head module with glowing vents and energy lines on its head. Keep everything else exactly the same.",
            "headwear_4": "Add a quantum computer module on its head with holographic displays and floating data streams. Keep everything else exactly the same.",
            "accessory_1": "Replace its hands with simple mechanical grippers/claws. Keep everything else exactly the same.",
            "accessory_2": "Add built-in tool attachments visible in its forearms (wrench, screwdriver shapes). Keep everything else exactly the same.",
            "accessory_3": "Add laser emitters in its palms with visible red laser beams. Keep everything else exactly the same.",
            "accessory_4": "Give it fully upgraded mega-arms with multiple tool attachments, rocket boosters, and energy shields. Keep everything else exactly the same.",
            "aura_1": "Add small LED lights glowing on various parts of its body. Keep everything else exactly the same.",
            "aura_2": "Add a screen on its chest that displays a happy emoticon face. Keep everything else exactly the same.",
            "aura_3": "Add electric sparks jumping between its joints and connections. Keep everything else exactly the same.",
            "aura_4": "Add full golden lighting effects across the entire robot - golden LED strips, golden energy field, and sparkling golden particles surrounding it. Keep everything else exactly the same.",
        },
    },
}


def upload_image(image_path: str) -> str:
    ext = Path(image_path).suffix.lstrip(".")
    resp = requests.post(f"{BASE_URL}/init-image", headers=HEADERS, json={"extension": ext})
    resp.raise_for_status()
    data = resp.json()["uploadInitImage"]
    fields = json.loads(data["fields"])
    with open(image_path, "rb") as f:
        requests.post(data["url"], data=fields, files={"file": (Path(image_path).name, f)}).raise_for_status()
    print(f"  Uploaded -> {data['id']}")
    return data["id"]


def generate_kontext(prompt: str, context_image_id: str) -> str:
    resp = requests.post(f"{BASE_URL}/generations", headers=HEADERS, json={
        "modelId": "28aeddf8-bd19-4803-80fc-79602d1a9989",
        "prompt": prompt, "width": WIDTH, "height": HEIGHT, "num_images": 1,
        "contextImages": [{"type": "UPLOADED", "id": context_image_id}],
    })
    resp.raise_for_status()
    gen_id = resp.json()["sdGenerationJob"]["generationId"]
    print(f"  Generation: {gen_id}")
    return gen_id


def poll_generation(gen_id: str, timeout: int = 120) -> str:
    start = time.time()
    while time.time() - start < timeout:
        resp = requests.get(f"{BASE_URL}/generations/{gen_id}", headers=HEADERS)
        resp.raise_for_status()
        data = resp.json()["generations_by_pk"]
        if data["status"] == "COMPLETE" and data["generated_images"]:
            return data["generated_images"][0]["url"]
        elif data["status"] == "FAILED":
            raise RuntimeError(f"Generation {gen_id} failed")
        time.sleep(5)
    raise TimeoutError(f"Generation {gen_id} timed out")


def download_image(url: str, path: str):
    resp = requests.get(url)
    resp.raise_for_status()
    with open(path, "wb") as f:
        f.write(resp.content)


def remove_bg_rembg(input_path: str, output_path: str):
    from rembg import remove as rembg_remove
    img = Image.open(input_path)
    result = rembg_remove(img)
    result.save(output_path)


def remove_bg_gray(input_path: str, output_path: str):
    """Remove gray background preserving colorful elements (for aura images)."""
    img = Image.open(input_path).convert("RGBA")
    data = np.array(img, dtype=np.float32)
    bg_sample = data[5:15, 5:15, :3].mean(axis=(0, 1))
    r, g, b = data[:, :, 0], data[:, :, 1], data[:, :, 2]
    dist = np.sqrt((r - bg_sample[0])**2 + (g - bg_sample[1])**2 + (b - bg_sample[2])**2)
    mean_rgb = (r + g + b) / 3.0
    sat = np.sqrt(((r - mean_rgb)**2 + (g - mean_rgb)**2 + (b - mean_rgb)**2) / 3.0)
    is_bg = (dist < 35) & (sat < 15)
    alpha = np.full(dist.shape, 255.0, dtype=np.float32)
    alpha[is_bg] = 0.0
    transition = (dist < 52) & (sat < 30) & (~is_bg)
    alpha[transition] = np.clip((dist[transition] - 35) / 17, 0, 1) * 255.0
    data[:, :, 3] = alpha
    Image.fromarray(data.astype(np.uint8)).save(output_path)


def is_dark_background(input_path: str) -> bool:
    """Check if the image has a dark background (like aura_4)."""
    img = Image.open(input_path).convert("RGB")
    data = np.array(img)
    corner = np.concatenate([
        data[0:5, 0:5].reshape(-1, 3), data[0:5, -5:].reshape(-1, 3),
        data[-5:, 0:5].reshape(-1, 3), data[-5:, -5:].reshape(-1, 3),
    ])
    brightness = corner.mean()
    return brightness < 100


def resize_to_asset(input_path: str, output_path: str, w=400, h=720):
    img = Image.open(input_path).convert("RGBA")
    img.thumbnail((w, h), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    canvas.paste(img, ((w - img.width) // 2, (h - img.height) // 2), img)
    canvas.save(output_path)


def process_image(raw_path: str, final_path: str, is_aura: bool):
    """Process a raw image: remove background and resize."""
    nobg_path = raw_path.replace("_raw.jpg", "_nobg.png")

    if is_aura:
        if is_dark_background(raw_path):
            # Aura with dark bg (like full aura) - just resize, keep bg
            resize_to_asset(raw_path, final_path)
            return
        else:
            remove_bg_gray(raw_path, nobg_path)
    else:
        remove_bg_rembg(raw_path, nobg_path)

    resize_to_asset(nobg_path, final_path)


def check_balance():
    resp = requests.get(f"{BASE_URL}/me", headers=HEADERS)
    resp.raise_for_status()
    tokens = resp.json()["user_details"][0].get("apiPaidTokens", 0)
    print(f"API tokens: {tokens}")
    return tokens


def generate_character(char_name: str, char_config: dict):
    """Generate all 13 images for a single character."""
    temp_dir = TEMP_DIR / char_name
    output_dir = PROJECT_DIR / "assets" / "images" / "characters" / char_name
    temp_dir.mkdir(parents=True, exist_ok=True)
    output_dir.mkdir(parents=True, exist_ok=True)

    state_file = temp_dir / "state.json"
    if state_file.exists():
        state = json.loads(state_file.read_text())
    else:
        state = {"completed": [], "base_ref_id": None}

    def save():
        state_file.write_text(json.dumps(state, indent=2))

    # Phase 1: Generate base character from mage reference
    base_raw = temp_dir / "base_raw.jpg"
    base_final = output_dir / f"{char_name}_base.png"

    if "base" not in state["completed"]:
        print(f"  Generating base {char_name}...")
        gen_id = generate_kontext(char_config["base_prompt"], MAGE_BASE_REF_ID)
        url = poll_generation(gen_id)
        download_image(url, str(base_raw))
        state["completed"].append("base")
        save()

    if not base_final.exists():
        process_image(str(base_raw), str(base_final), is_aura=False)

    # Phase 2: Upload base as reference
    if not state.get("base_ref_id"):
        print(f"  Uploading {char_name} base as reference...")
        state["base_ref_id"] = upload_image(str(base_raw))
        save()

    ref_id = state["base_ref_id"]

    # Phase 3: Generate all track variants
    for variant_name, prompt in char_config["tracks"].items():
        if variant_name in state["completed"]:
            continue

        raw_path = temp_dir / f"{variant_name}_raw.jpg"
        final_path = output_dir / f"{char_name}_{variant_name}.png"
        is_aura = variant_name.startswith("aura_")

        print(f"  Generating {variant_name}...")
        try:
            gen_id = generate_kontext(prompt, ref_id)
            url = poll_generation(gen_id)
            download_image(url, str(raw_path))
            process_image(str(raw_path), str(final_path), is_aura=is_aura)
            state["completed"].append(variant_name)
            save()
        except Exception as e:
            print(f"  ERROR: {e}")
            continue

    done = len(state["completed"])
    print(f"  {char_name}: {done}/13 complete")


def main():
    TEMP_DIR.mkdir(parents=True, exist_ok=True)

    print("=== Character Image Generation Pipeline ===\n")
    start_tokens = check_balance()

    # Process characters that need images
    chars_to_generate = sys.argv[1:] if len(sys.argv) > 1 else list(CHARACTERS.keys())

    for char_name in chars_to_generate:
        if char_name not in CHARACTERS:
            print(f"Unknown character: {char_name}")
            continue

        output_dir = PROJECT_DIR / "assets" / "images" / "characters" / char_name
        existing = list(output_dir.glob("*.png")) if output_dir.exists() else []
        if len(existing) >= 13:
            print(f"\n{char_name}: already has {len(existing)} images, skipping.")
            continue

        print(f"\n{'='*40}")
        print(f"Generating: {char_name}")
        print(f"{'='*40}")
        generate_character(char_name, CHARACTERS[char_name])

    end_tokens = check_balance()
    print(f"\n=== Done! Tokens used: {start_tokens - end_tokens} ===")

    # Summary
    for char_name in chars_to_generate:
        output_dir = PROJECT_DIR / "assets" / "images" / "characters" / char_name
        count = len(list(output_dir.glob("*.png"))) if output_dir.exists() else 0
        print(f"  {char_name}: {count}/13 images")


if __name__ == "__main__":
    main()
