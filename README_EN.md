# BorisWorkflow

> One-click setup for an efficient AI programming workflow based on Boris Cherny's 13 Claude Code best practices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

[中文文档](./README.md) | English

---

## Background

### What is Claude Code?

[Claude Code](https://claude.ai/code) is Anthropic's **AI programming assistant CLI tool** that can:

- Understand the entire codebase context
- Automatically write, modify, and refactor code
- Run commands and execute tests
- Create Git commits and Pull Requests
- Extend capabilities through MCP protocol

Claude Code transforms how developers collaborate with AI, but unlocking its full potential requires proper configuration and workflow.

### Who is Boris Cherny?

[Boris Cherny](https://x.com/bcherny) is a renowned TypeScript expert and author of the O'Reilly bestseller **"Programming TypeScript"**.

In early 2025, he shared **13 advanced tips** for using Claude Code in a [tweet](https://x.com/bcherny/status/2007179832300581177), which significantly boosted his development efficiency and sparked widespread discussion in the developer community.

### Why BorisWorkflow?

Boris's 13 tips involve:
- Multiple configuration files (CLAUDE.md, settings.json)
- Custom commands and Agents
- Hook configuration
- MCP plugin integration
- Permission management

Manually configuring these is tedious and error-prone. **BorisWorkflow packages all best practices into a one-click installation toolkit**, giving you an expert-level AI programming experience instantly.

---

## Boris's 13 Tips

| # | Tip | Description | Supported |
|---|-----|-------------|-----------|
| 1 | Run multiple Claudes in parallel | Open multiple terminal windows running Claude Code | Usage habit |
| 2 | Web + CLI combo | Web version for planning, CLI for execution | Usage habit |
| 3 | Use Opus 4.5 | Most powerful model for complex tasks | Model selection |
| 4 | **CLAUDE.md** | Claude's "memory file" for project specs | ✅ Template provided |
| 5 | **@.claude rules** | Mark rules in PR comments, auto-add to memory | ✅ `/add-rule` |
| 6 | **Plan Mode** | Plan first, then execute for complex tasks | Built-in Shift+Tab |
| 7 | **Slash Commands** | Custom slash commands | ✅ 7 commands |
| 8 | **Subagents** | Specialized agents for specific tasks | ✅ 4 Agents |
| 9 | **PostToolUse Hook** | Auto-format after file changes | ✅ Auto-configured |
| 10 | **Permissions** | Preset safe permissions, avoid frequent confirmations | ✅ Preset configs |
| 11 | **Tool Integrations (MCP)** | Connect Slack, BigQuery, Sentry and other tools via MCP servers | ✅ Plugin configs |
| 12 | **Long-Running Tasks** | Background agents, Stop hooks, Ralph Loop and other approaches | ✅ `/setup-ralph-loop` + Docs |
| 13 | **Verification (Most Important)** | Give Claude ways to verify its work, achieve 2-3x quality improvement | ✅ verify-app Agent |

**Additional Features**:

| Feature | Description |
|---------|-------------|
| **One-click install** | Interactive script with auto project type detection |

---

## Features

### 1. CLAUDE.md Template

Claude's "memory file" that helps Claude understand your project:

```markdown
# Project Guidelines for Claude

## Project Overview
- Project name, tech stack, main features

## Development Workflow
- Package manager (bun/npm)
- Dev commands (typecheck, test, lint, build)

## Code Standards
- TypeScript: prefer `type` over `interface`
- Avoid `any`, `enum`
- Naming conventions

## Prohibited
- ❌ Don't use `any`
- ❌ Don't use `console.log`
- ❌ Don't hardcode sensitive info

## Known Issues
- Record Claude's mistakes to avoid repetition
```

### 2. Permission Configuration (Three Tiers)

**Minimal (minimal)** - Read-only operations:
- Git: `status`, `diff`, `log`, `branch`
- Files: `Read(*)`
- System: `ls`, `pwd`, `which`

**Recommended (recommended)** - Balanced security and convenience (default):
- Package manager: Auto-detected `bun/npm/yarn/pnpm` + `run` commands
- Git: `status`, `diff`, `log`, `add`, `commit`, `branch`, `checkout`, `stash`
- Files: `Read(*)` (Write/Edit requires confirmation)

**Full (full)** - Maximum convenience:
- Package manager: All commands
- Git: All operations (including push)
- Files: `Read(*)`, `Write(*)`, `Edit(*)`
- System: `mkdir`, `cp`, `mv`, `touch`

**Always denied** (all levels):
- `rm -rf /`, `rm -rf ~`, `sudo:*`
- `curl * | bash`, `wget * | bash`
- `git push --force origin main/master`

### 3. Slash Commands

| Command | Function | Example |
|---------|----------|---------|
| `/init` | One-click environment init | `/init --preset node` |
| `/add-rule` | Add rule to CLAUDE.md | `/add-rule Don't use any` |
| `/commit-push-pr` | Commit + Push + Create PR | `/commit-push-pr --draft` |
| `/setup-format-hook` | Configure auto-formatting | `/setup-format-hook --formatter prettier` |
| `/setup-permissions` | Configure permissions | `/setup-permissions --preset node` |
| `/setup-plugins` | Configure MCP plugins | `/setup-plugins --preset web-dev` |
| `/setup-ralph-loop` | Configure autonomous loop | `/setup-ralph-loop --enable` |

### 4. Agent Templates

| Agent | Function | Use Case |
|-------|----------|----------|
| `code-reviewer` | Code review | Find bugs, security issues, performance problems |
| `code-simplifier` | Code simplification | Extract duplicate logic, optimize imports |
| `test-generator` | Test generation | Unit tests, integration tests, edge cases |
| `verify-app` | App verification | typecheck → lint → test → build |

Usage:
```
Ask code-reviewer to review recent changes
Ask test-generator to generate tests for src/auth.ts
```

### 5. MCP Plugins (Tool Integrations)

**Core Plugins**:

| Plugin | Function | Why Needed |
|--------|----------|------------|
| `context7` | Get latest docs | Avoid outdated APIs |
| `playwright` | Browser automation | Screenshots, E2E tests |
| `github` | GitHub API | Issue, PR management |
| `fetch` | HTTP requests | API debugging |
| `memory` | Persistent memory | Cross-session info storage |

**Enterprise Tool Integrations** (Boris Tip #11):

| Plugin | Function | Why Needed |
|--------|----------|------------|
| `slack` | Slack messages | Team communication, task notifications |
| `sentry` | Error tracking | View and analyze production errors |
| `bigquery` | BigQuery data warehouse | Query and analyze large-scale data |

**Other Plugins**:

| Plugin | Function | Why Needed |
|--------|----------|------------|
| `figma` | Design to code | UI development, design fidelity |
| `office` | Word/Excel/PPT | Document generation, report automation |

**Presets**:
- `minimal` - Only context7 (recommended for all projects)
- `recommended` - 5 core plugins
- `web-dev` - Full web development + Figma
- `data-science` - Data science suite
- `enterprise` - Enterprise tool integrations (Slack, Sentry, BigQuery)

### 6. Long-Running Tasks (Boris Tip #12)

Boris recommends multiple approaches for handling long-running tasks:

| Approach | Description | Use Case |
|----------|-------------|----------|
| **Background Agents** | Run agent tasks in background | Parallel processing multiple tasks |
| **Stop Hooks** | Configure hooks to pause at specific conditions | Manual confirmation at critical points |
| **Ralph Loop** | Autonomous loop iteration until completion | Overnight development, TDD workflow |

#### Ralph Loop Autonomous Development

Based on [Geoffrey Huntley's technique](https://ghuntley.com/ralph/), let Claude **autonomously iterate until completion**:

```bash
/ralph-loop "
Implement user authentication system:
- POST /auth/register
- POST /auth/login (JWT)
- GET /auth/me
- Test coverage > 80%
Output when done: <promise>AUTH_DONE</promise>
" --max-iterations 30 --completion-promise "AUTH_DONE"
```

**Real cases**:
- Y Combinator hackathon **6 repos generated overnight**
- **$50k contract completed for only $297 API cost**
- Created an entire programming language in 3 months using this method

See `/setup-ralph-loop` command for detailed configuration.

---

## Installation

### Method 1: One-click Install (Recommended)

```bash
# Clone the repo
git clone https://github.com/leiMizzou/BorisWorkflow.git

# Enter your project directory
cd your-project

# Run install script
../BorisWorkflow/install.sh --interactive
```

**Install options**:
```bash
./install.sh                              # Interactive install
./install.sh --preset node                # Node.js project
./install.sh --preset python              # Python project
./install.sh --full --with-ralph          # Full + Ralph Loop
./install.sh --minimal                    # Only CLAUDE.md
./install.sh --permission-level minimal   # Minimal permissions (read-only)
./install.sh --permission-level full      # Full permissions
./install.sh --help                       # Show help
```

**Permission levels**:
| Level | Description | Use Case |
|-------|-------------|----------|
| `minimal` | Read-only operations | Untrusted environments, code review |
| `recommended` | Balanced security and convenience (default) | Daily development |
| `full` | Full permissions | Trusted project environments |

**Auto-detection**:
- Package manager: Auto-detect bun/npm/yarn/pnpm/pip
- Project type: Auto-detect Node.js/Python/Rust/Go

### Method 2: Initialize in Claude Code

```
/init
/init --preset node --with-ralph
```

### Method 3: Natural Language

In Claude Code, say:
```
Initialize Claude Code environment
Help me configure Boris Cherny style development environment
```

### Method 4: Manual Install

```bash
mkdir -p .claude/commands .claude/agents
cp templates/CLAUDE.md ./CLAUDE.md
cp templates/settings.json .claude/settings.json
cp templates/agents/* .claude/agents/
cp commands/* .claude/commands/
```

---

## Usage

### Daily Development

```bash
# 1. Enter Plan Mode for complex tasks
Shift+Tab

# 2. Record rules when Claude makes mistakes
/add-rule Don't call async directly in useEffect

# 3. Verify after code completion
Ask verify-app agent to verify

# 4. Commit
/commit-push-pr
```

### Code Review

```bash
Ask code-reviewer to review recent changes
Ask code-simplifier to optimize this code
```

### Overnight Autonomous Development

```bash
# Start Ralph Loop
/ralph-loop "task description" --max-iterations 30 --completion-promise "DONE"

# Check the next day
git log --oneline -20
bun run test
```

---

## File Structure

```
BorisWorkflow/
├── install.sh                    # One-click install script
├── commands/                     # Slash commands
│   ├── init.md
│   ├── add-rule.md
│   ├── commit-push-pr.md
│   ├── setup-format-hook.md
│   ├── setup-permissions.md
│   ├── setup-plugins.md
│   └── setup-ralph-loop.md
├── templates/
│   ├── CLAUDE.md                 # Memory file template
│   ├── settings.json             # Permission config
│   ├── permissions/              # Permission presets
│   │   ├── minimal.json
│   │   ├── recommended.json
│   │   └── full.json
│   ├── agents/                   # Agent templates
│   └── plugins/                  # MCP plugin configs
└── skills/                       # Claude Skills
```

**After installation, your project**:
```
your-project/
├── CLAUDE.md
└── .claude/
    ├── settings.json
    ├── commands/
    └── agents/
```

---

## Best Practices

1. **Keep updating CLAUDE.md** - Use `/add-rule` whenever Claude makes mistakes
2. **Plan Mode** - Plan first for complex tasks (Shift+Tab)
3. **Format Hook** - Ensure consistent code style
4. **Preset permissions** - Avoid frequent confirmations while maintaining security
5. **Use Agents** - Review, test, verify
6. **Ralph Loop** - Complete clear tasks overnight

---

## Related Links

- [Boris Cherny's Original Tweet](https://x.com/bcherny/status/2007179832300581177)
- [Claude Code Official Site](https://claude.ai/code)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Geoffrey Huntley Ralph Technique](https://ghuntley.com/ralph/)
- [Ralph Wiggum Plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [Figma MCP Server](https://www.figma.com/blog/introducing-figma-mcp-server/)
- [OfficeMCP](https://github.com/OfficeMCP/OfficeMCP)

---

## Acknowledgments

The core concepts and best practices in this project come from the following contributors:

- **[Boris Cherny](https://x.com/bcherny)** - Creator of Claude Code, author of "Programming TypeScript", this project is based on his 13 advanced tips
- **[Geoffrey Huntley](https://ghuntley.com/)** - Inventor of the Ralph Loop autonomous iteration technique

---

## License

MIT License

---

## Contributing

Issues and PRs are welcome! If you find this useful, please give it a Star!

---

Made with Claude Code, based on Boris Cherny's workflow
