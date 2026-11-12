return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<F4>', function() require('dap').terminate() end, desc = 'Debug: Terminate' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Conditional Breakpoint' },
      { '<leader>ku', function() require('dap').up() end, desc = 'Debug: Up Stack Frame' },
      { '<leader>kd', function() require('dap').down() end, desc = 'Debug: Down Stack Frame' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    },
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
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
      dap.defaults.fallback.terminal_win_cmd = 'belowright 12new'
      dap.defaults.fallback.focus_terminal = true

      -- 5. Resolve codelldb path via Mason bin symlink
      local codelldb_path = vim.fn.stdpath("data") .. (is_windows and "/mason/bin/codelldb.cmd" or "/mason/bin/codelldb")

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
          name = "Launch (CodeLLDB Integrated Split Terminal)",
          type = "codelldb",
          request = "launch",
          program = get_program_path,
          args = get_args,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          terminal = "integrated",
        },
        {
          name = "Attach to Process (CodeLLDB)",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          cwd = "${workspaceFolder}",
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

      -- 8. UI Listeners
      dapui.setup()
      local ok_vt, dap_vt = pcall(require, "nvim-dap-virtual-text")
      if ok_vt then
        dap_vt.setup({
          commented = true,
          highlight_changed_variables = true,
          show_stop_reason = true,
        })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
        vim.notify("Debug Session Terminated")
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
        vim.notify("Debug Session Terminated")
      end

      -- 9. Visual Enhancements (Clean ASCII/Unicode Style)
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#e06c75' }) -- Soft red
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })   -- Light blue
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bold = true }) -- Green

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Simple clean dot
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' }) -- Hollow dot
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'Visual', numhl = 'DapStopped' }) -- Solid pointer arrow
    end,
  },
}
