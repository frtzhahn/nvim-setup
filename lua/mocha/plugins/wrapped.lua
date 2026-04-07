return {
  {
    "aikhe/wrapped.nvim",
    -- Plenary is usually already installed, but adding it here is safe
    dependencies = { "nvzone/volt", "nvim-lua/plenary.nvim" },
    cmd = { "NvimWrapped" },
    opts = {
      -- You can leave this empty {}, or add the "Default Config" items here
      border = true, -- I recommend true for a cleaner look
    	path = "/home/mocha/Documents/amoeba/",
      size = {
        width = 100,
        height = 30,
      },
      cap = {
        commits = 1000, -- It stops counting at 1000 to keep it fast
        plugins = 100,
      },
    },
  }
}

-- return {
--   "aikhe/wrapped.nvim",
--   dependencies = { "nvzone/volt", "nvim-lua/plenary.nvim" },
--   cmd = { "NvimWrapped" },
--   opts = {
--     path = "/home/mocha/Documents/programming/coding/java-programs"
--   },
-- }
