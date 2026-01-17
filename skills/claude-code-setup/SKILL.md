# Claude Code Setup Skill

一键初始化 Boris Cherny 风格的 Claude Code 开发环境。

## 触发条件

当用户说以下内容时触发此技能：
- "初始化 Claude Code 环境"
- "setup claude code"
- "配置 Boris 风格的开发环境"
- "创建 .claude 目录"

## 执行步骤

### 1. 创建目录结构

首先创建 Claude Code 的标准目录结构：

```bash
mkdir -p .claude/commands
mkdir -p .claude/agents
mkdir -p .claude/settings
```

### 2. 创建 CLAUDE.md 文件

在项目根目录创建 `CLAUDE.md`，这是项目的"记忆文件"：

```markdown
# Project Guidelines for Claude

## 项目概述
[请填写项目简介]

## 开发工作流

### 包管理器
**始终使用 `bun`，不要使用 `npm`。**

### 开发命令
```sh
# 1. 修改代码后

# 2. 类型检查（快速）
bun run typecheck

# 3. 运行测试
bun run test -- -t "测试名称"    # 单个测试套件
bun run test:file -- "glob"      # 特定文件

# 4. 提交前 lint
bun run lint:file -- "file1.ts"  # 特定文件
bun run lint                      # 所有文件

# 5. 创建 PR 前
bun run lint && bun run test
```

## 代码规范

### TypeScript
- 优先使用 `type` 而非 `interface`
- 避免使用 `enum`，使用字符串字面量联合类型
- 所有函数必须有明确的返回类型

### 命名约定
- 组件：PascalCase
- 函数/变量：camelCase
- 常量：UPPER_SNAKE_CASE
- 文件：kebab-case

## 禁止事项
- ❌ 不要使用 `any` 类型
- ❌ 不要使用 `enum`
- ❌ 不要使用 `npm`（使用 `bun`）
- ❌ 不要提交未格式化的代码

## 已知问题和解决方案
[当 Claude 犯错时，在此记录以避免重复]
```

### 3. 创建 settings.json

配置预设权限和常用设置：

```json
{
  "permissions": {
    "allow": [
      "Bash(bun run build:*)",
      "Bash(bun run lint:*)",
      "Bash(bun run test:*)",
      "Bash(bun run typecheck:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": []
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bun run format || true"
          }
        ]
      }
    ]
  }
}
```

### 4. 创建基础 Subagents

创建常用的 subagent 模板：

**`.claude/agents/code-simplifier.md`**
```markdown
# Code Simplifier Agent

## 目标
简化和优化 Claude 生成的代码。

## 任务
1. 检查代码是否有不必要的复杂性
2. 移除重复代码
3. 简化条件语句
4. 优化导入语句
5. 确保代码风格一致

## 输出
返回简化后的代码和修改说明。
```

**`.claude/agents/verify-app.md`**
```markdown
# Verify App Agent

## 目标
端到端验证应用功能。

## 任务
1. 运行类型检查
2. 执行单元测试
3. 检查构建是否成功
4. 验证关键功能路径

## 验证命令
```sh
bun run typecheck
bun run test
bun run build
```

## 输出
返回验证结果摘要，包括任何失败的测试或错误。
```

### 5. 创建基础斜杠命令

**`.claude/commands/commit-push-pr.md`**
```markdown
# /commit-push-pr

一键完成 commit、push 和创建 PR。

## 步骤
1. 运行 lint 和测试确保代码质量
2. 暂存所有更改
3. 创建有意义的 commit message
4. 推送到远程分支
5. 创建 Pull Request

## 命令
```sh
bun run lint && bun run test
git add -A
git commit -m "$COMMIT_MESSAGE"
git push -u origin HEAD
gh pr create --fill
```
```

### 6. 输出确认

完成后告知用户：

```
✅ Claude Code 环境初始化完成！

已创建：
📁 .claude/
  ├── commands/
  │   └── commit-push-pr.md
  ├── agents/
  │   ├── code-simplifier.md
  │   └── verify-app.md
  └── settings/
      └── settings.json
📄 CLAUDE.md

下一步：
1. 编辑 CLAUDE.md 添加项目特定规则
2. 根据需要调整 settings.json 中的权限
3. 创建更多自定义命令和 agents
```

## 自定义选项

用户可以指定：
- `--minimal`：只创建 CLAUDE.md
- `--with-mcp`：包含 MCP 服务器配置
- `--typescript`：使用 TypeScript 项目模板
- `--python`：使用 Python 项目模板
