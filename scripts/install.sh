#!/usr/bin/env bash
# ==============================================================================
# nvim-setup cross-platform bootstrap script (Hardened Production Grade)
# Targets: Arch/CachyOS, Debian/Ubuntu, Fedora, Android (Termux)
# ==============================================================================

set -eo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

log_info() { echo -e "${BLUE}${BOLD}[INFO]${RESET} $1"; }
log_ok()   { echo -e "${GREEN}${BOLD}[OK]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}${BOLD}[WARN]${RESET} $1"; }
log_err()  { echo -e "${RED}${BOLD}[ERROR]${RESET} $1"; }

REPO_URL="https://github.com/frtzhahn/nvim-setup.git"
TARGET_DIR="${HOME}/.config/nvim"

# Configure privilege escalation helper
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        log_err "'sudo' is not installed and you are not root. Please install sudo or run as root."
        exit 1
    fi
fi

# ------------------------------------------------------------------------------
# 1. Platform Detection
# ------------------------------------------------------------------------------
detect_os() {
    if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
        OS_TYPE="termux"
    elif [ -f "/etc/arch-release" ] || [ -f "/etc/cachyos-release" ] || [ -f "/etc/manjaro-release" ]; then
        OS_TYPE="arch"
    elif [ -f "/etc/debian_version" ]; then
        OS_TYPE="debian"
    elif [ -f "/etc/fedora-release" ]; then
        OS_TYPE="fedora"
    elif [ -f "/etc/os-release" ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID:-}" in
            arch|cachyos|manjaro) OS_TYPE="arch" ;;
            debian|ubuntu|pop|mint) OS_TYPE="debian" ;;
            fedora|rhel|centos|rocky|alma) OS_TYPE="fedora" ;;
            *) OS_TYPE="unknown" ;;
        esac
    else
        OS_TYPE="unknown"
    fi
    log_info "Detected operating system family: ${BOLD}${OS_TYPE}${RESET}"
}

# ------------------------------------------------------------------------------
# 2. Dependency Installation
# ------------------------------------------------------------------------------
install_dependencies() {
    log_info "Installing core build tools, runtimes, and dependencies..."

    case "${OS_TYPE}" in
        arch)
            log_info "Using pacman package manager..."
            ${SUDO} pacman -S --needed --noconfirm \
                neovim git curl wget tar unzip base-devel cmake ripgrep fd \
                xclip wl-clipboard zsh nodejs npm python python-pip python-pynvim \
                jdk-openjdk go lua tree-sitter tree-sitter-cli
            ;;
        debian)
            log_info "Using apt package manager..."
            ${SUDO} apt update -y
            ${SUDO} apt install -y \
                git curl wget tar unzip ca-certificates build-essential cmake ripgrep fd-find \
                xclip wl-clipboard zsh nodejs npm python3 python3-pip python3-venv python3-pynvim \
                openjdk-17-jdk golang-go lua5.4 tree-sitter-cli

            mkdir -p "${HOME}/.local/bin"
            if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
                log_ok "Created symlink for fd in ${HOME}/.local/bin/fd"
            fi
            ;;
        fedora)
            log_info "Using dnf package manager..."
            # NOTE: We intentionally OMIT neovim from dnf to avoid placing an outdated v0.10 in /usr/bin
            ${SUDO} dnf install -y \
                git curl wget tar unzip make gcc gcc-c++ cmake ripgrep fd-find \
                xclip wl-clipboard zsh nodejs npm python3 python3-pip python3-pynvim \
                java-17-openjdk-devel golang lua tree-sitter-cli

            mkdir -p "${HOME}/.local/bin"
            if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
                log_ok "Created symlink for fd in ${HOME}/.local/bin/fd"
            fi
            ;;
        termux)
            log_info "Using termux pkg package manager..."
            pkg update -y
            pkg install -y \
                neovim git curl wget tar unzip make clang cmake ripgrep fd \
                nodejs python golang lua54 tree-sitter openjdk-17

            # Ensure gcc and g++ aliases exist for clang
            if ! command -v gcc >/dev/null 2>&1 && command -v clang >/dev/null 2>&1; then
                ln -sf "$(command -v clang)" "${PREFIX}/bin/gcc"
                ln -sf "$(command -v clang++)" "${PREFIX}/bin/g++"
                log_ok "Symlinked clang to gcc/g++ in Termux."
            fi
            ;;
        *)
            log_warn "Unknown distribution. Ensure Neovim (>=0.12), git, compilers, and ripgrep are installed."
            ;;
    esac
}

