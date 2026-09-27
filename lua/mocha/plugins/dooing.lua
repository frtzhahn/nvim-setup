return {
	"atiladefreitas/dooing",
	cmd = { "Dooing" },
	keys = {
		{ "<leader>td", "<cmd>Dooing<cr>", desc = "Toggle Dooing task checklist" },
	},
	opts = {
		save_path = vim.fn.stdpath("data") .. "/dooing_todos.json",
	},
}
