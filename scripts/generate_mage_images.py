#!/usr/bin/env python3
"""
Generate all Mage character upgrade images via Leonardo AI Kontext API.

Pipeline:
1. Create base mage (no upgrades) by editing the reference image
2. Upload base as new reference
3. Generate all 12 track variants from the base
4. Download all images
5. Remove backgrounds with rembg
6. Resize to 400x720 transparent PNGs
7. Place in assets/images/characters/mage/
"""

import json
import os
import sys
import time
import requests
from pathlib import Path

API_KEY = open(os.path.expanduser("~/.leonardo-key")).read().strip()
BASE_URL = "https://cloud.leonardo.ai/api/rest/v1"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
}

# The uploaded base mage reference image (hat + star + staff + sparkles)
ORIGINAL_REF_ID = "3bdc0dca-9cea-4b21-ac60-6f4a8b0d62dc"

OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "images" / "characters" / "mage"
TEMP_DIR = Path("/tmp/mage_pipeline")

# Image dimensions for Kontext (must be supported)
WIDTH = 752
HEIGHT = 1392

# Generation prompts - each describes what the final image should look like
# Phase 1: Create base from original reference (remove hat, staff, sparkles)
BASE_PROMPT = (
    "Remove the wizard hat completely, showing bare head with white hair on top. "
    "Remove the wooden staff from his hand, his hand should be empty at his side. "
    "Remove all yellow sparkle star effects from the background. "
    "Keep everything else exactly the same - purple robe, white beard, brown belt, brown boots, same pose, same art style, same background color."
)

# Phase 2: Track variants - each edits the BASE image (not the original)
TRACK_VARIANTS = {
    # Headwear track: hat evolution
    "headwear_1": "Add a simple plain purple pointed wizard hat on his head. No decorations on the hat, just a basic pointy hat. Keep everything else exactly the same.",
    "headwear_2": "Add a purple wizard hat with a bright golden star emblem on the front of the hat. Keep everything else exactly the same.",
    "headwear_3": "Add a purple wizard hat that glows with magical blue-purple light, with small sparkles and light rays emanating from the hat. Keep everything else exactly the same.",
    "headwear_4": "Replace his bare head with an ornate golden crown with purple gems and magical energy radiating from it, like a powerful wizard king. Keep everything else exactly the same.",

    # Accessory track: staff evolution
    "accessory_1": "Put a simple plain wooden walking stick (brown, no decorations) in his right hand. Keep everything else exactly the same.",
    "accessory_2": "Put a wooden staff with a large blue glowing crystal mounted on top in his right hand. Keep everything else exactly the same.",
    "accessory_3": "Put a dark wooden staff with glowing purple rune symbols carved along the shaft and a crystal on top in his right hand. Keep everything else exactly the same.",
    "accessory_4": "Put an ornate legendary golden staff with a large radiant orb on top surrounded by swirling magical energy in his right hand. Keep everything else exactly the same.",

    # Aura track: magic effects
    "aura_1": "Add a few small magical sparkle dots (tiny white and yellow glowing dots) floating around the character. Keep everything else exactly the same.",
    "aura_2": "Add multiple golden four-pointed stars floating and orbiting around the character at various distances. Keep everything else exactly the same.",
    "aura_3": "Add floating magical rune symbols glowing in purple and blue, slowly orbiting around the character. Keep everything else exactly the same.",
    "aura_4": "Add a powerful full magical aura - a glowing purple and golden energy field surrounding the entire character with floating runes, stars, and swirling magical particles. Keep everything else exactly the same.",
}


def upload_image(image_path: str) -> str:
    """Upload an image to Leonardo and return its ID."""
    # Step 1: Get presigned URL
    ext = Path(image_path).suffix.lstrip(".")
    resp = requests.post(
        f"{BASE_URL}/init-image",
        headers=HEADERS,
        json={"extension": ext},
    )
    resp.raise_for_status()
    data = resp.json()["uploadInitImage"]
    upload_url = data["url"]
    image_id = data["id"]
    fields_json = data["fields"]

    # Step 2: Upload to S3
    fields = json.loads(fields_json)
    with open(image_path, "rb") as f:
        files = {"file": (Path(image_path).name, f)}
        upload_resp = requests.post(upload_url, data=fields, files=files)
        upload_resp.raise_for_status()

    print(f"  Uploaded {image_path} -> image ID: {image_id}")
    return image_id


def generate_kontext(prompt: str, context_image_id: str) -> str:
    """Start a Kontext generation and return the generation ID."""
    payload = {
        "modelId": "28aeddf8-bd19-4803-80fc-79602d1a9989",
        "prompt": prompt,
        "width": WIDTH,
        "height": HEIGHT,
        "num_images": 1,
        "contextImages": [{"type": "UPLOADED", "id": context_image_id}],
    }
    resp = requests.post(
        f"{BASE_URL}/generations",
        headers=HEADERS,
        json=payload,
    )
    resp.raise_for_status()
    gen_id = resp.json()["sdGenerationJob"]["generationId"]
    print(f"  Generation started: {gen_id}")
    return gen_id


def poll_generation(gen_id: str, timeout: int = 120) -> str:
    """Poll until generation completes, return image URL."""
    start = time.time()
    while time.time() - start < timeout:
        resp = requests.get(
            f"{BASE_URL}/generations/{gen_id}",
            headers=HEADERS,
        )
        resp.raise_for_status()
        data = resp.json()["generations_by_pk"]
        status = data["status"]

        if status == "COMPLETE":
            images = data["generated_images"]
            if images:
                url = images[0]["url"]
                print(f"  Complete: {url[:80]}...")
                return url
            raise RuntimeError(f"Generation {gen_id} complete but no images")
        elif status == "FAILED":
            raise RuntimeError(f"Generation {gen_id} failed")

        time.sleep(5)

    raise TimeoutError(f"Generation {gen_id} timed out after {timeout}s")


