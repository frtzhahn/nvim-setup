return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {},
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'LspInfo', 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate', 'MasonToolsInstall', 'MasonToolsUpdate' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', event = 'LspAttach', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- LSP Symbol navigation via Snacks.picker with graceful fallback to native LSP
          local has_snacks, snacks = pcall(require, "snacks")
          if has_snacks and snacks.picker then
            map("gd", function() snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")
            map("gr", function() snacks.picker.lsp_references() end, "[G]oto [R]eferences")
            map("gI", function() snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
            map("<leader>D", function() snacks.picker.lsp_type_definitions() end, "Type [D]efinition")
            map("<leader>ds", function() snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")
            map("<leader>ws", function() snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")
          else
            map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
            map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
            map("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gh', vim.lsp.buf.hover, '[G]oto [H]over Documentation')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = false }),
              buffer = event.buf,
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Broadcast completion capabilities globally to all LSP clients via Neovim 0.12 wildcard config
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
      local tsserver_path = mason_pkgs .. '/typescript-language-server/node_modules/typescript/lib'

      vim.lsp.config('vue_ls', {
        cmd = { 'vue-language-server', '--stdio' },
        init_options = {
          typescript = {
            tsdk = tsserver_path,
          },
        },
      })

      local servers = {
        ts_ls = {},
        tailwindcss = {},
        cssls = {},
        pyright = {},
        html = {},

        lemminx = {
          filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg', 'fxml' },
        },

        lua_ls = {
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(fname, {
              '.git',
              'stylua.toml',
              '.stylua.toml',
              'selene.toml',
              'selene.yml',
              '.luarc.json',
              '.luarc.jsonc',
              'init.lua',
            })
            local dir = root or vim.fs.dirname(fname)
            if dir and dir ~= vim.env.HOME then
              on_dir(dir)
            end
          end,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        jsonls = {},
        stylelint_lsp = {},
        eslint = {},
        dockerls = {},
        clangd = {},
      }

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prettierd',
        'prettier',
        'jdtls',
        'java-debug-adapter',
        'java-test',
      })
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
        run_on_start = false,
      }

      -- 1. Register custom server overrides natively
      for server_name, server_config in pairs(servers) do
        if next(server_config) ~= nil then
          vim.lsp.config(server_name, server_config)
        end
      end

      -- 2. Setup mason-lspconfig and exclude jdtls from automatic activation
      require('mason-lspconfig').setup {
        automatic_enable = {
          exclude = { 'jdtls', 'omnisharp' }
        }
      }
    end,
  },
}

