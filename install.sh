#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# NanoBox — AI Agent Platform
# Installation script
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
BOXLANG=""

source "$SCRIPT_DIR/scripts/helpers.sh"

###########################################################################
# Usage
###########################################################################
usage() {
	cat <<'EOF'
NanoBox Installer

Usage:
  ./install.sh [options]

Options:
  --help, -h          Show this help
  --version, -v       Show the version being installed
  --local             Install in-project (data in .nanobox/, run from source)
  --uninstall         Remove NanoBox installation
  --prefix=PATH       Install to a custom prefix (e.g. /opt/nanobox)
  --ci                Non-interactive; fail fast on missing dependencies

Environment:
  NANOBOX_HOME        Override installation data directory
  NANOBOX_BIN         Override wrapper directory (default: ~/.local/bin)
  NANOBOX_VERSION     Version label (default: 0.1.0)
  BOXLANG             Explicit path to the boxlang binary
EOF
}

###########################################################################
# Parse arguments
###########################################################################
for arg in "$@"; do
	case "$arg" in
		--help|-h)      usage; exit 0 ;;
		--version|-v)   printf 'NanoBox Installer v%s\n' "$VERSION"; exit 0 ;;
		--local)        LOCAL_MODE=true ;;
		--uninstall)    UNINSTALL_MODE=true ;;
		--ci)           CI_MODE=true ;;
		--prefix=*)     PREFIX_MODE="${arg#--prefix=}" ;;
	esac
done

###########################################################################
# Resolve installation paths
###########################################################################
if $LOCAL_MODE; then
	NANOBOX_HOME="$SCRIPT_DIR/.nanobox"
	INSTALL_BIN="$SCRIPT_DIR"
fi

if [[ -n "$PREFIX_MODE" ]]; then
	NANOBOX_HOME="$PREFIX_MODE"
	INSTALL_BIN="$PREFIX_MODE/bin"
fi

VERSION_DIR="$NANOBOX_HOME/versions/v$VERSION"
CURRENT_LINK="$NANOBOX_HOME/current"
CONFIG_DIR="$NANOBOX_HOME/config"

###########################################################################
# Uninstall
###########################################################################
if $UNINSTALL_MODE; then
	print_header "NanoBox Uninstaller"
	printf '\n'
	if $LOCAL_MODE; then
		if [[ -d "$NANOBOX_HOME" ]]; then
			print_info "Removing local data directory $NANOBOX_HOME ..."
			rm -rf "$NANOBOX_HOME"
			print_success "Local NanoBox data removed"
		else
			print_warning "No local installation found at $NANOBOX_HOME"
		fi
	else
		[[ -L "$CURRENT_LINK" ]] && rm -f "$CURRENT_LINK" && print_info "Removed symlink $CURRENT_LINK"
		[[ -f "$INSTALL_BIN/nanobox" ]] && rm -f "$INSTALL_BIN/nanobox" && print_info "Removed wrapper $INSTALL_BIN/nanobox"
		print_success "NanoBox uninstalled (data preserved in $NANOBOX_HOME)"
		print_info "To remove all data: rm -rf $NANOBOX_HOME"
	fi
	exit 0
fi

###########################################################################
# Step 1 — Detect BoxLang (install if missing)
###########################################################################
print_header "NanoBox Installer v$VERSION"
printf '\n'
print_info "Step 1: Checking for BoxLang runtime..."

find_boxlang() {
	local found
	found="${BOXLANG:-$(command -v boxlang 2>/dev/null || true)}"
	if [[ -n "$found" && -x "$found" ]]; then
		BOXLANG="$found"
		return 0
	fi
	for candidate in \
		"$HOME/.bvm/current/bin/boxlang" \
		"$HOME/.boxlang/bin/boxlang" \
		/opt/homebrew/bin/boxlang \
		/usr/local/bin/boxlang; do
		if [[ -x "$candidate" ]]; then
			BOXLANG="$candidate"
			return 0
		fi
	done
	return 1
}

