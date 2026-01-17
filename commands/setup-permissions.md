# /setup-permissions

批量配置 Claude Code 的权限设置，预先允许安全的常用命令，避免频繁的权限确认提示。

**重要**: 这是 Boris 推荐的方式，而不是使用危险的 `--dangerously-skip-permissions`。

## 使用方式

```
/setup-permissions
/setup-permissions --preset node
/setup-permissions --preset python
/setup-permissions --preset full-stack
/setup-permissions --interactive
```

## 命令模板

将以下内容保存到 `.claude/commands/setup-permissions.md`:

```markdown
---
name: setup-permissions
description: 配置 Claude Code 权限
arguments:
  - name: preset
    description: 预设配置 (node/python/full-stack/minimal)
    required: false
    default: auto
  - name: interactive
    description: 交互式选择权限
    required: false
    default: false
---

# 配置 Claude Code 权限

## 任务

配置 Claude Code 的 `/permissions` 设置，预先允许项目中常用的安全命令。

## 预设配置

### Node.js / TypeScript 项目 (--preset node)

```json
{
  "permissions": {
    "allow": [
      "Bash(bun:*)",
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(yarn:*)",
      "Bash(pnpm:*)",
      "Bash(node:*)",
      "Bash(tsc:*)",
      "Bash(tsx:*)",
      "Bash(jest:*)",
      "Bash(vitest:*)",
      "Bash(eslint:*)",
      "Bash(prettier:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git pull)",
      "Bash(git branch:*)",
      "Bash(git checkout:*)",
      "Bash(git stash:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(wc:*)",
      "Bash(echo:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)",
      "Bash(curl:* | bash)",
      "Bash(wget:* | bash)"
    ]
  }
}
```

### Python 项目 (--preset python)

```json
{
  "permissions": {
    "allow": [
      "Bash(python:*)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(pip3:*)",
      "Bash(poetry:*)",
      "Bash(pdm:*)",
      "Bash(uv:*)",
      "Bash(pytest:*)",
      "Bash(ruff:*)",
      "Bash(black:*)",
      "Bash(mypy:*)",
      "Bash(flake8:*)",
      "Bash(isort:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git pull)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(sudo:*)",
      "Bash(pip install --user:*)"
    ]
  }
}
```

### 全栈项目 (--preset full-stack)

```json
{
  "permissions": {
    "allow": [
      "Bash(bun:*)",
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(python:*)",
      "Bash(pip:*)",
      "Bash(docker:*)",
      "Bash(docker-compose:*)",
      "Bash(kubectl:*)",
      "Bash(make:*)",
      "Bash(cargo:*)",
      "Bash(go:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(curl -s:*)",
      "Bash(jq:*)",
      "Bash(yq:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(wc:*)",
      "Bash(sort:*)",
      "Bash(uniq:*)",
      "Bash(awk:*)",
      "Bash(sed:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(touch:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)",
      "Bash(:* | bash)",
      "Bash(kubectl delete namespace:*)",
      "Bash(docker system prune -a)"
    ]
  }
}
```

### 最小权限 (--preset minimal)

```json
{
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff)",
      "Bash(ls)",
      "Bash(cat:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": []
  }
}
```

## Boris 的个人配置

这是 Boris 在推文中展示的实际配置：

```json
{
  "permissions": {
    "allow": [
      "Bash(bq query:*)",
      "Bash(bun run build:*)",
      "Bash(bun run lint:file:*)",
      "Bash(bun run test:*)",
      "Bash(bun run test:file:*)",
      "Bash(bun run typecheck:*)",
      "Bash(bun test:*)",
      "Bash(cc:*)",
      "Bash(comm:*)",
      "Bash(find:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ]
  }
}
```

## 交互式配置流程

当使用 `--interactive` 时：

```
🔧 Claude Code 权限配置向导

请选择要允许的命令类别：

📦 包管理
  [x] bun (bun:*)
  [x] npm (npm:*, npx:*)
  [ ] yarn (yarn:*)
  [ ] pnpm (pnpm:*)

🧪 测试和构建
  [x] 运行测试 (bun run test:*)
  [x] 运行构建 (bun run build:*)
  [x] 类型检查 (bun run typecheck:*)
  [x] Lint (bun run lint:*)

🔄 Git 操作
  [x] 状态查看 (git status, git diff, git log)
  [x] 基础操作 (git add, git commit, git push)
  [ ] 分支操作 (git branch, git checkout, git merge)
  [ ] 高级操作 (git rebase, git reset)

📁 文件操作
  [x] 读取 (cat, head, tail, less)
  [x] 搜索 (grep, find, ag, rg)
  [x] 目录 (ls, tree)
  [ ] 修改 (mkdir, cp, mv, rm)

🔌 其他工具
  [ ] Docker (docker:*, docker-compose:*)
  [ ] Kubernetes (kubectl:*)
  [ ] AWS CLI (aws:*)
  [ ] 数据库 (psql:*, mysql:*)

按空格选择/取消，Enter 确认
```

## 执行步骤

### 1. 检测项目类型

```bash
# 检测 Node.js
if [ -f "package.json" ]; then
  PROJECT_TYPE="node"
fi

# 检测 Python
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
  PROJECT_TYPE="python"
fi

# 检测包管理器
if [ -f "bun.lockb" ]; then
  PKG_MANAGER="bun"
elif [ -f "pnpm-lock.yaml" ]; then
  PKG_MANAGER="pnpm"
elif [ -f "yarn.lock" ]; then
  PKG_MANAGER="yarn"
else
  PKG_MANAGER="npm"
fi
```

### 2. 生成配置

根据检测结果和用户选择生成 `settings.json`。

### 3. 写入配置文件

```bash
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": [...],
    "deny": [...]
  }
}
EOF
```

### 4. 验证配置

```bash
# 测试一个允许的命令
claude-cli --test-permission "Bash(bun run test)"
```

## 输出示例

```
🔧 配置 Claude Code 权限

📦 检测到的项目类型: Node.js (bun)
📋 使用预设: node

配置内容:
┌─────────────────────────────────────────────────┐
│ 允许的命令 (24 项):                              │
│   ✅ Bash(bun:*)                                │
│   ✅ Bash(npm:*)                                │
│   ✅ Bash(git status)                           │
│   ✅ Bash(git diff:*)                           │
│   ... 更多                                       │
│                                                 │
│ 禁止的命令 (6 项):                               │
│   ❌ Bash(rm -rf /)                             │
│   ❌ Bash(sudo:*)                               │
│   ... 更多                                       │
└─────────────────────────────────────────────────┘

✅ 已写入 .claude/settings.json

💡 提示:
- 使用 /permissions 命令查看和修改当前权限
- 配置会自动被 Claude Code 加载
- 团队成员可以共享此配置（提交到 git）
```

## 安全建议

### ✅ 推荐允许
- 只读的 git 命令
- 项目的测试和构建命令
- 文件读取命令
- 项目特定的脚本

### ❌ 建议禁止
- `rm -rf` 带危险路径
- `sudo` 命令
- 从网络下载并执行的命令
- 修改系统配置的命令

### ⚠️ 谨慎允许
- 写入和删除文件
- Git push/force push
- 数据库操作
- 网络请求
