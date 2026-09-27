return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Git Diffview" },
		{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Git Diffview" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File Git History (Diffview)" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			default = {
				layout = "diff2_horizontal",
			},
		},
	},
}
