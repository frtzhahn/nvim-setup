-- =============================
-- My Own Settings
-- =============================

-- Line numbers
vim.opt.number = true
-- vim.opt.relativenumber = true

-- Mouse & Clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Auto indentation & tabs
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Persistent undo & UI stability
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Show status line globally across splits
vim.opt.laststatus = 3

-- Make backspace behave naturally
vim.opt.backspace = { "indent", "eol", "start" }

vim.o.background = "dark"

-- Command-line completion (native floating popup menu)
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- Silence unused host providers to accelerate startup
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
