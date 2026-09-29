# Keymap Reference Manual

Leader Key: `<Space>`  
Local Leader Key: `<Space>`

---

## 1. Multiplexer & Split Navigation

Navigation is unified across Neovim splits and tmux panes via `christoomey/vim-tmux-navigator`.

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-h>` | Normal | `TmuxNavigateLeft` | Focus left window / tmux pane |
| `<C-j>` | Normal | `TmuxNavigateDown` | Focus lower window / tmux pane |
| `<C-k>` | Normal | `TmuxNavigateUp` | Focus upper window / tmux pane |
| `<C-l>` | Normal | `TmuxNavigateRight` | Focus right window / tmux pane |
| `<C-\>` | Normal | `TmuxNavigatePrevious` | Focus previous window / tmux pane |
| `<Leader>q` | Normal | `:close<CR>` | Close current split |
| `<Leader>hs` | Normal | `:new<CR>` | Open empty horizontal split |
| `<Leader>vs` | Normal | `:vnew<CR>` | Open empty vertical split |
| `<Leader>ht` | Normal | `:split \| terminal<CR>` | Open horizontal terminal split |
| `<Leader>tv` | Normal | `:vsplit \| terminal<CR>` | Open vertical terminal split |

---

## 2. Window Resizing

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `=` | Normal | `:vertical resize +5<CR>` | Increase window width |
| `-` | Normal | `:vertical resize -5<CR>` | Decrease window width |
| `<A-=>` | Normal | `:horizontal resize +2<CR>` | Increase window height |
| `<M-->` | Normal | `:horizontal resize -2<CR>` | Decrease window height |

---

## 3. File Explorers & Buffers

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>pt` | Normal | `:Neotree left<CR>` | Open Neo-tree sidebar explorer |
| `<Leader>pf` | Normal | `:Neotree float<CR>` | Open Neo-tree floating explorer |
| `<Leader>pc` | Normal | `:Neotree toggle<CR>` | Toggle Neo-tree explorer |
| `<Leader>pv` | Normal | `:Oil<CR>` | Open Oil directory editor |
| `<Leader>pe` | Normal | `:Oil --float<CR>` | Open Oil floating directory editor |
| `<Leader>cs` | Normal | `:CSharpExplorerToggle<CR>` | Toggle C# Solution Explorer drawer |
| `<S-h>` | Normal | `:BufferLineCyclePrev<CR>` | Cycle to previous buffer tab |
| `<S-l>` | Normal | `:BufferLineCycleNext<CR>` | Cycle to next buffer tab |
| `<Leader>dp` | Normal | `:BufferLineTogglePin<CR>` | Pin/unpin current buffer tab |
| `<Leader>do` | Normal | `:BufferLineCloseOthers<CR>` | Close all buffer tabs except active |
| `<Leader>dl` | Normal | `:BufferLineCloseLeft<CR>` | Close all buffer tabs to the left |
| `<Leader>dr` | Normal | `:BufferLineCloseRight<CR>` | Close all buffer tabs to the right |
| `<Leader>dP` | Normal | `:BufferLineGroupClose ungrouped<CR>` | Close non-pinned buffer tabs |

---

## 4. Code Execution & Build

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<F6>` | Normal | Native Split Runner | Save, compile, and execute current file in bottom split terminal |
| `<Leader>mb` | Normal | `compiler dotnet \| make build` | Build current C# .NET solution |
| `<Leader>mr` | Normal | `dotnet run` | Run C# .NET solution in terminal |
| `<Leader>mt` | Normal | `dotnet test` | Run C# .NET solution tests in terminal |
| `<Leader>cf` | Normal | `Cake.open({ mode = 'float' })` | Open Cake floating task runner |
| `<Leader>ct` | Normal | `Cake.toggle()` | Toggle Cake task runner window |
| `<Leader>cv` | Normal | `Cake.open({ mode = 'splitv' })` | Open Cake vertical split runner |
| `<Leader>ch` | Normal | `Cake.open({ mode = 'splith' })` | Open Cake horizontal split runner |
| `<Leader>cr` | Normal | `Cake.run()` | Execute selected Cake command |

---

## 5. Fuzzy Finding & Telemetry (Snacks.picker)

Telescope has been replaced by `folke/snacks.nvim` (`snacks.picker`), providing zero C compilation overhead and native asynchronous stream rendering while preserving identical keymap muscle memory.

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>sf` | Normal | `Snacks.picker.files` | Search files by name in current working directory |
| `<Leader>sg` | Normal | `Snacks.picker.grep` | Search text across project via ripgrep |
| `<Leader>sw` | Normal | `Snacks.picker.grep_word` | Search current word under cursor |
| `<Leader><Space>` | Normal | `Snacks.picker.buffers` | Search and switch between open buffer tabs |
| `<Leader>s.` | Normal | `Snacks.picker.recent` | Search recently opened files |
| `<Leader>sh` | Normal | `Snacks.picker.help` | Search Neovim documentation help tags |
| `<Leader>sk` | Normal | `Snacks.picker.keymaps` | Search registered keymaps and commands |
| `<Leader>sm` | Normal | `Snacks.picker.marks` | Search jump marks |
| `<Leader>sd` | Normal | `Snacks.picker.diagnostics` | Search workspace compiler warnings and LSP diagnostics |
| `<Leader>sr` | Normal | `Snacks.picker.resume` | Resume previous picker state |
| `<Leader>/` | Normal | `Snacks.picker.lines` | Fuzzy search lines in current buffer (async stream) |
| `<Leader>s/` | Normal | `Snacks.picker.grep_buffers` | Live grep text only across currently open buffers |
| `<Leader>sn` | Normal | `Snacks.picker.files({ cwd = config })` | Search Neovim configuration files |
| `<Leader>gl` | Normal | `Snacks.picker.git_log` | Search Git commit log |
| `<Leader>gs` | Normal | `Snacks.picker.git_status` | Search modified Git status files |
| `<Leader>lg` | Normal | `Snacks.lazygit` | Toggle Lazygit floating terminal |
| `<Leader>un` | Normal | `Snacks.notifier.hide` | Dismiss all active notification toasts |
| `<Leader>nh` | Normal | `Snacks.notifier.show_history` | Display notification history log |

