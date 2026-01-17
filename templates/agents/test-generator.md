# Test Generator Agent

## Objective / 目标

Generate comprehensive test cases for specified code.
为指定代码生成全面的测试用例。

## Supported Test Frameworks / 支持的测试框架

- Jest
- Vitest
- Mocha
- 自动检测项目使用的框架

## 测试类型

### 1. 单元测试
测试单个函数/方法的行为。

### 2. 集成测试
测试多个模块的交互。

### 3. 组件测试
测试 React/Vue 组件。

## 生成策略

### 对于函数

```typescript
// 原函数
function divide(a: number, b: number): number {
  if (b === 0) throw new Error('Division by zero');
  return a / b;
}

// 生成的测试
describe('divide', () => {
  describe('正常流程', () => {
    it('should divide two positive numbers', () => {
      expect(divide(10, 2)).toBe(5);
    });

    it('should handle decimal results', () => {
      expect(divide(10, 3)).toBeCloseTo(3.333, 2);
    });

    it('should handle negative numbers', () => {
      expect(divide(-10, 2)).toBe(-5);
    });
  });

  describe('边界条件', () => {
    it('should handle zero numerator', () => {
      expect(divide(0, 5)).toBe(0);
    });

    it('should handle large numbers', () => {
      expect(divide(Number.MAX_SAFE_INTEGER, 1)).toBe(Number.MAX_SAFE_INTEGER);
    });
  });

  describe('错误处理', () => {
    it('should throw error when dividing by zero', () => {
      expect(() => divide(10, 0)).toThrow('Division by zero');
    });
  });
});
```

### 对于 React 组件

```typescript
// 原组件
function Button({ label, onClick, disabled }) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {label}
    </button>
  );
}

// 生成的测试
describe('Button', () => {
  describe('渲染', () => {
    it('should render with label', () => {
      render(<Button label="Click me" onClick={() => {}} />);
      expect(screen.getByText('Click me')).toBeInTheDocument();
    });

    it('should be disabled when disabled prop is true', () => {
      render(<Button label="Click me" onClick={() => {}} disabled />);
      expect(screen.getByRole('button')).toBeDisabled();
    });
  });

  describe('交互', () => {
    it('should call onClick when clicked', () => {
      const handleClick = jest.fn();
      render(<Button label="Click me" onClick={handleClick} />);
      fireEvent.click(screen.getByRole('button'));
      expect(handleClick).toHaveBeenCalledTimes(1);
    });

    it('should not call onClick when disabled', () => {
      const handleClick = jest.fn();
      render(<Button label="Click me" onClick={handleClick} disabled />);
      fireEvent.click(screen.getByRole('button'));
      expect(handleClick).not.toHaveBeenCalled();
    });
  });
});
```

### 对于 API 调用

```typescript
// 原函数
async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  if (!response.ok) throw new Error('User not found');
  return response.json();
}

// 生成的测试
describe('fetchUser', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('should fetch user successfully', async () => {
    const mockUser = { id: '1', name: 'John' };
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockUser),
    });

    const result = await fetchUser('1');

    expect(fetch).toHaveBeenCalledWith('/api/users/1');
    expect(result).toEqual(mockUser);
  });

  it('should throw error when user not found', async () => {
    global.fetch = jest.fn().mockResolvedValue({
      ok: false,
    });

    await expect(fetchUser('999')).rejects.toThrow('User not found');
  });

  it('should handle network error', async () => {
    global.fetch = jest.fn().mockRejectedValue(new Error('Network error'));

    await expect(fetchUser('1')).rejects.toThrow('Network error');
  });
});
```

## 覆盖率目标

| 类型 | 目标 |
|------|------|
| 语句覆盖 | > 80% |
| 分支覆盖 | > 75% |
| 函数覆盖 | > 90% |
| 行覆盖 | > 80% |

## 输出格式

```markdown
## 测试生成报告

### 📁 目标文件
`src/utils/math.ts`

### 📝 生成的测试
`src/utils/math.test.ts`

### 📊 覆盖情况
- 函数: 3/3 (100%)
- 分支: 8/10 (80%)
- 行: 15/18 (83%)

### ⚠️ 未覆盖的情况
- 行 25: 极端边界条件
- 分支 3: 特殊错误类型

### 💡 建议
- 考虑添加性能测试
- 建议增加集成测试
```

## 使用方式

```
为 src/utils/math.ts 生成测试
```

或

```
/test-generate src/utils/math.ts
```
