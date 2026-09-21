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
        -- отключаем форматеры кроме oxfmt
        formatting = {
          disabled = {
            "vtsls",
            "vue_ls",
            "volar",
            "emmet_ls",
            "emmet_language_server",
            "html",
            "cssls",
            "jsonls",
          },
        },
        ---@diagnostic disable: missing-fields
        config = {
          -- on_init-форвардинг нужен именно на том ключе, который реально запускается.
          vue_ls = {
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
                experimental = {
                  maxInlayHintLength = 60,
                },
              },
              typescript = {
                -- для типов оставляем имена параметров и значения enum. Полный тип виден в hover (K).
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = false },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = false },
                  propertyDeclarationTypes = { enabled = false },
                  variableTypes = { enabled = false },
                },
                suggest = {
                  autoImports = true,
                  completeFunctionCalls = false,
                },
                preferences = {
                  includePackageJsonAutoImports = "off",
                },
              },
              javascript = {
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = false },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = false },
                  propertyDeclarationTypes = { enabled = false },
                  variableTypes = { enabled = false },
                },
                suggest = {
                  autoImports = true,
                  completeFunctionCalls = false,
                },
                preferences = {
                  includePackageJsonAutoImports = "off",
                },
              },
            },
            before_init = function(_, config)
              local registry_ok, registry = pcall(require, "mason-registry")
              if not registry_ok then return end

              if registry.is_installed "vue-language-server" then
                config.settings = config.settings or {}
                config.settings.vtsls = config.settings.vtsls or {}
                config.settings.vtsls.tsserver = config.settings.vtsls.tsserver or {}
                config.settings.vtsls.tsserver.globalPlugins = config.settings.vtsls.tsserver.globalPlugins or {}
                for _, p in ipairs(config.settings.vtsls.tsserver.globalPlugins) do
                  if p.name == "@vue/typescript-plugin" then return end
                end
                table.insert(config.settings.vtsls.tsserver.globalPlugins, {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                })
              end
            end,
          },
        },
      })
    end,
  },
  -- formatter: только oxfmt, без fallback на LSP (vtsls/vue_ls)
  {
    "stevearc/conform.nvim",
    optional = true,
    event = "User AstroFile",
    cmd = "ConformInfo",
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
      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, {
        lsp_format = "never",
        timeout_ms = 1500,
      })
      opts.format_on_save = {
        lsp_format = "never",
        timeout_ms = 1500,
      }
    end,
  },
  -- -- testing: TODO: find out how use 
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
      -- vue_ls — актуальное имя (volar — legacy). oxfmt/oxlint — LSP, тоже отсюда.
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "vue_ls", "oxfmt", "oxlint" })
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
