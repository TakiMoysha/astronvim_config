-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- single LSP mode: only vtsls (no volar)

---@type LazySpec
return {
  -- =========================================================================================
  -- https://github.com/vuejs/language-tools/wiki/Neovim
  { import = "astrocommunity.pack.typescript" },
  -- =========================================================================================

  {
    "AstroNvim/astrocore",
    optional = true,
    opts = {
      treesitter = { ensure_installed = { "vue" } },
    },
  },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local astrocore = require "astrocore"
      local vtsls_ft = astrocore.list_insert_unique(vim.tbl_get(opts, "config", "vtsls", "filetypes") or {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      }, { "vue" })
      return astrocore.extend_tbl(opts, {
        ---@diagnostic disable: missing-fields
        config = {
          volar = {
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
                if #clients == 0 then
                  vim.notify(
                    "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                    vim.log.levels.ERROR
                  )
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = "typescript.tsserverRequest",
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response_data = { { id, r.body } }
                  client:notify("tsserver/response", response_data)
                end)
              end
            end,
          },
          vtsls = {
            filetypes = vtsls_ft,
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {},
                },
                typescript = {
                  suggest = {
                    autoImports = false,
                    includePackageJsonAutoImports = "off",
                    includeCompletionsForModuleExports = false,
                    completeFunctionCalls = false,
                  },
                },
                javascript = {
                  suggest = {
                    autoImports = false,
                    includePackageJsonAutoImports = "off",
                    includeCompletionsForModuleExports = false,
                    completeFunctionCalls = false,
                  },
                },
              },
            },
            before_init = function(_, config)
              local registry_ok, registry = pcall(require, "mason-registry")
              if not registry_ok then return end

              if registry.is_installed "vue-language-server" then
                local vue_plugin_config = {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                }

                astrocore.list_insert_unique(config.settings.vtsls.tsserver.globalPlugins, { vue_plugin_config })
              end
            end,
          },
        },
      })
    end,
  },
  -- -- formatter for files
  {
    "stevearc/conform.nvim",
    -- event = { "BufWritePre" },
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        vue = { "oxfmt" },
        css = { "oxfmt" },
        scss = { "oxfmt" },
        html = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
      })
    end,

    format_on_save = {
      format_on_save = false,
      lsp_fallback = false, -- if lsp is not available
      async = false,
    },
  },
  -- -- testing: TODO: how to
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = {
  --     { "nvim-neotest/neotest-jest" },
  --   },
  --   opts = function(_, opts)
  --     opts.adapters = opts.adapters or {}
  --     table.insert(
  --       opts.adapters,
  --       require "neotest-jest" {
  --         jestCommand = "bun test --",
  --         env = { CI = true },
  --         cwd = function() return vim.fn.getcwd() end,
  --       }
  --     )
  --   end,
  -- },
  -- {
  --   "vuki656/package-info.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = {},
  --   event = "BufRead package.json",
  -- },
  -- exclude noisy LSPs from auto-start (mason-lspconfig Neovim 0.11+)
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
          require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "volar", "oxlint" })
    end,
  },
  -- no-lsp tools installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- only ensure if it installed (not setup)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vtsls",
        "js-debug-adapter",
        "vue-language-server",
        "oxlint",
        "oxfmt",
      })
    end,
  },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "js" })
  --   end,
  -- },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "oxlint" })
    end,
  },
}
