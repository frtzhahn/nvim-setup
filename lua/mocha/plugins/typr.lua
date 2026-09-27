return {
	"nvzone/typr",
	lazy = false,
	config = function()
		require("typr").setup({
			-- Add any custom configuration here
		})
	end,
	keys = {
		-- Add keybindings if desired
		{ "<leader>tp", "<cmd>Typr<cr>", desc = "Open Typr" },
	},
}
