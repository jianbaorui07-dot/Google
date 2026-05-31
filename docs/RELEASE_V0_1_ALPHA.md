# v0.1-alpha 发布说明

`v0.1-alpha` 只承诺当前仓库里真实可运行、可测试、可审计的工程原型能力。它不是完整创意软件自动化平台，也不声明 Photoshop / Illustrator / Blender / CapCut 已经生产可用。

## 承诺范围

stable：

- MCP stdio server 可以启动并响应 `initialize`、`tools/list`、`tools/call`。
- `starbridge.tools` 能列出 stable / experimental / planned 工具，`safe_only` 能过滤 guarded write。
- `bridge:status:safe` 和 preflight 能在缺少真实软件时返回结构化状态，不直接崩溃。
- ComfyUI workflow validate 可离线校验公开 workflow JSON；ComfyUI offline probe 返回 structured unavailable。
- AutoCAD/DXF 支持 JSON CAD plan validate、summary、dry-run、显式 `confirm_write` 后写入 `examples/cad/output`，并生成 manifest/report。
- sanitizer/redactor 会处理路径、HOME/USERPROFILE、用户名、token、api key、cookie、password、secret 等敏感文本。

experimental：

- Photoshop COM/document info 和 sandbox PSD/preview demo。
- Illustrator COM/document info 和 sandbox artboard/export demo。
- ComfyUI txt2img job lifecycle；img2img/upscale 仍属于后续扩展。
- Blender scene script 和 CapCut / 剪映 draft write。

planned：

- 多软件生产闭环。
- 真实桌面软件 E2E 验证截图和 release evidence。
- 跨软件素材交接、版本化 job manifest、可恢复任务队列。

not implemented：

- 自动登录、订阅、支付、验证码、OAuth 绕过。
- 默认读取客户图纸、PSD、AI、BLEND、视频草稿、模型或生成图。
- 无确认写入真实桌面软件或用户目录。

## 安装

推荐 Python 3.10+。最小安装不需要重型依赖：

```powershell
python -m pip install -e .
python -m pip install -e ".[dev]"
```

可选 extras：

```powershell
python -m pip install -e ".[cad]"
python -m pip install -e ".[comfy]"
python -m pip install -e ".[adobe]"
```

`cad` extra 里的 `ezdxf` 只用于真实 DXF 写入；没有它时 validate / dry-run 仍可运行，write 会返回 structured unavailable。

## 验证

```powershell
python -m pytest
npm.cmd test
npm.cmd run preflight
npm.cmd run bridge:status:safe
npm.cmd run starbridge:tools:safe
python scripts\security_check.py
python scripts\starbridge_preflight.py --markdown
python scripts\starbridge_preflight.py --write-report --soft-exit
```

## AutoCAD/DXF demo

默认 dry-run，不写文件：

```powershell
python examples\cad\generate_dxf_plan.py
```

通过 MCP 调用真实写入时必须满足三点：

- `dry_run=false`
- `confirm_write=true`
- `output_path` 位于 `examples/cad/output`

写入成功后只生成测试 DXF 和 `.manifest.json`，manifest 包含 layers、entity count、bbox、安全状态和脱敏后的输出名。

## MCP tools list

```powershell
npm.cmd run starbridge:tools:safe
python -m starbridge_mcp.server tools --json --safe-only
python -m starbridge_mcp.mcp_server
```

## 发布边界

本 release 不提交任何私有素材、模型、图片、客户图纸、真实路径、账号缓存或真实导出结果。Adobe / Blender / CapCut 写入类能力必须继续标注为 experimental，并默认限制在 sandbox/demo。
