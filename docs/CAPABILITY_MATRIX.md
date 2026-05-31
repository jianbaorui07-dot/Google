# StarBridge 能力矩阵

状态约定：

- `stable`：当前仓库有可运行代码和测试覆盖，缺少真实软件时返回 structured unavailable / skipped / soft-exit。
- `experimental`：已有 probe、demo 或 sandbox 入口，但不承诺生产闭环；写入必须 dry-run 或显式确认。
- `planned`：路线图能力，不能写成已完成。
- `not implemented`：明确不支持或还没有实现。

| Bridge | MCP Tool | CLI Script | Reads | Writes | Dry-run | Needs Real Software | Current Status | Safety Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| StarBridge core | `starbridge.status`, `starbridge.tools`, `starbridge.probe` | `python -m starbridge_mcp.server --json`; `npm.cmd run starbridge:tools:safe` | bridge metadata, env summary, static tool registry | no | n/a | no | stable | 输出经过 sanitizer；不打开用户文件。 |
| ComfyUI | `comfyui.system_probe`, `comfyui.workflow_validate` | `python examples\comfy_bridge\comfy_probe.py`; `python examples\comfy_bridge\validate_workflow.py --json`; `python examples\comfy_bridge\run_txt2img.py ...` | local API status, object info, workflow JSON | txt2img job submit only through explicit CLI | workflow validate is read-only; job lifecycle is experimental | probe/job submit needs local ComfyUI; workflow validate does not | stable for probe/validate; experimental for txt2img/img2img/upscale lifecycle | 不提交模型、LoRA、VAE、ControlNet、生成图或本机输出目录。ComfyUI offline 返回 structured unavailable。 |
| CAD / AutoCAD probe | `cad_autocad.environment_probe` | `python examples\cad_bridge\probe.py --json`; `python scripts\test_autocad_mcp.py` | executable, COM, pywin32, MCP project hints | no | n/a | real AutoCAD only needed for full desktop automation | stable probe; real AutoCAD automation remains environment-dependent | 不打开客户 DWG/DXF，不写真实项目输出。 |
| AutoCAD / DXF headless | `autocad_dxf.status`, `autocad_dxf.validate_cad_plan`, `autocad_dxf.create_dxf_plan`, `autocad_dxf.summarize_plan`, `autocad_dxf.write_dxf` | `python examples\cad\generate_dxf_plan.py`; MCP `tools/call` | JSON CAD plan, layers, entity summary, bbox | DXF and manifest under `examples/cad/output` only | default yes | no AutoCAD; real write needs optional `ezdxf` | stable alpha closed-loop | `confirm_write=true` required for real write; output path cannot escape controlled directory; missing `ezdxf` returns structured unavailable. |
| Photoshop | `photoshop.session_info`, `photoshop.document_info`, `photoshop.create_demo_document`, `photoshop.export_demo_preview`, `photoshop.run_demo` | `npm.cmd run photoshop:demo:plan`; `npm.cmd run photoshop:demo`; `npm.cmd run photoshop:info` | session/document metadata through COM when available | sandbox PSD/preview demo only | default yes | yes, authorized local Photoshop | stable for dry-run metadata shape; experimental for writes | 不打开私有 PSD；输入/输出必须参数化；真实输出只允许 `examples/output/photoshop`。 |
| Illustrator | `illustrator.document_info`, `illustrator.create_demo_artboard`, `illustrator.export_demo_assets`, `illustrator.run_demo` | `npm.cmd run illustrator:demo:plan`; `npm.cmd run illustrator:demo`; `npm.cmd run illustrator:info` | active document metadata through COM when available | sandbox AI/SVG/PDF/PNG demo only | default yes | yes, authorized local Illustrator | experimental | Image Trace/export 不能声称生产可用；真实输出只允许 `examples/output/illustrator`。 |
| Blender | `blender.environment_probe` | `python examples\blender_bridge\probe.py --json` | executable and optional MCP directory hints | no public write loop yet | n/a | real Blender only needed for future scene scripts | stable probe; scene generation planned | 不打开私有 `.blend`，不执行任意 Python，不下载外部资产。 |
| CapCut / 剪映 | `jianying_capcut.draft_probe` | `python examples\capcut_jianying_bridge\probe.py --json` | executable and draft directory env hints | no current draft write | n/a | real app only needed for future draft validation | research / planned | 不读取 `draft_content.json`，不导出视频，不触碰账号、会员或缓存。 |

## 当前功能清单

stable：

- MCP stdio server 和 `tools/list` / `tools/call` 基础协议。
- Tool registry，包含 safe-only 过滤。
- 总状态检查、bridge metadata 检查、preflight 和 security check。
- ComfyUI offline-safe probe 与 workflow JSON validate。
- AutoCAD/DXF plan validate、summary、dry-run、guarded write、manifest/report。

experimental：

- Photoshop sandbox demo 写入和导出。
- Illustrator sandbox demo 写入和导出。
- ComfyUI txt2img job submit 和后续 img2img/upscale lifecycle。
- Blender scene script。
- CapCut / 剪映 draft write。

planned：

- 完整多软件生产闭环。
- 真实桌面软件 E2E evidence。
- 跨软件 asset handoff 和 release-grade manifest。

not implemented：

- 自动登录、验证码、OAuth 授权、订阅支付。
- 默认读取客户文件、模型文件、账号缓存或真实工程输出。
- 无确认写入 Photoshop / Illustrator / Blender / CapCut / AutoCAD。
