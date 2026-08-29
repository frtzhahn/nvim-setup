return {
	"frtzhahn/showkeys",
	event = "VimEnter",
	opts = {
		autostart = true, -- opens automatically on startup
		timeout = 1,
		maxkeys = 3,
		position = "top-right",
		show_count = true,
		theme = "carbonfox", -- "auto", "tokyonight", "catppuccin", "gruvbox", "nord", "rose-pine", "kanagawa", "dracula", "carbonfox"
		style = {
			-- latest active key: bright smooth pink/red cell with white bold text
			active = { fg = "#ffffff", bg = "#ff6b81", bold = true },
			-- previous inactive keys: distinct grey cell with light grey text
			inactive = { fg = "#c0c0c0", bg = "#383838" },
		},
	},
}
