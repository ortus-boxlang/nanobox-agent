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

usage() {
	cat <<'EOF'
NanoBox installer

Usage:
  ./install.sh [options]

Options:
  --help       Show this help
  --version    Show the version being installed

Environment:
  NANOBOX_HOME  Installation directory (default: ~/.nanobox)
  NANOBOX_BIN   Wrapper directory (default: ~/.local/bin)
  NANOBOX_VERSION  Version directory name (default: 0.1.0)
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
	usage
	exit 0
fi

if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
	printf 'NanoBox installer v%s\n' "$VERSION"
	exit 0
fi

VERSION_DIR="$NANOBOX_HOME/versions/v$VERSION"
CURRENT_LINK="$NANOBOX_HOME/current"
CONFIG_DIR="$NANOBOX_HOME/config"

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

# Copy the versioned application without copying user state or build artifacts.
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

# Keep a stable current pointer. Reinstalling the same version is idempotent.
ln -sfn "versions/v$VERSION" "$CURRENT_LINK"

# Create user-owned defaults only when they do not already exist.
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


# Install required BoxLang modules into the project-local module directory.
# BoxLang auto-discovers this directory when run from the project root.
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
	printf 'Warning: install-bx-module not found; required local BoxLang modules were not installed.\n' >&2
	printf 'Install BoxLang modules with: install-bx-module bx-ai bx-sqlite --local\n' >&2
fi

# Install a thin wrapper that always resolves the active version.
cat > "$INSTALL_BIN/nanobox" <<EOF
#!/usr/bin/env bash
set -euo pipefail
NANOBOX_HOME="\${NANOBOX_HOME:-$NANOBOX_HOME}"
exec boxlang "\$NANOBOX_HOME/current/nanobox.bx" "\$@"
EOF
chmod 755 "$INSTALL_BIN/nanobox"

printf '\nNanoBox v%s installed successfully.\n' "$VERSION"
printf 'Home:    %s\n' "$NANOBOX_HOME"
printf 'Version: %s\n' "$VERSION_DIR"
printf 'Wrapper: %s/nanobox\n' "$INSTALL_BIN"
printf '\nNext steps:\n'
printf '  export PATH="%s:\$PATH"\n' "$INSTALL_BIN"
printf '  nanobox doctor\n'
printf '  nanobox model\n'
