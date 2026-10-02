# Daily Engineering Workflows

## 1. Fast Single-File Execution (`<F6>`)

The `<F6>` runner provides rapid compile-and-run capabilities for competitive programming (LeetCode, Advent of Code), algorithmic testing, and scratch scripts.

### How It Operates

1. Pressing `<F6>` automatically executes `:silent write` to save any unsaved buffer changes.
2. It detects the buffer filetype, extracts directory and base filenames, and applies shell escaping via `vim.fn.shellescape`.
3. It spawns a bottom terminal split (`:botright 12split | terminal <cmd>`) and automatically enters Insert mode (`startinsert`).
4. You can provide interactive input to `stdin` immediately.
5. When execution concludes, the terminal window remains open so you can inspect stdout, stderr, and exit codes. Press `<C-\><C-N>:q<CR>` to close.

### Language Compile Matrix

- **C:** `gcc -Wall -Wextra -Werror -std=c11 -g sample.c -o <base> && ./<base>`
- **C++:** `g++ <file> -o <base> && ./<base>`
- **Java:** `javac <filename> && java <base>`
- **Python:** `python3 <file>` (or `python <file>` on Windows)
- **Rust:** `rustc <file> -o <base> && ./<base>`
- **Go:** `go run <file>`
- **Lua:** `nvim -l <file>` (uses Neovim's embedded LuaJIT runtime with all APIs)
- **TypeScript:** `ts-node <file>`
- **JavaScript:** `node <file>`
- **Shell:** `bash <file>`

---

## 2. Multiplexer Integration (tmux + Neovim)

Navigation boundaries between Neovim splits and tmux panes are unified.

### Pane Movement

- Press `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` in normal mode to move left, down, up, or right.
- When your cursor reaches the edge of a Neovim split window, pressing the direction key crosses the boundary directly into the adjacent tmux pane without requiring the tmux prefix key (`Ctrl+Space`).
- From a tmux pane, pressing the direction key moves straight back into Neovim splits.

---

## 3. QuickFix & Compilation Error Triage (`nvim-bqf`)

Whenever compilation errors occur (via `:make`, `<Leader>mb`, or quickfix export), open the quickfix window:

```vim
:copen
```

### Enhanced Features

- **Floating Code Preview:** Hovering over any error in the quickfix list displays a floating window with the source code and Treesitter syntax highlighting.
- **FZF Filtering:** Press `zf` inside the quickfix list to filter hundreds of compiler warnings using fuzzy search.
- **Split Opening:** Press `Ctrl-v` to open an error entry in a vertical split or `Ctrl-x` for horizontal split.

---

## 4. Git Review & Diffing (`diffview.nvim`)

Replace command-line git diffs with visual side-by-side comparison panels:

- **Compare Working Tree:** Press `<Leader>gd` to open a two-way horizontal diff view comparing your uncommitted edits against `HEAD`. Press `<Leader>gD` to exit.
- **Inspect File History:** Press `<Leader>gh` while viewing any file to open its full commit history drawer and step through historical diffs commit by commit.

---

## 5. Task & Debt Management

### Code Annotations (`todo-comments.nvim`)

- Place tags inside code comments:
  ```lua
  -- TODO: implement persistent caching here
  -- FIXME: edge case with empty buffer
  -- NOTE: required for Neovim 0.12 ABI compatibility
  ```
- **Cycle through tags:** Press `]t` for next todo or `[t` for previous todo.
- **Workspace Search:** Press `<Leader>st` to search all project todos via Telescope, or `<Leader>xt` to open the full list inside the Trouble drawer.

### Personal Floating Checklist (`dooing`)

- Press `<Leader>td` from any buffer to open your personal task list.
- Tasks are stored globally in `~/.local/share/nvim/dooing_todos.json` and persist across projects.
- Controls:
  - `a`: Add a new task.
  - `x`: Toggle completion checkmark.
  - `d`: Delete task.
  - `q` / `<Esc>`: Close checklist.

---

## 6. C# & .NET Development

### Solution & Project Management (`easy-dotnet.nvim`)

- `<Leader>dr`: Run .NET project.
- `<Leader>db`: Build solution or project.
- `<Leader>dt`: Open floating test runner UI (`viewmode = "float"` with buffer-aware test execution).
- `<Leader>ds`: Manage .NET User Secrets without leaving Neovim.
- `<Leader>do`: Audit outdated NuGet packages across dependencies.
- `<Leader>dn`: Scaffold new .NET projects, solutions, or items from installed templates.

### Compilation Runner & Debugging

- `<F6>`: Root-aware compilation runner. Automatically scans upward from active buffer for `.csproj` or `.sln`, changes to the project root directory, and executes `dotnet run` in an isolated bottom terminal split.
- `<F5>`: Launch active C# project with buffer-aware DLL auto-detection (scans `<projectRoot>/bin/Debug/`, excluding `.deps.` and `.test.` files).
- `<Leader>du`: Toggle DAP UI.
- Inline variable states and stepping stop reasons are rendered directly via `nvim-dap-virtual-text`.

---

## 7. Performance & Resource Conservation

### Cold Startup Telemetry

Cold start time is continuously benchmarked to ensure it remains below 225ms:

```bash
nvim --startuptime /tmp/nvim_startuptime.txt --headless +qa && sort -k2 -n -r /tmp/nvim_startuptime.txt | head -n 25
```

- **Purpose:** Logs detailed millisecond timestamps for every script and Lua module sourced during initialization.
- **Use Case:** Detects new plugins or configurations causing startup regression.
- **Distribution Availability:** Standard CLI option built into Neovim core.
