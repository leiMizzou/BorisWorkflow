# /setup-ralph-loop

配置 Ralph Wiggum 自主循环开发插件，实现 "睡觉时也能写代码" 的自动化开发。

## 什么是 Ralph Loop？

Ralph Wiggum 是 [Geoffrey Huntley 的技术](https://ghuntley.com/ralph/)，以《辛普森一家》中的角色命名，体现了"尽管遭遇挫折仍坚持迭代"的哲学。

**核心原理**：
- 同一个 prompt 反复喂给 Claude Code
- Claude 的上一次工作保存在文件中
- 每次迭代都能看到修改的文件和 git 历史
- Claude 通过阅读自己过去的工作自主改进

**真实案例**：
- Y Combinator 黑客马拉松中一夜生成 6 个仓库
- 一个 $50k 的合同仅花费 $297 API 费用完成
- 用这种方法 3 个月创建了一整门编程语言

## 使用方式

```
/setup-ralph-loop
/setup-ralph-loop --enable
/setup-ralph-loop --disable
```

## 快速开始

### 启用 Ralph Loop 插件

```bash
# 在 Claude Code 中运行
claude plugins:install ralph-wiggum
```

或手动配置 `.claude/settings.json`：

```json
{
  "plugins": ["ralph-wiggum"]
}
```

### 使用 Ralph Loop

```bash
# 基础用法
/ralph-loop "构建一个 TODO REST API。要求：CRUD 操作、输入验证、测试。完成后输出 <promise>COMPLETE</promise>" --completion-promise "COMPLETE" --max-iterations 50
```

Claude 会：
1. 迭代实现 API
2. 运行测试并看到失败
3. 根据测试输出修复 bug
4. 迭代直到满足所有需求
5. 完成后输出 completion promise

### 取消循环

```bash
/cancel-ralph
```

## 命令详解

### `/ralph-loop`

启动 Ralph 循环。

**语法**：
```bash
/ralph-loop "<prompt>" --max-iterations <n> --completion-promise "<text>"
```

**参数**：
| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--max-iterations <n>` | 最大迭代次数 | 无限制 |
| `--completion-promise <text>` | 完成信号文本 | 无 |

### `/cancel-ralph`

取消当前运行的 Ralph 循环。

## Prompt 写作最佳实践

### 1. 明确的完成标准

❌ 错误示范：
```
构建一个 todo API，做好点。
```

✅ 正确示范：
```
构建一个 TODO REST API。

完成标准：
- 所有 CRUD 端点正常工作
- 输入验证已实现
- 测试通过（覆盖率 > 80%）
- README 包含 API 文档
- 完成后输出：<promise>COMPLETE</promise>
```

### 2. 增量目标

❌ 错误示范：
```
创建一个完整的电商平台。
```

✅ 正确示范：
```
阶段 1：用户认证（JWT，测试）
阶段 2：产品目录（列表/搜索，测试）
阶段 3：购物车（添加/删除，测试）

所有阶段完成后输出 <promise>COMPLETE</promise>
```

### 3. 自我纠正（TDD 工作流）

```
按照 TDD 实现功能 X：
1. 编写失败的测试
2. 实现功能
3. 运行测试
4. 如果有失败，调试并修复
5. 如需要则重构
6. 重复直到全部通过
7. 输出：<promise>COMPLETE</promise>
```

### 4. 安全阀

始终使用 `--max-iterations` 作为安全网：

```bash
/ralph-loop "尝试实现功能 X" --max-iterations 20
```

在 prompt 中加入：
```
15 次迭代后如果未完成：
- 记录阻塞原因
- 列出已尝试的方案
- 建议替代方案
```

## 适用场景

### ✅ 适合使用 Ralph

- 有明确成功标准的任务
- 需要迭代和优化的任务（如让测试通过）
- 可以放着不管的新项目
- 有自动验证的任务（测试、lint）

### ❌ 不适合使用 Ralph

- 需要人工判断或设计决策的任务
- 一次性操作
- 成功标准不明确的任务
- 生产环境调试

## 完整配置示例

### settings.json

```json
{
  "plugins": ["ralph-wiggum"],
  "permissions": {
    "allow": [
      "Bash(bun run test:*)",
      "Bash(bun run build:*)",
      "Bash(bun run lint:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ]
  }
}
```

### 过夜开发模板

```bash
/ralph-loop "
## 任务
实现用户认证系统

## 技术栈
- Node.js + Express
- JWT
- SQLite
- Jest 测试

## 验收标准
1. POST /auth/register - 用户注册
2. POST /auth/login - 用户登录，返回 JWT
3. GET /auth/me - 获取当前用户（需要 JWT）
4. 所有端点有输入验证
5. 测试覆盖率 > 80%
6. 错误处理完善

## 工作流程
1. 先写测试
2. 实现功能
3. 运行 bun run test
4. 修复失败的测试
5. 重复直到全部通过

## 完成信号
所有测试通过后输出：<promise>AUTH_COMPLETE</promise>
" --completion-promise "AUTH_COMPLETE" --max-iterations 30
```

## 故障排除

### 循环不停止

```
⚠️ Ralph 循环超过预期迭代次数

可能原因：
1. completion-promise 拼写错误
2. 完成标准不够明确
3. 任务过于复杂

解决方案：
1. 运行 /cancel-ralph 停止循环
2. 检查 prompt 中的完成信号
3. 将大任务拆分成小任务
4. 始终设置 --max-iterations
```

### API 费用过高

```
💡 控制费用的技巧：

1. 设置合理的 --max-iterations（推荐 20-50）
2. 使用增量目标，每个阶段独立验证
3. 在 prompt 中要求使用最小实现
4. 监控 usage: claude usage
```

## 相关链接

- [Geoffrey Huntley 的 Ralph 技术](https://ghuntley.com/ralph/)
- [Ralph Wiggum 官方插件](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [Ralph Orchestrator](https://github.com/mikeyobrien/ralph-orchestrator)

## 与其他命令配合

```bash
# 完整开发环境设置
/setup-permissions --preset node      # 配置权限
/setup-plugins --preset web-dev       # 配置 MCP 插件
/setup-format-hook                    # 配置格式化
/setup-ralph-loop --enable            # 启用 Ralph Loop

# 然后开始自主开发
/ralph-loop "你的任务描述" --max-iterations 30 --completion-promise "DONE"
```
