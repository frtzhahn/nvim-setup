return
{
  "folke/persistence.nvim",
  event = "BufReadPre", -- Automatically saves sessions when a file is opened
  opts = {
    options = { "buffers", "curdir", "tabpages", "winsize" },
  },
}
