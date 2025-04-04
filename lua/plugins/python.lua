return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        basedpyright = {
          before_init = function(_, config)
            if not config.settings then config.settings = {} end
            if not config.settings.python then config.settings.python = {} end
            config.settings.python.pythonPath = vim.fn.exepath "python"
          end,

          settings = {
            basedpyright = {
              -- analysis = {
              --   typeCheckingMode = "basic",
              --   autoImportCompletions = true,
              --   diagnosticSeverityOverrides = {
              --     reportUnusedImport = "information",
              --     reportUnusedFunction = "information",
              --     reportUnusedVariable = "information",
              --     reportGeneralTypeIssues = "none",
              --     reportOptionalMemberAccess = "none",
              --     reportOptionalSubscript = "none",
              --     reportPrivateImportUsage = "none",
              --   },
              -- },

              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportUnusedFunction = "none",
                  reportUnusedVariable = "none",
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },

          ruff = {
            on_attach = function(client) client.server_capabilities.hoverProvider = false end,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "basedpyright", "ruff" })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(
        function(v) return not vim.tbl_contains({ "black", "isort" }, v) end,
        opts.ensure_installed
      )
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "python" })
      if not opts.handlers then opts.handlers = {} end
      opts.handlers.python = function() end -- make sure python doesn't get set up by mason-nvim-dap, it's being set up by nvim-dap-python
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "ruff", "basedpyright", "black", "isort", "debugpy" }
      )
      opts.ensure_installed = vim.tbl_filter(
        function(v) return not vim.tbl_contains({ "black", "isort" }, v) end,
        opts.ensure_installed
      )
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
    dependencies = {
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
            },
          },
        },
      },
    },
    opts = {
      auto_refresh = true,
      -- search = true,
      -- -- search_venv_managers = true,
      -- name = { "venv", "env", ".venv" },
    },
    cmd = "VenvSelect",
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python", -- NOTE: ft: lazy-load on filetype
        config = function(_, opts)
          local path = vim.fn.exepath "python"
          local debugpy = require("mason-registry").get_package "debugpy"
          if debugpy:is_installed() then
            path = debugpy:get_install_path()
            if vim.fn.has "win32" == 1 then
              path = path .. "/venv/Scripts/python"
            else
              path = path .. "/venv/bin/python"
            end
          end
          require("dap-python").setup(path, opts)
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "nvim-neotest/neotest-python", config = function() end },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-python"(require("astrocore").plugin_opts "neotest-python"))
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format", "isort", "black" },
      },
    },
  },
}
