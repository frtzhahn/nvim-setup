-- ==============================================================================
-- Snacks.nvim Modern Ecosystem (folke/snacks.nvim)
-- High-performance suite: picker, notifier, quickfile, bigfile, words
-- Replaces heavy Telescope dependency chain with native Neovim 0.12+ async streams
-- ==============================================================================

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				layout = {
					preset = "default",
				},
			},
		},
		keys = {
			-- Top Pickers (matching Telescope muscle memory)
			{
				"<leader>sf",
				function()
					Snacks.picker.files()
				end,
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader><space>",
				function()
					Snacks.picker.buffers()
				end,
				desc = "[ ] Find existing buffers",
			},
			{
				"<leader><leader>",
				function()
					Snacks.picker.buffers()
				end,
				desc = "[ ] Find existing buffers",
			},
			{
				"<leader>s.",
				function()
					Snacks.picker.recent()
				end,
				desc = "[S]earch Recent Files",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "[S]earch [M]arks",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>sr",
				function()
					Snacks.picker.resume()
				end,
				desc = "[S]earch [R]esume",
			},
			-- In-Buffer Line Search (Native stream replacement for Telescope current_buffer_fuzzy_find)
			{
				"<leader>/",
				function()
					Snacks.picker.lines()
				end,
				desc = "[/] Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "[S]earch [/] in Open Buffers",
			},
			{
				"<leader>sn",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[S]earch [N]eovim files",
			},
			-- Git Pickers
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log (Snacks)",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status (Snacks)",
			},
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "Toggle Lazygit",
			},
			-- Notifier controls
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss Notifications",
			},
			{
				"<leader>nh",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
		},
	},
}