install_boxlang() {
	print_info "Running BoxLang quick installer..."
	if curl -fsSL https://downloads.ortussolutions.com/ortussolutions/boxlang-quick-installer/install-boxlang.sh | bash; then
		# Reload PATH from well-known locations
		export PATH="$HOME/.bvm/current/bin:$HOME/.boxlang/bin:$PATH"
		if find_boxlang; then
			print_success "BoxLang installed at $BOXLANG"
			return 0
		fi
		print_error "BoxLang was installed but the binary could not be located. Open a new shell and re-run this script."
		exit 1
	else
		print_error "BoxLang quick installer failed."
		exit 1
	fi
}

if find_boxlang; then
	boxlang_ver=$(check_boxlang 2>/dev/null || echo "unknown")
	print_success "BoxLang $boxlang_ver found at $BOXLANG"
else
	print_warning "BoxLang not found"
	if $CI_MODE; then
		print_error "CI mode: BoxLang is required. Install it before running this script."
		print_info "curl -fsSL https://downloads.ortussolutions.com/ortussolutions/boxlang-quick-installer/install-boxlang.sh | bash"
		exit 1
	fi
	printf '\n'
	read -r -p "BoxLang is not installed. Install it now? [Y/n] " response
	case "${response:-y}" in
		[nN]*) print_error "BoxLang is required. Aborting."; exit 1 ;;
		*)     install_boxlang ;;
	esac
fi

printf '\n'

###########################################################################
# Step 2 — System dependency check
###########################################################################
print_info "Step 2: Checking system dependencies..."
preflight_check "$CI_MODE"
printf '\n'

###########################################################################
# Step 3 — Download Lanterna TUI library
###########################################################################
print_info "Step 3: Downloading Lanterna TUI library..."
LANTERNA_JAR="$SCRIPT_DIR/lib/java/lanterna-3.1.3.jar"
if [[ -f "$LANTERNA_JAR" ]]; then
	print_success "  lanterna-3.1.3.jar (already present)"
else
	mkdir -p "$SCRIPT_DIR/lib/java"
	if curl -fsSL --retry 3 -o "$LANTERNA_JAR" \
		"https://repo1.maven.org/maven2/com/googlecode/lanterna/lanterna/3.1.3/lanterna-3.1.3.jar"; then
		print_success "  lanterna-3.1.3.jar downloaded"
	else
		print_warning "  Could not download Lanterna — interactive TUI features will be unavailable"
	fi
fi
printf '\n'

###########################################################################
# Step 4 — Verify bundled BoxLang modules
###########################################################################
print_info "Step 4: Verifying bundled BoxLang modules..."
modules_ok=true
for mod in bx-ai bx-sqlite; do
	if [[ -d "$SCRIPT_DIR/lib/modules/$mod" ]]; then
		print_success "  $mod (bundled)"
	else
		print_warning "  $mod not found in lib/modules/ — some features may not work"
		modules_ok=false
	fi
done
if ! $modules_ok; then
	print_info "Try: git submodule update --init --recursive"
fi
printf '\n'

###########################################################################
# Step 5 — Create directory structure
###########################################################################
print_info "Step 5: Creating directory structure..."
mkdir -p \
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
	"$NANOBOX_HOME/data"
print_step_done
printf '\n'

###########################################################################
# Step 5 — Copy application files (global install only)
###########################################################################
if ! $LOCAL_MODE; then
	print_info "Step 5: Installing application files to $VERSION_DIR ..."
	mkdir -p "$INSTALL_BIN" "$VERSION_DIR"
	rsync -a \
		--exclude '.git/' \
		--exclude '.nanobox/' \
		--exclude '.DS_Store' \
		--exclude '.env' \
		--exclude 'build/' \
		--exclude 'node_modules/' \
		--exclude 'tests/results/' \
		--exclude 'versions/' \
		--exclude 'current' \
		"$SCRIPT_DIR/" "$VERSION_DIR/"
	ln -sfn "versions/v$VERSION" "$CURRENT_LINK"
	print_step_done
	printf '\n'
