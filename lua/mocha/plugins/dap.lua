return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = { 'js-debug-adapter' },
      }

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}', -- nvim-dap will find an available port
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }

			-- keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>ku', dap.up, { desc = 'Debug: Up Stack Frame' })
      vim.keymap.set('n', '<leader>kd', dap.down, { desc = 'Debug: Down Stack Frame' })


			-- dap ui set up
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close


			-- language configuration
			for _, language in ipairs { 'typescript', 'javascript' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
        }
      end

			-- Cross-platform terminal fallback setup
			local function get_linux_terminal()
				-- Prioritize Kitty since the user prefers it
				if vim.fn.executable('kitty') == 1 then return { command = 'kitty', args = { '-e' } } end
				if os.getenv("SWAYSOCK") then
					if vim.fn.executable('alacritty') == 1 then return { command = 'alacritty', args = { '-e' } } end
					if vim.fn.executable('foot') == 1 then return { command = 'foot', args = { '-e' } } end
				end
				if vim.fn.executable('konsole') == 1 then return { command = 'konsole', args = { '-e' } } end
				if vim.fn.executable('alacritty') == 1 then return { command = 'alacritty', args = { '-e' } } end
				return { command = 'xterm', args = { '-e' } }
			end

<<<<<<< Updated upstream
<<<<<<< Updated upstream
			-- Cross-platform terminal fallback setup
			local function get_linux_terminal()
				-- Prioritize Kitty since the user prefers it
				if vim.fn.executable('kitty') == 1 then return { command = 'kitty', args = { '-e' } } end
				if os.getenv("SWAYSOCK") then
					if vim.fn.executable('alacritty') == 1 then return { command = 'alacritty', args = { '-e' } } end
					if vim.fn.executable('foot') == 1 then return { command = 'foot', args = { '-e' } } end
				end
				if vim.fn.executable('konsole') == 1 then return { command = 'konsole', args = { '-e' } } end
				if vim.fn.executable('alacritty') == 1 then return { command = 'alacritty', args = { '-e' } } end
				return { command = 'xterm', args = { '-e' } }
			end

=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
			if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
				dap.defaults.fallback.external_terminal = {
					command = 'cmd.exe',
					args = { '/c', 'start' }
				}
			else
				dap.defaults.fallback.external_terminal = get_linux_terminal()
			end

			dap.defaults.fallback.force_external_terminal = true

			-- Debugger Adapters Section

			-- 1. GDB Adapter
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "-i", "dap" }
			}

			-- 2. CodeLLDB Adapter (Cross-platform Mason resolver)
			local codelldb_cmd = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
			if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
				codelldb_cmd = vim.fn.stdpath("data") .. "/mason/bin/codelldb.cmd"
			end

			dap.adapters.codelldb = {
				type = 'server',
				port = "${port}",
				executable = {
					command = codelldb_cmd,
					args = {"--port", "${port}"},
				}
			}

			-- Debug Configurations Section
			local c_cpp_configurations = {
				{
					name = "Launch (CodeLLDB Built-in Console)",
					type = "codelldb",
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					args = function()
						local args_str = vim.fn.input('Arguments: ')
						return vim.split(args_str, " +")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch (GDB External Terminal)",
					type = "gdb",
>>>>>>> Stashed changes
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					args = function()
						local args_str = vim.fn.input('Arguments: ')
						return vim.split(args_str, " +")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch (GDB External Terminal)",
					type = "gdb",
>>>>>>> Stashed changes
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					args = function()
						local args_str = vim.fn.input('Arguments: ')
						return vim.split(args_str, " +")
					end,
					cwd = "${workspaceFolder}",
<<<<<<< Updated upstream
					stopOnEntry = false,
=======
					stopAtBeginningOfMainSubprogram = false,
					runInTerminal = true, -- Direct GDB to spawn the external TTY defined in fallback
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
				},
			}

			dap.configurations.cpp = c_cpp_configurations
			dap.configurations.c = c_cpp_configurations

<<<<<<< Updated upstream
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    end,
  },
}

