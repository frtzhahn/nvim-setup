-- return {
--     "slugbyte/lackluster.nvim",
--     lazy = false,
--     priority = 1000,
--     init = function()
--         -- vim.cmd.colorscheme("lackluster")
--         vim.cmd.colorscheme("lackluster-hack") -- my favorite
--         -- vim.cmd.colorscheme("lackluster-mint")
--     end,
-- }




-- return {
--   "ellisonleao/gruvbox.nvim",
--   priority = 1000,
--   config = function()
--     require("gruvbox").setup({
      -- transparent_mode = true, -- enable transparent background
--     })
--
--     vim.o.background = "dark" -- or "light"
--     vim.cmd.colorscheme("gruvbox")
--   end,
-- }

-- github themes
-- return {
--   'projekt0n/github-nvim-theme',
--   name = 'github-theme',
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     require('github-theme').setup({
--       -- ...
--     })
--
--     -- vim.cmd('colorscheme github_dark_dimmed')
--     -- vim.cmd('colorscheme github_light_high_contrast')
--     vim.cmd('colorscheme github_dark_default')
--   end,
-- }


--gruvbox v2
-- return {
-- "xero/miasma.nvim",
-- lazy = false,
-- priority = 1000,
-- config = function()
-- 	vim.cmd("colorscheme miasma")
-- end,
-- }


--fleur theme
-- return {
--   'aikhe/fleur.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd("colorscheme fleur")
--   end,
-- }


-- material theme
return {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- Set your desired style here BEFORE loading the colorscheme.
        -- Options: 'darker', 'lighter', 'oceanic', 'palenight', 'deep ocean'
        vim.g.material_style = "deep ocean"
        -- Optional: Call setup if you want to tweak specific UI elements later 
        -- (like making the background transparent)
        require('material').setup({
            -- custom settings go here
        })

        vim.cmd("colorscheme material")
    end,
}


-- nightfox theme
-- return {
--     "EdenEast/nightfox.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         -- Optional: Call setup if you want to tweak specific UI elements later
--         -- (like enabling transparent backgrounds, changing styles for keywords, etc.)
--         require('nightfox').setup({
--             options = {
--                 -- transparent = true,
--             }
--         })
--
--         -- Set your desired style here by uncommenting the one you want.
--         -- Options: 'nightfox', 'dayfox', 'dawnfox', 'duskfox', 'nordfox', 'terafox', 'carbonfox'
--         -- vim.cmd("colorscheme nightfox")
--         vim.cmd("colorscheme duskfox")
--         -- vim.cmd("colorscheme carbonfox")
--         -- vim.cmd("colorscheme nordfox")
--         -- vim.cmd("colorscheme terafox")
--     end,
-- }
