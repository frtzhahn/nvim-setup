# Tooling Matrix: LSP, Formatters, & Debuggers

## 1. Language Server Protocol (LSP) Architecture

The setup utilizes Neovim 0.12's native client interface (`vim.lsp.config` and `vim.lsp.enable`) with wildcard capability broadcasting (`vim.lsp.config('*', { capabilities = capabilities })`), paired with `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim` for automated binary installation and path management. `nvim-lspconfig` is lazy-loaded on `BufReadPre` and `BufNewFile` (with `mason-tool-installer` set to `run_on_start = false` and `fidget.nvim` deferred to `LspAttach`).

### Active Language Servers

| Language | LSP Server Name | Binary / Package | Notes |
| :--- | :--- | :--- | :--- |
| **C / C++** | `clangd` | `clangd` | Comprehensive indexing with `compile_commands.json` support |
| **C#** | `roslyn` | `Microsoft.CodeAnalysis.LanguageServer` | Lazy-loaded on `ft = "cs"` via `seblyng/roslyn.nvim` using custom Crashdummyy registry |
| **Java** | `jdtls` | `jdtls` | Automated workspace mapping and multi-JAR DAP/test bundle wiring via list-mode `vim.fn.glob` in `nvim-jdtls` |
| **Lua** | `lua_ls` | `lua-language-server` | Integrates `lazydev.nvim` (with native Neovim 0.12 `vim.uv` types) and asynchronous `root_dir` resolution with standalone script fallback |
| **Python** | `pyright` | `pyright` | Static type checking and symbol indexing |
| **TypeScript / JS / Vue** | `ts_ls`, `vue_ls`, `eslint` | `typescript-language-server`, `vue-language-server`, `eslint-lsp` | Dynamic Mason path resolution for `@vue/language-server` Hybrid Mode |
| **HTML / CSS** | `html`, `cssls`, `stylelint_lsp` | `vscode-langservers-extracted`, `stylelint-lsp` | Web template, stylesheet parsing, and CSS linting |
| **JSON** | `jsonls` | `vscode-langservers-extracted` | Schema verification for config files |
| **TailwindCSS** | `tailwindcss` | `tailwindcss-language-server` | Utility class completions |
| **XML / SVG** | `lemminx` | `lemminx` | XML, XSD, SVG, and FXML language support |
| **Docker** | `dockerls` | `dockerfile-language-server` | Dockerfile linting and validation |

---

## 2. Code Formatter Matrix (`conform.nvim`)

Formatters are managed in [lua/mocha/plugins/formatting.lua](file:///home/mocha/.config/nvim/lua/mocha/plugins/formatting.lua). Auto-formatting triggers on save (`BufWritePre`) with a 500ms default timeout (2500ms for C# `csharpier` to accommodate CoreCLR cold starts) and automatic LSP fallback.

| Language / Filetype | Primary Formatter | Fallback | Command Execution |
| :--- | :--- | :--- | :--- |
| **Lua** | `stylua` | LSP format | Managed via Mason |
| **C# (.NET)** | `csharpier` | LSP format | Resolves Mason bin, `~/.dotnet/tools`, or system `$PATH` |
| **JavaScript / TS** | `prettierd` | `prettier` | Daemonized formatting for zero latency |
| **JSON / JSONC** | `prettierd` | `prettier` | Standardized formatting |
| **HTML / CSS** | `prettierd` | `prettier` | Web markup formatting |
| **Markdown** | `prettierd` | `prettier` | Formats Markdown tables and lists |
| **C / C++** | *Manual only* | LSP format | Format-on-save is disabled to avoid unconfigured style overwrites |

**Manual Formatting:** Press `<Leader>f` in Normal or Visual mode to format any buffer or range on demand.

---

## 3. Debug Adapter Protocol (DAP)

Debug adapters are orchestrated by `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, and `jay-babu/mason-nvim-dap.nvim`. `nvim-dap` is lazy-loaded on its debugging `keys` (`<F1>`–`<F5>`, `<Leader>b`, `<Leader>B`, `<Leader>du`, `<Leader>ku`, `<Leader>kd`).

| Target Environment | Adapter | Integration File | Launch Options |
| :--- | :--- | :--- | :--- |
| **C / C++** | `codelldb` / `gdb` | `lua/mocha/plugins/dap.lua` | Resolves Mason 2.0 `/mason/bin/codelldb` wrapper; supports integrated and external terminal popups |
| **C# (.NET Core)** | `netcoredbg` | `lua/mocha/plugins/csharp.lua` | Lazy-loaded on `ft = "cs"` via `nicholasmata/nvim-dap-cs` |
| **Java** | `java-debug-adapter` | `lua/mocha/plugins/jdtls.lua` | Automated multi-JAR bundle injection via list-mode `vim.fn.glob` and `nvim-jdtls.setup_dap()` |
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
