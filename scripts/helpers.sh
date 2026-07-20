#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# NanoBox — Helper Functions
# Adapted from BoxLang Quick Installer helpers.sh
# ──────────────────────────────────────────────────────────────

###########################################################################
# Setup Colors (NanoBox teal/neon-blue palette)
###########################################################################
setup_colors() {
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        # NanoBox brand colors
        TEAL="$(tput setaf 6)"          # Cyan/teal for primary accents
        NEON_BLUE="$(tput setaf 4)"     # Bright blue for secondary
        DARK_NAVY="$(tput setaf 0)"     # Dark background text
        SUCCESS="$(tput setaf 2)"       # Green for success
        WARNING="$(tput setaf 3)"       # Yellow/amber for warnings
        ERROR="$(tput setaf 1)"         # Red/coral for errors
        BOLD="$(tput bold)"
        NORMAL="$(tput sgr0)"
        UNDERLINE="$(tput smul)"
        DIM="$(tput dim)"
    else
        TEAL=""
        NEON_BLUE=""
        DARK_NAVY=""
        SUCCESS=""
        WARNING=""
        ERROR=""
        BOLD=""
        NORMAL=""
        UNDERLINE=""
        DIM=""
    fi
}

# Initialize colors immediately
setup_colors

###########################################################################
# Printing Functions
###########################################################################
print_info() {
    printf "${NEON_BLUE}ℹ $1${NORMAL}\n"
}

print_success() {
    printf "${SUCCESS}✔︎ $1${NORMAL}\n"
}

print_warning() {
    printf "${WARNING}⚠️  $1${NORMAL}\n"
}

print_error() {
    printf "${ERROR}  $1${NORMAL}\n"
}

print_header() {
    printf "${BOLD}${TEAL}$1${NORMAL}\n"
}

print_step() {
    printf "  ${NEON_BLUE}├─ $1...${NORMAL}"
}

print_step_done() {
    printf "${SUCCESS} ✅\n"
}

###########################################################################
# Check if command exists
###########################################################################
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

###########################################################################
# Extract semantic version from version string
###########################################################################
extract_semantic_version() {
    echo "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1
}

###########################################################################
# Compare two semantic versions
# Returns: 0 = equal, 1 = v1 > v2, 2 = v1 < v2
###########################################################################
compare_versions() {
    local v1="$1"
    local v2="$2"

    if [ "$v1" = "$v2" ]; then
        return 0
    fi

    local v1_major=$(echo "$v1" | cut -d. -f1)
    local v1_minor=$(echo "$v1" | cut -d. -f2)
    local v1_patch=$(echo "$v1" | cut -d. -f3)

    local v2_major=$(echo "$v2" | cut -d. -f1)
    local v2_minor=$(echo "$v2" | cut -d. -f2)
    local v2_patch=$(echo "$v2" | cut -d. -f3)

    if [ "$v1_major" -gt "$v2_major" ]; then return 1; fi
    if [ "$v1_major" -lt "$v2_major" ]; then return 2; fi
    if [ "$v1_minor" -gt "$v2_minor" ]; then return 1; fi
    if [ "$v1_minor" -lt "$v2_minor" ]; then return 2; fi
    if [ "$v1_patch" -gt "$v2_patch" ]; then return 1; fi
    if [ "$v1_patch" -lt "$v2_patch" ]; then return 2; fi

    return 0
}

###########################################################################
# Check if BoxLang is installed (optimized for speed)
###########################################################################
check_boxlang() {
    # Fast path: check if 'boxlang' is in PATH first
    if command_exists "boxlang"; then
        local version_output=$(boxlang --version 2>/dev/null || echo "")
        if [ -n "$version_output" ]; then
            local version=$(extract_semantic_version "$version_output")
            if [ -n "$version" ]; then
                echo "$version"
                return 0
            fi
        fi
    fi

    # Slow path: check specific installation paths
    local boxlang_candidates=(
        "$HOME/.bvm/current/bin/boxlang"
        "$HOME/.boxlang/bin/boxlang"
        "/opt/homebrew/bin/boxlang"
        "/usr/local/bin/boxlang"
    )

    if [ -n "$BOXLANG_INSTALL_HOME" ]; then
        boxlang_candidates+=("$BOXLANG_INSTALL_HOME/bin/boxlang")
    fi

    for candidate in "${boxlang_candidates[@]}"; do
        if [ -x "$candidate" ]; then
            local version_output=$("$candidate" --version 2>/dev/null || echo "")
            if [ -n "$version_output" ]; then
                local version=$(extract_semantic_version "$version_output")
                if [ -n "$version" ]; then
                    echo "$version"
                    return 0
                fi
            fi
        fi
    done

    return 1
}

###########################################################################
# Check Java version (only called if BoxLang is missing)
###########################################################################
check_java_version() {
    if ! command_exists java; then
        return 1
    fi

    local java_version=$(java -version 2>&1 | head -n1 | grep -oE '"[^"]+"' | tr -d '"' | cut -d'.' -f1)
    if [ -z "$java_version" ]; then
        return 1
    fi

    if [ "$java_version" -ge 21 ]; then
        return 0
    fi

    return 1
}

###########################################################################
# Preflight check for system tools
###########################################################################
preflight_check() {
    local auto_install="${1:-false}"
    print_info "Running system requirements checks..."

    local missing_deps=()
    command_exists curl || missing_deps+=("curl")
    command_exists unzip || missing_deps+=("unzip")
    command_exists jq || missing_deps+=("jq")
    command_exists rsync || missing_deps+=("rsync")

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"

        if [ "$(uname)" = "Darwin" ]; then
            if ! command_exists brew; then
                print_error "Homebrew is not installed. Please install Homebrew first."
                print_info "You can install Homebrew with:"
                printf "   /bin/bash -c '\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'\n"
                return 1
            fi

            print_info "Installing missing dependencies using Homebrew..."
            for dep in "${missing_deps[@]}"; do
                print_step "Installing $dep"
                if brew install "$dep" >/dev/null 2>&1; then
                    print_step_done
                else
                    print_error "Failed to install $dep. Please install it manually."
                    return 1
                fi
            done
            print_success "All dependencies installed successfully!"

        elif [ "$(uname)" = "Linux" ]; then
            local use_sudo=""
            if [ "$EUID" -ne 0 ]; then
                use_sudo="sudo"
            fi

            print_info "Installing missing dependencies using system package manager..."

            if command_exists apt-get; then
                $use_sudo apt update >/dev/null 2>&1
                $use_sudo apt install -y ${missing_deps[@]} >/dev/null 2>&1
            elif command_exists apk; then
                $use_sudo apk update >/dev/null 2>&1
                $use_sudo apk add ${missing_deps[@]} >/dev/null 2>&1
            elif command_exists yum; then
                $use_sudo yum install -y ${missing_deps[@]} >/dev/null 2>&1
            elif command_exists dnf; then
                $use_sudo dnf install -y ${missing_deps[@]} >/dev/null 2>&1
            elif command_exists pacman; then
                $use_sudo pacman -S --noconfirm ${missing_deps[@]} >/dev/null 2>&1
            else
                print_error "No supported package manager found. Please install manually: ${missing_deps[*]}"
                return 1
            fi
            print_success "All dependencies installed successfully!"
        fi
    else
        print_success "All system dependencies satisfied"
    fi

    return 0
}
