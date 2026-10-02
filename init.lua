-- Polyfill for Telescope/Treesitter compatibility in Neovim 0.12+
if not vim.treesitter.language.ft_to_lang then
	vim.treesitter.language.ft_to_lang = function(ft)
		return vim.treesitter.language.get_lang(ft) or ft
	end
end
if not vim.treesitter.ft_to_lang then
	vim.treesitter.ft_to_lang = function(ft)
		return vim.treesitter.language.get_lang(ft) or ft
	end
end

-- Automatically set the compiler environment variable for tree-sitter CLI on Windows
if vim.fn.has("win32") == 1 then
	-- If cl.exe is not in PATH, but gcc is available, fall back to gcc
	if vim.fn.executable("cl") == 0 and vim.fn.executable("gcc") == 1 then
		vim.env.CC = "gcc"
	elseif vim.fn.executable("cl") == 0 and vim.fn.executable("clang") == 1 then
		vim.env.CC = "clang"
	end
end

require("mocha.options")
require("mocha.keymaps")

-- =============================
-- Lazy Package Manager
-- =============================

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with declarative plugin discovery
require("lazy").setup({
	spec = {
		{ import = "mocha.plugins" },
	},
	defaults = { lazy = false },
	install = { colorscheme = { "gruvbox", "habamax" } },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- ==============================================================================
-- Native Split Terminal Runner (<F6>)
-- ==============================================================================
vim.keymap.set("n", "<F6>", function()
	local file = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")
	local filetype = vim.bo.filetype
	local basename = vim.fn.expand("%:t:r")
	local dir = vim.fn.fnamemodify(file, ":h")
	local is_win = vim.fn.has("win32") == 1

	if filename == "" then
		vim.notify("Save the file first before running.", vim.log.levels.WARN)
		return
	end

	-- Auto-save before running so the compiler sees the latest buffer contents
	vim.cmd("silent! write")

	local escaped_file = vim.fn.shellescape(file)
	local escaped_dir = vim.fn.shellescape(dir)
	local escaped_filename = vim.fn.shellescape(filename)
	local escaped_base = vim.fn.shellescape(basename)
	local cmd = nil

	if filetype == "c" then
		local out_bin = is_win and (basename .. ".exe") or ("./" .. basename)
		cmd = string.format("cd %s && gcc %s -o %s && %s", escaped_dir, escaped_filename, escaped_base, out_bin)
	elseif filetype == "cpp" then
		local out_bin = is_win and (basename .. ".exe") or ("./" .. basename)
		cmd = string.format("cd %s && g++ %s -o %s && %s", escaped_dir, escaped_filename, escaped_base, out_bin)
	elseif filetype == "cs" then
		local proj_root = vim.fs.root(dir, function(name)
			return name:match("%.csproj$") ~= nil or name:match("%.sln$") ~= nil
		end)
		if proj_root then
			cmd = string.format("cd %s && dotnet run", vim.fn.shellescape(proj_root))
		else
			cmd = string.format("cd %s && dotnet run %s", escaped_dir, escaped_filename)
		end
	elseif filetype == "java" then
		cmd = string.format("cd %s && javac %s && java %s", escaped_dir, escaped_filename, escaped_base)
	elseif filetype == "python" then
		local py = is_win and "python" or "python3"
		cmd = string.format("%s %s", py, escaped_file)
	elseif filetype == "javascript" then
		cmd = string.format("node %s", escaped_file)
	elseif filetype == "typescript" then
		cmd = string.format("ts-node %s", escaped_file)
	elseif filetype == "sh" then
		cmd = string.format("bash %s", escaped_file)
	elseif filetype == "lua" then
		-- nvim -l uses Neovim's embedded LuaJIT runtime with all Neovim APIs available
		cmd = string.format("nvim -l %s", escaped_file)
	elseif filetype == "go" then
		cmd = string.format("go run %s", escaped_file)
	elseif filetype == "rust" then
		local out_bin = is_win and (basename .. ".exe") or ("./" .. basename)
		cmd = string.format("cd %s && rustc %s -o %s && %s", escaped_dir, escaped_filename, escaped_base, out_bin)
	else
		vim.notify("Unsupported filetype for quick runner: " .. filetype, vim.log.levels.WARN)
		return
	end

	-- Execute inside a native Neovim bottom split terminal
	vim.cmd("botright 12split | terminal " .. cmd)
	vim.cmd("startinsert")
end, { desc = "Run current file in native split terminal" })
