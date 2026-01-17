# /commit-push-pr

一键完成代码提交、推送和创建 Pull Request 的完整流程。这是 Boris Cherny 最常用的命令之一。

## 使用方式

```
/commit-push-pr
/commit-push-pr --title "feat: 添加用户认证功能"
/commit-push-pr --draft
/commit-push-pr --no-verify
```

## 命令模板

将以下内容保存到 `.claude/commands/commit-push-pr.md`:

```markdown
---
name: commit-push-pr
description: 一键完成 commit、push 和创建 PR
arguments:
  - name: title
    description: PR 标题（可选，自动生成）
    required: false
  - name: draft
    description: 是否创建草稿 PR
    required: false
    default: false
  - name: no-verify
    description: 跳过 pre-commit hooks
    required: false
    default: false
---

# 一键提交并创建 PR

## 执行流程

### 阶段 1: 预检查

首先确保代码质量：

```bash
# 1. 检查是否有未暂存的更改
git status

# 2. 运行 lint（除非 --no-verify）
bun run lint

# 3. 运行测试
bun run test
```

如果任何检查失败，停止并报告问题。

### 阶段 2: 分析更改

```bash
# 获取更改的文件
git diff --cached --name-only
git diff --name-only

# 分析更改类型
# - feat: 新功能
# - fix: 修复
# - docs: 文档
# - style: 格式
# - refactor: 重构
# - test: 测试
# - chore: 杂项
```

### 阶段 3: 生成 Commit Message

根据更改内容自动生成符合 Conventional Commits 规范的消息：

```
<type>(<scope>): <description>

<body>

<footer>
```

示例：
```
feat(auth): add user login functionality

- Implement JWT token generation
- Add login API endpoint
- Create login form component

Closes #123
```

### 阶段 4: 提交和推送

```bash
# 暂存所有更改
git add -A

# 提交
git commit -m "$COMMIT_MESSAGE"

# 推送到远程（创建上游分支如果需要）
git push -u origin HEAD
```

### 阶段 5: 创建 Pull Request

```bash
# 使用 GitHub CLI 创建 PR
gh pr create \
  --title "$PR_TITLE" \
  --body "$PR_BODY" \
  {{#if draft}}--draft{{/if}}
```

PR 正文模板：
```markdown
## 概述
[自动生成的更改摘要]

## 更改内容
- [更改列表]

## 测试
- [x] 本地测试通过
- [x] Lint 检查通过
- [ ] 需要 code review

## 相关 Issue
Closes #[issue_number]
```

## 完整执行脚本

```bash
#!/bin/bash
set -e

echo "🚀 开始 commit-push-pr 流程..."

# 阶段 1: 预检查
echo "📋 阶段 1: 预检查"

if [ -z "$(git status --porcelain)" ]; then
  echo "❌ 没有需要提交的更改"
  exit 1
fi

echo "Running lint..."
bun run lint || { echo "❌ Lint 失败"; exit 1; }

echo "Running tests..."
bun run test || { echo "❌ 测试失败"; exit 1; }

echo "✅ 预检查通过"

# 阶段 2: 暂存更改
echo "📦 阶段 2: 暂存更改"
git add -A
git status

# 阶段 3: 提交
echo "💾 阶段 3: 提交"
# [Claude 在此生成 commit message]
git commit -m "$COMMIT_MESSAGE"

# 阶段 4: 推送
echo "⬆️ 阶段 4: 推送"
BRANCH=$(git branch --show-current)
git push -u origin "$BRANCH"

# 阶段 5: 创建 PR
echo "🔀 阶段 5: 创建 PR"
PR_URL=$(gh pr create --fill)

echo ""
echo "✅ 完成！"
echo "📎 PR 链接: $PR_URL"
```

## 输出示例

```
🚀 开始 commit-push-pr 流程...

📋 阶段 1: 预检查
  ✅ Lint 通过
  ✅ 测试通过 (42 passed)

📦 阶段 2: 暂存更改
  M  src/components/Login.tsx
  A  src/hooks/useAuth.ts
  M  src/api/auth.ts

💾 阶段 3: 提交
  生成的 commit message:
  ┌────────────────────────────────────┐
  │ feat(auth): implement user login  │
  │                                    │
  │ - Add useAuth hook                 │
  │ - Create Login component           │
  │ - Implement auth API endpoints     │
  └────────────────────────────────────┘

  确认提交？(Y/n)

⬆️ 阶段 4: 推送
  推送到 origin/feat/user-login

🔀 阶段 5: 创建 PR
  ✅ PR 创建成功！

📎 https://github.com/user/repo/pull/456

下一步：
  - 等待 CI 检查
  - 请求 code review
  - 合并后删除分支
```

## 选项说明

| 选项 | 说明 | 示例 |
|------|------|------|
| `--title` | 指定 PR 标题 | `--title "feat: 新功能"` |
| `--draft` | 创建草稿 PR | `--draft` |
| `--no-verify` | 跳过 lint/test | `--no-verify` |
| `--base` | 指定目标分支 | `--base develop` |
| `--reviewer` | 添加 reviewer | `--reviewer @user` |

## 错误处理

### Lint 失败
```
❌ Lint 检查失败

发现以下问题：
  src/Login.tsx:15 - 'unused' is defined but never used

建议操作：
1. 运行 `bun run lint:fix` 自动修复
2. 手动修复后重新运行 /commit-push-pr
```

### 测试失败
```
❌ 测试失败

失败的测试：
  ✗ Login.test.tsx > should handle invalid credentials

建议操作：
1. 运行 `bun run test -- -t "invalid credentials"` 查看详情
2. 修复测试后重新运行
```

### 推送冲突
```
⚠️ 推送被拒绝 - 远程有更新

建议操作：
1. 运行 `git pull --rebase`
2. 解决冲突
3. 重新运行 /commit-push-pr
```
