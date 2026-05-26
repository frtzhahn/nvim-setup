-- return {
--   "vyfor/cord.nvim",
--   config = function()
--     require("cord").setup({
--       auto_update = true,   -- automatically updates Discord presence
--       show_file = true,     -- show the current file name
--       show_branch = false,  -- hide git branch
--       editor_icon = true,  -- hide Neovim icon
--       workspace_text      = "Working on %s",
--       enable_line_number  = true,
--       line_number_text    = "Line %s out of %s",
--     })
--   end
-- }




-- option 2


-- return {
--   {
--     'vyfor/cord.nvim',
--     build = './build',
--     event = 'VeryLazy',
--     opts = {
--       usercmds = true,
--       log_level = 'error',
--
--       -- TIMER SETTINGS
--       timestamp = {
--         enabled = true,
--         reset_on_idle = false,
--         reset_on_change = true, -- Reset timer when you switch files (feels more responsive)
--       },
--
--       editor = {
--         client = 'neovim',
--         tooltip = 'The Superior Text Editor', -- Custom tooltip
--         icon = nil,
--       },
--
--       display = {
--         theme = 'catppuccin', -- Matches your system theme
--         flavor = 'accent',
--         swap_fields = false, 
--         swap_icons = true,   -- File icon is Big, Neovim icon is Small
--       },
--
--       idle = {
--         enabled = true,
--         timeout = 300000, -- 5 mins
--         show_status = true,
--         ignore_focus = true,
--         unidle_on_focus = true,
--         smart_idle = true,
--         details = 'AFK / Thinking',
--         state = 'Waiting for input...',
--         tooltip = '💤',
--         icon = nil, 
--       },
--
--       -- DYNAMIC TEXT CONFIGURATION
--       -- Instead of static strings, we use functions to calculate status in real-time.
--       text = {
--         -- When viewing a file (read-only)
--         viewing = function(opts)
--           return string.format('Reading %s', opts.filename)
--         end,
--
--         -- When editing (The heavy lifting happens here)
--         editing = function(opts)
--           local filename = opts.filename
--
--           -- Get standard line number data
--           local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
--           local total_lines = vim.api.nvim_buf_line_count(0)
--
--           -- Check if file has unsaved changes
--           local is_modified = vim.bo.modified
--           local prefix = is_modified and "Unsaved: " or "Editing "
--
--           -- Returns: "Editing main.lua | Line 15 of 100"
--           return string.format('%s%s | Line %d of %d', prefix, filename, cursor_line, total_lines)
--         end,
--
--         -- When in a file explorer (like oil.nvim or netrw)
--         file_browser = function(opts)
--           return string.format('Browsing %s', opts.name)
--         end,
--
--         -- Shows your current project folder name
--         workspace = function(opts)
--           return string.format('Project: %s', opts.workspace)
--         end,
--
--         plugin_manager = 'Updating Plugins...',
--         lsp_manager = 'Configuring LSP...',
--         vcs = 'Managing Git...',
--       },
--
--       -- DYNAMIC BUTTONS
--       buttons = {
--         {
--           label = 'View Repository',
--           -- Tries to find the git URL, otherwise links to your GitHub profile (Update the fallback URL!)
--           url = function(opts) 
--             return opts.repo_url or "https://github.com/YOUR_USERNAME" 
--           end,
--         },
--         -- Optional second button
--         -- {
--         --   label = 'Send Help',
--         --   url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
--         -- }
--       },
--
--       assets = nil,
--
--       -- ADVANCED HOOKS
--       -- This ensures updates happen as fast as Discord allows
--       advanced = {
--         plugin = {
--           autocmds = true,
--           cursor_update = 'on_hold', -- Updates when you stop typing for a moment
--           match_in_mappings = true,
--         },
--         server = {
--           update = 'fetch',
--           timeout = 300000,
--         },
--         discord = {
--           reconnect = {
--             enabled = true, -- Auto-reconnect if Discord crashes
--             interval = 5000,
--             initial = true,
--           },
--         },
--       },
--     },
--   },
-- }





