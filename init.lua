-- Polyfill for Telescope/Treesitter compatibility in Neovim 0.12+
if not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = function(ft)
    return vim.treesitter.language.get_lang(ft) or ft
  end
end

require 'mocha.options'
require 'mocha.keymaps'
vim.opt.mouse = ""

-- =============================
-- Lazy Package Manager
-- =============================

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        -- cond = function()
        --   return vim.fn.executable 'make' == 1
        -- end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'

      -- https://github.com/MagicDuck/grug-far.nvim/pull/305
      local is_windows = vim.fn.has 'win64' == 1 or vim.fn.has 'win32' == 1
      local vimfnameescape = vim.fn.fnameescape
      local winfnameescape = function(path)
        local escaped_path = vimfnameescape(path)
        if is_windows then
          local need_extra_esc = path:find '[%[%]`%$~]'
          local esc = need_extra_esc and '\\\\' or '\\'
          escaped_path = escaped_path:gsub('\\[%(%)%^&;]', esc .. '%1')
          if need_extra_esc then
            escaped_path = escaped_path:gsub("\\\\['` ]", '\\%1')
          end
        end
        return escaped_path
      end

      local select_default = function(prompt_bufnr)
        vim.fn.fnameescape = winfnameescape
        local result = actions.select_default(prompt_bufnr, 'default')
        vim.fn.fnameescape = vimfnameescape
        return result
      end

      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              ['<cr>'] = select_default,
              ['<c-d>'] = actions.delete_buffer,
            },
            n = {
              ['<cr>'] = select_default,
              ['<c-d>'] = actions.delete_buffer,
              ['dd'] = actions.delete_buffer,
            },
          },
          file_ignore_patterns = { 'node_modules', '.next', '.git' },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      -- pcall(require('telescope').load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

			local map = vim.keymap.set
			-- [[ Window Navigation for Systems Mastery ]]
			map('n', '<leader>wh', '<C-w>h', { desc = 'Move focus [W]indow [H]eft (Left)' })
			map('n', '<leader>wl', '<C-w>l', { desc = 'Move focus [W]indow [L]ight (Right)' })
			map('n', '<leader>wk', '<C-w>k', { desc = 'Move focus [W]indow [K]up (Up)' })
			map('n', '<leader>wj', '<C-w>j', { desc = 'Move focus [W]indow [J]own (Down)' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  require 'mocha.plugins.lualine',
  require 'mocha.plugins.neotree',
  require 'mocha.plugins.cord',
  require 'mocha.plugins.lsp',
  require 'mocha.plugins.cmp',
  require 'mocha.plugins.wakatime',
  require 'mocha.plugins.bufferline',
  require 'mocha.plugins.oil',
  -- require 'mocha.plugins.indents',
  require 'mocha.plugins.themes',
  require 'mocha.plugins.live-server',
  require 'mocha.plugins.cake',
  require 'mocha.plugins.wrapped',
  require 'mocha.plugins.dap',
  require 'mocha.plugins.treesitter',
})


  --wakatime
--require("lazy").setup({
    -- other plugins...

--    { "wakatime/vim-wakatime", lazy = false },
--})


local map = vim.keymap.set
local opts = { silent = true }

-- Horizontal split terminal
map('n', '<Leader>ht', ':split | terminal<CR>', opts)

-- Vertical split terminal
map('n', '<Leader>tv', ':vsplit | terminal<CR>', opts)

-- Floating terminal
-- map('n', '<Leader>tf', function()
--   vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
--     relative = 'editor',
--     width = math.floor(vim.o.columns * 0.8),
--     height = math.floor(vim.o.lines * 0.8),
--     row = math.floor(vim.o.lines * 0.1),
--     col = math.floor(vim.o.columns * 0.1),
--     style = 'minimal',
--     border = 'rounded',
--   })
--   vim.cmd('terminal')
-- end, opts)


local float_term_win

map('n', '<Leader>tf', function()
  local buf = vim.api.nvim_create_buf(false, true)
  float_term_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
  })
  vim.cmd('terminal')
end, opts)



map('n', '<Leader>tj', function()
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    vim.api.nvim_set_current_win(float_term_win)
  end
end, opts)



-- Navigate between splits (normal + terminal mode)
map({'n', 't'}, '<C-h>', '<C-\\><C-N><C-w>h', opts)
map({'n', 't'}, '<C-j>', '<C-\\><C-N><C-w>j', opts)
map({'n', 't'}, '<C-k>', '<C-\\><C-N><C-w>k', opts)
map({'n', 't'}, '<C-l>', '<C-\\><C-N><C-w>l', opts)

-- Close current split
map('n', '<Leader>q', ':close<CR>', opts)


-- Horizontal empty split
map('n', '<Leader>hs', ':new<CR>', opts)

-- Vertical empty slit
map('n', '<Leader>vs', ':vnew<CR>', opts)

vim.api.nvim_set_option("clipboard", "unnamedplus")


	-- [[ ARCHITECTURAL POLYFILL ]]
	-- Fixes Telescope for Neovim 0.12+
	vim.treesitter.ft_to_lang = function(ft)
		return vim.treesitter.language.get_lang(ft) or ft
	end

local map = vim.keymap.set

map("n", "<F6>", function()
    local file = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")
    local filetype = vim.bo.filetype
    local basename = vim.fn.expand("%:t:r")
    local dir = vim.fn.fnamemodify(file, ":h")

    if filename == "" then
        print("Save the file first.")
        return
    end

    local cmd = nil

    if filetype == "java" then
        cmd = string.format('kitty --hold sh -c "cd %s && javac %s && java %s"', dir, filename, basename)
    elseif filetype == "c" then
        cmd = string.format('kitty --hold sh -c "cd %s && gcc %s -o %s && ./%s"', dir, filename, basename, basename)
    elseif filetype == "cpp" then
        cmd = string.format('kitty --hold sh -c "cd %s && g++ %s -o %s && ./%s"', dir, filename, basename, basename)
    elseif filetype == "python" then
        cmd = string.format('kitty --hold sh -c "python3 %s"', filename)
    elseif filetype == "javascript" then
        cmd = string.format('kitty --hold sh -c "node %s"', filename)
    elseif filetype == "typescript" then
        cmd = string.format('kitty --hold sh -c "ts-node %s"', filename)
    elseif filetype == "sh" then
        cmd = string.format('kitty --hold sh -c "bash %s"', filename)
    elseif filetype == "lua" then
        cmd = string.format('kitty --hold sh -c "lua %s"', filename)
    elseif filetype == "go" then
        cmd = string.format('kitty --hold sh -c "go run %s"', filename)
    else
        print("Unsupported filetype: " .. filetype)
        return
    end
    vim.fn.jobstart({"sh", "-c", cmd})
end)



