return {
	"nvimdev/indentmini.nvim",
	enabled = false, -- Dormant: disabled per user configuration
	event = "BufEnter",
	config = function()
		require("indentmini").setup()
	end,
}