--option 3
return {
  {
    'vyfor/cord.nvim',
    event = 'VeryLazy',
    opts = {
      log_level = 'error',

      editor = {
        client = 'neovim',
        tooltip = "Better than any IDE you've used ꉂ(˵˃ ᗜ ˂˵)", 
        icon = nil, 
      },

      display = {
        theme = 'minecraft',
        flavor = 'accent',

        -- theme = 'minecraft',
        -- flavor = 'dark',

        -- theme = 'catppuccin', 
        -- flavor = 'accent',

        -- theme = 'atom',
        -- flavor = 'dark',

        -- theme = 'void',
        -- flavor = 'accent',

        -- theme = 'classic',
        -- flavor = 'dark',

        swap_fields = false, 
        swap_icons = false,   
      },

      timestamp = {
        enabled = true,
        reset_on_idle = false,  
        reset_on_change = false, 
      },

      idle = {
        enabled = true,
        timeout = 90000000, 
        show_status = true,
        ignore_focus = true,
        unidle_on_focus = true,
        smart_idle = true,
        details = "do not disturb fls ☕",
        state = 'Taking a break from this agony 🫩✌️', 
        tooltip = '🛌💤',
        icon = nil, 
      },

      text = {
        viewing = function(opts) return 'Reading ' .. opts.filename end,

        editing = function(opts)
          local is_modified = vim.bo.modified
          if is_modified then
            return string.format('Unsaved: %s', opts.filename)
          else
            return string.format('Editing %s', opts.filename)
          end
        end,

        file_browser = function(opts) return 'Browsing ' .. opts.name end,
        workspace = function(opts) return 'Project: ' .. opts.workspace end,
        plugin_manager = 'Updating plugins...',
        vcs = 'Git Operations...',

        -- lsp and diagnostics 
        lsp = 'Configuring LSP...',
        diagnostics = 'Fixing code diagnostics...',
      },

      buttons = {
        {
          label = 'view my shit',
          url = function(opts) 
            return opts.repo_url or "https://github.com/frtzhahn" 
          end,
        },
        -- Optional Second Button (Discord supports up to 2)
        -- {
        --   label = 'Send Coffee ☕',
        --   url = 'https://github.com/sponsors/vyfor',
        -- },
      },

      -- Custom Event Hooks (Ready to be uncommented for system/editor alerts)
      -- hooks = {
      --   idle_enter = function(opts)
      --     vim.notify("Cord: Entered idle mode", vim.log.levels.INFO)
      --   end,
      --   idle_leave = function(opts)
      --     vim.notify("Cord: Returned to coding", vim.log.levels.INFO)
      --   end,
      -- },

      advanced = {
        plugin = {
          autocmds = true,
          cursor_update = 'on_hold',
          match_in_mappings = true,

          -- Performance Throttle & Debouncer
          debounce = {
            delay = 50,      -- Wait 50ms for events to settle
            interval = 750,  -- Limit IPC requests to once every 750ms
          },
        },
        server = {
          update = 'fetch',
          timeout = 3000,
        },
        discord = {
          reconnect = {
            enabled = true,
            interval = 5000,
            initial = true,
          },
        },
      },
    },
  },
}


-- option 4
-- return {
--   "IogaMaster/neocord",
--   event = "VeryLazy",
--   config = function()
--     local neocord = require("neocord")
--     neocord:setup({
--       client_id           = "1157438221865717891",
--       log_level           = "error",
--       logo                = "auto",
--       logo_tooltip        = "Better than any IDE you've used ꉂ(˵˃ ᗜ ˂˵)",
--       main_image          = "language",
--       editing_text        = "Editing %s",
--       file_explorer_text  = "Browsing %s",
--       plugin_manager_text = "Updating plugins...",
--       reading_text        = "Reading %s",
--       workspace_text      = "Project: %s",
--       show_time           = true,
--       global_timer        = true,
--       buttons = {
--         { label = "view my shit", url = "https://github.com/frtzhahn" },
--       },
--     })
--
--     -- 1. Disable / Clear Presence
--     vim.api.nvim_create_user_command("NeocordDisable", function()
--       vim.g.neocord_auto_update = 0
--       neocord:cancel()
--       vim.notify("Neocord: Presence Disabled", vim.log.levels.INFO)
--     end, {})
--
--     -- 2. Enable / Reconnect Presence
--     vim.api.nvim_create_user_command("NeocordEnable", function()
--       vim.g.neocord_auto_update = 1
--       neocord:update()
--       vim.notify("Neocord: Presence Enabled", vim.log.levels.INFO)
--     end, {})
--
--     -- 3. Force Idle Status (Simulated by clearing presence)
--     vim.api.nvim_create_user_command("NeocordIdle", function()
--       neocord:cancel()
--       vim.notify("Neocord: Presence Cleared (Idle)", vim.log.levels.INFO)
--     end, {})
--   end,
-- }
