# /setup-plugins

配置 Claude Code 的 MCP 插件，自动安装和配置常用的 MCP 服务器。

## 使用方式

```
/setup-plugins
/setup-plugins --preset web-dev
/setup-plugins --preset data-science
/setup-plugins --list
/setup-plugins --add context7
```

## 命令模板

将以下内容保存到 `.claude/commands/setup-plugins.md`:

```markdown
---
name: setup-plugins
description: 配置 Claude Code MCP 插件
arguments:
  - name: preset
    description: 预设配置 (web-dev/data-science/devops/minimal)
    required: false
    default: auto
  - name: add
    description: 添加单个插件
    required: false
  - name: list
    description: 列出已安装的插件
    required: false
---

# 配置 Claude Code 插件

## 任务

配置 Claude Code 的 MCP (Model Context Protocol) 服务器，扩展 Claude 的能力。

## 可用插件列表

### 核心推荐插件

| 插件名 | 功能 | 适用场景 |
|--------|------|----------|
| context7 | 获取最新库文档 | 所有开发项目 |
| playwright | 浏览器自动化 | Web 开发、测试 |
| github | GitHub 集成 | 所有 Git 项目 |
| filesystem | 高级文件操作 | 复杂文件处理 |
| memory | 持久化记忆 | 长期项目 |

### 自主开发插件

| 插件名 | 功能 | 适用场景 |
|--------|------|----------|
| ralph-loop | 自主循环开发 | 过夜任务、TDD 工作流 |

**Ralph Loop** 是 Geoffrey Huntley 的自主循环技术，让 Claude 能够自主迭代直到任务完成。详见 `/setup-ralph-loop`。

### 设计与文档插件

| 插件名 | 功能 | 适用场景 |
|--------|------|----------|
| figma | Figma 设计稿转代码 | UI 开发、设计还原 |
| office | Word/Excel/PPT 自动化 | 文档生成、数据处理 |

**Figma MCP** - 官方插件，支持从 Figma 设计稿生成代码，提取设计变量和组件。

```bash
# 安装 Figma 插件
claude plugin install figma@claude-plugins-official
```

**Office MCP** - 支持 Word、Excel、PowerPoint 文档的创建和编辑。

```json
{
  "mcpServers": {
    "office-word": {
      "command": "npx",
      "args": ["-y", "@anthropic/office-word-mcp"]
    }
  }
}
```

> 参考: [Figma MCP Server](https://www.figma.com/blog/introducing-figma-mcp-server/) | [OfficeMCP](https://github.com/OfficeMCP/OfficeMCP)

### Web 开发插件

| 插件名 | 功能 |
|--------|------|
| puppeteer | 浏览器自动化 |
| fetch | HTTP 请求增强 |
| sqlite | 本地数据库 |

### 数据科学插件

| 插件名 | 功能 |
|--------|------|
| jupyter | Jupyter 集成 |
| postgres | PostgreSQL 数据库 |
| slack | Slack 通知 |

### DevOps 插件

| 插件名 | 功能 |
|--------|------|
| docker | Docker 管理 |
| kubernetes | K8s 操作 |
| aws | AWS 服务 |

## 预设配置

### Web 开发预设 (--preset web-dev)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/playwright-mcp@latest"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

### 数据科学预设 (--preset data-science)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PWD}"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### DevOps 预设 (--preset devops)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PWD}"]
    }
  }
}
```

### 最小预设 (--preset minimal)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Ralph Loop 插件 (--with-ralph)

启用自主循环开发能力，让 Claude 能够自主迭代直到任务完成。

```json
{
  "plugins": ["ralph-loop"]
}
```

**安装方式**：

```bash
# 方式 1: 通过 install.sh
./install.sh --with-ralph

# 方式 2: 在 Claude Code 中安装
/install-plugin ralph-loop

# 方式 3: 手动添加到 settings.json
# 在 settings.json 中添加 "plugins": ["ralph-loop"]
```

**使用示例**：