else
	print_info "Step 5: Local mode — running from source at $SCRIPT_DIR (no copy)"
	printf '\n'
fi

###########################################################################
# Step 6 — Generate BoxLang runtime config with absolute paths
###########################################################################
print_info "Step 6: Writing BoxLang runtime config..."

if $LOCAL_MODE; then
	BX_CONFIG="$NANOBOX_HOME/boxlang-local.json"
	MODULES_DIR="$SCRIPT_DIR/lib/modules"
	DB_PATH="$NANOBOX_HOME/data/nanobox.db"
else
	BX_CONFIG="$NANOBOX_HOME/boxlang.json"
	MODULES_DIR="$VERSION_DIR/lib/modules"
	DB_PATH="$NANOBOX_HOME/data/nanobox.db"
fi

cat > "$BX_CONFIG" <<EOF
{
	"clearClassFilesOnStartup": true,
	"classResolverCache": true,
	"trustedCache": false,
	"validClassExtensions": [ "bx", "cfc" ],
	"mappings": {
		"/cli":    "$( $LOCAL_MODE && echo "$SCRIPT_DIR/cli"    || echo "$VERSION_DIR/cli" )",
		"/models": "$( $LOCAL_MODE && echo "$SCRIPT_DIR/models" || echo "$VERSION_DIR/models" )",
		"/nanobox":"$( $LOCAL_MODE && echo "$SCRIPT_DIR/"       || echo "$VERSION_DIR/" )"
	},
	"modulesDirectory": [
		"$MODULES_DIR",
		"\${boxlang-home}/modules"
	],
	"datasources": {
		"nanobox": {
			"driver": "sqlite",
			"connectionString": "jdbc:sqlite:$DB_PATH"
		}
	},
	"javaLibraryPaths": [
		"$( $LOCAL_MODE && echo "$SCRIPT_DIR/lib/java" || echo "$VERSION_DIR/lib/java" )"
	]
}
EOF
print_success "  Written to $BX_CONFIG"
printf '\n'

###########################################################################
# Step 7 — Write default NanoBox config files (skip existing)
###########################################################################
print_info "Step 7: Writing default NanoBox configuration..."

[[ -f "$CONFIG_DIR/nanobox.json" ]] || cat > "$CONFIG_DIR/nanobox.json" <<'EOF'
{
	"$schema": "https://nanobox.io/schemas/v1/config.json",
	"version": "1",
	"bx-ai": {
		"defaultProvider": "",
		"defaultModel": "",
		"providers": {}
	},
	"nanobox": {
		"web":      { "enabled": true, "host": "127.0.0.1", "port": 8080 },
		"worker":   { "enabled": true, "debug": false },
		"sessions": { "enabled": true, "maxSessions": 1000, "pruneAfterDays": 90 },
		"cron":     { "enabled": true, "maxJobs": 50 },
		"security": { "enabled": true, "autoDisable": true },
		"tui": {
			"theme": "boxlang",
			"streaming": true,
			"wordWrap": true,
			"wrapWidth": 0,
			"statusBar": true,
			"colors": true,
			"markdownRender": true,
			"sidebarWidth": 22
		}
	}
}
EOF

[[ -f "$CONFIG_DIR/preferences.json" ]] || cat > "$CONFIG_DIR/preferences.json" <<'EOF'
{
	"tone": "helpful",
	"verbosity": "normal",
	"model": "",
	"provider": ""
}
EOF

[[ -f "$CONFIG_DIR/system-instructions.md" ]] || cat > "$CONFIG_DIR/system-instructions.md" <<'EOF'
# NanoBox System Instructions

Add your custom instructions for NanoBox here.
EOF

if [[ ! -f "$CONFIG_DIR/.env" ]]; then
	cat > "$CONFIG_DIR/.env" <<'EOF'
