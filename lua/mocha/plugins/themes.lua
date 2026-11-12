return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			variant = "default", -- "default", "muted", "light", or "auto"
			transparent = false,
			cache = true,
		})

		vim.cmd.colorscheme("cyberdream")
	end,
}
