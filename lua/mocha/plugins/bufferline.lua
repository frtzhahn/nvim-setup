return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>xx",
			function()
				local ok, snacks = pcall(require, "snacks")
				if ok and snacks.bufdelete then
					snacks.bufdelete()
				else
					vim.cmd("bdelete")
				end
			end,
			desc = "Delete Current Buffer",
		},
		{
			"<leader>xd",
			function()
				local ok, snacks = pcall(require, "snacks")
				if ok and snacks.bufdelete then
					snacks.bufdelete()
				else
					vim.cmd("bdelete")
				end
			end,
			desc = "Delete Current Buffer",
		},
		{ "<leader>xo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
		{ "<leader>xp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>xP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>xr", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>xl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	},
	opts = {
		options = {
			-- This makes it look like VS Code
			mode = "buffers",
			-- Show icons? (Requires a Nerd Font)
			show_buffer_close_icons = true,
			show_close_icon = true,
			always_show_bufferline = false,
			diagnostics = "nvim_lsp", -- Show error icons in the tab?
		},
	},
}
