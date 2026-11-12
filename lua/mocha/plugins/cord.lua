return {
	{
		"vyfor/cord.nvim",
		event = "VeryLazy",
		opts = {
			log_level = "error",

			editor = {
				client = "neovim",
				tooltip = "Better than any IDE you've used ꉂ(˵˃ ᗜ ˂˵)",
				icon = nil,
			},

			display = {
				theme = "minecraft",
				flavor = "accent",

				-- theme = 'minecraft',
				-- flavor = 'dark',

				-- theme = "catppuccin",
				-- flavor = "accent",

				-- theme = "atom",
				-- flavor = "dark",

				-- theme = "void",
				-- flavor = "accent",

				-- theme = "classic",
				-- flavor = "dark",

				swap_fields = false,
				swap_icons = false,
			},

			timestamp = {
				enabled = true,
				reset_on_idle = false,
				reset_on_change = false,
			},

			idle = {
				enabled = true,
				timeout = 1800000,
				show_status = true,
				ignore_focus = true,
				unidle_on_focus = true,
				smart_idle = true,
				details = "probably sleeping",
				state = "𐔌՞- . -՞𐦯 ᶻ𝗓𐰁",
				tooltip = "⋆｡˚ ☁︎ ˚｡⋆｡˚☽˚｡⋆",
				icon = nil,
			},

			text = {
				viewing = function(opts)
					return "Reading " .. opts.filename
				end,

				editing = function(opts)
					local is_modified = vim.bo.modified
					if is_modified then
						return string.format("Unsaved: %s", opts.filename)
					else
						return string.format("Working on %s", opts.filename)
					end
				end,

				file_browser = function(opts)
					return "Browsing " .. opts.name
				end,
				workspace = function(opts)
					return "Project: " .. opts.workspace
				end,
				plugin_manager = "Updating plugins",
				vcs = "Git Operations",

				-- lsp and diagnostics
				lsp = "Configuring LSP",
				diagnostics = "Fixing code diagnostics",
			},

			buttons = {
				{
					label = "view my shit",
					url = function(opts)
						return "https://github.com/frtzhahn" --add this if you want to add dir repo: url opts.repo_url or
					end,
				},
				-- Optional Second Button (Discord supports up to 2)
				-- {
				-- 	label = "view another shit",
				-- 	url = "https://github.com/frtzhahn",
				-- },
			},

			-- Custom Event Hooks (Ready to be uncommented for system/editor alerts)
			hooks = {
				idle_enter = function(opts)
					vim.notify("Cord: Entered idle mode", vim.log.levels.INFO)
				end,
				idle_leave = function(opts)
					vim.notify("Cord: Returned to coding", vim.log.levels.INFO)
				end,
			},

			advanced = {
				plugin = {
					autocmds = true,
					cursor_update = "on_hold",
					match_in_mappings = true,

					-- Performance Throttle & Debouncer
					debounce = {
						delay = 50, -- Wait 50ms for events to settle
						interval = 750, -- Limit IPC requests to once every 750ms
					},
				},
				server = {
					update = "fetch",
					timeout = 3000,
				},
				discord = {
					reconnect = {
						enabled = true,
						interval = 5000,
						initial = true,
					},
				},
			},
		},
	},
}
