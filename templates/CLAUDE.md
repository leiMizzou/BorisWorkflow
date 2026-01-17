# Project Guidelines for Claude

## Project Overview / 项目概述

[Please fill in project description / 请在此填写项目简介]

- **Project Name / 项目名称**:
- **Tech Stack / 技术栈**:
- **Main Features / 主要功能**:

## Development Workflow / 开发工作流

### Package Manager / 包管理器

**Use the project's configured package manager: `{{PKG_MANAGER}}`**

**使用项目配置的包管理器: `{{PKG_MANAGER}}`**

### Development Commands / 开发命令

```sh
# 1. After modifying code / 修改代码后

# 2. Type check (fast) / 类型检查（快速）
{{PKG_MANAGER}} run typecheck

# 3. Run tests / 运行测试
{{PKG_MANAGER}} run test -- -t "test name"    # Single test suite / 单个测试套件
{{PKG_MANAGER}} run test:file -- "glob"       # Specific files / 特定文件

# 4. Lint before commit / 提交前 lint
{{PKG_MANAGER}} run lint:file -- "file1.ts"   # Specific files / 特定文件
{{PKG_MANAGER}} run lint                       # All files / 所有文件

# 5. Before creating PR / 创建 PR 前
{{PKG_MANAGER}} run lint && {{PKG_MANAGER}} run test
```

### Git Workflow / Git 工作流

- Branch naming / 分支命名: `feat/xxx`, `fix/xxx`, `docs/xxx`
- Commit messages use Conventional Commits format / 使用 Conventional Commits 规范
- Must pass all checks before PR / PR 前必须通过所有检查

## Code Standards / 代码规范

### TypeScript

- ✅ Prefer `type` over `interface` / 优先使用 `type` 而非 `interface`
- ✅ Use string literal union types instead of `enum` / 使用字符串字面量联合类型而非 `enum`
- ✅ All functions must have explicit return types / 所有函数必须有明确的返回类型
- ✅ Prefer `const` over `let` / 优先使用 `const` 而非 `let`
- ✅ Use optional chaining `?.` and nullish coalescing `??` / 使用可选链和空值合并

### Naming Conventions / 命名约定

| Type / 类型 | Convention / 约定 | Example / 示例 |
|-------------|-------------------|----------------|
| Components / 组件 | PascalCase | `UserProfile.tsx` |
| Functions/Variables / 函数/变量 | camelCase | `getUserData` |
| Constants / 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Files / 文件 | kebab-case | `user-profile.ts` |
| Types / 类型 | PascalCase | `type UserData = {...}` |

### File Organization / 文件组织

```
src/
├── components/     # React components / React 组件
├── hooks/          # Custom hooks / 自定义 hooks
├── utils/          # Utility functions / 工具函数
├── types/          # Type definitions / 类型定义
├── api/            # API calls / API 调用
└── constants/      # Constants / 常量定义
```

## Prohibited / 禁止事项

- ❌ Don't use `any` type (use `unknown` or specific types) / 不要使用 `any` 类型
- ❌ Don't use `enum` (use string literal union types) / 不要使用 `enum`
- ❌ Don't mix package managers (use `{{PKG_MANAGER}}` consistently) / 不要混用包管理器
- ❌ Don't commit unformatted code / 不要提交未格式化的代码
- ❌ Don't use `console.log` (use project's logger) / 不要使用 `console.log`
- ❌ Don't call APIs directly in components (use hooks) / 不要在组件中直接调用 API
- ❌ Don't hardcode sensitive information / 不要硬编码敏感信息

## Testing Standards / 测试规范

### Test File Naming / 测试文件命名

- Unit tests / 单元测试: `*.test.ts` or `*.spec.ts`
- Integration tests / 集成测试: `*.integration.test.ts`
- E2E tests: `*.e2e.test.ts`

### Coverage Requirements / 测试覆盖要求

- All public APIs must have tests / 所有公共 API 必须有测试
- Edge cases must be covered / 边界条件必须覆盖
- Error handling must be tested / 错误处理必须测试

### Test Template / 测试模板

```typescript
describe('FunctionName/ComponentName', () => {
  describe('Normal flow / 正常流程', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange
      // Act
      // Assert
    });
  });

  describe('Edge cases / 边界条件', () => {
    it('should handle empty input', () => {});
    it('should handle null/undefined', () => {});
  });

  describe('Error handling / 错误处理', () => {
    it('should throw error when [condition]', () => {});
  });
});
```

## Known Issues and Solutions / 已知问题和解决方案

[Record Claude's mistakes here to avoid repetition / 当 Claude 犯错时，在此记录以避免重复]

### Issue Template / 问题模板

```
### [Brief description / 问题简述]

**Issue / 问题**:
**Cause / 原因**:
**Solution / 解决方案**:
**Date / 日期**: YYYY-MM-DD
```

---

## Changelog / 更新日志

| Date / 日期 | Update / 更新内容 | Author / 作者 |
|-------------|-------------------|---------------|
| YYYY-MM-DD | Initialize CLAUDE.md / 初始化 CLAUDE.md | @username |
