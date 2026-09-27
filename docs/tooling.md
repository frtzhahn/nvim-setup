# Tooling Matrix: LSP, Formatters, & Debuggers

## 1. Language Server Protocol (LSP) Architecture

The setup utilizes Neovim 0.12's native client interface paired with `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim` for automated binary installation and path management.

### Active Language Servers

| Language | LSP Server Name | Binary / Package | Notes |
| :--- | :--- | :--- | :--- |
| **C / C++** | `clangd` | `clangd` | Comprehensive indexing with compile_commands.json support |
| **C#** | `roslyn` | `Microsoft.CodeAnalysis.LanguageServer` | Managed via `seblyng/roslyn.nvim` using custom Crashdummyy registry |
| **Java** | `jdtls` | `jdtls` | Automated workspace mapping and DAP bundle wiring via `nvim-jdtls` |
| **Lua** | `lua_ls` | `lua-language-server` | Integrates `lazydev.nvim` and `luvit-meta` for Neovim Lua API completions |
| **Python** | `pyright` | `pyright` | Static type checking and symbol indexing |
| **TypeScript / JS** | `ts_ls` | `typescript-language-server` | JavaScript and TypeScript support |
| **HTML / CSS** | `html`, `cssls` | `vscode-langservers-extracted` | Web template and stylesheet parsing |
| **JSON** | `jsonls` | `vscode-langservers-extracted` | Schema verification for config files |
| **TailwindCSS** | `tailwindcss` | `tailwindcss-language-server` | Utility class completions |
| **XML / SVG** | `lemminx` | `lemminx` | XML, XSD, SVG, and FXML language support |
| **Docker** | `dockerls` | `dockerfile-language-server` | Dockerfile linting and validation |
| **Bash / Shell** | `bashls` | `bash-language-server` | Shell script validation |

---

## 2. Code Formatter Matrix (`conform.nvim`)

Formatters are managed in [lua/mocha/plugins/formatting.lua](file:///home/mocha/.config/nvim/lua/mocha/plugins/formatting.lua). Auto-formatting triggers on save (`BufWritePre`) with a 500ms timeout and automatic LSP fallback.

| Language / Filetype | Primary Formatter | Fallback | Command Execution |
| :--- | :--- | :--- | :--- |
| **Lua** | `stylua` | LSP format | Managed via Mason |
| **C# (.NET)** | `csharpier` | LSP format | Resolves `~/.dotnet/tools/dotnet-csharpier` |
| **JavaScript / TS** | `prettierd` | `prettier` | Daemonized formatting for zero latency |
| **JSON / JSONC** | `prettierd` | `prettier` | Standardized formatting |
| **HTML / CSS** | `prettierd` | `prettier` | Web markup formatting |
| **Markdown** | `prettierd` | `prettier` | Formats Markdown tables and lists |
| **C / C++** | *Manual only* | LSP format | Format-on-save is disabled to avoid unconfigured style overwrites |

**Manual Formatting:** Press `<Leader>f` in Normal or Visual mode to format any buffer or range on demand.

---

## 3. Debug Adapter Protocol (DAP)

Debug adapters are orchestrated by `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, and `jay-babu/mason-nvim-dap.nvim`.

| Target Environment | Adapter | Integration File | Launch Options |
| :--- | :--- | :--- | :--- |
| **C / C++** | `codelldb` / `gdb` | `lua/mocha/plugins/dap.lua` | Built-in terminal integration and external terminal popups |
| **C# (.NET Core)** | `netcoredbg` | `lua/mocha/plugins/csharp.lua` | Configured via `nicholasmata/nvim-dap-cs` |
| **Java** | `java-debug-adapter` | `lua/mocha/plugins/jdtls.lua` | Automated bundle injection via `nvim-jdtls.setup_dap()` |
| **Node.js / JS** | `js-debug-adapter` | `lua/mocha/plugins/dap.lua` | Server-mode socket connection on `${port}` (`pwa-node`) |

---

## 4. Diagnostics & Healthcheck Maintenance

To verify external binary readiness and provider status:

```bash
nvim --headless "+checkhealth" "+w! /tmp/nvim_checkhealth.txt" +qa
```
- **Purpose:** Audits LSP registration, Treesitter ABI compilation, and runtime health.
- **Use Case:** Run after updating packages or switching development machines.
- **Distribution Availability:** Built into Neovim core across all Linux distributions.
