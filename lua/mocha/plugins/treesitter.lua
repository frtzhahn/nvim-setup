return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- CRITICAL: Switch to the 0.12+ branch
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
			ts.install({
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"latex",
				"query",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"java",
				"c_sharp",
				"razor",
			})
			-- Enable Highlighting natively
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
					if lang and ts.get_installed(lang) then
						pcall(vim.treesitter.start)
					end
				end,
			})
		end,
	},
}
