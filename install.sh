#!/bin/bash
#
# Boris Cherny 风格 Claude Code 工作流一键安装脚本
#
# 使用方式:
#   curl -fsSL https://raw.githubusercontent.com/your-repo/claude-code-boris-workflow/main/install.sh | bash
#   或
#   ./install.sh [选项]
#
# 选项:
#   --minimal     仅安装 CLAUDE.md 和基础配置
#   --full        安装所有功能（默认）
#   --with-ralph  包含 Ralph Loop 插件
#   --preset      预设: node, python, web-dev, data-science
#   --no-plugins  不配置 MCP 插件
#   --help        显示帮助
#

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置变量
INSTALL_MODE="full"
PRESET="auto"
WITH_RALPH=false
WITH_PLUGINS=true
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检测是否从远程运行
if [[ ! -f "$SCRIPT_DIR/templates/CLAUDE.md" ]]; then
    REMOTE_MODE=true
    REPO_URL="https://raw.githubusercontent.com/your-username/claude-code-boris-workflow/main"
else
    REMOTE_MODE=false
fi

# 打印带颜色的消息
print_header() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  ${CYAN}🚀 Boris Cherny 风格 Claude Code 工作流安装器${NC}           ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ️${NC} $1"
}

# 显示帮助
show_help() {
    cat << EOF
Boris Cherny 风格 Claude Code 工作流安装器

使用方式:
  ./install.sh [选项]

选项:
  --minimal       仅安装 CLAUDE.md 和基础权限配置
  --full          安装所有功能（默认）
  --with-ralph    包含 Ralph Loop 自主循环插件
  --preset <name> 使用预设配置:
                    node        - Node.js/TypeScript 项目
                    python      - Python 项目
                    web-dev     - Web 开发全套
                    data-science - 数据科学项目
  --no-plugins    不配置 MCP 插件
  --interactive   交互式选择功能
  --help          显示此帮助信息

示例:
  ./install.sh                          # 完整安装，自动检测项目类型
  ./install.sh --preset node            # Node.js 项目预设
  ./install.sh --minimal                # 最小安装
  ./install.sh --full --with-ralph      # 完整安装 + Ralph Loop
  ./install.sh --interactive            # 交互式安装

EOF
    exit 0
}

# 检测项目类型
detect_project_type() {
    if [[ -f "package.json" ]]; then
        if grep -q "bun" package.json 2>/dev/null || [[ -f "bun.lockb" ]]; then
            echo "bun"
        elif [[ -f "pnpm-lock.yaml" ]]; then
            echo "pnpm"
        elif [[ -f "yarn.lock" ]]; then
            echo "yarn"
        else
            echo "npm"
        fi
    elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
        echo "python"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    else
        echo "generic"
    fi
}

# 交互式安装
interactive_install() {
    print_header
    echo -e "${CYAN}请选择要安装的功能：${NC}"
    echo ""

    # 选择安装模式
    echo "1) 完整安装 (推荐) - 包含所有功能"
    echo "2) 最小安装 - 仅 CLAUDE.md 和基础配置"
    echo "3) 自定义安装"
    echo ""
    read -p "请选择 [1-3]: " mode_choice

    case $mode_choice in
        1) INSTALL_MODE="full" ;;
        2) INSTALL_MODE="minimal" ;;
        3)
            INSTALL_MODE="custom"
            echo ""
            echo -e "${CYAN}选择要包含的组件（输入 y/n）：${NC}"

            read -p "  📄 CLAUDE.md 模板? [Y/n]: " inc_claude
            read -p "  ⚙️  权限配置? [Y/n]: " inc_permissions
            read -p "  🔧 格式化 Hook? [Y/n]: " inc_hooks
            read -p "  📁 Agents 模板? [Y/n]: " inc_agents
            read -p "  💻 斜杠命令? [Y/n]: " inc_commands
            read -p "  🔌 MCP 插件? [Y/n]: " inc_plugins
            read -p "  🔄 Ralph Loop? [y/N]: " inc_ralph

            [[ "$inc_plugins" =~ ^[Nn]$ ]] && WITH_PLUGINS=false
            [[ "$inc_ralph" =~ ^[Yy]$ ]] && WITH_RALPH=true
            ;;
    esac

    # 选择预设
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        echo ""
        echo -e "${CYAN}检测到的项目类型: $(detect_project_type)${NC}"
        echo ""
        echo "选择配置预设："
        echo "1) 自动检测 (推荐)"
        echo "2) Node.js / TypeScript"
        echo "3) Python"
        echo "4) Web 开发全套"
        echo "5) 数据科学"
        echo ""
        read -p "请选择 [1-5]: " preset_choice

        case $preset_choice in
            1) PRESET="auto" ;;
            2) PRESET="node" ;;
            3) PRESET="python" ;;
            4) PRESET="web-dev" ;;
            5) PRESET="data-science" ;;
        esac
    fi

    echo ""
    print_info "开始安装..."
    echo ""
}

