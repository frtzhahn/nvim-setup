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
      local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1

      -- 1. Setup Mason and dependency chains
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = { 'js-debug-adapter', 'codelldb', 'netcoredbg' },
      }

      -- 2. js-debug-adapter configuration
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}', -- nvim-dap will find an available port
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }

      -- 3. Safe Input Handlers (Preventing Neovim Lock-ups/Freezes)
      local function get_program_path()
        local path = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        if path == "" or path == nil or path == vim.fn.getcwd() .. '/' then
          vim.notify("Debugging execution canceled.", vim.log.levels.WARN)
          return nil -- Returns nil to abort nvim-dap cleanly
        end
        return path
      end

      local function get_args()
        local args_str = vim.fn.input('Arguments: ')
        if args_str == "" or args_str == nil or string.match(args_str, "^%s*$") then
          return {} -- Clean empty table if user hits enter/cancel
        end
        -- Trim leading and trailing spaces to prevent empty entries
        local trimmed = string.gsub(args_str, "^%s+", "")
        trimmed = string.gsub(trimmed, "%s+$", "")
        if trimmed == "" then
          return {}
        end
        return vim.split(trimmed, " +")
      end

      -- 4. Dynamic Environment Terminal Resolver
      local function get_linux_terminal()
        if os.getenv("SWAYSOCK") then
          if vim.fn.executable('kitty') == 1 then
            return { command = 'kitty', args = { '--hold', '-e' } }
          elseif vim.fn.executable('alacritty') == 1 then
            return { command = 'alacritty', args = { '--hold', '-e' } }
          elseif vim.fn.executable('foot') == 1 then
            return { command = 'foot', args = { 'sh', '-c', '"$@"; exec bash', 'sh' } }
          end
        end

        -- If on KDE Plasma or as a generic Linux fallback, cleanly route to 'konsole' with {'--noclose', '-e'}
        local is_kde = os.getenv("KDE_FULL_SESSION") or (os.getenv("XDG_CURRENT_DESKTOP") and string.find(string.lower(os.getenv("XDG_CURRENT_DESKTOP")), "kde"))
        if is_kde or not os.getenv("SWAYSOCK") then
          if vim.fn.executable('konsole') == 1 then
            return { command = 'konsole', args = { '--noclose', '-e' } }
          end
        end

        -- General safety fallback list if konsole or the sway-specific terminal aren't found
        if vim.fn.executable('kitty') == 1 then
          return { command = 'kitty', args = { '--hold', '-e' } }
        elseif vim.fn.executable('alacritty') == 1 then
          return { command = 'alacritty', args = { '--hold', '-e' } }
        elseif vim.fn.executable('foot') == 1 then
          return { command = 'foot', args = { 'sh', '-c', '"$@"; exec bash', 'sh' } }
        end
        return { command = 'xterm', args = { '-hold', '-e' } }
      end

      if is_windows then
        dap.defaults.fallback.external_terminal = { command = 'cmd.exe', args = { '/c', 'start' } }
      else
        dap.defaults.fallback.external_terminal = get_linux_terminal()
      end
      dap.defaults.fallback.force_external_terminal = false

      -- 5. FIXING ADAPTERS: Resolve strings synchronously *during* initialization block
      local ok, registry = pcall(require, "mason-registry")
      local codelldb_path = ""
      
      if ok and registry.has_package("codelldb") then
        local pkg = registry.get_package("codelldb")
        local base_path = pkg:get_install_path()
        if is_windows then
          codelldb_path = base_path .. "/extension/adapter/codelldb.exe"
        else
          codelldb_path = base_path .. "/extension/adapter/codelldb"
        end
      else
        -- High-resilient fallback if mason has not synced index yet
        codelldb_path = vim.fn.stdpath("data") .. (is_windows and "/mason/bin/codelldb.cmd" or "/mason/bin/codelldb")
      end

      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = codelldb_path, -- FIXED: Raw string passed directly to internal spawn routine
          args = {"--port", "${port}"},
        }
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" }
      }

      -- 6. C/C++ Launch Matrix
      local c_cpp_configurations = {
        {
          name = "Launch (CodeLLDB Built-in Terminal Integration)",
          type = "codelldb",
          request = "launch",
          program = get_program_path,
          args = get_args,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          terminal = "external",
        },
        {
          name = "Launch (GDB External Popup Window)",
          type = "gdb",
          request = "launch",
          program = get_program_path,
          args = get_args,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
          runInTerminal = true, -- Directs GDB to spawn out to get_linux_terminal mappings
        },
      }

      dap.configurations.cpp = c_cpp_configurations
      dap.configurations.c = c_cpp_configurations

      -- 7. Node Language Configurations
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

      -- 8. Keymaps & UI Listeners
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F4>', dap.terminate, { desc = 'Debug: Terminate' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>ku', dap.up, { desc = 'Debug: Up Stack Frame' })
      vim.keymap.set('n', '<leader>kd', dap.down, { desc = 'Debug: Down Stack Frame' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })

      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = function()
        vim.notify("Debug Session Terminated")
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        vim.notify("Debug Session Terminated")
      end

			-- 9. Visual Enhancements (Clean ASCII/Unicode Style)
			   vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#e06c75' }) -- Soft red
			   vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })   -- Light blue
			   vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bold = true }) -- Green

			   vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Simple clean dot
			   vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Hollow dot
			   vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'Visual', numhl = 'DapStopped' }) -- Solid pointer arrow

			-- alternative option if no nerd font is configured
				 --  vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#992525' })
				 --  vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
				 --  vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bold = true })
				 --
				 -- vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Filled circle
				 --  vim.fn.sign_define('DapBreakpointCondition', { text = 'BC', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Target/Nested circle
				 --  vim.fn.sign_define('DapStopped', { text = '󰁕', texthl = 'DapStopped', linehl = 'Visual', numhl = 'DapStopped' }) -- Clean right arrow
    end,
  },
}
