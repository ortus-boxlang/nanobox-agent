#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# NanoBox — AI Agent Platform
# Installation script with dependency management
# ──────────────────────────────────────────────────────────────
set -euo pipefail

VERSION="${NANOBOX_VERSION:-0.1.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NANOBOX_HOME="${NANOBOX_HOME:-$HOME/.nanobox}"
INSTALL_BIN="${NANOBOX_BIN:-$HOME/.local/bin}"
CI_MODE=false
LOCAL_MODE=false
UNINSTALL_MODE=false
PREFIX_MODE=""

# Source helpers
if [ -f "$SCRIPT_DIR/scripts/helpers.sh" ]; then
    source "$SCRIPT_DIR/scripts/helpers.sh"
else
    printf "Error: scripts/helpers.sh not found\n" >&2
    exit 1
fi

###########################################################################
# Usage
###########################################################################
usage() {
	cat <<'EOF'
📦 NanoBox Installer

Usage:
  ./install.sh [options]

Options:
  --help, -h          Show this help
  --version, -v       Show the version being installed
  --local             Install beside the project (creates .nanobox/ locally)
  --uninstall         Remove NanoBox installation
  --prefix=PATH       Install to custom prefix (e.g., /opt/nanobox)
  --ci                Non-interactive mode; fail fast if dependencies missing

Environment:
  NANOBOX_HOME        Installation directory (default: ~/.nanobox)
  NANOBOX_BIN         Wrapper directory (default: ~/.local/bin)
  NANOBOX_VERSION     Version directory name (default: 0.1.0)
EOF
}

###########################################################################
# Parse arguments
###########################################################################
for arg in "$@"; do
    case "$arg" in
        --help|-h) usage; exit 0 ;;
        --version|-v) printf '📦 NanoBox Installer v%s\n' "$VERSION"; exit 0 ;;
        --local) LOCAL_MODE=true ;;
        --uninstall) UNINSTALL_MODE=true ;;
        --ci) CI_MODE=true ;;
        --prefix=*) PREFIX_MODE="${arg#--prefix=}" ;;
    esac
done

###########################################################################
# Uninstall mode
###########################################################################
if $UNINSTALL_MODE; then
    print_header "NanoBox Uninstaller"

    if $LOCAL_MODE; then
        local_home="$SCRIPT_DIR/.nanobox"
        if [ -d "$local_home" ]; then
            print_info "Removing local installation at $local_home..."
            rm -rf "$local_home"
            if [ -f "$SCRIPT_DIR/nanobox-dev" ]; then
                rm "$SCRIPT_DIR/nanobox-dev"
            fi
            print_success "Local NanoBox uninstalled"
        else
            print_warning "No local installation found at $local_home"
        fi
    else
        if [ -L "$NANOBOX_HOME/current" ]; then
            print_info "Removing symlink $NANOBOX_HOME/current..."
            rm "$NANOBOX_HOME/current"
        fi
        if [ -f "$INSTALL_BIN/nanobox" ]; then
            print_info "Removing wrapper $INSTALL_BIN/nanobox..."
            rm "$INSTALL_BIN/nanobox"
        fi
        print_success "NanoBox uninstalled (data preserved in $NANOBOX_HOME)"
        print_info "To remove all data: rm -rf $NANOBOX_HOME"
    fi
    exit 0
fi

###########################################################################
# Set up paths based on mode
###########################################################################
if $LOCAL_MODE; then
    NANOBOX_HOME="$SCRIPT_DIR/.nanobox"
    INSTALL_BIN="$SCRIPT_DIR"
fi

if [ -n "$PREFIX_MODE" ]; then
    NANOBOX_HOME="$PREFIX_MODE"
    INSTALL_BIN="$PREFIX_MODE/bin"
fi

VERSION_DIR="$NANOBOX_HOME/versions/v$VERSION"
CURRENT_LINK="$NANOBOX_HOME/current"
CONFIG_DIR="$NANOBOX_HOME/config"

###########################################################################
# Dependency checks
###########################################################################
print_header "NanoBox Installer v$VERSION"
printf "\n"

# Check BoxLang first (if present, Java is guaranteed)
print_info "Checking for BoxLang..."
boxlang_version=$(check_boxlang 2>/dev/null || echo "")

if [ -n "$boxlang_version" ]; then
    print_success "BoxLang $boxlang_version found"
