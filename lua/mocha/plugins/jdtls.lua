return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function()
    local function setup_jdtls()
      local mason_path = vim.fn.stdpath('data') .. '/mason'
      local jdtls_bin = mason_path .. '/bin/jdtls'

      -- Find project root (prioritize build specs; fallback to local directory for standalone DSA exercises)
      local root_dir = require('jdtls.setup').find_root({ 'pom.xml', 'gradlew', '.mvn' })
      if root_dir == "" or root_dir == nil then
        local current_file = vim.api.nvim_buf_get_name(0)
        if current_file ~= "" then
          root_dir = vim.fs.dirname(current_file)
        else
          return
        end
      end

      -- Create a unique workspace directory for each project
      local project_name = vim.fn.fnamemodify(root_dir, ':t')
      local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name

      -- Find debug/test bundles if they exist
      local bundles = {}
      local java_dbg_path = vim.fn.glob(mason_path .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true)
      if java_dbg_path ~= "" then
        table.insert(bundles, java_dbg_path)
      end

      local java_test_path = vim.fn.glob(mason_path .. '/packages/java-test/extension/server/com.microsoft.java.test.plugin-*.jar', true)
      if java_test_path ~= "" then
        table.insert(bundles, java_test_path)
      end

      local config = {
        cmd = {
          jdtls_bin,
          '-data', workspace_dir,
        },
        root_dir = root_dir,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*"
              },
              filteredTypes = {
                "com.sun.*",
                "sun.*",
                "jdk.*",
                "org.graalvm.*",
                "kotlin.jvm.internal.*"
              }
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}[#memberFields]"
              },
              useBlocks = true,
            },
          }
        },
        init_options = {
          bundles = bundles
        },
        on_attach = function(client, bufnr)
          -- Register DAP configurations with JDTLS
          require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        end
      }

      -- Merge capabilities with cmp if available
      local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_ok then
        config.capabilities = vim.tbl_deep_extend('force', config.capabilities, cmp_lsp.default_capabilities())
      end

      require('jdtls').start_or_attach(config)
    end

    -- Run setup_jdtls when opening a Java file
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = setup_jdtls,
    })

    -- Trigger setup for the current buffer if it is already open and is a java file
    if vim.bo.filetype == 'java' then
      setup_jdtls()
    end
  end
}
