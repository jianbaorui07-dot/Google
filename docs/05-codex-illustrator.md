# 5. Codex 接入 Illustrator / AI 矢量文件

这份文档说明 Codex 如何接入 Adobe Illustrator 和 `.ai` 矢量文件工作流。这里的 **AI 文件** 指 Adobe Illustrator 的 `.ai` 矢量工程文件，不是“大模型 AI”。公开仓库只描述接入方式、参数化脚本方向和安全边界，不上传客户图稿、源图路径、导出结果或私有 `.ai` 工程。

## 这条桥解决什么

Illustrator 适合处理矢量图形、线稿矢量化、SVG/PDF 导出、图标草图、包装辅助图和品牌物料初稿。Codex 不替代 Illustrator，而是负责把重复动作写成脚本、把输入输出参数化、检查本机环境，并把可公开复用的流程沉淀到 GitHub。

| 场景 | Codex 负责 | Illustrator 负责 |
| --- | --- | --- |
| 线稿矢量化 | 生成任务参数、调用脚本、记录结果摘要 | Image Trace、路径扩展、矢量清理 |
| SVG / PDF 导出 | 检查输出格式、统一命名规则、提示安全边界 | 按画板导出 SVG、PDF、PNG |
| 图标和版式草图 | 生成基础形状、文字占位和图层结构 | 矢量编辑、排版、颜色和画板 |
| 包装辅助图 | 把尺寸、区域和标注转成脚本参数 | 画板、路径、参考线和导出 |

## 最短工作链

1. 用户手动安装并授权 Illustrator。
2. 用户手动打开 Illustrator，确认能正常进入主界面。
3. 本机用环境变量配置可执行文件路径：

```powershell
$env:ILLUSTRATOR_EXE="<illustrator.exe>"
```

4. 运行总状态检查：

```powershell
python examples\bridge_status.py --probe-executables
```

5. 后续公开脚本只通过参数接收输入和输出路径，例如 `-InputPath "<source-image>" -OutputPath "$env:TEMP\trace.svg"`，不把真实素材路径写进仓库。

## 推荐 MCP 工具方向

| 工具名 | 作用 | 公开边界 |
| --- | --- | --- |
| `get_document_info` | 读取当前文档名称、画板数量、尺寸和颜色模式 | 只返回状态，不保存图稿 |
| `create_test_artboard` | 创建公开安全的测试画板和基础矢量对象 | 不引用本机素材 |
| `trace_image_to_vector` | 输入图片，调用 Image Trace，导出 SVG/PDF | 输入和输出路径必须由参数传入 |
| `export_svg` | 导出当前文档或指定画板为 SVG | 输出目录只放本机临时目录 |
| `export_pdf` | 导出 PDF 校样 | 不提交导出文件 |
| `export_png` | 导出预览 PNG | 预览图只留本机输出目录 |

## 当前公开仓库应该保存什么

允许进入 GitHub：

- Illustrator / AI 矢量文件接入说明。
- 不含本机路径的 PowerShell / Python / JavaScript 示例脚本。
- 只使用程序生成图形的公开测试画板脚本。
- 状态检查中对 `ILLUSTRATOR_EXE` 和 `Illustrator.Application` COM 的探测逻辑。

不要进入 GitHub：

- `.ai` 私有工程、客户图稿、商业字体、商业画笔、购买素材。
- 源图路径、微信临时路径、桌面路径、导出目录和真实项目输出。
- Illustrator 安装路径、Creative Cloud 缓存、账号、许可证、Cookie、token。
- 自动登录、绕过授权、批量抓取账号内云文档的脚本。

## 适合中国用户的说法

在中文文档里优先把这条桥叫做 **AI 矢量文件桥**，第一次出现时说明：“AI 文件指 Adobe Illustrator 的 `.ai` 文件”。这样更符合设计、电商、包装和物料制作人员的日常叫法，也能避免和人工智能 AI 混淆。

## 验收标准

| 检查项 | 合格标准 |
| --- | --- |
| 状态检查 | `python examples\bridge_status.py --probe-executables` 能显示 Illustrator 桥状态 |
| 路径安全 | 文档和脚本里没有真实本机路径、客户图稿路径或默认素材目录 |
| 参数化 | 输入图片、输出 SVG/PDF/PNG 路径都通过参数传入 |
| 公开示例 | 测试画板只使用程序生成的形状、文字和颜色 |
| Git 安全 | `.ai`、导出 SVG/PDF/PNG、源图和报告产物不进入 Git 提交 |

## 后续路线

1. 给 `examples/bridge_status.py` 保留 Illustrator 状态检查入口。
2. 新增只读当前文档信息脚本，先读取文档和画板状态，不导出文件。
3. 新增公开安全的测试画板脚本，只绘制基础矢量对象。
4. 再做 `trace_image_to_vector`，输入和输出路径全部参数化。
5. 稳定后封装成本机 MCP 工具，让 Codex 能调用、记录结果并提示风险。
