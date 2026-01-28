-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        basedpyright = {
          -- before_init = function(_, config)
          --   if not config.settings then config.settings = {} end
          --   if not config.settings.python then config.settings.python = {} end
          --   config.settings.python.pythonPath = vim.fn.exepath "python"
          -- end,

          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
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
            -- ruff = {},
          },

          ruff = {
            on_attach = function(client) client.server_capabilities.hoverProvider = false end,
          },
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "basedpyright",
      })
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

  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   --   enabled = vim.fn.executable "fd" == 1,
  --   -- cmd = "VenvSelect",
  --   opts = {
  --     search = {
  --       workspace = false,
  --     },
  --     -- TODO: added command
  --     -- commands = {
  --     --   VenvDeactivate = { function() require("venv-selector").deactivate() end, desc = "Deactivate VirtualEnv" },
  --     -- }
  --   },
  --   keys = {
  --     { "<leader>lv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
  --     { "<leader>l/d", "<cmd>:VenvDeactivate<cr>", desc = "Deactivate VirtualEnv" },
  --   },
  -- },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python", -- NOTE: ft: lazy-load on filetype
        config = function(_, opts)
          local path = vim.fn.exepath "debugpy-adapter"
          if path == "" then path = vim.fn.exepath "python" end
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
