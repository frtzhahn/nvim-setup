-- return {
--   {
--     "aikhe/cake.nvim",
--     dependencies = { "nvzone/volt" }, -- Essential dependency
--     cmd = { "CakeToggle", "CakeFloat" }, -- Lazy load on these commands
--
--     -- Configuration (Optional: defaults are usually fine)
--     opts = {
--       title = " cake.nvim",
--       size = { h = 60, w = 50 },
--       mappings = {
--         edit_commands = "m",
--         new_tab = "n",
--         rerun = "r",
--         kill_tab = "x",
--         next_tab = "<C-n>",
--         prev_tab = "<C-p>",
--       },
--     },
--
--     -- Keybindings to launch the plugin
--     keys = {
--       {
--         "<leader>cf",
--         function() require("cake").open_float() end,
--         desc = "Cake Float",
--       },
--       {
--         "<leader>ct",
--         function() require("cake").toggle() end,
--         desc = "Cake Toggle",
--       },
--     },
--   }
-- }

return {
  {
    "aikhe/cake.nvim",
    dependencies = { "nvzone/volt" },
    -- Added the new split commands to trigger lazy loading
    cmd = { "CakeToggle", "CakeFloat", "CakeSplitV", "CakeSplitH", "CakeRun" },
    
    opts = {
      title = " cake.nvim",
      mode = "float", -- Default mode
      size = { h = 60, w = 50 },
      split = { w = 50, h = 25 }, -- New: Default split sizes
      mappings = {
        edit_commands = "m",
        new_tab = "n",
        edit_cwd = ";", -- New: added from the update
        rerun = "r",
        kill_tab = "x",
        next_tab = "<C-n>",
        prev_tab = "<C-p>",
      },
      -- New: Navigation keys for splits
      split_nav = {
        h = { "<C-h>" },
        j = { "<C-j>" },
        k = { "<C-k>" },
        l = { "<C-l>" },
      },
    },

    keys = {
      { "<leader>cf", function() require('cake').open({ mode = "float" }) end, desc = "Cake Float" },
      { "<leader>cv", function() require('cake').open({ mode = "splitv" }) end, desc = "Cake Split Vertical" },
      { "<leader>ch", function() require('cake').open({ mode = "splith" }) end, desc = "Cake Split Horizontal" },
      { "<leader>ct", function() require('cake').toggle() end, desc = "Cake Toggle" },
      { "<leader>cr", function() require('cake').run() end, desc = "Cake Run" },
    },
  }
}
