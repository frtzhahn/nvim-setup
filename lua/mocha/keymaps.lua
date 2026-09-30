-- =============================
-- My Own Keymaps
-- =============================

--vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
--vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
--vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
--vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger horizontally
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller horizontally
vim.keymap.set("n", "<A-=>", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger vertically by pressing shift and =
vim.keymap.set("n", "<M-->", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller vertically by pressing shift and -

-- K, J as 5k,5j
vim.keymap.set("n", "J", "5j", { noremap = true, silent = true })
vim.keymap.set("n", "K", "5k", { noremap = true, silent = true })
vim.keymap.set("v", "J", "5j", { noremap = true, silent = true })
vim.keymap.set("v", "K", "5k", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim.keymap.set('n', '<leader>pv', '<Cmd>Ex<CR>', { silent = true })

vim.keymap.set("n", "<leader>pf", [[<cmd>Neotree float<cr>]])
vim.keymap.set("n", "<leader>pt", [[<cmd>Neotree left<cr>]])
vim.keymap.set("n", "<leader>pc", [[<cmd>Neotree toggle<cr>]])

vim.keymap.set("n", "<leader>pv", "<Cmd>Oil<CR>", { silent = true })
vim.keymap.set("n", "<leader>pe", "<Cmd>Oil --float<CR>", { silent = true })

-- [[ Minty - Color Tools ]]
-- Open Shades - color picker with shade/tint variations
vim.keymap.set(
	"n",
	"<leader>mis",
	":Shades<CR>",
	{ noremap = true, silent = true, desc = "[M]inty [I]nteractive [S]hades" }
)

-- Open Huefy - manipulate hue, saturation, and lightness
vim.keymap.set(
	"n",
	"<leader>mih",
	":Huefy<CR>",
	{ noremap = true, silent = true, desc = "[M]inty [I]nteractive [H]uefy" }
)

-- [[ Window Navigation & Splits ]]
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Move focus window left" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Move focus window right" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Move focus window up" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Move focus window down" })
vim.keymap.set("n", "<leader>q", ":close<CR>", { silent = true, desc = "Close current split window" })
vim.keymap.set("n", "<leader>hs", ":new<CR>", { silent = true, desc = "Open empty horizontal split" })
vim.keymap.set("n", "<leader>vs", ":vnew<CR>", { silent = true, desc = "Open empty vertical split" })
vim.keymap.set("n", "<leader>ht", ":split | terminal<CR>", { silent = true, desc = "Open horizontal terminal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { silent = true, desc = "Open vertical terminal split" })

-- ==============================================================================
-- Terminal Modal Lifecycle Controls
-- ==============================================================================
-- 1. Double-Escape exits Terminal mode into Normal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode to Normal mode" })

-- 2. Direct split navigation out of terminal mode
vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Move to lower window from terminal" })
vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Move to upper window from terminal" })
vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Move to right window from terminal" })

-- 3. Terminal Buffer Autocommand: 3rd Escape or 'q' closes the terminal split in Normal mode
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("mocha-terminal-modal", { clear = true }),
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set(
			"n",
			"<Esc>",
			"<cmd>close<CR>",
			{ buffer = event.buf, silent = true, desc = "Close terminal split" }
		)
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close terminal split" })
	end,
})
