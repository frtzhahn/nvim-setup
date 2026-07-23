return {
  -- 1. Custom Mason Registry declaration for Roslyn server installation
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },

  -- 2. seblyng/roslyn.nvim setup
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = { "williamboman/mason.nvim" },
    init = function()
      local map = vim.keymap.set

      -- Compile/Build keymap using Neovim's compiler infrastructure
      map('n', '<leader>mb', function()
        vim.cmd('silent! wa')
        vim.cmd('compiler dotnet')
        vim.cmd('make build')
        vim.cmd('copen')
      end, { desc = 'Dotnet: [M]ake/[B]uild' })

      -- Helper to run commands in horizontal split terminal
      local function run_dotnet(args)
        vim.cmd('silent! wa')
        vim.cmd('botright split | terminal dotnet ' .. args)
        vim.cmd('startinsert')
      end

      -- Run keymap
      map('n', '<leader>mr', function()
        run_dotnet('run')
      end, { desc = 'Dotnet: Run project' })

      -- Test keymap
      map('n', '<leader>mt', function()
        run_dotnet('test')
      end, { desc = 'Dotnet: Test project' })
    end,
    opts = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      return {
        filewatching = "off", -- Crucial dual-core CPU performance tweak
        broad_search = false,
        lock_target = false,
        exe = {
          vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec", "Microsoft.CodeAnalysis.LanguageServer")
        },
        config = {
          capabilities = capabilities,
        },
      }
    end,
  },

  -- 3. stevearc/conform.nvim setup
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = function(bufnr)
          local global_path = vim.fn.expand("~/.dotnet/tools/dotnet-csharpier")
          local cmd = "dotnet-csharpier"
          if vim.fn.executable(global_path) == 1 then
            cmd = global_path
          else
            local global_path_alt = vim.fn.expand("~/.dotnet/tools/csharpier")
            if vim.fn.executable(global_path_alt) == 1 then
              cmd = global_path_alt
            end
          end
          return {
            command = cmd,
          }
        end,
      },
    },
  },

  -- 4. nicholasmata/nvim-dap-cs setup
  {
    "nicholasmata/nvim-dap-cs",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local ok, dap_cs = pcall(require, "dap-cs")
      if ok then
        dap_cs.setup({
          netcoredbg = {
            path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
          }
        })
      end
    end,
  },

  -- 5. dtrh95/csharp-explorer.nvim setup
  {
    "dtrh95/csharp-explorer.nvim",
    dependencies = {
      "nvim-tree/nvim-tree.lua",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "CSharpExplorerToggle", "CSharpExplorerFindFile" },
    keys = {
      { "<leader>cs", "<cmd>CSharpExplorerToggle<cr>", desc = "Toggle C# Explorer" },
    },
    opts = {},
  },
}