else
    print_warning "BoxLang not found"

    # Check Java only if BoxLang is missing
    print_info "Checking for Java 21+..."
    if check_java_version 2>/dev/null; then
        print_success "Java 21+ found"
    else
        print_error "Java 21+ not found"

        if $CI_MODE; then
            print_error "CI mode: cannot prompt for installation. Please install BoxLang or Java 21+ first."
            exit 1
        fi

        printf "\n${WARNING}Would you like to install BoxLang (includes JRE 21)? (y/N) ${NORMAL}"
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY])
                print_info "Installing BoxLang via quick installer..."
                if curl -fsSL https://downloads.ortussolutions.com/ortussolutions/boxlang-quick-installer/install-boxlang.sh | bash; then
                    print_success "BoxLang installed successfully"
                    boxlang_version=$(check_boxlang 2>/dev/null || echo "")
                else
                    print_error "BoxLang installation failed"
                    exit 1
                fi
                ;;
            *)
                print_error "BoxLang is required. Please install it manually:"
                print_info "curl -fsSL https://downloads.ortussolutions.com/ortussolutions/boxlang-quick-installer/install-boxlang.sh | bash"
                exit 1
                ;;
        esac
    fi
fi

# System tools check
preflight_check "$CI_MODE"

printf "\n"

###########################################################################
# Interactive prompt (skip in CI mode)
###########################################################################
if ! $CI_MODE; then
    print_header "Choose an action:"
    printf "\n"
    printf "  ${SUCCESS}y${NORMAL}   Install NanoBox (default)\n"
    printf "  ${ERROR}u${NORMAL}   Uninstall NanoBox\n"
    printf "  ${DIM}n${NORMAL}   Do nothing\n"
    printf "\n"

    read -r -p "Will " choice
    case "$choice" in
        u|U)
            exec "$0" --uninstall $([ "$LOCAL_MODE" = true ] && echo "--local")
            ;;
        n|N)
            print_info "Installation cancelled"
            exit 0
            ;;
        *)
            # Default: install
            ;;
    esac
fi

###########################################################################
# Create directory structure
###########################################################################
print_info "Creating directory structure..."

mkdir -p \
	"$VERSION_DIR" \
	"$CONFIG_DIR" \
	"$NANOBOX_HOME/agents" \
	"$NANOBOX_HOME/tools" \
	"$NANOBOX_HOME/mcp-servers" \
	"$NANOBOX_HOME/vault/reports" \
	"$NANOBOX_HOME/vault/research" \
	"$NANOBOX_HOME/vault/imported" \
	"$NANOBOX_HOME/vault/manual" \
	"$NANOBOX_HOME/user-scripts/registered" \
	"$NANOBOX_HOME/skills" \
	"$NANOBOX_HOME/backups" \
	"$NANOBOX_HOME/logs" \
	"$NANOBOX_HOME/run" \
	"$NANOBOX_HOME/quarantine" \
	"$NANOBOX_HOME/data" \
	"$INSTALL_BIN"

print_step_done

###########################################################################
# Copy application files
###########################################################################
print_info "Copying application files..."

rsync -a \
	--exclude '.git/' \
	--exclude '.DS_Store' \
	--exclude '.env' \
	--exclude 'build/' \
	--exclude 'node_modules/' \
	--exclude 'boxlang_modules/' \
	--exclude 'testbox/' \
	--exclude 'tests/results/' \
	--exclude 'versions/' \
	--exclude 'current' \
	"$SCRIPT_DIR/" "$VERSION_DIR/"

print_step_done

###########################################################################
# Create current symlink
###########################################################################
print_info "Setting up version symlink..."

ln -sfn "versions/v$VERSION" "$CURRENT_LINK"

print_step_done

###########################################################################
# Write default config files (only if they don't exist)
###########################################################################
print_info "Writing default configuration..."

if [[ ! -f "$CONFIG_DIR/nanobox.json" ]]; then
	cat > "$CONFIG_DIR/nanobox.json" <<'EOF'
{
	"$schema": "https://nanobox.io/schemas/v1/config.json",
	"version": "1",
	"bx-ai": {
		"defaultProvider": "",
		"defaultModel": "",
		"providers": {}
	},
	"nanobox": {
		"web": { "enabled": true, "host": "127.0.0.1", "port": 8080 },
		"worker": { "enabled": true, "debug": false },
		"sessions": { "enabled": true, "maxSessions": 1000, "pruneAfterDays": 90 },
		"cron": { "enabled": true, "maxJobs": 50 },
		"security": { "enabled": true, "autoDisable": true }
	}
}
EOF
fi

