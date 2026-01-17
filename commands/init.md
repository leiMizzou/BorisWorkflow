# /init

一键初始化 Boris Cherny 风格的 Claude Code 开发环境。

## 使用方式

```
/init
/init --minimal
/init --preset node
/init --preset python
/init --with-ralph
```

## 执行步骤

当用户运行 `/init` 时，执行以下操作：

### 1. 创建目录结构

```bash
mkdir -p .claude/commands .claude/agents
```

### 2. 创建 CLAUDE.md

在项目根目录创建 `CLAUDE.md` 模板，包含：
- 项目概述（待填写）
- 开发工作流命令
- 代码规范
- 禁止事项
- 已知问题记录区

### 3. 配置 settings.json

根据项目类型自动配置：
- 权限白名单（包管理器、git、测试命令等）
- 危险命令黑名单
- PostToolUse Hook（自动格式化）

### 4. 安装 Agent 模板

- `code-reviewer.md` - 代码审查
- `code-simplifier.md` - 代码简化
- `test-generator.md` - 测试生成
- `verify-app.md` - 应用验证

### 5. 安装斜杠命令

- `/add-rule` - 快速添加规则
- `/commit-push-pr` - 一键提交 PR
- `/setup-format-hook` - 配置格式化
- `/setup-permissions` - 配置权限
- `/setup-plugins` - 配置 MCP 插件

### 6. 可选：配置 MCP 插件

推荐插件：
- context7 - 获取最新库文档
- playwright - 浏览器自动化
- github - GitHub 集成

### 7. 可选：配置 Ralph Loop

启用自主循环开发功能。

## 完成后输出

```
✅ Claude Code 环境初始化完成！

📁 已创建文件：
├── CLAUDE.md
└── .claude/
    ├── settings.json
    ├── commands/
    │   ├── add-rule.md
    │   ├── commit-push-pr.md
    │   ├── setup-format-hook.md
    │   ├── setup-permissions.md
    │   └── setup-plugins.md
    └── agents/
        ├── code-reviewer.md
        ├── code-simplifier.md
        ├── test-generator.md
        └── verify-app.md

🎯 下一步：
1. 编辑 CLAUDE.md 添加项目特定规则
2. 测试命令：/add-rule 不要使用 any
3. 使用 /commit-push-pr 一键提交

💡 提示：
- 每次 Claude 犯错，用 /add-rule 记录规则
- 使用 Shift+Tab 进入 Plan Mode
- 长任务用 verify-app agent 验证
```

## 预设说明

### --minimal

仅创建：
- CLAUDE.md
- .claude/settings.json（基础权限）

### --preset node

优化 Node.js/TypeScript 项目：
- bun/npm 命令权限
- TypeScript 代码规范
- Jest/Vitest 测试配置

### --preset python

优化 Python 项目：
- pip/poetry 命令权限
- Python 代码规范
- pytest 测试配置

### --with-ralph

额外配置 Ralph Loop 自主循环开发。