# 获取文件内容（本地或远程）
get_file() {
    local path=$1
    if [[ "$REMOTE_MODE" == true ]]; then
        curl -fsSL "$REPO_URL/$path"
    else
        cat "$SCRIPT_DIR/$path"
    fi
}

# 创建目录结构
create_directories() {
    print_step "创建目录结构..."

    mkdir -p .claude/commands
    mkdir -p .claude/agents

    print_success "目录结构已创建"
}

# 安装 CLAUDE.md
install_claude_md() {
    print_step "创建 CLAUDE.md..."

    if [[ -f "CLAUDE.md" ]]; then
        print_warning "CLAUDE.md 已存在，创建备份..."
        mv CLAUDE.md CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)
    fi

    get_file "templates/CLAUDE.md" > CLAUDE.md

    # 根据项目类型调整
    local project_type=$(detect_project_type)
    case $project_type in
        python)
            sed -i.bak 's/bun/pip/g; s/npm/pip/g' CLAUDE.md 2>/dev/null || true
            rm -f CLAUDE.md.bak
            ;;
    esac

    print_success "CLAUDE.md 已创建"
}

# 安装权限配置
install_settings() {
    print_step "配置 settings.json..."

    local settings_file=".claude/settings.json"

    if [[ -f "$settings_file" ]]; then
        print_warning "settings.json 已存在，合并配置..."
        # TODO: 智能合并
    fi

    # 根据预设选择配置
    case $PRESET in
        python)
            get_file "commands/setup-permissions.md" | \
            sed -n '/### Python 项目/,/```$/p' | \
            sed -n '/```json/,/```/p' | sed '1d;$d' > "$settings_file"
            ;;
        *)
            get_file "templates/settings.json" > "$settings_file"
            ;;
    esac

    print_success "settings.json 已配置"
}

# 安装 agents
install_agents() {
    print_step "安装 Agent 模板..."

    local agents=("code-reviewer" "code-simplifier" "test-generator" "verify-app")

    for agent in "${agents[@]}"; do
        get_file "templates/agents/${agent}.md" > ".claude/agents/${agent}.md"
    done

    print_success "已安装 ${#agents[@]} 个 Agent 模板"
}

# 安装斜杠命令
install_commands() {
    print_step "安装斜杠命令..."

    local commands=("add-rule" "commit-push-pr" "setup-format-hook" "setup-permissions" "setup-plugins")

    if [[ "$WITH_RALPH" == true ]]; then
        commands+=("setup-ralph-loop")
    fi

    for cmd in "${commands[@]}"; do
        get_file "commands/${cmd}.md" > ".claude/commands/${cmd}.md"
    done

    print_success "已安装 ${#commands[@]} 个斜杠命令"
}

# 配置 MCP 插件
install_plugins() {
    print_step "配置 MCP 插件..."

    local plugins_preset="recommended"
    case $PRESET in
        web-dev) plugins_preset="web-dev" ;;
        data-science) plugins_preset="data-science" ;;
        minimal) plugins_preset="minimal" ;;
    esac

    # 读取插件配置并合并到 settings.json
    local plugins_config=$(get_file "templates/plugins/${plugins_preset}.json")

    if [[ -f ".claude/settings.json" ]]; then
        # 使用 jq 合并（如果可用）
        if command -v jq &> /dev/null; then
            local current=$(cat .claude/settings.json)
            echo "$current" | jq --argjson plugins "$plugins_config" '. + {mcpServers: $plugins.mcpServers}' > .claude/settings.json.tmp
            mv .claude/settings.json.tmp .claude/settings.json
        else
            print_warning "jq 未安装，插件配置需要手动合并"
            echo "$plugins_config" > .claude/plugins.json
            print_info "插件配置已保存到 .claude/plugins.json"
        fi
    fi

    print_success "MCP 插件已配置 (预设: $plugins_preset)"
}

