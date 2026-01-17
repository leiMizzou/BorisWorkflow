# /setup-format-hook

配置 PostToolUse Hook 自动格式化 Claude 生成的代码。这是 Boris 用来确保代码风格一致的关键配置。

## 使用方式

```
/setup-format-hook
/setup-format-hook --formatter prettier
/setup-format-hook --formatter biome
/setup-format-hook --formatter eslint
```

## 命令模板

将以下内容保存到 `.claude/commands/setup-format-hook.md`:

```markdown
---
name: setup-format-hook
description: 配置代码自动格式化 Hook
arguments:
  - name: formatter
    description: 格式化工具 (prettier/biome/eslint/custom)
    required: false
    default: auto
---

# 配置代码格式化 Hook

## 任务

为 Claude Code 配置 PostToolUse Hook，在每次写入或编辑文件后自动运行格式化工具。

## 执行步骤

### 1. 检测项目格式化工具

首先检测项目使用的格式化工具：

```bash
# 检查 package.json 中的依赖
if grep -q "prettier" package.json; then
  FORMATTER="prettier"
elif grep -q "biome" package.json; then
  FORMATTER="biome"
elif grep -q "eslint" package.json; then
  FORMATTER="eslint"
fi

# 检查配置文件
if [ -f ".prettierrc" ] || [ -f "prettier.config.js" ]; then
  FORMATTER="prettier"
elif [ -f "biome.json" ]; then
  FORMATTER="biome"
fi
```

### 2. 确定格式化命令

根据检测到的工具和包管理器确定命令：

| 格式化工具 | bun 命令 | npm 命令 |
|-----------|----------|----------|
| Prettier | `bun run format` 或 `bunx prettier --write` | `npx prettier --write` |
| Biome | `bun run format` 或 `bunx biome format --write` | `npx biome format --write` |
| ESLint | `bun run lint:fix` | `npx eslint --fix` |
| dprint | `bunx dprint fmt` | `npx dprint fmt` |

### 3. 创建/更新 settings.json

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "{{FORMAT_COMMAND}} || true"
          }
        ]
      }
    ]
  }
}
```

### 4. 验证配置

```bash
# 测试格式化命令
echo "const x=1" > /tmp/test.ts
{{FORMAT_COMMAND}} /tmp/test.ts
cat /tmp/test.ts  # 应该是格式化后的代码
rm /tmp/test.ts
```

## 格式化配置模板

### Prettier (推荐)

**settings.json:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bun run format || bunx prettier --write \"$FILE\" || true"
          }
        ]
      }
    ]
  }
}
```

**推荐的 .prettierrc:**
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### Biome

**settings.json:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bunx biome format --write \"$FILE\" || true"
          }
        ]
      }
    ]
  }
}
```

**推荐的 biome.json:**
```json
{
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2
  },
  "linter": {
    "enabled": true
  }
}
```

### ESLint + Prettier

**settings.json:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bunx eslint --fix \"$FILE\" && bunx prettier --write \"$FILE\" || true"
          }
        ]
      }
    ]
  }
}
```

### 仅特定文件类型

**只格式化 TypeScript/JavaScript:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "filePattern": "**/*.{ts,tsx,js,jsx}",
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

**只格式化 Python:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "filePattern": "**/*.py",
        "hooks": [
          {
            "type": "command",
            "command": "black \"$FILE\" || ruff format \"$FILE\" || true"
          }
        ]
      }
    ]
  }
}
```

## 输出示例

```
🔧 配置代码格式化 Hook

📦 检测到的格式化工具: Prettier
📁 包管理器: bun

配置内容:
┌─────────────────────────────────────────────────┐
│ {                                               │
│   "hooks": {                                    │
│     "PostToolUse": [{                           │
│       "matcher": "Write|Edit",                  │
│       "hooks": [{                               │
│         "type": "command",                      │
│         "command": "bun run format || true"     │
│       }]                                        │
│     }]                                          │
│   }                                             │
│ }                                               │
└─────────────────────────────────────────────────┘

✅ 已写入 .claude/settings.json

测试结果:
  ✅ 格式化命令可用
  ✅ Hook 配置有效

现在，每次 Claude 写入或编辑文件后都会自动格式化！
```

## 故障排除

### 格式化命令未找到
```
❌ 错误: 'prettier' 命令未找到

解决方案：
1. 安装 prettier: bun add -D prettier
2. 或使用其他格式化工具: /setup-format-hook --formatter biome
```

### 格式化失败不影响工作流
```
💡 提示: Hook 命令使用 `|| true` 确保即使格式化失败，
Claude 的工作流也不会中断。

如果需要严格格式化检查，可以移除 `|| true`：
  "command": "bun run format"
```

### 特定文件格式化失败
```
⚠️ 某些文件格式化失败是正常的，比如：
- 生成的文件 (*.generated.ts)
- 配置文件 (*.json, *.yaml)
- Markdown 文件

可以在 .prettierignore 中排除这些文件。
```

## 高级配置

### 链式 Hook（格式化 + Lint）

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bun run format || true"
          },
          {
            "type": "command",
            "command": "bun run lint:file -- \"$FILE\" || true"
          }
        ]
      }
    ]
  }
}
```

### 条件格式化

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "condition": "!$FILE.includes('generated') && !$FILE.includes('.min.')",
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