# NanoBox API keys — keep this file private.
# ANTHROPIC_API_KEY=
# OPENAI_API_KEY=
# OPENROUTER_API_KEY=
EOF
	chmod 600 "$CONFIG_DIR/.env"
fi

[[ -f "$NANOBOX_HOME/mcp-servers/registry.json" ]] || printf '{\n\t"servers": {}\n}\n' > "$NANOBOX_HOME/mcp-servers/registry.json"
[[ -f "$NANOBOX_HOME/user-scripts/nano-scripts.json" ]] || printf '{\n\t"scripts": {}\n}\n' > "$NANOBOX_HOME/user-scripts/nano-scripts.json"

print_step_done
printf '\n'

###########################################################################
# Step 8 — Create system wrapper (global install only)
###########################################################################
if ! $LOCAL_MODE; then
	print_info "Step 8: Creating wrapper at $INSTALL_BIN/nanobox ..."
	mkdir -p "$INSTALL_BIN"
	cat > "$INSTALL_BIN/nanobox" <<EOF
#!/usr/bin/env bash
set -euo pipefail
NANOBOX_HOME="\${NANOBOX_HOME:-$NANOBOX_HOME}"
BOXLANG="\${BOXLANG:-$(command -v boxlang 2>/dev/null || true)}"
if [[ -z "\${BOXLANG:-}" || ! -x "\${BOXLANG:-}" ]]; then
    for c in "$HOME/.bvm/current/bin/boxlang" "$HOME/.boxlang/bin/boxlang" /opt/homebrew/bin/boxlang /usr/local/bin/boxlang; do
        [[ -x "\$c" ]] && { BOXLANG="\$c"; break; }
    done
fi
[[ -z "\${BOXLANG:-}" ]] && { printf 'Error: boxlang not found\\n' >&2; exit 4; }
export NANOBOX_HOME
exec "\$BOXLANG" --bx-config "\$NANOBOX_HOME/boxlang.json" "\$NANOBOX_HOME/current/cli/nanobox.bx" "\$@"
EOF
	chmod 755 "$INSTALL_BIN/nanobox"
	print_step_done
	printf '\n'
fi

###########################################################################
# Done
###########################################################################
printf '\n'
print_header "NanoBox v$VERSION installed successfully!"
printf '\n'
printf 'Data:   %s\n' "$NANOBOX_HOME"
printf 'Config: %s\n' "$BX_CONFIG"
if $LOCAL_MODE; then
	printf 'Run:    %s/nanobox\n' "$SCRIPT_DIR"
else
	printf 'Binary: %s/nanobox\n' "$INSTALL_BIN"
fi

printf '\n'
print_header "Next steps:"
printf '\n'

if $LOCAL_MODE; then
	cat <<EOF
  1. Verify the installation:
       ./nanobox doctor

  2. Configure your AI provider and model:
       ./nanobox model setup

     Or set values directly:
       ./nanobox config set bx-ai.defaultProvider anthropic
       ./nanobox config set bx-ai.defaultModel    claude-sonnet-5

  3. Add your API key to:
       $CONFIG_DIR/.env

  4. Start chatting:
       ./nanobox chat "Hello, NanoBox!"
EOF
else
	# Check if INSTALL_BIN is in PATH
	if [[ ":$PATH:" != *":$INSTALL_BIN:"* ]]; then
		printf '  !! %s is not in your PATH. Add it:\n' "$INSTALL_BIN"
		printf '       export PATH="%s:$PATH"\n' "$INSTALL_BIN"
		printf '     (add to ~/.bashrc or ~/.zshrc to make it permanent)\n\n'
	fi
	cat <<EOF
  1. Verify the installation:
       nanobox doctor

  2. Configure your AI provider and model:
       nanobox model setup

     Or set values directly:
       nanobox config set bx-ai.defaultProvider anthropic
       nanobox config set bx-ai.defaultModel    claude-sonnet-5

  3. Add your API key to:
       $CONFIG_DIR/.env

  4. Start chatting:
       nanobox chat "Hello, NanoBox!"
EOF
fi
printf '\n'
