return {
	"frtzhahn/showkeys",
	event = "VimEnter",
	opts = {
		autostart = true,
		timeout = 3,
		maxkeys = 3,
		position = "top-right",
		show_count = true,
		theme = "tokyonight", -- "auto", "tokyonight", "catppuccin", "gruvbox", "nord", "rose-pine", "kanagawa", "dracula", "carbonfox"

		-- personal pref
		-- style = {
		-- 	-- latest active keys
		-- 	active = { fg = "#ffffff", bg = "#ff6b81", bold = true },
		-- 	-- previous inactive keys
		-- 	inactive = { fg = "#c0c0c0", bg = "#383838" },
		-- },
	},
}
