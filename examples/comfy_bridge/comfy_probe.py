from __future__ import annotations

import json
import os
import urllib.request


BASE_URL = os.environ.get("COMFY_BASE_URL", "http://127.0.0.1:8188")


def get_json(path: str):
    with urllib.request.urlopen(f"{BASE_URL}{path}", timeout=20) as response:
        return json.loads(response.read().decode("utf-8"))


def main() -> None:
    stats = get_json("/system_stats")
    print("ComfyUI API:", BASE_URL)
    print("Version:", stats["system"].get("comfyui_version"))
    print("Python:", stats["system"].get("python_version"))

    for device in stats.get("devices", []):
        print("Device:", device.get("name"))
        print("VRAM free:", device.get("vram_free"))

    loader = get_json("/object_info/CheckpointLoaderSimple")
    checkpoints = loader["CheckpointLoaderSimple"]["input"]["required"]["ckpt_name"][0]
    print("Checkpoints:")
    for name in checkpoints:
        print("-", name)

    queue = get_json("/queue")
    print("Queue running:", len(queue.get("queue_running", [])))
    print("Queue pending:", len(queue.get("queue_pending", [])))


if __name__ == "__main__":
    main()
