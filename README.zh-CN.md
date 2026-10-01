# Unity MCP UI Layout

[English](./README.md) | [한국어](./README.ko.md) | **简体中文**

一套通过 `unity-mcp` 构建稳定 Unity UI 的可复用工作流规则，以 Codex 技能为标准版本，并提供其他 LLM 平台的适配文档。

先根据设计稿、截图、结构化导出文件或目标分辨率建立中立的 `layer-to-layout tree`，再使用所选 UI 技术栈的布局、复用、缩放和验证机制实现界面。先确定顶层区域的归属，再处理具体控件；复用重复结构，并保留完整的单张图片资源，除非运行时行为要求拆分。

当前版本：[v0.7.0](https://github.com/Hanjo92/unity-mcp-ui-layout/releases/tag/v0.7.0) · [更新日志](./CHANGELOG.md)

## 从这里开始

1. 阅读标准工作流 [`unity-mcp-ui-layout/SKILL.md`](./unity-mcp-ui-layout/SKILL.md)。
2. 实现之前先选择 UI 技术栈：`UGUI` 或 `UI Toolkit`。
3. 确定修改模式：修复已有界面，或构建新界面。
4. 对于新界面或重新设计，通过逐步提问确认尚未决定的设计与结构，再确定中立的 `layer-to-layout tree`。保留用户已有的回答。
5. 有设计稿时，检查并复用项目中合适的图片。只有执行者具备可用的图像生成技能和执行路径，才可询问是否生成缺失资源并进行生成。没有该技能时，即使存在独立的图像工具，也应跳过提问和生成。优先遵守用户明确提出的仅布局要求。
6. 对于 Stitch HTML/CSS、Figma 节点树导出、`DESIGN.md` 或设计令牌，编辑前先区分结构来源与样式来源。
7. 从 [`examples/README.md`](./examples/README.md) 选择任务示例，按照[智能体执行指南](./unity-mcp-ui-layout/references/agent-runbook.md)操作，或在[参考文档索引](./unity-mcp-ui-layout/references/README.md)中查找具体规则和故障处理方法。

首次练习可使用[基础布局示例](./examples/first-layout-pass-example.md)。“根据附件中的设计稿构建 Unity UI”或“根据这张设计截图创建 Unity UI 预制体”等自然语言请求也应能触发该技能，无需明确写出技能名称。

工作流优先考虑稳定的结构、明确的修改范围和有依据的验证。微调单个控件时，不必机械地执行全部规划步骤。

[执行约定](./unity-mcp-ui-layout/references/execution-contract.md)统一技术栈选择、审核权限、坐标计算和完成判定。可安装技能内置[计划模板](./unity-mcp-ui-layout/templates/mockup-layout-plan.yaml)及 [Ruby 验证器](./unity-mcp-ui-layout/scripts/validate_layout_plan.rb)，仓库顶层模板保留为同步的兼容副本。这使决策和计划检查可重复，但不保证不同模型或 Unity 版本产生逐像素一致的结果。

## 逐步规划与图片资源

先进行 [UI 规划](./unity-mcp-ui-layout/references/ui-planning-workflow.md)，再执行[图片资源工作流](./unity-mcp-ui-layout/references/image-asset-workflow.md)。确认尚未决定的设计与结构，复用合适的项目图片，并且只在有合格执行者时生成已商定的缺失资源。没有资源索引时，直接搜索和检查项目。

生成的图片需要在所选 UI 技术栈中完成检查、导入、绑定和视觉验证。允许生成临时资源不等于批准最终美术资源。[完整示例](./examples/planned-ui-with-project-images-example.md)涵盖已有回答、用户拒绝生成、生成不可用，以及两种 UI 技术栈的处理方式。

## 多智能体与编排

对于 Orca/Paseo 管理的会话、Claude/OpenCode 执行者或 API 委派任务，请遵循[智能体能力与任务分配规则](./unity-mcp-ui-layout/references/agent-capability-routing.md)和[混合智能体示例](./examples/mixed-agent-ui-workflow-example.md)。分配角色前，应逐一验证实际执行会话的能力。服务名称或父智能体的能力不能证明子智能体具备相应资格。

| 角色 | 所需证据 |
| --- | --- |
| 图像分析与视觉验收 | 当前版本的图片已实际传入，且执行者能够理解图片内容 |
| 图像生成 | 同一执行者已阅读其图像生成技能，并拥有可用的执行路径 |
| 结构与代码实现 | 已批准的结构化计划，以及对负责文件的访问权限 |
| Unity 绑定与截图 | 已验证的项目/Editor 访问能力及相关工具 |

只有指定的协调者可以转达已验证的生成负责人提出的问题；没有生成技能的实现子智能体不能提问或代为转达。纯文本执行者使用已批准的结构、测量数据和资源引用。具备已验证视觉能力的负责人分析图片并检查最终截图。截图、导入或代码检查成功并不能证明视觉质量。如果团队没有视觉能力，必要的图像分析和视觉验证应保持待完成状态。

## 核心规则

- 调整具体控件前，先确定顶层区域归属和容器关系。
- 有设计稿时，在创建对象之前建立中立的 `layer-to-layout tree`。
- 将该树映射到所选技术栈的原生层级、样式和复用机制。
- 仅在运行时路径需要时添加界面宿主；创建可复用 UI 本身并不要求添加宿主。
- 半自动图像检测结果在审核前保留于 `candidate item ledger` 中。
- 对需拆分的运行时元素或重复元素，记录原始 rect、归一化 rect、Unity 适配意图和资源/裁剪计划。
- 使用所选技术栈的复用机制表达重复结构。
- 除非交互、动画或自适应行为要求拆分，否则保持单张图片区域完整。
- 通过截图验证结构，不要只追求原始像素坐标对齐。

## 从设计稿到 UI Toolkit

按以下顺序操作：

1. 在 [ui-stack-selection.md](./unity-mcp-ui-layout/references/ui-stack-selection.md) 中选择技术栈。
2. 确认并批准 [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml) 中的中立 `mockup-layout-plan/v2` 计划。
3. 按照 [ui-toolkit-build-workflow.md](./unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md) 进行实现。

标准 YAML 示例分别涵盖 [UGUI 预制体计划](./examples/mockup-layout-plan-prefab-example.yaml)和 [UI Toolkit 实现](./examples/mockup-layout-plan-ui-toolkit-example.yaml)。完整过程请参阅 [UI Toolkit 示例](./examples/ui-toolkit-from-mockup-example.md)。

## 完成条件

- 布局在主要目标分辨率和至少一种其他宽高比下保持稳定。
- 文本能够正确处理较长标签、计数器和本地化后的长度增长。
- 保留共享资源、将修改限制在局部，或在修改共享基础资源前验证另一处已知使用位置。
- 涉及脚本的修改没有未解决的编译或控制台错误。
- 必要的视觉检查针对当前输出版本进行；技术检查与用户对美术资源的批准应分别报告。

## 适用任务

- 设计稿与截图分析：原始分辨率、图层树、候选审核、元素 rect、裁剪计划和资源拆分粒度。
- UGUI：锚点、`CanvasScaler`、预制体复用与 Variant、静态 Sprite 和纹理驱动的 `RawImage` 区别，以及共享资源的安全修改。
- UI Toolkit：容器归属、flex 布局、UXML/USS、可复用的 `VisualTreeAsset` 模板和文本溢出。
- 结构化设计输入：Stitch HTML/CSS、Figma 节点树、`DESIGN.md`、设计令牌及其到 Unity 样式的映射。
- 资源复用：发现优先级、项目图片、命名与目录规则、共享及界面专用资源，以及由合格执行者进行的图像生成。
- 响应式 UI：HUD、背包、弹窗、滚动视图、移动端安全区域，以及长屏、宽屏和不同平板规格的验证。
- 文本与本地化：换行、截断、自动字号控制、长标签、多行正文和不断增长的计数器。
- 构建与修复：限定范围的修改、当前界面与设计稿对比、MCP 调用示例、截图验证循环和故障恢复。

## 仓库导航

| 路径 | 用途 |
| --- | --- |
| [unity-mcp-ui-layout/](./unity-mcp-ui-layout) | 可安装的标准技能：`SKILL.md`、智能体元数据和详细参考文档 |
| [Platform/](./Platform) | Codex、Google Antigravity 和 Claude Artifacts 适配文档 |
| [examples/](./examples/README.md) | 可复制的提示词和任务示例 |
| [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml) | 中立布局计划模板 |
| [tests/](./tests) | 文档、元数据和模式检查 |
| [tests/forward/](./tests/forward) | 保留的提示词、报告和诊断测试资料 |
| [docs/validation/](./docs/validation) | 实际运行记录及其验证范围 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | 贡献流程与范围说明 |

先阅读技能和相关示例，再按需查阅详细参考文档。UI Toolkit 文档检查还会验证公开入口、计划链接、平台提示词及发布文档说明。检查已有报告并不会启动新的智能体。

## 平台说明

### Codex

默认平台。使用下方命令将标准技能目录复制到 Codex 的技能目录。

### Google Antigravity

将 `Platform/Google-Antigravity/` 中的提示词用于工作区或自定义指令。需要通过 MCP 或同等桥接工具访问 Unity。

### Claude Artifacts

将 `Platform/Claude-Artifacts/` 中的提示词用于已连接 Unity 工具的 Claude 项目或 artifact 工作流。

## 安装到 Codex

在仓库根目录执行以下命令。

### Windows

```powershell
Copy-Item -Recurse -Force .\unity-mcp-ui-layout $HOME\.codex\skills\
```

### macOS / Linux

```bash
cp -R ./unity-mcp-ui-layout ~/.codex/skills/
```

## 请求示例

```text
使用 $unity-mcp-ui-layout，根据附件中的布局图片构建 1920x1080 UGUI HUD。
创建对象前，先将视觉图层分析为清晰的 Unity Transform/RectTransform 树。
如果元素检测存在不确定性，在审核前将候选保留于 candidate item ledger。
对于需拆分的运行时元素或重复元素，先记录设计稿中的 item-level UI rect，再调整 Unity 尺寸。
按锚点划分顶层区域，再映射到父容器和 CanvasScaler 规则。
将重复结构实现为可复用的预制体或布局块。
除非运行时行为要求拆分，否则保持单张图片区域完整。
使用截图验证结果。
```

## 各平台示例

### Codex

```text
使用 $unity-mcp-ui-layout 修复当前 UGUI 背包布局。
保留现有样式，修复槽位间距和缩放偏移，并在 1920x1080 和一种更窄的宽高比下验证。
保持重复槽位结构可复用，不要逐个重建。
```

### Google Antigravity

```text
根据附件设计稿构建 1920x1080 Unity HUD。
选择目标 UI 技术栈，建立中立的 layer-to-layout tree，并使用该技术栈的原生布局系统实现顶层区域。
使用截图验证结果。
```

### Claude Artifacts

```text
根据附件设计稿，帮助我构建 1920x1080 UGUI HUD。
以 artifact 方式循环推进，使用 Plan、Current Change、Verification 和 Next Step 四个部分。
```

## 验证

准备发布或修改公开工作流说明时，运行以下检查：

```bash
bash tests/agent_runbook_keywords.sh
bash tests/layout_snapshot_keywords.sh
bash tests/mockup_layout_plan_schema.sh
ruby tests/layout_plan_semantics_test.rb
bash tests/review_gates_keywords.sh
bash tests/trigger_keywords.sh
bash tests/layer_tree_keywords.sh
bash tests/item_rect_keywords.sh
bash tests/item_candidate_keywords.sh
bash tests/ui_toolkit_docs_keywords.sh
bash tests/ui_stack_selection_keywords.sh
bash tests/ui_toolkit_build_keywords.sh
bash tests/ui_toolkit_forward_contract.sh
for test in tests/*.sh; do bash -n "$test" || exit 1; done
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py unity-mcp-ui-layout
git diff --check
```

[2026-09-09 实际能力验证记录](./docs/validation/2026-09-09-agent-capability-routing.md)涵盖在 Orca 中运行的真实 Codex 和 OpenCode 会话。两者均成功解读了诊断图片。针对 OpenCode 首次回答中关于问题转达的矛盾，修正说明后在同一会话中进行了复测并通过；首次和修正后的报告均已保留。

尚未执行实际图像生成、Unity 操作、Paseo/Claude 运行，以及禁用视觉能力的运行时测试。上述 shell 检查验证的是文档、模式约束和已保存的证据，不能证明这些执行路径已成功运行。

## 发布与维护

- [更新日志](./CHANGELOG.md)
- [后续任务](./BACKLOG.md)
- [发布检查清单](./RELEASE_CHECKLIST.md)
- [维护说明](./MAINTENANCE.md)

## 说明

- Codex 技能是标准版本；平台适配文档遵循相同工作流。
- 根据真实项目中的使用经验持续改进。
- 使用所选技术栈的复用机制描述重复 UI。
- 装饰性的单张图片区域应保持简单，仅在交互或自适应行为需要时拆分。
- 修改概述、命令或验证范围时，应同步更新英文、韩文和简体中文 README。链接指向的参考文档保留各自原有语言。
