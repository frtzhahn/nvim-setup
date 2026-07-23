return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- -- DRY helper function to compile a centered size-adaptive header
			-- local function get_header(width)
			--   if width >= 150 then
			--     return {
			--       [[██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗    ██████╗  █████╗  ██████╗██╗  ██╗    ███╗   ███╗ ██████╗  ██████╗██╗  ██╗ █████╗]],
			--       [[██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝    ████╗ ████║██╔═══██╗██╔════╝██║  ██║██╔══██╗]],
			--       [[██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗      ██████╔╝███████║██║     █████╔╝     ██╔████╔██║██║   ██║██║     ███████║███████║]],
			--       [[██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝      ██╔══██╗██╔══██║██║     ██╔═██╗     ██║╚██╔╝██║██║   ██║██║     ██╔══██║██╔══██║]],
			--       [[╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗    ██████╔╝██║  ██║╚██████╗██║  ██╗    ██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║██║  ██║]],
			--       [[ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝]],
			--     }
			--   else
			--     return {
			--       [[      ███╗   ███╗ ██████╗  ██████╗██╗  ██╗ █████╗      ]],
			--       [[      ████╗ ████║██╔═══██╗██╔════╝██║  ██║██╔══██╗     ]],
			--       [[      ██╔████╔██║██║   ██║██║     ███████║███████║     ]],
			--       [[      ██║╚██╔╝██║██║   ██║██║     ██╔══██║██╔══██║     ]],
			--       [[      ██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║██║  ██║     ]],
			--       [[      ╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝     ]],
			--     }
			--   end
			-- end

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
				dashboard.button("e", "󰙅  File Explorer", "<cmd>Oil<cr>"), -- or NvimTreeToggle / Neotree
				-- dashboard.button("f", "  Find File", "<cmd>Telescope find_files<cr>"),
				dashboard.button("p", "󰦛  Restore Last Session", '<cmd>lua require("persistence").load()<cr>'),
				dashboard.button(
					"v",
					"  Git Changed Files",
					'<cmd>lua if not pcall(vim.cmd, "Telescope git_status") then vim.notify("Not a git repository", vim.log.levels.WARN) end<cr>'
				),
				dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
				dashboard.button("c", "󰒓  Edit Neovim Config", "<cmd>e $MYVIMRC | cd %:p:h<cr>"),
				-- dashboard.button('g', '  Live Grep', '<cmd>Telescope live_grep<cr>'),
				dashboard.button("m", "  Mason Panel", "<cmd>Mason<cr>"),
				-- dashboard.button('s', '  Sync Plugins', '<cmd>Lazy sync<cr>'),
				dashboard.button("l", "  Lazy Dashboard", "<cmd>Lazy<cr>"),
				dashboard.button("h", "  Help / Docs", "<cmd>Telescope help_tags<cr>"),
				-- dashboard.button("q", "  Quit Neovim", "<cmd>qa<cr>"),
			}

			-- Custom dynamic footer displays only a single, sleek load time status
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			dashboard.section.footer.val = "Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"

			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"

			-- Auto-resize redraw hook: Swaps banner and centers version on the fly when window is resized!
			vim.api.nvim_create_autocmd("VimResized", {
				callback = function()
					dashboard.section.header.val = get_header(vim.o.columns)
					alpha.redraw()
				end,
			})

			alpha.setup(dashboard.opts)
		end,
	},
}