```bash
/ralph-loop "实现用户认证系统，测试覆盖率 > 80%，完成后输出 <promise>DONE</promise>" --max-iterations 30 --completion-promise "DONE"
```

详细用法请参考 `/setup-ralph-loop`。

## 执行步骤

### 1. 检测已有配置

```bash
# 检查全局配置
if [ -f ~/.claude/settings.json ]; then
  echo "发现全局配置"
fi

# 检查项目配置
if [ -f .claude/settings.json ]; then
  echo "发现项目配置"
fi
```

### 2. 合并配置

将新的 MCP 服务器配置与现有配置合并，不覆盖已有设置。

### 3. 检查依赖

```bash
# 确保 Node.js 可用
node --version || echo "需要安装 Node.js"

# 检查 npx
npx --version || echo "需要安装 npm"
```

### 4. 验证插件

重启 Claude Code 后，插件会自动加载。可通过以下方式验证：

```
在 Claude Code 中输入: /plugins
查看已加载的 MCP 工具列表
```

### 5. 写入配置

配置文件位置选项：
- 全局配置: `~/.claude/settings.json`
- 项目配置: `.claude/settings.json`

## 输出示例

```
🔌 配置 Claude Code 插件

📦 使用预设: web-dev

检查依赖:
  ✅ Node.js v20.10.0
  ✅ npx 可用

安装插件:
  ✅ context7 - 最新库文档
  ✅ playwright - 浏览器自动化
  ✅ github - GitHub 集成
  ✅ fetch - HTTP 请求

配置已写入: .claude/settings.json

┌─────────────────────────────────────────────────────────┐
│ 已安装的插件                                              │
├─────────────────────────────────────────────────────────┤
│ 📚 context7    - 获取最新库文档                           │
│ 🌐 playwright  - 浏览器自动化和测试                        │
│ 🐙 github      - GitHub API 集成                         │
│ 🔗 fetch       - 增强的 HTTP 请求能力                     │
└─────────────────────────────────────────────────────────┘

💡 提示:
- 部分插件需要配置环境变量（如 GITHUB_TOKEN）
- 使用 /plugins 查看可用的工具
- 使用 /setup-plugins --list 查看已安装插件
```

## 单独添加插件

```
/setup-plugins --add context7
/setup-plugins --add playwright
/setup-plugins --add github
```

## 环境变量配置

某些插件需要环境变量：

```bash
# GitHub 插件
export GITHUB_TOKEN="your_github_token"

# PostgreSQL 插件
export DATABASE_URL="postgresql://user:pass@localhost:5432/db"

# AWS 插件
export AWS_PROFILE="default"
```

建议将这些添加到 `.env` 文件或 shell 配置中。

## 故障排除

### 插件无法启动

```
❌ 错误: context7 插件启动失败

可能原因:
1. Node.js 版本过低（需要 >= 18）
2. 网络问题导致包下载失败
3. 权限问题

解决方案:
1. 更新 Node.js: nvm install 20
2. 检查网络连接
3. 尝试: npm cache clean --force
```

### 找不到工具

```
⚠️ 插件已安装但工具未显示

可能原因:
- Claude Code 需要重启
- 配置文件格式错误

解决方案:
1. 重启 Claude Code
2. 运行 /setup-plugins --list 验证配置
```

## 与其他命令配合

```bash
# 初始化完整环境
/setup-permissions --preset node
/setup-plugins --preset web-dev
/setup-format-hook --formatter prettier
```

## 常用插件详解

### Context7 (强烈推荐)

获取任何库的最新文档，避免使用过时的 API。

```
使用 context7 查询 React 19 的新特性
```

### Playwright

浏览器自动化，可以：
- 截图网页
- 填写表单
- 运行 E2E 测试

```
使用 playwright 打开 https://example.com 并截图
```

### GitHub

直接操作 GitHub：
- 创建 Issue
- 查看 PR
- 管理仓库

```
使用 github 查看最近的 PR
```