# ------------------------------------------------------------------------------
# 3. Neovim Version Verification & Standalone Fallback
# ------------------------------------------------------------------------------
ensure_neovim_version() {
    local nvim_bin
    nvim_bin="$(command -v nvim || true)"
    local install_standalone=false

    if [ -z "${nvim_bin}" ]; then
        log_warn "Neovim binary not found in PATH."
        install_standalone=true
    else
        # Feature test: Neovim >= 0.12 natively evaluates has('nvim-0.12') == 1
        if "${nvim_bin}" --clean --headless -u NONE -c "lua vim.cmd(vim.fn.has('nvim-0.12') == 1 and 'q 0' or 'cq 1')" >/dev/null 2>&1; then
            log_ok "Neovim version satisfies requirement (>= 0.12.0): $("${nvim_bin}" --version | head -n 1)"
        else
            log_warn "Neovim version is below required 0.12.0: $("${nvim_bin}" --version | head -n 1)"
            install_standalone=true
        fi
    fi

    if [ "${install_standalone}" = true ]; then
        if [ "${OS_TYPE}" = "termux" ]; then
            log_err "Termux cannot run glibc standalone binaries. Please update Termux packages: pkg upgrade neovim"
            exit 1
        fi

        log_info "Installing official Neovim standalone release into /usr/local or ~/.local..."
        local arch_raw
        arch_raw="$(uname -m)"
        local download_url=""

        if [ "${arch_raw}" = "x86_64" ]; then
            download_url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
        elif [ "${arch_raw}" = "aarch64" ]; then
            download_url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-arm64.tar.gz"
        fi

        if [ -n "${download_url}" ]; then
            local tmp_tar
            tmp_tar="$(mktemp /tmp/nvim-standalone.XXXXXX.tar.gz)"
            log_info "Downloading standalone Neovim from ${download_url}..."
            curl -fsSL "${download_url}" -o "${tmp_tar}"

            # Install to /usr/local if sudo available, guaranteeing PATH priority over /usr/bin
            if [ -n "${SUDO}" ] || [ "$(id -u)" -eq 0 ]; then
                log_info "Extracting to /usr/local..."
                ${SUDO} tar -xzf "${tmp_tar}" -C /usr/local --strip-components=1
                log_ok "Neovim installed to /usr/local/bin/nvim"
            else
                log_info "Extracting to ${HOME}/.local..."
                mkdir -p "${HOME}/.local"
                tar -xzf "${tmp_tar}" -C "${HOME}/.local" --strip-components=1
                log_ok "Neovim installed to ${HOME}/.local/bin/nvim"
            fi
            rm -f "${tmp_tar}"
        else
            log_warn "Unsupported architecture ${arch_raw}. Proceeding with existing system binary."
        fi
    fi

    # Guarantee ~/.local/bin is in PATH for current script and persistent shells
    mkdir -p "${HOME}/.local/bin"
    export PATH="/usr/local/bin:${HOME}/.local/bin:${PATH}"

    for rc_file in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
        if [ -f "${rc_file}" ]; then
            if ! grep -q 'export PATH=.*\.local/bin' "${rc_file}"; then
                echo -e '\n# nvim-setup path configuration\nexport PATH="$HOME/.local/bin:$PATH"' >> "${rc_file}"
                log_ok "Persisted ~/.local/bin to ${rc_file}"
            fi
        fi
    done
}

# ------------------------------------------------------------------------------
# 4. Clone / Deploy Configuration
# ------------------------------------------------------------------------------
deploy_config() {
    mkdir -p "${HOME}/.config"

    if [ -d "${TARGET_DIR}/.git" ]; then
        log_info "Existing git repository found at ${TARGET_DIR}. Updating..."
        git -C "${TARGET_DIR}" pull --ff-only || {
            log_warn "git pull failed; preserving current working state."
        }
    elif [ -d "${TARGET_DIR}" ]; then
        local backup_path="${TARGET_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        log_warn "Existing non-git directory found at ${TARGET_DIR}."
        log_info "Creating non-destructive backup at ${backup_path}..."
        mv "${TARGET_DIR}" "${backup_path}"
        log_info "Cloning nvim-setup into ${TARGET_DIR}..."
        git clone "${REPO_URL}" "${TARGET_DIR}"
    else
        log_info "Cloning nvim-setup into ${TARGET_DIR}..."
        git clone "${REPO_URL}" "${TARGET_DIR}"
    fi
    log_ok "Configuration deployed at ${TARGET_DIR}"
}

# ------------------------------------------------------------------------------
# 5. Headless Lazy.nvim Bootstrap
# ------------------------------------------------------------------------------
sync_plugins() {
    log_info "Bootstrapping lazy.nvim plugins in headless mode (this may take 1-2 minutes)..."
    if command -v nvim >/dev/null 2>&1; then
        nvim --headless "+Lazy! sync" +qa || {
            log_warn "Headless sync exited with warnings; continuing..."
        }
        log_ok "Lazy.nvim plugin sync complete. External tools (Mason/Treesitter) will finish upon first launch."
    else
        log_err "Neovim executable could not be resolved in PATH."
        exit 1
    fi
}

main() {
    echo -e "${BOLD}${BLUE}=== nvim-setup Automated Bootstrap ===${RESET}\n"
    detect_os
    install_dependencies
    ensure_neovim_version
    deploy_config
    sync_plugins
    echo -e "\n${BOLD}${GREEN}=== Setup Complete! Launch with 'nvim' ===${RESET}"
}

main "$@"
