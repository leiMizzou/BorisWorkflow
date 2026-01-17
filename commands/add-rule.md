# /add-rule

快速将规则添加到 CLAUDE.md 文件，实现 "Compounding Engineering"（复合工程）。

## 使用方式

```
/add-rule <规则描述>
```

## 示例

```
/add-rule 不要使用 enum，使用字符串字面量联合类型
/add-rule 所有 API 调用必须有错误处理
/add-rule 组件文件使用 PascalCase 命名
/add-rule 避免在 useEffect 中直接修改 state
```

## 执行逻辑

### 1. 检查 CLAUDE.md 是否存在

```bash
if [ ! -f "CLAUDE.md" ]; then
  echo "⚠️ CLAUDE.md 不存在，正在创建..."
  # 创建基础模板
fi
```

### 2. 分类规则

根据规则内容自动分类到合适的章节：

| 关键词 | 分类章节 |
|--------|----------|
| 不要/禁止/避免 | ## 禁止事项 |
| 使用/优先/推荐 | ## 代码规范 |
| 命名/格式 | ## 命名约定 |
| 测试/test | ## 测试规范 |
| 文档/注释 | ## 文档规范 |
| 其他 | ## 其他规则 |

### 3. 添加规则

```bash
# 添加到对应章节
echo "- ❌ $RULE" >> CLAUDE.md  # 禁止类
echo "- ✅ $RULE" >> CLAUDE.md  # 推荐类
```

### 4. 可选：提交更改

```bash
# 如果用户确认，自动提交
git add CLAUDE.md
git commit -m "docs: add rule to CLAUDE.md - $RULE"
```

## 完整命令模板

将以下内容保存到 `.claude/commands/add-rule.md`:

```markdown
---
name: add-rule
description: 添加规则到 CLAUDE.md
arguments:
  - name: rule
    description: 要添加的规则描述
    required: true
---

# 添加规则到 CLAUDE.md

## 任务
将以下规则添加到项目的 CLAUDE.md 文件中：

**规则**: {{rule}}

## 步骤

1. 读取当前 CLAUDE.md 文件
2. 分析规则类型（禁止/推荐/命名/测试/文档）
3. 找到合适的章节位置
4. 添加规则，使用合适的格式：
   - 禁止类: `- ❌ 不要...`
   - 推荐类: `- ✅ 优先使用...`
5. 保存文件

## 输出格式

```
✅ 规则已添加到 CLAUDE.md

📍 位置: ## [章节名称]
📝 内容: - [emoji] [规则内容]

是否需要提交此更改？(y/n)
```

## 注意事项
- 检查是否已存在相似规则，避免重复
- 保持规则描述简洁清晰
- 使用统一的格式和表情符号
```

## 高级用法

### 批量添加规则

```
/add-rule --batch <<EOF
不要使用 any 类型
不要使用 enum
所有函数必须有返回类型
EOF
```

### 从 PR 评论添加

```
/add-rule --from-pr 123
```

这会扫描 PR #123 的评论，找到 `@.claude` 标记的内容并添加。

### 添加并关联示例

```
/add-rule "使用 type 而非 interface" --example "type User = { name: string }"
```

## 与 @.claude 配合

在 GitHub PR 评论中使用：

```
@.claude add to CLAUDE.md: 不要使用 console.log，使用项目的 logger
```

Claude Code GitHub Action 会自动：
1. 解析评论
2. 调用 /add-rule 命令
3. 提交更改
4. 回复确认
