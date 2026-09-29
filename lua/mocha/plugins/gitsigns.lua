-- ==============================================================================
-- Gitsigns Plugin Specification (lewis6991/gitsigns.nvim)
-- Provides in-buffer gutter change indicators, hunk jumping, staging, and inline blame
-- ==============================================================================

return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation between modified hunks
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git hunk" })

				-- Hunk Actions (Normal & Visual)
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage visual selection hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset visual selection hunk" })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage entire buffer" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo staged hunk" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset entire buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk inline" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle inline git [B]lame" })
				map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle git [D]eleted lines" })
			end,
		},
	},
}
