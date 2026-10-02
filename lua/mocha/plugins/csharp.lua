return {
	-- 1. Custom Mason Registry declaration for Roslyn server installation
	{
		"williamboman/mason.nvim",
		opts = {
			registries = {
				"github:Crashdummyy/mason-registry",
				"github:mason-org/mason-registry",
			},
		},
	},

	-- 2. seblyng/roslyn.nvim setup
	{
		"seblyng/roslyn.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		init = function()
			-- Register Razor/Blazor filetypes explicitly for Roslyn LSP co-hosting
			vim.filetype.add({
				extension = {
					razor = "razor",
					cshtml = "razor",
				},
			})
		end,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
			end

			-- Configure Roslyn LSP settings via Neovim 0.12+ vim.lsp.config
			vim.lsp.config("roslyn", {
				capabilities = capabilities,
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
						dotnet_enable_tests_code_lens = true,
					},
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
				},
			})

			require("roslyn").setup({
				filewatching = "off", -- Crucial dual-core CPU performance tweak
				broad_search = false,
				lock_target = false,
			})
		end,
	},

	-- 4. nicholasmata/nvim-dap-cs setup
	{
		"nicholasmata/nvim-dap-cs",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local ok, dap_cs = pcall(require, "dap-cs")
			local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
			local netcoredbg_binary = is_windows and "netcoredbg.exe" or "netcoredbg"
			local netcoredbg_path =
				vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "netcoredbg", netcoredbg_binary)

			-- Fallback to system netcoredbg binary if Mason package is not installed or unexecutable
			if vim.fn.executable(netcoredbg_path) ~= 1 and vim.fn.executable("netcoredbg") == 1 then
				netcoredbg_path = "netcoredbg"
			end

			if ok then
				dap_cs.setup({
					netcoredbg = {
						path = netcoredbg_path,
					},
				})
			end

			-- Enhance dap.configurations.cs with buffer-aware DLL auto-detection, process attachment, and terminal console support
			local dap_ok, dap = pcall(require, "dap")
			if dap_ok then
				local function get_dll_path()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local buf_dir = #buf_path > 0 and vim.fs.dirname(buf_path) or vim.fn.getcwd()
					local root = vim.fs.root(buf_dir, function(name)
						return name:match("%.csproj$") ~= nil or name:match("%.sln$") ~= nil
					end) or vim.fn.getcwd()

					local matches = vim.fs.find(function(name, path)
						return name:match("%.dll$")
							and path:match("[/\\]bin[/\\](Debug|Release)[/\\]")
							and not path:match("[/\\]ref[/\\]")
							and not name:lower():match("test")
							and not name:match("%.deps%.")
					end, { path = root, type = "file" })

					if #matches > 0 then
						-- Sort by newest modification timestamp to pick freshest compilation
						table.sort(matches, function(a, b)
							return vim.fn.getftime(a) > vim.fn.getftime(b)
						end)
						return matches[1]
					end

					local input_path = vim.fn.input("Path to .dll: ", root .. "/bin/Debug/", "file")
					if input_path == "" or input_path == root .. "/bin/Debug/" then
						vim.notify("Debugging execution cancelled.", vim.log.levels.WARN)
						return nil
					end
					return input_path
				end

				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "Launch (Integrated Terminal - Console.ReadLine)",
						request = "launch",
						console = "integratedTerminal",
						program = get_dll_path,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
					},
					{
						type = "coreclr",
						name = "Launch with Arguments (Integrated Terminal)",
						request = "launch",
						console = "integratedTerminal",
						program = get_dll_path,
						args = function()
							local args_str = vim.fn.input("Command line arguments: ")
							if args_str == "" or args_str == nil then
								return {}
							end
							return vim.split(vim.trim(args_str), "%s+")
						end,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
					},
					{
						type = "coreclr",
						name = "Launch (External Terminal - Popup Window)",
						request = "launch",
						console = "externalTerminal",
						program = get_dll_path,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
					},
					{
						type = "coreclr",
						name = "Launch (Internal Console - Web / API)",
						request = "launch",
						console = "internalConsole",
						program = get_dll_path,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
					},
					{
						type = "coreclr",
						name = "Launch (Framework / External Step - justMyCode = false)",
						request = "launch",
						console = "integratedTerminal",
						program = get_dll_path,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
						justMyCode = false,
					},
					{
						type = "coreclr",
						name = "Attach (Pick Process)",
						request = "attach",
						processId = function()
							return require("dap.utils").pick_process()
						end,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	},

	-- 5. GustavEikaas/easy-dotnet.nvim (Solution, Test Runner, Secrets & Package Management)
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"folke/snacks.nvim",
		},
		cmd = { "Dotnet" },
		keys = {
			{ "<leader>dr", "<cmd>Dotnet run<cr>", desc = "Dotnet: Run project" },

			{ "<leader>db", "<cmd>Dotnet build<cr>", desc = "Dotnet: Build solution/project" },
			{ "<leader>dt", "<cmd>Dotnet testrunner<cr>", desc = "Dotnet: Test Runner UI" },
			{ "<leader>ds", "<cmd>Dotnet secrets<cr>", desc = "Dotnet: User Secrets" },
			{ "<leader>do", "<cmd>Dotnet outdated<cr>", desc = "Dotnet: Outdated NuGet Packages" },
			{ "<leader>dn", "<cmd>Dotnet new<cr>", desc = "Dotnet: New Project/File" },
		},
		config = function()
			local ok, easy_dotnet = pcall(require, "easy-dotnet")
			if not ok then
				return
			end

			easy_dotnet.setup({
				test_runner = {
					viewmode = "float",
					enable_buffer_test_execution = true,
				},
			})
		end,
	},
}
