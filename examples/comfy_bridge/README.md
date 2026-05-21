# Comfy Bridge Example

This folder contains a safe example bridge for connecting local Codex automation to a local ComfyUI server.

## What It Does

- Checks whether ComfyUI is online at `http://127.0.0.1:8188`.
- Reads system stats and checkpoint names.
- Submits a basic text-to-image workflow through the ComfyUI HTTP API.
- Keeps the visual workflow JSON separate from the API workflow JSON.

## What It Does Not Include

- No account passwords.
- No OAuth tokens.
- No browser cookies.
- No payment data.
- No private model files.
- No generated image output.
- No local browser profile data.

## Files

- `comfy_probe.py` checks ComfyUI status and available checkpoints.
- `run_txt2img.py` submits a minimal text-to-image workflow.
- `workflows/txt2img_basic_api.json` is the API workflow used by the script.
- `workflows/txt2img_basic_visual.json` is the visual workflow that can be opened inside the ComfyUI canvas.

## Usage

Start ComfyUI first, then run:

```powershell
python examples/comfy_bridge/comfy_probe.py
```

Check the full StarBridge local environment:

```powershell
python examples/bridge_status.py
```

Generate an image:

```powershell
python examples/comfy_bridge/run_txt2img.py --prompt "a quiet futuristic tea house in a garden"
```

Optional environment variables:

- `COMFY_BASE_URL`, default `http://127.0.0.1:8188`
- `COMFY_OUTPUT_DIR`, default `D:\AIGC\comfyui安装包\ComfyUI\output`

## Visual Workflow

Open this file inside ComfyUI:

```text
examples/comfy_bridge/workflows/txt2img_basic_visual.json
```

The visual workflow contains these nodes:

- `CheckpointLoaderSimple`
- `EmptyLatentImage`
- `CLIPTextEncode` positive prompt
- `CLIPTextEncode` negative prompt
- `KSampler`
- `VAEDecode`
- `SaveImage`
