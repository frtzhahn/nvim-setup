# my nvim config

[aikhe](https://github.com/aikhe) helped me build this setup from scratch so you'd better checkout his own amazing set up as well https://github.com/aikhe/nvim-config

##  features
- **package manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **fuzzy finder:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- **language servers:** managed by [Mason](https://github.com/williamboman/mason.nvim) and [lspconfig](https://github.com/neovim/nvim-lspconfig)
- **completion:** [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- **file explorer:** [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) and [Oil.nvim](https://github.com/stevearc/oil.nvim)
- **statusline:** [Lualine](https://github.com/nvim-lualine/lualine.nvim)
- **discord rpc:** [Cord.nvim](https://github.com/vyfor/cord.nvim)
- **nvim wrapped (goated plugin made by [aikhe](https://github.com/aikhe)):** [nvim wrapped](https://github.com/aikhe/wrapped.nvim)
- **preferred terminal:** [cake terminal](https://github.com/aikhe/cake.nvim)
- **themes:** multiple options including Material, Catppuccin, read `themes.lua` for more options.

---

## set up and installation

install several core dependencies and runtimes.

### prerequisites
- **neovim (0.10+):** must install for core functionality.
- **nerd font:** for icons (my recommendation: [jetBrainsMono nerd font](https://github.com/ryanoasis/nerd-fonts).
- **git & curl:** plugin and tool installation.
- **ripgrep & FD :** fast searching.

---

### specific OS installation

#### Linux (debian/ubuntu based)
```bash
sudo apt update
sudo apt install -y neovim git curl wget unzip build-essential cmake ripgrep fd-find xclip wl-clipboard zsh konsole nodejs npm python3 python3-pip openjdk-17-jdk golang-go lua5.4

mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
```

####  Linux (fedora based)
```bash
sudo dnf install -y neovim git curl wget unzip make gcc-c++ cmake ripgrep fd-find xclip wl-clipboard zsh konsole nodejs npm python3 python3-pip java-17-openjdk-devel golang lua
```

#### Linux (arch based)
```bash
sudo pacman -S --needed neovim git curl wget unzip base-devel cmake ripgrep fd xclip wl-clipboard zsh konsole nodejs npm python python-pip jdk-openjdk go lua
```

#### winslop (10/11)

- **install scoop (preffered package manager)**
   ```powershell
   Set-ExecutionPolicy RemoteSigned -scope CurrentUser
   iwr -useb get.scoop.sh | iex
   ```
- **core tools**
   ```powershell
   scoop install neovim git curl 7zip jq wget make gcc cmake ripgrep fd win32yank nodejs-lts python openjdk17-lts go lua
   npm install -g ts-node
   ```
- **font setup:** open your terminal settings and set the font to any **nerd font**.

---

### setting up this config (Linux)
- **clone the repo (you can follow this command or just clone the main branch)**
   ```bash
   git clone -b frtzhahn-crine-nvim https://github.com/aikhe/crine-nvim.git ~/.config/nvim
   ```
- **launch nvim**
   ```bash
   nvim
   ```
   **Lazy.nvim will automatically start installing plugins once finished run `:Mason` to verify LSPs are installed.**

---

### setting up this config (winslop 10/11)

- clone the repo (you can follow this command or just clone the main branch)
    ```powershell
    mkdir $env:LOCALAPPDATA\nvim -Force
    git clone -b frtzhahn-crine-nvim https://github.com/aikhe/crine-nvim.git $env:LOCALAPPDATA\nvim
    ```  


- font setup:
    open windows terminal, go to Settings > Defaults > Appearance, and set the Font face to a Nerd Font (e.g., Cascadia Code NF or JetBrainsMono NF).  


- launch & sync:
      type nvim in your terminal
       - Lazy.nvim will automatically start downloading all plugins
       - restart nvim 
       - run :Mason inside Neovim to ensure your LSPs (like lua_ls, pyright, etc.) are being installed.


>[!IMPORTANT]
>review/read the keybinds on this set up for smoother experience

---

# Showcase

![nvim-sample](assets/nvim-sample.webp)

