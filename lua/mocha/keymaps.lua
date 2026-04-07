-- =============================
-- My Own Keymaps
-- =============================

--vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
--vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
--vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
--vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '=', [[<cmd>vertical resize +5<cr>]]) -- make the window biger horizontally
vim.keymap.set('n', '-', [[<cmd>vertical resize -5<cr>]]) -- make the window smaller horizontally
vim.keymap.set('n', '<A-=>', [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger vertically by pressing shift and =
vim.keymap.set('n', '<M-->', [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller vertically by pressing shift and -

-- K, J as 5k,5j
vim.keymap.set('n', 'J', '5j', { noremap = true, silent = true })
vim.keymap.set('n', 'K', '5k', { noremap = true, silent = true })
vim.keymap.set('v', 'J', '5j', { noremap = true, silent = true })
vim.keymap.set('v', 'K', '5k', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank()
  end,
})

-- vim.keymap.set('n', '<leader>pv', '<Cmd>Ex<CR>', { silent = true })

vim.keymap.set('n', '<leader>pf', [[<cmd>Neotree float<cr>]])
vim.keymap.set('n', '<leader>pt', [[<cmd>Neotree left<cr>]])
vim.keymap.set('n', '<leader>pc', [[<cmd>Neotree toggle<cr>]])

vim.keymap.set('n', '<leader>pv', '<Cmd>Oil<CR>', { silent = true })
vim.keymap.set('n', '<leader>pe', '<Cmd>Oil --float<CR>', { silent = true })