---

## 6. Language Server Protocol (LSP) & Formatting

These mappings activate automatically when an LSP attaches to a buffer:

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `gd` | Normal | `vim.lsp.buf.definition` | Jump to symbol definition |
| `gD` | Normal | `vim.lsp.buf.declaration` | Jump to symbol declaration (headers in C) |
| `gr` | Normal | `vim.lsp.buf.references` | List symbol references across workspace |
| `gI` | Normal | `vim.lsp.buf.implementation` | Jump to interface implementation |
| `<Leader>D` | Normal | `vim.lsp.buf.type_definition` | Jump to type definition |
| `<Leader>rn` | Normal | `vim.lsp.buf.rename` | Rename symbol across project |
| `<Leader>ca` | Normal/Visual | `vim.lsp.buf.code_action` | Trigger code actions at cursor |
| `<Leader>ds` | Normal | `vim.lsp.buf.document_symbol` | Outline document symbols |
| `<Leader>ws` | Normal | `vim.lsp.buf.workspace_symbol` | Search workspace symbols |
| `<Leader>th` | Normal | `vim.lsp.inlay_hint` toggle | Toggle parameter/type inlay hints |
| `[d` | Normal | `vim.diagnostic.goto_prev` | Jump to previous diagnostic error/warning |
| `]d` | Normal | `vim.diagnostic.goto_next` | Jump to next diagnostic error/warning |
| `<Leader>f` | Normal/Visual | `conform.format()` | Format buffer with active formatter |

---

