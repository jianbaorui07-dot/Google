# 6. Codex 接入剪映 / CapCut

调研日期：2026-05-23

这份文档记录 Codex 接入剪映专业版 / CapCut Desktop 的初步方案。当前阶段先做公开安全调研和路线设计，不把本机草稿、素材路径、导出视频、账号信息或剪映缓存提交到 GitHub。

## 调研结论

- 优先路线是 **本地草稿桥**：Codex 生成或检查剪映草稿文件，用户在剪映里打开、确认和导出。
- 暂不把方向放在网页登录、云端接口抓包、绕过会员限制、自动点击 UI 或控制账号功能上。
- 本次没有找到面向普通开发者、可稳定调用的官方桌面剪辑自动化 API。CapCut 官方资料确认有 Desktop 版本和常见剪辑能力；服务条款提到 SDK/API 但也限制用自动化脚本与服务交互，所以公开仓库不能把“自动控制官方在线服务”当作默认路线。
- 可研究的开源方向包括 `pyJianYingDraft`、`pyCapCut` 和以 FastAPI / MCP 包装草稿生成能力的项目。它们适合作为候选参考，但进入本仓库前要先验证许可、依赖、草稿兼容性和隐私边界。

## 参考资料

| 来源 | 调研用途 |
| --- | --- |
| [CapCut 官方介绍](https://ads.us.tiktok.com/help/article/about-capcut?lang=en) | 确认 CapCut Mobile / Web / Desktop 的产品形态，以及桌面端支持多轨剪辑、字幕、文本、转场等能力。 |
| [CapCut Terms of Service](https://www.capcut.com/clause/terms-of-service?enter_from=page_header&from_page=landing_page&lang=en&store_region=US&template_scale=1%3A1) | 确认平台范围包含 Desktop、SDK/API，同时注意其对自动化脚本交互的限制。 |
| [GuanYixuan/pyJianYingDraft](https://github.com/GuanYixuan/pyJianYingDraft) | Python 生成剪映专业版草稿；文档建议从剪映全局设置里获取草稿位置，并用 `DraftFolder` 管理草稿。 |
| [GuanYixuan/pyCapCut](https://github.com/GuanYixuan/pyCapCut) | 与 `pyJianYingDraft` 同源的 CapCut 草稿工具，支持模板、素材替换、文本字幕和批量导出方向；生成草稿仍需在 Windows 版 CapCut 中打开或导出。 |
| [Hommy-master/capcut-mate](https://github.com/Hommy-master/capcut-mate) | FastAPI 形式的剪映草稿自动化助手，宣称提供 REST API、草稿管理、素材添加和 MCP 集成；适合作为后续服务化/MCP 参考，不直接照搬。 |

## 接入目标

- 让 Codex 能把脚本、字幕、镜头表和素材清单转换成剪映可打开的本地草稿。
- 支持读取本机草稿目录的基本状态，但不上传、不打印、不提交真实素材路径。
- 支持从用户手动创建的模板草稿复制出新草稿，再按参数替换文本、视频、图片、音频和字幕。
- 把稳定动作封装成 MCP 工具，让 Codex 可以调用 `inspect_draft`、`create_draft_from_plan`、`replace_template_media`、`import_subtitles_srt` 等能力。

## 推荐路线

### 1. 只读状态检查

先增加只读探针，读取环境变量，不扫描全盘：

```powershell
$env:JIANYING_DRAFTS_DIR="<path-to-jianying-drafts>"
$env:CAPCUT_DRAFTS_DIR="<path-to-capcut-drafts>"
```

探针只做这些事：

- 检查草稿目录是否存在。
- 统计含 `draft_content.json` 的草稿数量。
- 检查是否安装候选 Python 库，例如 `pyJianYingDraft` 或 `pycapcut`。
- 输出状态和下一步建议，不输出真实素材路径。

### 2. 生成公开安全测试草稿

第二步再生成一个最小草稿：

- 使用程序生成的纯色图、测试文字或本地临时音频占位，不使用用户私有素材。
- 草稿名称使用公开安全名称，例如 `codex_jianying_probe`。
- 输出到用户通过环境变量指定的草稿目录，或输出到 `output/` 让用户手动复制。
- 生成后由用户在剪映里打开检查，导出仍由用户手动处理。

### 3. 模板草稿替换

剪映里复杂字体、花字、转场、滤镜、字幕样式和贴纸最好先由用户手动做成模板。Codex 只替换可参数化内容：

| 替换对象 | Codex 可做的事 |
| --- | --- |
| 文本 | 替换标题、口播字幕、商品卖点、章节标题 |
| 视频 | 按片段名或模板槽位替换素材 |
| 图片 | 替换封面、产品图、背景图 |
| 音频 | 替换 BGM、旁白、音效 |
| 字幕 | 导入或更新 `.srt`，保留模板样式 |

### 4. MCP 封装方向

稳定后可以把本地脚本封装成 MCP 工具：

| 工具名 | 用途 |
| --- | --- |
| `inspect_draft_folder` | 检查草稿目录、草稿数量和候选模板 |
| `create_draft_from_plan` | 根据结构化镜头表生成草稿 |
| `duplicate_template_draft` | 复制模板草稿并命名为新草稿 |
| `replace_template_media` | 替换模板里的视频、图片、音频或文字 |
| `import_subtitles_srt` | 导入 `.srt` 字幕并套用模板样式 |
| `open_draft_location` | 打开草稿文件夹，交给用户在剪映中确认 |

## 本地配置

真实路径只放本机环境变量或本地 `.env`，不要写进公开文档：

```powershell
$env:JIANYING_EXE="<path-to-jianying.exe>"
$env:JIANYING_DRAFTS_DIR="<path-to-jianying-drafts>"
$env:CAPCUT_EXE="<path-to-capcut.exe>"
$env:CAPCUT_DRAFTS_DIR="<path-to-capcut-drafts>"
```

如果后续需要安装开源依赖，先在本机下载收件箱整理来源：

```powershell
$env:STARBRIDGE_DOWNLOAD_INBOX="<local-download-inbox>"
```

## 安全边界

允许进入 GitHub：

- 调研文档、路线图和公开安全的脚本。
- 不含真实素材路径的草稿结构检查逻辑。
- 使用程序生成占位素材的最小测试草稿脚本。
- 只读状态检查和明确的中文错误提示。

禁止进入 GitHub：

- 剪映草稿目录、`draft_content.json`、`draft_info.json`、缓存、封面图和导出视频。
- 用户素材路径、微信临时路径、桌面路径、客户视频、商业音乐、字幕原稿和真实项目输出。
- CapCut / 剪映账号、Cookie、token、OAuth 缓存、会员状态、支付信息。
- 破解版本、绕过会员限制、绕过登录、自动点击付费或发布流程的脚本。

## 最小验证清单

第一次真正接入前，应先完成这些验证：

- 在本机手动打开剪映，确认可以正常进入主界面。
- 用户从剪映设置中确认草稿目录，并只通过 `JIANYING_DRAFTS_DIR` 或 `CAPCUT_DRAFTS_DIR` 提供给脚本。
- 选择一个开源库做本地临时验证，记录版本、许可、依赖和是否能生成可打开草稿。
- 检查生成草稿里是否包含真实绝对路径；如果包含，只能留本机，不提交。
- 导出视频由用户在剪映里手动执行，直到确认官方条款和工具稳定性。

## 后续任务

- 新增 `examples/jianying_bridge/README.md`，只写本地配置和安全边界。
- 新增只读状态脚本，检查草稿目录和候选依赖。
- 本机临时验证 `pyJianYingDraft` 与 `pyCapCut` 的最小草稿生成能力。
- 选择一个模板替换实验：标题、字幕、图片和一段视频。
- 评估是否需要单独的本地 MCP 服务，而不是把剪映逻辑塞进通用状态检查脚本。
