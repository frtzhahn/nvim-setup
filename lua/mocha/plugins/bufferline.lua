return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>dp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>dP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>do", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>dr", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>dl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[d", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]d", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  opts = {
    options = {
        -- This makes it look like VS Code
      mode = "buffers", 
      -- Show icons? (Requires a Nerd Font)
      show_buffer_close_icons = true,
      show_close_icon = true,
      always_show_bufferline = false,
      diagnostics = "nvim_lsp", -- Show error icons in the tab?
    },
  },
}
