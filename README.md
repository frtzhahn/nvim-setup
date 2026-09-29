# my nvim config

<div align="center">

![Image](https://github.com/user-attachments/assets/67e45217-ddbb-4733-81c3-eee36a6b726a)

</div>

[aikhe](https://github.com/aikhe) helped me build this setup from scratch so you'd better checkout his own amazing set up as well [here](https://github.com/aikhe/nvim-config)

## features

- **package manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **fuzzy finder & telemetry:** [snacks.nvim](https://github.com/folke/snacks.nvim) (snacks.picker, notifier, bigfile)
- **language servers:** managed by [Mason](https://github.com/williamboman/mason.nvim) and [lspconfig](https://github.com/neovim/nvim-lspconfig)
- **completion:** [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) for real-time command suggestions
- **formatters:** [conform.nvim](https://github.com/stevearc/conform.nvim) (stylua, prettierd, csharpier)
- **file explorer:** [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim), [Oil.nvim](https://github.com/stevearc/oil.nvim), and [csharp-explorer.nvim](https://github.com/dtrh95/csharp-explorer.nvim)
- **statusline:** [Lualine](https://github.com/nvim-lualine/lualine.nvim) with live LSP indicators
- **quickfix enhancement:** [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) for floating Treesitter previews
- **git telemetry & blame:** [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **git diff & history:** [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- **ast text objects:** [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- **task & debt management:** [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) and [dooing](https://github.com/atiladefreitas/dooing)
- **multiplexer navigation:** [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) for seamless split/pane hopping
- **code execution:** native bottom split terminal runner on `<F6>` + [cake terminal](https://github.com/aikhe/cake.nvim)
- **discord rpc:** [Cord.nvim](https://github.com/vyfor/cord.nvim)
- **nvim wrapped:** [wrapped.nvim](https://github.com/aikhe/wrapped.nvim)

---

## set up and installation

### automated installation (recommended)

For a fresh operating system install or automated setup, run the appropriate one-liner:

#### Linux & Android (Termux)

```bash
curl -fsSL https://raw.githubusercontent.com/frtzhahn/nvim-setup/master/scripts/install.sh | bash
```

#### Windows 10 / 11 (PowerShell)

```powershell
irm -useb https://raw.githubusercontent.com/frtzhahn/nvim-setup/master/scripts/install.ps1 | iex
```

> [!TIP]
> The automated scripts detect your OS and package manager (`pacman`, `apt`, `dnf`, `pkg`, or `scoop`), install the required compilers and runtimes, ensure Neovim `>= 0.12.0` (with standalone fallback if distro packages are outdated), non-destructively back up existing configurations, and bootstrap plugins headlessly.

---

### manual installation

If you prefer to install dependencies manually, follow the instructions for your platform below.

### prerequisites

- **neovim (0.12+):** required for modern Treesitter support (`main` branch) and unified `vim.lsp.config`.
- **tree-sitter CLI:** required to compile Treesitter language parsers (`tree-sitter-cli`).
- **nerd font:** for icons (recommendation: [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts)).
- **git & curl:** plugin and tool installation.
- **ripgrep & fd:** high-performance file searching and live grepping.

---

### specific OS installation

#### Linux (Debian / Ubuntu based)

```bash
sudo apt update
sudo apt install -y git curl wget tar unzip ca-certificates build-essential cmake ripgrep fd-find xclip wl-clipboard zsh nodejs npm python3 python3-pip python3-venv python3-pynvim openjdk-17-jdk golang-go lua5.4 tree-sitter-cli

mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd
```

#### Linux (Fedora based)

```bash
sudo dnf install -y git curl wget tar unzip make gcc gcc-c++ cmake ripgrep fd-find xclip wl-clipboard zsh nodejs npm python3 python3-pip python3-pynvim java-17-openjdk-devel golang lua tree-sitter-cli
```

#### Linux (Arch / CachyOS based)

```bash
sudo pacman -S --needed neovim git curl wget tar unzip base-devel cmake ripgrep fd xclip wl-clipboard zsh nodejs npm python python-pip python-pynvim jdk-openjdk go lua tree-sitter tree-sitter-cli
```

#### Windows (10/11)

- **install scoop and required buckets:**
  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
  irm -useb get.scoop.sh | iex
  scoop install git 7zip
  scoop bucket add extras
  scoop bucket add versions
  scoop bucket add java
  ```
- **install core tools:**
  ```powershell
  scoop install neovim-nightly curl wget jq make mingw cmake ripgrep fd win32yank nodejs-lts python openjdk17 go lua tree-sitter
  ```

> [!NOTE]
> - Ensure your Neovim is **v0.12.0 or later** (on Windows via Scoop, install `neovim-nightly` from the `versions` bucket).
> - Treesitter requires a C compiler to compile language parsers. On Windows, `mingw` provides `gcc`, and this configuration automatically sets `CC = "gcc"` if MSVC (`cl.exe`) is absent.

- **font setup:** open your terminal settings and set the font to any **nerd font**.

---

### setting up this config (Linux)

- **clone this repo directly on `.config/nvim` dir**
  ```bash
  git clone https://github.com/frtzhahn/nvim-setup.git ~/.config/nvim
  ```
- **launch nvim on your terminal**
  ```bash
  nvim
  ```
  **Lazy.nvim will automatically start installing plugins once finished run `:Mason` to verify LSPs are installed.**

---

### setting up this config (winslop 10/11)

- create a dir to store the config files and clone the repo inside of it

  ```powershell
  mkdir $env:LOCALAPPDATA\nvim -Force
  git clone https://github.com/frtzhahn/nvim-setup.git $env:LOCALAPPDATA\nvim
  ```

- font setup:
  open windows terminal, go to Settings > Defaults > Appearance, and set the Font face to a Nerd Font (e.g., Cascadia Code NF or JetBrainsMono NF).

- launch & sync:
  type nvim in your terminal - Lazy.nvim will automatically start downloading all plugins - restart nvim - run :Mason inside Neovim to ensure your LSPs (like lua_ls, pyright, etc.) are being installed.

> [!IMPORTANT]
>
> ## documentation & guides
>
> Detailed guides and references are located in the [`docs/`](docs/) directory:
>
> - [Config Architecture & Design Principles](docs/README.md) — Hardware vs software layer breakdown, cold boot telemetry, and system structure.
> - [Keymap Reference Manual](docs/keymaps.md) — Complete catalog of navigation, LSP, Git, and editing keybindings.
> - [Tooling & LSP Matrix](docs/tooling.md) — Language servers, auto-formatting rules, and DAP debugger setups.
> - [My Engineering Workflows](docs/workflows.md) — Practical guides for `<F6>` execution, tmux navigation, quickfix triage, and task tracking.
