# Create Subagent Skill

交互式创建自定义 Claude Code Subagent。

## 触发条件

当用户说以下内容时触发此技能：
- "创建 subagent"
- "create subagent"
- "新建一个 agent"
- "添加自定义 agent"

## Subagent 类型模板

### 1. 代码质量类

**code-reviewer.md** - 代码审查
```markdown
# Code Reviewer Agent

## 目标
审查代码变更，提供改进建议。

## 审查清单
- [ ] 代码是否符合项目规范
- [ ] 是否有潜在的 bug
- [ ] 是否有性能问题
- [ ] 是否有安全隐患
- [ ] 测试覆盖是否充分
- [ ] 文档是否需要更新

## 审查重点
1. 类型安全性
2. 错误处理
3. 边界条件
4. 代码可读性
5. DRY 原则

## 输出格式
```
## 审查结果

### ✅ 优点
- ...

### ⚠️ 建议改进
- ...

### ❌ 必须修复
- ...
```
```

**code-simplifier.md** - 代码简化
```markdown
# Code Simplifier Agent

## 目标
简化复杂代码，提高可维护性。

## 简化策略
1. 提取重复逻辑为函数
2. 简化嵌套条件
3. 使用更简洁的语法
4. 移除死代码
5. 优化导入

## 规则
- 保持功能不变
- 不引入新依赖
- 保持类型安全
- 添加必要注释

## 输出
返回简化后的代码 + diff 说明
```

### 2. 测试类

**test-generator.md** - 测试生成
```markdown
# Test Generator Agent

## 目标
为指定代码生成全面的测试用例。

## 测试类型
1. 单元测试 - 测试单个函数/方法
2. 集成测试 - 测试模块间交互
3. 边界测试 - 测试极端情况

## 测试框架
使用项目配置的测试框架（Jest/Vitest/等）

## 覆盖要求
- 正常流程
- 错误处理
- 边界条件
- 空值/undefined
- 类型边界

## 命名规范
```typescript
describe('函数名', () => {
  it('should 预期行为 when 条件', () => {
    // ...
  });
});
```

## 输出
生成的测试文件 + 运行结果
```

**verify-app.md** - 应用验证
```markdown
# Verify App Agent

## 目标
端到端验证应用状态。

## 验证流程
```sh
# 1. 类型检查
bun run typecheck

# 2. Lint 检查
bun run lint

# 3. 单元测试
bun run test

# 4. 构建测试
bun run build
```

## 失败处理
如果任何步骤失败：
1. 记录错误信息
2. 尝试自动修复
3. 重新验证
4. 报告最终状态

## 输出格式
```
## 验证报告

| 检查项 | 状态 | 详情 |
|--------|------|------|
| 类型检查 | ✅/❌ | ... |
| Lint | ✅/❌ | ... |
| 测试 | ✅/❌ | ... |
| 构建 | ✅/❌ | ... |
```
```

### 3. 文档类

**doc-generator.md** - 文档生成
```markdown
# Documentation Generator Agent

## 目标
为代码生成或更新文档。

## 文档类型
1. JSDoc/TSDoc 注释
2. README 文件
3. API 文档
4. 使用示例

## 文档规范
- 清晰简洁
- 包含示例代码
- 说明参数和返回值
- 注明可能的错误

## 模板
```typescript
/**
 * 简短描述
 *
 * 详细说明（可选）
 *
 * @param paramName - 参数描述
 * @returns 返回值描述
 * @throws {ErrorType} 错误情况
 * @example
 * ```ts
 * const result = functionName(args);
 * ```
 */
```
```

### 4. 运维类

**oncall-guide.md** - 值班指南
```markdown
# On-Call Guide Agent

## 目标
协助处理线上问题。

## 问题诊断流程
1. 收集错误信息
2. 查找相关日志
3. 识别问题根因
4. 提供修复建议

## 常用命令
```sh
# 查看日志
kubectl logs -f <pod>

# 检查服务状态
curl -s http://localhost/health

# 查看错误
grep -r "ERROR" logs/
```

## 升级路径
- P0: 立即通知团队
- P1: 1小时内响应
- P2: 工作时间处理
- P3: 下个迭代处理

## 输出
诊断报告 + 建议的修复步骤
```

### 5. 架构类

**code-architect.md** - 代码架构
```markdown
# Code Architect Agent

## 目标
分析和改进代码架构。

## 分析维度
1. 模块划分
2. 依赖关系
3. 接口设计
4. 数据流向
5. 可扩展性

## 架构原则
- 单一职责
- 开闭原则
- 依赖倒置
- 接口隔离
- 最小知识原则

## 输出
```
## 架构分析报告

### 当前架构
[架构图/描述]

### 问题识别
1. ...
2. ...

### 改进建议
1. ...
2. ...

### 重构计划
[分步骤的重构方案]
```
```

## 创建流程

### 步骤 1: 询问用户需求

```
请问您想创建什么类型的 Subagent？

1. 🔍 代码质量类（审查、简化）
2. 🧪 测试类（生成测试、验证应用）
3. 📝 文档类（生成文档）
4. 🔧 运维类（问题诊断）
5. 🏗️ 架构类（架构分析）
6. 📦 自定义

请输入数字或描述您的需求：
```

### 步骤 2: 收集详细信息

根据选择询问：
- Agent 名称
- 主要目标
- 具体任务
- 输入/输出格式
- 相关命令

### 步骤 3: 生成 Agent 文件

在 `.claude/agents/` 目录下创建对应的 `.md` 文件。

### 步骤 4: 确认和调整

```
✅ Subagent 创建成功！

📄 文件位置: .claude/agents/{agent-name}.md

使用方式:
- 在 Claude Code 中直接引用此 agent
- 或使用 /agent {agent-name} 命令调用

需要调整配置吗？
```

## 最佳实践

1. **命名清晰** - agent 名称应反映其功能
2. **目标明确** - 每个 agent 专注于一件事
3. **输出规范** - 定义清晰的输出格式
4. **可组合** - 设计可与其他 agent 配合的接口