## 7. Diagnostics Drawer (Trouble) & QuickFix

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>xx` | Normal | `:Trouble diagnostics toggle<CR>` | Toggle workspace diagnostics panel |
| `<Leader>xX` | Normal | `:Trouble diagnostics toggle filter.buf=0<CR>` | Toggle active buffer diagnostics panel |
| `:copen` | Command | Open QuickFix list | Opens quickfix list with `nvim-bqf` preview |
| `zf` | QuickFix | Filter quickfix with fzf | Pipe quickfix items into fzf inside bqf |

---

## 8. Git Operations & Gutter Telemetry (Gitsigns & Diffview)

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `]c` | Normal | `gitsigns.nav_hunk('next')` | Jump cursor to next modified git hunk |
| `[c` | Normal | `gitsigns.nav_hunk('prev')` | Jump cursor to previous modified git hunk |
| `<Leader>hs` | Normal/Visual | `gitsigns.stage_hunk` | Stage active hunk or visual selection |
| `<Leader>hr` | Normal/Visual | `gitsigns.reset_hunk` | Revert active hunk or visual selection |
| `<Leader>hS` | Normal | `gitsigns.stage_buffer` | Stage entire current buffer |
| `<Leader>hu` | Normal | `gitsigns.undo_stage_hunk` | Undo last staged hunk |
| `<Leader>hR` | Normal | `gitsigns.reset_buffer` | Reset all modifications in current buffer |
| `<Leader>hp` | Normal | `gitsigns.preview_hunk` | Preview diff of current hunk inline |
| `<Leader>tb` | Normal | `gitsigns.toggle_current_line_blame` | Toggle inline commit author & date blame |
| `<Leader>td` | Normal | `gitsigns.toggle_deleted` | Toggle display of deleted lines in buffer |
| `<Leader>gd` | Normal | `:DiffviewOpen<CR>` | Open side-by-side Git diffview |
| `<Leader>gD` | Normal | `:DiffviewClose<CR>` | Close Git diffview |
| `<Leader>gh` | Normal | `:DiffviewFileHistory %<CR>` | View revision history for current file |

---

## 9. Semantic Treesitter Text Objects

Manipulate code grammatically based on Abstract Syntax Tree (AST) node boundaries:

| Keybinding | Mode | Target Node | Description |
| :--- | :--- | :--- | :--- |
| `vaf` / `dif` / `cif` | Operator-Pending / Visual | `@function.outer` | Around function (includes signature and body) |
| `vif` / `dif` / `cif` | Operator-Pending / Visual | `@function.inner` | Inside function body |
| `vac` / `dic` / `cic` | Operator-Pending / Visual | `@class.outer` | Around class or struct declaration |
| `vic` / `dic` / `cic` | Operator-Pending / Visual | `@class.inner` | Inside class or struct body |
| `vaa` / `dia` / `cia` | Operator-Pending / Visual | `@parameter.outer` | Around function argument or parameter |
| `via` / `dia` / `cia` | Operator-Pending / Visual | `@parameter.inner` | Inside function argument or parameter |
| `vai` / `dii` / `cii` | Operator-Pending / Visual | `@conditional.outer` | Around if/else conditional block |
| `val` / `dil` / `cil` | Operator-Pending / Visual | `@loop.outer` | Around while/for loop block |
| `]m` / `[m` | Normal | Function Start | Jump to next / previous function header |
| `]M` / `[M` | Normal | Function End | Jump to next / previous function closing delimiter |
| `]]` / `[[` | Normal | Class Start | Jump to next / previous class header |
| `][` / `[]` | Normal | Class End | Jump to next / previous class closing delimiter |

---

## 10. Task Management & Code Annotations

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>td` | Normal | `:Dooing<CR>` | Toggle floating task and checklist manager |
| `]t` | Normal | `todo_comments.jump_next` | Jump to next `TODO` or `FIXME` tag |
| `[t` | Normal | `todo_comments.jump_prev` | Jump to previous `TODO` or `FIXME` tag |
| `<Leader>st` | Normal | `:TodoTelescope<CR>` | Search all project todos in picker |
| `<Leader>xt` | Normal | `:TodoTrouble<CR>` | List all project todos in Trouble drawer |

---

## 11. Debugging (DAP)

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<F5>` | Normal | `dap.continue` | Start or continue debug session |
| `<F1>` | Normal | `dap.step_into` | Step into function |
| `<F2>` | Normal | `dap.step_over` | Step over line |
| `<F3>` | Normal | `dap.step_out` | Step out of function |
| `<F4>` | Normal | `dap.terminate` | Terminate debug session |
| `<Leader>b` | Normal | `dap.toggle_breakpoint` | Toggle breakpoint on current line |
| `<Leader>B` | Normal | `dap.set_breakpoint(cond)` | Set conditional breakpoint |
| `<Leader>du` | Normal | `dapui.toggle` | Toggle DAP UI layout |
| `<Leader>ku` | Normal | `dap.up` | Move up stack frame |
| `<Leader>kd` | Normal | `dap.down` | Move down stack frame |

---

## 12. Terminal Modal Lifecycle & Mouse-Free Controls

Embedded terminal buffers (spawned via `<F6>`, `:terminal`, `<leader>ht`, `<leader>tv`) operate under a dedicated modal state machine:

| Keybinding | Mode | Target Buffer | Description |
| :--- | :--- | :--- | :--- |
| `<Esc><Esc>` | Terminal (`t`) | Active Terminal | Exit Terminal mode to Normal mode (conflict-free escape) |
| `<Esc>` or `q` | Normal (`n`) | Terminal Buffer | Close the terminal split window (the "3rd Escape") |
| `i` or `a` | Normal (`n`) | Terminal Buffer | Re-enter Terminal mode at interactive shell prompt |
| `V` / `v` / `<C-v>` | Normal (`n`) | Terminal Buffer | Enter Visual Line, Visual, or Block mode to highlight logs |
| `y` | Visual (`v`/`V`) | Terminal Buffer | Yank selected terminal logs directly to system clipboard |
| `k` / `j` | Normal (`n`) | Terminal Buffer | Line-by-line mouse-free log navigation |
| `<C-u>` / `<C-d>` | Normal (`n`) | Terminal Buffer | Half-page scrolling through compiler output |
| `gg` / `G` | Normal (`n`) | Terminal Buffer | Jump to top or bottom of terminal log stream |
| `/pattern` | Normal (`n`) | Terminal Buffer | Search backward/forward through output (e.g. `/error`) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Terminal (`t`) | Active Terminal | Seamlessly jump focus out of terminal to adjacent windows |

---

## 13. UNIX & Readline Insert-Mode Shortcuts

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-w>` | Insert / Command | `werase` | Delete word backward |
| `<C-u>` | Insert / Command | `kill` | Delete from cursor to line start |
| `<C-h>` | Insert | Backspace | Delete character backward |
| `<C-t>` | Insert | Indent | Shift current line right |
| `<C-d>` | Insert | Dedent | Shift current line left |
| `<C-o>` | Insert | Insert-Normal | Execute one Normal command, then return to Insert |
| `<C-r><reg>` | Insert / Command | Paste register | Paste register contents inline without leaving mode |
| `<C-r>=` | Insert / Command | Expression | Evaluate math expression inline (e.g. `24*60`) |

