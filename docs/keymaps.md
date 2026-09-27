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

## 5. Fuzzy Finding (Telescope)

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>sf` | Normal | `builtin.find_files` | Search files by name |
| `<Leader>sg` | Normal | `builtin.live_grep` | Search text across project via ripgrep |
| `<Leader>sw` | Normal | `builtin.grep_string` | Search current word under cursor |
| `<Leader><Space>` | Normal | `builtin.buffers` | Search open buffer list |
| `<Leader>s.` | Normal | `builtin.oldfiles` | Search recent files |
| `<Leader>sh` | Normal | `builtin.help_tags` | Search Neovim documentation tags |
| `<Leader>sk` | Normal | `builtin.keymaps` | Search registered keymaps |
| `<Leader>sm` | Normal | `builtin.marks` | Search marks |
| `<Leader>sd` | Normal | `builtin.diagnostics` | Search workspace diagnostics |
| `<Leader>sr` | Normal | `builtin.resume` | Resume previous Telescope picker |
| `<Leader>/` | Normal | `builtin.current_buffer_fuzzy_find` | Search text in active buffer |
| `<Leader>sn` | Normal | `builtin.find_files({ cwd = config })` | Search Neovim configuration files |

---

## 6. Language Server Protocol (LSP) & Formatting

These mappings activate automatically when an LSP attaches to a buffer:

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `gd` | Normal | `telescope.lsp_definitions` | Jump to symbol definition |
| `gD` | Normal | `vim.lsp.buf.declaration` | Jump to symbol declaration (headers in C) |
| `gr` | Normal | `telescope.lsp_references` | List symbol references across workspace |
| `gI` | Normal | `telescope.lsp_implementations` | Jump to interface implementation |
| `<Leader>D` | Normal | `telescope.lsp_type_definitions` | Jump to type definition |
| `<Leader>rn` | Normal | `vim.lsp.buf.rename` | Rename symbol across project |
| `<Leader>ca` | Normal/Visual | `vim.lsp.buf.code_action` | Trigger code actions at cursor |
| `<Leader>ds` | Normal | `telescope.lsp_document_symbols` | Outline document symbols |
| `<Leader>ws` | Normal | `telescope.lsp_dynamic_workspace_symbols` | Search workspace symbols |
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

## 8. Git Operations & Review

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>gd` | Normal | `:DiffviewOpen<CR>` | Open side-by-side Git diffview |
| `<Leader>gD` | Normal | `:DiffviewClose<CR>` | Close Git diffview |
| `<Leader>gh` | Normal | `:DiffviewFileHistory %<CR>` | View revision history for current file |

---

## 9. Task Management & Code Annotations

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>td` | Normal | `:Dooing<CR>` | Toggle floating task and checklist manager |
| `]t` | Normal | `todo_comments.jump_next` | Jump to next `TODO` or `FIXME` tag |
| `[t` | Normal | `todo_comments.jump_prev` | Jump to previous `TODO` or `FIXME` tag |
| `<Leader>st` | Normal | `:TodoTelescope<CR>` | Search all project todos in Telescope |
| `<Leader>xt` | Normal | `:TodoTrouble<CR>` | List all project todos in Trouble drawer |

---

## 10. Debugging (DAP)

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

## 11. UNIX & Readline Insert-Mode Shortcuts

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