# 配置 Ralph Loop
install_ralph() {
    print_step "配置 Ralph Loop..."

    get_file "commands/setup-ralph-loop.md" > ".claude/commands/setup-ralph-loop.md"

    # 添加 ralph-wiggum 到 plugins
    if [[ -f ".claude/settings.json" ]] && command -v jq &> /dev/null; then
        local current=$(cat .claude/settings.json)
        echo "$current" | jq '. + {plugins: ["ralph-wiggum"]}' > .claude/settings.json.tmp
        mv .claude/settings.json.tmp .claude/settings.json
    fi

    print_success "Ralph Loop 已配置"
    print_info "使用 /ralph-loop 启动自主开发循环"
}

# 显示完成信息
show_completion() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}           ${GREEN}✅ 安装完成！${NC}                                  ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${CYAN}已安装的文件：${NC}"
    echo ""

    if [[ -f "CLAUDE.md" ]]; then
        echo "  📄 CLAUDE.md"
    fi

    if [[ -d ".claude" ]]; then
        echo "  📁 .claude/"
        [[ -f ".claude/settings.json" ]] && echo "     ├── settings.json"
        [[ -d ".claude/commands" ]] && echo "     ├── commands/ ($(ls .claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ') 个命令)"
        [[ -d ".claude/agents" ]] && echo "     └── agents/ ($(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ') 个 agent)"
    fi

    echo ""
    echo -e "${CYAN}下一步：${NC}"
    echo ""
    echo "  1. 编辑 CLAUDE.md 添加项目特定规则"
    echo "  2. 在 Claude Code 中测试命令："
    echo ""
    echo -e "     ${YELLOW}/add-rule 不要使用 any 类型${NC}"
    echo -e "     ${YELLOW}/commit-push-pr${NC}"
    echo ""

    if [[ "$WITH_RALPH" == true ]]; then
        echo -e "  3. 使用 Ralph Loop 自主开发："
        echo ""
        echo -e "     ${YELLOW}/ralph-loop \"你的任务\" --max-iterations 30${NC}"
        echo ""
    fi

    echo -e "${CYAN}文档：${NC} https://github.com/your-repo/claude-code-boris-workflow"
    echo ""
}

# 主函数
main() {
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                ;;
            --minimal)
                INSTALL_MODE="minimal"
                shift
                ;;
            --full)
                INSTALL_MODE="full"
                shift
                ;;
            --with-ralph)
                WITH_RALPH=true
                shift
                ;;
            --no-plugins)
                WITH_PLUGINS=false
                shift
                ;;
            --preset)
                PRESET="$2"
                shift 2
                ;;
            --interactive|-i)
                interactive_install
                shift
                ;;
            *)
                print_error "未知选项: $1"
                echo "使用 --help 查看帮助"
                exit 1
                ;;
        esac
    done

    # 如果没有参数，显示交互式菜单
    if [[ "$INSTALL_MODE" == "full" ]] && [[ "$PRESET" == "auto" ]]; then
        # 检查是否在终端中运行
        if [[ -t 0 ]]; then
            echo ""
            read -p "是否使用交互式安装？[Y/n]: " use_interactive
            if [[ ! "$use_interactive" =~ ^[Nn]$ ]]; then
                interactive_install
            else
                print_header
            fi
        else
            print_header
        fi
    else
        print_header
    fi

    # 自动检测预设
    if [[ "$PRESET" == "auto" ]]; then
        local detected=$(detect_project_type)
        case $detected in
            bun|npm|pnpm|yarn) PRESET="node" ;;
            python) PRESET="python" ;;
            *) PRESET="node" ;;
        esac
        print_info "自动检测项目类型: $detected (使用 $PRESET 预设)"
    fi

    # 执行安装
    create_directories
    install_claude_md
    install_settings

    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        install_agents
        install_commands

        if [[ "$WITH_PLUGINS" == true ]]; then
            install_plugins
        fi

        if [[ "$WITH_RALPH" == true ]]; then
            install_ralph
        fi
    fi

    show_completion
}

# 运行
main "$@"
