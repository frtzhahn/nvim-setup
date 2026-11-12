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
			ts.setup({})

			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local select_fn = require("nvim-treesitter-textobjects.select").select_textobject
			local select_maps = {
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
			}
			for lhs, query in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select_fn(query, "textobjects")
				end, { desc = "TS Select " .. query })
			end

			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class start" })
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Prev function end" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Prev class end" })

			local ensure_installed = {
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
			}
			local installed = ts.get_installed("parsers")
			local to_install = vim.tbl_filter(function(lang)
				return not vim.list_contains(installed, lang)
			end, ensure_installed)
			if #to_install > 0 then
				ts.install(to_install)
			end

			-- Enable Highlighting natively
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("mocha-treesitter-start", { clear = true }),
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
}
