return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	keys = {
		{ "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate window / tmux pane left" },
		{ "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate window / tmux pane down" },
		{ "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate window / tmux pane up" },
		{ "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate window / tmux pane right" },
		{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous window / tmux pane" },
	},
}
