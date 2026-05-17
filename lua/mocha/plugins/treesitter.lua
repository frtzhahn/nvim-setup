return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- CRITICAL: Switch to the 0.12+ branch
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup({})
      ts.install({
        'bash', 'c', 'diff', 'html', 'lua', 'markdown', 
        'markdown_inline', 'query', 'vim', 'vimdoc',
        'javascript', 'typescript'
      })
      -- Enable Highlighting natively
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if lang and ts.get_installed(lang) then
            pcall(vim.treesitter.start)
          end
        end,
      })
    end,
  },
}