def download_image(url: str, output_path: str):
    """Download image from URL."""
    resp = requests.get(url)
    resp.raise_for_status()
    with open(output_path, "wb") as f:
        f.write(resp.content)
    print(f"  Downloaded -> {output_path}")


def remove_background(input_path: str, output_path: str):
    """Remove background using rembg."""
    from rembg import remove
    from PIL import Image

    img = Image.open(input_path)
    result = remove(img)
    result.save(output_path)
    print(f"  Background removed -> {output_path}")


def resize_image(input_path: str, output_path: str, width: int = 400, height: int = 720):
    """Resize transparent PNG to target dimensions."""
    from PIL import Image

    img = Image.open(input_path).convert("RGBA")
    img.thumbnail((width, height), Image.Resampling.LANCZOS)

    # Center on canvas of exact target size
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    x = (width - img.width) // 2
    y = (height - img.height) // 2
    canvas.paste(img, (x, y), img)
    canvas.save(output_path)
    print(f"  Resized -> {output_path}")


def check_balance():
    """Print current API token balance."""
    resp = requests.get(f"{BASE_URL}/me", headers=HEADERS)
    resp.raise_for_status()
    user = resp.json()["user_details"][0]
    api_tokens = user.get("apiPaidTokens", 0)
    sub_tokens = user.get("subscriptionTokens", 0)
    print(f"Balance: {api_tokens} API tokens, {sub_tokens} subscription tokens")
    return api_tokens


def main():
    TEMP_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    print("=== Mage Character Image Generation Pipeline ===\n")

    # Check balance
    api_tokens = check_balance()
    estimated_cost = 13 * 71  # ~71 tokens per generation
    print(f"Estimated cost: ~{estimated_cost} tokens for 13 generations")
    if api_tokens < estimated_cost:
        print(f"WARNING: May not have enough API tokens ({api_tokens} < {estimated_cost})")
    print()

    # Track state for resume capability
    state_file = TEMP_DIR / "state.json"
    if state_file.exists():
        state = json.loads(state_file.read_text())
        print(f"Resuming from previous state ({len(state.get('completed', []))} completed)")
    else:
        state = {"completed": [], "base_ref_id": None}

    def save_state():
        state_file.write_text(json.dumps(state, indent=2))

    # === Phase 1: Generate base image ===
    base_raw = TEMP_DIR / "base_raw.jpg"
    base_nobg = TEMP_DIR / "base_nobg.png"
    base_final = OUTPUT_DIR / "mage_base.png"

    if "base" not in state["completed"]:
        print("Phase 1: Generating base mage (no upgrades)...")
        gen_id = generate_kontext(BASE_PROMPT, ORIGINAL_REF_ID)
        url = poll_generation(gen_id)
        download_image(url, str(base_raw))
        state["completed"].append("base")
        save_state()
    else:
        print("Phase 1: Base already generated, skipping.")

    # Process base image
    if not base_final.exists():
        print("Processing base image...")
        remove_background(str(base_raw), str(base_nobg))
        resize_image(str(base_nobg), str(base_final))

    # === Phase 1.5: Upload base as new reference ===
    if not state.get("base_ref_id"):
        print("\nUploading base as reference for variant generation...")
        # Upload the raw (with background) version for better Kontext results
        state["base_ref_id"] = upload_image(str(base_raw))
        save_state()
    base_ref_id = state["base_ref_id"]
    print(f"Base reference ID: {base_ref_id}\n")

    # === Phase 2: Generate all track variants ===
    print("Phase 2: Generating track variants...")
    for variant_name, prompt in TRACK_VARIANTS.items():
        if variant_name in state["completed"]:
            print(f"  {variant_name}: already generated, skipping.")
            continue

        raw_path = TEMP_DIR / f"{variant_name}_raw.jpg"
        nobg_path = TEMP_DIR / f"{variant_name}_nobg.png"
        final_path = OUTPUT_DIR / f"mage_{variant_name}.png"

        print(f"\n  Generating: {variant_name}")
        print(f"  Prompt: {prompt[:70]}...")

        try:
            gen_id = generate_kontext(prompt, base_ref_id)
            url = poll_generation(gen_id)
            download_image(url, str(raw_path))

            print(f"  Processing {variant_name}...")
            remove_background(str(raw_path), str(nobg_path))
            resize_image(str(nobg_path), str(final_path))

            state["completed"].append(variant_name)
            save_state()
            print(f"  Done: {variant_name}")

        except Exception as e:
            print(f"  ERROR generating {variant_name}: {e}")
            print("  Continuing with next variant...")
            continue

    # === Summary ===
    print("\n=== Summary ===")
    completed = state["completed"]
    total = 1 + len(TRACK_VARIANTS)  # base + variants
    print(f"Completed: {len(completed)}/{total}")

    missing = [v for v in ["base"] + list(TRACK_VARIANTS.keys()) if v not in completed]
    if missing:
        print(f"Missing: {', '.join(missing)}")
        print("Run the script again to retry missing images.")
    else:
        print("All images generated successfully!")

    final_balance = check_balance()
    print(f"Tokens used: ~{api_tokens - final_balance}")

    # List final assets
    print(f"\nFinal assets in {OUTPUT_DIR}:")
    for f in sorted(OUTPUT_DIR.glob("*.png")):
        print(f"  {f.name}")


if __name__ == "__main__":
    main()
