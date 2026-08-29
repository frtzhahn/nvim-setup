return {
	"frtzhahn/copy-history.nvim",
	branch = "feat/core-enhancements",
	event = "VeryLazy",
	opts = {
		keymap = "<leader>cp",
		max_history = 10,
		border = "rounded",
		max_payload_size = 10 * 1024 * 1024,
		syntax_highlight = true,
		close_on_q = true,
		storage_dir = nil,
		window = {
			width = 0.88,
			height = 0.60,
			preview_ratio = 0.55,
			min_height = 8,
			preview = true,
		},
	},
}
