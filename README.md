# BorisWorkflow

> **🔄 用 Claude Code 学习 Claude Code 之父的开发技巧，再用这些技巧增强你的 Claude Code**
>
> *Learn from the father of CC, empower your CC, with CC itself.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

中文 | [English](./README_EN.md)

---

## 这是什么？

一套从 Claude Code 创造者 [Boris Cherny](https://x.com/bcherny) 的实战经验中提炼的工作流配置包。

**7.4M+ 浏览、98K+ 收藏**的[爆款推文](https://x.com/bcherny/status/2007179832300581177)，现在变成了可以直接使用的 Skills、Commands 和 Templates。

## 为什么特别？

这不仅仅是配置文件的集合 —— 这是 Anthropic 内部 Claude Code 团队日常使用的「**Compounding Engineering**」方法论的具象化。每一个配置都经过了高强度的实战验证。

### Boris Cherny 是谁？

- 🎯 **Claude Code 创造者** - 没错，就是他发明的这个工具
- 📚 **《Programming TypeScript》作者** - O'Reilly 畅销书
- 💡 **13 个高级技巧的分享者** - 引发开发者社区的广泛讨论

### 为什么需要 BorisWorkflow？

Boris 的 13 个技巧涉及：
- 多个配置文件 (CLAUDE.md, settings.json)
- 自定义命令和 Agent
- Hook 配置
- MCP 插件集成
- 权限管理

手动配置这些内容繁琐且容易出错。**BorisWorkflow 将所有最佳实践打包成一键安装的工具包**，让你立即获得专家级的 AI 编程体验。

---

## Boris 的 13 个技巧

| # | 技巧 | 说明 | 本套件支持 |
|---|------|------|-----------|
| 1 | 并行运行多个 Claude | 同时开多个终端窗口运行 Claude Code | 使用习惯 |
| 2 | Web + CLI 配合 | Web 版做规划，CLI 做执行 | 使用习惯 |
| 3 | 使用 Opus 4.5 | 最强模型，复杂任务必备 | 模型选择 |
| 4 | **CLAUDE.md** | Claude 的"记忆文件"，记录项目规范 | ✅ 模板提供 |
| 5 | **@.claude 规则** | PR 评论中标记规则，自动添加到记忆 | ✅ `/add-rule` |
| 6 | **Plan Mode** | 复杂任务先计划再执行 | 内置 Shift+Tab |
| 7 | **Slash Commands** | 自定义斜杠命令 | ✅ 7 个命令 |
| 8 | **Subagents** | 专门的子代理处理特定任务 | ✅ 4 个 Agent |
| 9 | **PostToolUse Hook** | 文件修改后自动格式化 | ✅ 自动配置 |
| 10 | **Permissions** | 预设安全权限，避免频繁确认 | ✅ 预设配置 |
| 11 | **工具集成 (MCP)** | 通过 MCP 服务器连接 Slack、BigQuery、Sentry 等工具 | ✅ 插件配置 |
| 12 | **长任务处理** | Background agents、Stop hooks、Ralph Loop 等多种方案 | ✅ `/setup-ralph-loop` + 文档 |
| 13 | **验证（最重要）** | 给 Claude 验证工作的方式，达到 2-3x 质量提升 | ✅ verify-app Agent |

**额外功能**：

| 功能 | 说明 |
|------|------|
| **一键安装** | 交互式脚本，自动检测项目类型 |

---

## 套件能力

### 1. CLAUDE.md 模板

Claude 的"记忆文件"，让 Claude 了解你的项目：

```markdown
# Project Guidelines for Claude

## 项目概述
- 项目名称、技术栈、主要功能

## 开发工作流
- 包管理器（bun/npm）
- 开发命令（typecheck, test, lint, build）

## 代码规范
- TypeScript：优先用 type 而非 interface
- 避免 any、enum
- 命名约定

## 禁止事项
- ❌ 不要使用 any
- ❌ 不要使用 console.log
- ❌ 不要硬编码敏感信息

## 已知问题
- 记录 Claude 犯过的错误，避免重复
```

### 2. 权限配置（三档预设）

**最小权限 (minimal)** - 仅只读操作：
- Git: `status`, `diff`, `log`, `branch`
- 文件: `Read(*)`
- 系统: `ls`, `pwd`, `which`

**推荐权限 (recommended)** - 平衡安全与便利（默认）：
- 包管理器: 自动检测的 `bun/npm/yarn/pnpm` + `run` 命令
- Git: `status`, `diff`, `log`, `add`, `commit`, `branch`, `checkout`, `stash`
- 文件: `Read(*)`（Write/Edit 需确认）

**完整权限 (full)** - 最大便利性：
- 包管理器: 所有命令
- Git: 所有操作（包括 push）
- 文件: `Read(*)`, `Write(*)`, `Edit(*)`
- 系统: `mkdir`, `cp`, `mv`, `touch`

**始终拒绝**（所有级别）：
- `rm -rf /`, `rm -rf ~`, `sudo:*`
- `curl * | bash`, `wget * | bash`
- `git push --force origin main/master`

### 3. 斜杠命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `/init` | 一键初始化环境 | `/init --preset node` |
| `/add-rule` | 添加规则到 CLAUDE.md | `/add-rule 不要使用 any` |
| `/commit-push-pr` | 提交 + 推送 + 创建 PR | `/commit-push-pr --draft` |
| `/setup-format-hook` | 配置自动格式化 | `/setup-format-hook --formatter prettier` |
| `/setup-permissions` | 配置权限 | `/setup-permissions --preset node` |
| `/setup-plugins` | 配置 MCP 插件 | `/setup-plugins --preset web-dev` |
| `/setup-ralph-loop` | 配置自主循环 | `/setup-ralph-loop --enable` |

### 4. Agent 模板

| Agent | 功能 | 使用场景 |
|-------|------|----------|
| `code-reviewer` | 代码审查 | 发现 bug、安全问题、性能问题 |
| `code-simplifier` | 代码简化 | 提取重复逻辑、优化导入 |
| `test-generator` | 测试生成 | 单元测试、集成测试、边界测试 |
| `verify-app` | 应用验证 | typecheck → lint → test → build |

使用方式：
```
请 code-reviewer 审查最近的更改
请 test-generator 为 src/auth.ts 生成测试
```

### 5. MCP 插件（工具集成）

**核心插件**：

| 插件 | 功能 | 为什么需要 |
|------|------|-----------|
| `context7` | 获取最新文档 | 避免使用过时的 API |
| `playwright` | 浏览器自动化 | 截图、E2E 测试 |
| `github` | GitHub API | Issue、PR 管理 |
| `fetch` | HTTP 请求 | 调试 API |
| `memory` | 持久化记忆 | 跨会话保存信息 |

**企业工具集成**（Boris 第 11 条）：

| 插件 | 功能 | 为什么需要 |
|------|------|-----------|
| `slack` | Slack 消息通知 | 团队沟通、任务完成通知 |
| `sentry` | 错误追踪 | 查看和分析生产错误 |
| `bigquery` | BigQuery 数据仓库 | 查询和分析大规模数据 |

**其他插件**：

| 插件 | 功能 | 为什么需要 |
|------|------|-----------|
| `figma` | 设计稿转代码 | UI 开发、设计还原 |
| `office` | Word/Excel/PPT | 文档生成、报告自动化 |

**预设配置**：
- `minimal` - 仅 context7（所有项目推荐）
- `recommended` - 5 个核心插件
- `web-dev` - Web 开发全套 + Figma
- `data-science` - 数据科学全套
- `enterprise` - 企业工具集成（Slack、Sentry、BigQuery）

### 6. 长任务处理（Boris 第 12 条）

Boris 推荐多种方案处理长时间运行的任务：

| 方案 | 说明 | 适用场景 |
|------|------|----------|
| **Background Agents** | 后台运行代理任务 | 并行处理多个任务 |
| **Stop Hooks** | 配置钩子在特定条件下暂停 | 需要人工确认的关键点 |
| **Ralph Loop** | 自主循环迭代直到完成 | 过夜开发、TDD 工作流 |

#### Ralph Loop 自主循环

基于 [Geoffrey Huntley 的技术](https://ghuntley.com/ralph/)，让 Claude **自主迭代开发直到完成**：

```bash
/ralph-loop "
实现用户认证系统：
- POST /auth/register
- POST /auth/login (JWT)
- GET /auth/me
- 测试覆盖率 > 80%
完成后输出: <promise>AUTH_DONE</promise>
" --max-iterations 30 --completion-promise "AUTH_DONE"
```

**真实案例**：
- Y Combinator 黑客马拉松**一夜生成 6 个仓库**
- **$50k 合同仅花费 $297 API 费用**完成
- 用此方法 3 个月创建了一整门编程语言

详细配置请参考 `/setup-ralph-loop` 命令。

---

## 安装

### 方式 1：一键安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/leiMizzou/BorisWorkflow.git

# 进入你的项目目录
cd your-project

# 运行安装脚本
../BorisWorkflow/install.sh --interactive
```

**安装选项**：
```bash
./install.sh                              # 交互式安装
./install.sh --preset node                # Node.js 项目
./install.sh --preset python              # Python 项目
./install.sh --full --with-ralph          # 完整 + Ralph Loop
./install.sh --minimal                    # 仅 CLAUDE.md
./install.sh --permission-level minimal   # 最小权限（只读）
./install.sh --permission-level full      # 完整权限
./install.sh --help                       # 查看帮助
```

**权限级别**：
| 级别 | 说明 | 适用场景 |
|------|------|----------|
| `minimal` | 仅只读操作 | 不信任的环境、审查代码 |
| `recommended` | 平衡安全与便利（默认） | 日常开发 |
| `full` | 完整权限 | 信任的项目环境 |

**自动检测**：
- 包管理器：自动检测 bun/npm/yarn/pnpm/pip
- 项目类型：自动检测 Node.js/Python/Rust/Go

### 方式 2：Claude Code 中初始化

```
/init
/init --preset node --with-ralph
```

### 方式 3：自然语言

在 Claude Code 中说：
```
初始化 Claude Code 环境
帮我配置 Boris Cherny 风格的开发环境
```

### 方式 4：手动安装

```bash
mkdir -p .claude/commands .claude/agents
cp templates/CLAUDE.md ./CLAUDE.md
cp templates/settings.json .claude/settings.json
cp templates/agents/* .claude/agents/
cp commands/* .claude/commands/
```

---

## 使用方式

### 日常开发

```bash
# 1. 复杂任务进入 Plan Mode
Shift+Tab

# 2. Claude 犯错时记录规则
/add-rule 不要在 useEffect 中直接调用 async

# 3. 代码完成后验证
请 verify-app agent 验证

# 4. 提交
/commit-push-pr
```

### 代码审查

```bash
请 code-reviewer 审查最近的更改
请 code-simplifier 优化这段代码
```

### 过夜自主开发

```bash
# 启动 Ralph Loop
/ralph-loop "任务描述" --max-iterations 30 --completion-promise "DONE"

# 第二天检查
git log --oneline -20
bun run test
```

---

## 文件结构

```
BorisWorkflow/
├── install.sh                    # 一键安装脚本
├── commands/                     # 斜杠命令
│   ├── init.md
│   ├── add-rule.md
│   ├── commit-push-pr.md
│   ├── setup-format-hook.md
│   ├── setup-permissions.md
│   ├── setup-plugins.md
│   └── setup-ralph-loop.md
├── templates/
│   ├── CLAUDE.md                 # 记忆文件模板
│   ├── settings.json             # 权限配置
│   ├── agents/                   # Agent 模板
│   └── plugins/                  # MCP 插件配置
└── skills/                       # Claude Skills
```

**安装后你的项目**：
```
your-project/
├── CLAUDE.md
└── .claude/
    ├── settings.json
    ├── commands/
    └── agents/
```

---

## 最佳实践

1. **持续更新 CLAUDE.md** - 每次 Claude 犯错用 `/add-rule` 记录
2. **Plan Mode** - 复杂任务先计划 (Shift+Tab)
3. **格式化 Hook** - 保证代码风格一致
4. **预设权限** - 避免频繁确认但保留安全检查
5. **使用 Agent** - 审查、测试、验证
6. **Ralph Loop** - 清晰任务可过夜完成

---

## 相关链接

- [Boris Cherny 原推文](https://x.com/bcherny/status/2007179832300581177)
- [Claude Code 官网](https://claude.ai/code)
- [Claude Code 文档](https://docs.anthropic.com/claude-code)
- [Geoffrey Huntley Ralph 技术](https://ghuntley.com/ralph/)
- [Ralph Wiggum 插件](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)

---

## 致谢

本项目的核心理念和最佳实践来自以下贡献者：

- **[Boris Cherny](https://x.com/bcherny)** - Claude Code 创建者，《Programming TypeScript》作者，本项目基于他分享的 13 个高级技巧
- **[Geoffrey Huntley](https://ghuntley.com/)** - Ralph Loop 自主循环技术的发明者

---

## License

MIT License

---

## 贡献

欢迎提交 Issue 和 PR！如果觉得有用，请给个 Star！

---

Made with Claude Code, based on Boris Cherny's workflow
