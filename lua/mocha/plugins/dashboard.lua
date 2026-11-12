return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local function get_header(width)
				if width >= 150 then
					return {
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⣠⡦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣦⡀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣈⣉⠉⠳⢄⢠⢯⠀⣠⠴⠢⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡀⠀⢃⠀⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢤⠒⠤⡀⠈⢳⡆⡴⠺⢉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀]],
						[[⡾⢁⣴⠒⣄⠀⠀⠀⠀⠀⠀⢀⣴⣛⣓⡒⠭⣢⡈⠪⡆⢸⠉⠀⠀⣨⠒⠀⠀⠀⢀⣀⣀⣀⠀⡀⣀⣀⣀⡈⣾⠸⡞⢁⣀⣀⠀⢀⢀⣀⣀⣀⠀⠀⠀⠀⢸⡃⠀⠀⢹⠀⡜⠎⣠⣶⠿⣒⣒⣳⣄⠀⠀⠀⠀⠀⠀⠀⣴⠒⢄⠙⡆]],
						[[⠹⡘⡆⠠⠁⠁⠀⠀⠀⢀⠔⣹⡩⢀⠀⠈⠑⣌⠙⢦⡈⠘⣄⠀⠀⠀⠀⢀⢔⣪⡟⠛⠁⠀⠀⠀⠀⠀⠀⣨⠷⢸⠧⡁⠀⠀⠀⠀⠀⠀⠨⠑⢮⣑⢄⠀⠀⠀⠀⠀⡼⠞⣡⡾⠋⡱⠋⠁⢀⠡⠹⡕⢤⡀⠀⠀⠀⠀⠁⠀⡜⡸⠁]],
						[[⠀⠈⠪⠦⢤⣤⡠⠤⠚⠁⠀⠱⡀⠈⡗⠀⠀⠈⢣⡀⠙⠲⣌⡓⠤⠤⡴⣛⡭⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠪⢕⡳⡤⠤⠔⣊⡤⠞⠁⢀⠎⠀⠀⠀⣟⠁⣠⠃⠀⠉⠢⠤⢀⣤⡤⠾⠊⠀⠀]],
						[[⠀⠀⠀⠀⣬⠉⠁⠀⠀⠀⠀⠀⠑⠒⠁⠀⠀⠀⠈⠳⡄⠀⠉⠑⣒⣶⠓⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠳⣶⠖⠋⠁⠀⡠⠊⠀⠀⠀⠀⠙⠒⠋⠀⠀⠀⠀⠀⠈⠉⡅⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠒⠊⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠂⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⢀⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣇⠄⠀⠀⠀]],
						[[⠀⠀⠉⡩⠿⢍⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠝⡿⡉⠀⠀⠀]],
						[[⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀]],
					}
				else
					return {
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⣀⡴⢧⣀⠀⠀⣀⣠⠤⠤⠤⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠘⠏⢀⡴⠊⠁⠀⠀⠀⠀⠀⠀⠈⠙⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢶⣶⣒⣶⠦⣤⣀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⢀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣟⠲⡌⠙⢦⠈⢧⠀]],
						[[⠀⠀⠀⣠⢴⡾⢟⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡴⢃⡠⠋⣠⠋⠀]],
						[[⠐⠀⠞⣱⠋⢰⠁⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⠤⢖⣋⡥⢖⣫⠔⠋⠀⠀⠀]],
						[[⠈⠠⡀⠹⢤⣈⣙⠚⠶⠤⠤⠤⠴⠶⣒⣒⣚⣩⠭⢵⣒⣻⠭⢖⠏⠁⢀⣀⠀⠀⠀⠀]],
						[[⠠⠀⠈⠓⠒⠦⠭⠭⠭⣭⠭⠭⠭⠭⠿⠓⠒⠛⠉⠉⠀⠀⣠⠏⠀⠀⠘⠞⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢤⣀⠀⠀⠀⠀⠀⠀⣀⡤⠞⠁⠀⣰⣆⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠘⠿⠀⠀⠀⠀⠀⠈⠉⠙⠒⠒⠛⠉⠁⠀⠀⠀⠉⢳⡞⠉⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					}
				end
			end

			-- Initial header build
			local width = vim.o.columns
			dashboard.section.header.val = get_header(width)

			-- Custom interactive buttons (including the newly added Mason Panel and Help/Docs shortcut)
			dashboard.section.buttons.val = {
				dashboard.button("e", "󰙅  File Explorer", "<cmd>Neotree float<cr>"), -- options: Oil / Neotree / lua Snacks.picker.files()
				-- dashboard.button("f", "  Find File", "<cmd>lua Snacks.picker.files()<cr>"),
				dashboard.button("p", "󰦛  Restore Last Session", '<cmd>lua require("persistence").load()<cr>'),
				dashboard.button("v", "  Git Changed Files", "<cmd>lua Snacks.picker.git_status()<cr>"),
				dashboard.button("r", "  Recent Files", "<cmd>lua Snacks.picker.recent()<cr>"),
				dashboard.button("c", "󰒓  Edit Neovim Config", "<cmd>e $MYVIMRC | cd %:p:h<cr>"),
				-- dashboard.button('g', '  Live Grep', '<cmd>lua Snacks.picker.grep()<cr>'),
				dashboard.button("m", "  Mason Panel", "<cmd>Mason<cr>"),
				-- dashboard.button('s', '  Sync Plugins', '<cmd>Lazy sync<cr>'),
				dashboard.button("l", "  Lazy Dashboard", "<cmd>Lazy<cr>"),
				dashboard.button("h", "  Help / Docs", "<cmd>lua Snacks.picker.help()<cr>"),
				-- dashboard.button("q", "  Quit Neovim", "<cmd>qa<cr>"),
			}

			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"

			local alpha_group = vim.api.nvim_create_augroup("mocha-alpha-dashboard", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				group = alpha_group,
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(alpha.redraw)
				end,
			})

			-- Auto-resize redraw hook: Swaps banner and centers version on the fly when window is resized!
			vim.api.nvim_create_autocmd("VimResized", {
				group = alpha_group,
				callback = function()
					if vim.bo.filetype == "alpha" then
						dashboard.section.header.val = get_header(vim.o.columns)
						alpha.redraw()
					end
				end,
			})

			alpha.setup(dashboard.opts)
		end,
	},
}
