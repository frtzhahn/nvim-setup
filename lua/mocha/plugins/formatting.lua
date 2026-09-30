return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			-- C# CSharpier JIT cold starts on CoreCLR often take 600-1200ms
			local timeout = vim.bo[bufnr].filetype == "cs" and 2500 or 500
			return {
				timeout_ms = timeout,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			cs = { "csharpier" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			csharpier = function(bufnr)
				local mason_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "csharpier")
				local global_path = vim.fn.expand("~/.dotnet/tools/dotnet-csharpier")
				local global_path_alt = vim.fn.expand("~/.dotnet/tools/csharpier")
				local cmd = "csharpier"

				if vim.fn.executable(mason_path) == 1 then
					cmd = mason_path
				elseif vim.fn.executable(global_path) == 1 then
					cmd = global_path
				elseif vim.fn.executable(global_path_alt) == 1 then
					cmd = global_path_alt
				end

				return {
					command = cmd,
					args = { "format", "--stdin-path", "$FILENAME" },
				}
			end,
		},
	},
}