if [[ ! -f "$CONFIG_DIR/preferences.json" ]]; then
	cat > "$CONFIG_DIR/preferences.json" <<'EOF'
{
	"tone": "helpful",
	"verbosity": "normal",
	"model": "",
	"provider": ""
}
EOF
fi

if [[ ! -f "$CONFIG_DIR/system-instructions.md" ]]; then
	cat > "$CONFIG_DIR/system-instructions.md" <<'EOF'
# NanoBox System Instructions

Add user-editable instructions for NanoBox here.
EOF
fi

if [[ ! -f "$CONFIG_DIR/.env" ]]; then
	cat > "$CONFIG_DIR/.env" <<'EOF'
# NanoBox secrets. Keep this file private.
# OPENAI_API_KEY=
# ANTHROPIC_API_KEY=
# OPENROUTER_API_KEY=
EOF
	chmod 600 "$CONFIG_DIR/.env"
fi

if [[ ! -f "$NANOBOX_HOME/mcp-servers/registry.json" ]]; then
	printf '{\n\t"servers": {}\n}\n' > "$NANOBOX_HOME/mcp-servers/registry.json"
fi

if [[ ! -f "$NANOBOX_HOME/user-scripts/nano-scripts.json" ]]; then
	printf '{\n\t"scripts": {}\n}\n' > "$NANOBOX_HOME/user-scripts/nano-scripts.json"
fi

print_step_done

###########################################################################
# Install BoxLang modules
###########################################################################
print_info "Installing BoxLang modules..."

if command -v install-bx-module >/dev/null 2>&1; then
	missing_modules=()
	[[ -d "$SCRIPT_DIR/boxlang_modules/bx-ai" ]] || missing_modules+=( "bx-ai" )
	[[ -d "$SCRIPT_DIR/boxlang_modules/bx-sqlite" ]] || missing_modules+=( "bx-sqlite" )
	if (( ${#missing_modules[@]} > 0 )); then
		(
			cd "$SCRIPT_DIR"
			install-bx-module "${missing_modules[@]}" --local
		)
	fi
else
	print_warning "install-bx-module not found; required local BoxLang modules were not installed."
	print_info "Install BoxLang modules with: install-bx-module bx-ai bx-sqlite --local"
fi

print_step_done

###########################################################################
# Install wrapper script
###########################################################################
print_info "Setting up wrapper script..."

if $LOCAL_MODE; then
    cat > "$INSTALL_BIN/nanobox-dev" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export NANOBOX_HOME="$NANOBOX_HOME"
exec boxlang "$NANOBOX_HOME/current/cli/nanobox.bx" "\$@"
EOF
    chmod 755 "$INSTALL_BIN/nanobox-dev"
else
    cat > "$INSTALL_BIN/nanobox" <<EOF
#!/usr/bin/env bash
set -euo pipefail
NANOBOX_HOME="\${NANOBOX_HOME:-$NANOBOX_HOME}"
exec boxlang "\$NANOBOX_HOME/current/cli/nanobox.bx" "\$@"
EOF
    chmod 755 "$INSTALL_BIN/nanobox"
fi

print_step_done

###########################################################################
# Success message
###########################################################################
printf "\n"
print_header "✅ NanoBox v$VERSION installed successfully!"
printf "\n"
printf "Home:    %s\n" "$NANOBOX_HOME"
printf "Version: %s\n" "$VERSION_DIR"

if $LOCAL_MODE; then
    printf "Wrapper: %s/nanobox-dev\n" "$INSTALL_BIN"
    printf "\nNext steps:\n"
    printf "  ./nanobox-dev doctor\n"
    printf "  ./nanobox-dev model\n"
else
    printf "Wrapper: %s/nanobox\n" "$INSTALL_BIN"
    printf "\nNext steps:\n"
    printf "  export PATH=\"%s:\$PATH\"\n" "$INSTALL_BIN"
    printf "  nanobox doctor\n"
    printf "  nanobox model\n"
fi
printf "\n"
