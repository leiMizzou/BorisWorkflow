# Project Guidelines for Claude

## 项目概述

[请在此填写项目简介]

- **项目名称**:
- **技术栈**:
- **主要功能**:

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

### Git 工作流

- 分支命名: `feat/xxx`, `fix/xxx`, `docs/xxx`
- Commit message 使用 Conventional Commits 规范
- PR 前必须通过所有检查

## 代码规范

### TypeScript

- ✅ 优先使用 `type` 而非 `interface`
- ✅ 使用字符串字面量联合类型而非 `enum`
- ✅ 所有函数必须有明确的返回类型
- ✅ 优先使用 `const` 而非 `let`
- ✅ 使用可选链 `?.` 和空值合并 `??`

### 命名约定

| 类型 | 约定 | 示例 |
|------|------|------|
| 组件 | PascalCase | `UserProfile.tsx` |
| 函数/变量 | camelCase | `getUserData` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 文件 | kebab-case | `user-profile.ts` |
| 类型 | PascalCase | `type UserData = {...}` |

### 文件组织

```
src/
├── components/     # React 组件
├── hooks/          # 自定义 hooks
├── utils/          # 工具函数
├── types/          # 类型定义
├── api/            # API 调用
└── constants/      # 常量定义
```

## 禁止事项

- ❌ 不要使用 `any` 类型（使用 `unknown` 或具体类型）
- ❌ 不要使用 `enum`（使用字符串字面量联合类型）
- ❌ 不要使用 `npm`（使用 `bun`）
- ❌ 不要提交未格式化的代码
- ❌ 不要使用 `console.log`（使用项目的 logger）
- ❌ 不要在组件中直接调用 API（使用 hooks）
- ❌ 不要硬编码敏感信息

## 测试规范

### 测试文件命名

- 单元测试: `*.test.ts` 或 `*.spec.ts`
- 集成测试: `*.integration.test.ts`
- E2E 测试: `*.e2e.test.ts`

### 测试覆盖要求

- 所有公共 API 必须有测试
- 边界条件必须覆盖
- 错误处理必须测试

### 测试模板

```typescript
describe('函数名/组件名', () => {
  describe('正常流程', () => {
    it('should 预期行为 when 条件', () => {
      // Arrange
      // Act
      // Assert
    });
  });

  describe('边界条件', () => {
    it('should handle empty input', () => {});
    it('should handle null/undefined', () => {});
  });

  describe('错误处理', () => {
    it('should throw error when 条件', () => {});
  });
});
```

## 已知问题和解决方案

[当 Claude 犯错时，在此记录以避免重复]

### 问题模板

```
### [问题简述]

**问题**:
**原因**:
**解决方案**:
**日期**: YYYY-MM-DD
```

---

## 更新日志

| 日期 | 更新内容 | 作者 |
|------|----------|------|
| YYYY-MM-DD | 初始化 CLAUDE.md | @username |
