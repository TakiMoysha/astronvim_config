-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- WARN: issues
-- - don't working comments in templates
-- - https://github.com/vuejs/language-tools/wiki/Neovim

---@type LazySpec
return {
  -- { import = "astrocommunity.lsp.nvim-lsp-file-operations" },
  { import = "astrocommunity.pack.json" },
  -- =========================================================================================
  -- https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
  { import = "astrocommunity.pack.typescript" },
  -- =========================================================================================
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/vue/
  -- { import = "astrocommunity.pack.vue" },
  -- =========================================================================================
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      filetypes = {
        extension = {
          pcss = "postcss",
          postcss = "postcss",
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local astrocore = require "astrocore"
      local vue_plugin_service = {
        name = "@vue/language-service",
        location = vim.fn.stdpath "data" .. "/mason/packages/vue-language-server/node_modules/@vue/language-service",
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }
      local vue_plugin_ts = {
        name = "@vue/typescript-plugin",
        location = vim.fn.stdpath "data" .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }

      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        -- biome have experimental support vue, svelte and astro, see docs for more info
        biome = {
          capabilities = {
            general = { positionEncodings = { "utf-16" } },
          },
          -- formatter = {
          --   enabled = false,
          -- },
          -- linter = {
          --   enabled = false,
          -- },
        },

        ---@diagnostic disable: missing-fields
        ---@type lspconfig.options.vtsls
        vtsls = {
          filetypes = tsserver_filetypes,
          capabilities = {
            semanticTokensProvider = false,
          },
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "prompt" },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
              },
              globalPlugins = {},
            },
            vtsls = {
              enableMoveToFileCodeAction = true,
              tsserver = {
                globalPlugins = {
                  vue_plugin_service,
                  vue_plugin_ts,
                },
              },
            },
          },
        },

        ---@type lspconfig.options.volar
        volar = {
          filetypes = tsserver_filetypes,
          settings = {
            vue = {
              format = { enabled = false }, -- use prettier or biome
              diagnostic = { enabled = true, enable_tailwind = true },
              inlayHints = {
                destructuredProps = true,
                inlineHandlerLeading = true,
                missingProps = true,
                optionsWrapper = true,
                vBindShorthand = true,
              },
            },
          },

          on_init = function(client)
            client.handlers["tsserver/request"] = function(_, result, context)
              local vtsls_clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }

              if #vtsls_clients == 0 then
                vim.notify(
                  "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                  vim.log.levels.ERROR
                )
                return
              end
              local ts_client = vtsls_clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = "vue_request_forward", -- command name in the UI, `:h Client:exec_cmd`
                command = "typescript.tsserverRequest",
                arguments = { command, payload },
              }, { bufnr = context.bufnr }, function(err, r)
                -- NOTE: if err or r is nil value, then return nil back (memory leak prevent)
                if err then
                  vim.notify("error: " .. vim.inspect(err), vim.log.levels.ERROR, { title = "AstroLSP" })
                  return
                end

                if not r then return end

                -- vim.notify("response: " .. vim.inspect(r), vim.log.levels.DEBUG, { title = "Volar Debug on_init" })
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify("tsserver/response", response_data)
              end)
            end
          end,
        },
      })
    end,
  },

  -- formatter for files
  {
    "stevearc/conform.nvim",
    -- biome or prettier
    -- event = { "BufWritePre" },
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { formatter = "oxfmt" },
        javascriptreact = { formatter = "oxfmt" },
        typescript = { formatter = "oxfmt" },
        typescriptreact = { formatter = "oxfmt" },
        vue = { formatter = "oxfmt" },
        css = { formatter = "oxfmt" },
        scss = { formatter = "oxfmt" },
        html = { formatter = "oxfmt" },
        json = { formatter = "oxfmt" },
        jsonc = { formatter = "oxfmt" },
      })
    end,

    format_on_save = {
      format_on_save = false,
      lsp_fallback = false, -- if lsp is not available
      async = false,
    },
  },
  -- testing: TODO: how to
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "nvim-neotest/neotest-jest" },
      { "nvim-neotest/neotest-vue" },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require "neotest-jest" {
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }
      )
      table.insert(opts.adapters, require "neotest-vue")
    end,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  -- =========================================================================================
  -- installation lsp servers,

  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   optional = true,
  --   dependencies = {
  --     { "AstroNvim/astrolsp", opts = {} },
  --   },
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "volar" })
  --   end,
  -- },
  -- no-lsp tools installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vtsls",
        "vue-language-server", -- volar
        "js-debug-adapter",
        "prettierd",
        "biome",
        "oxlint",
        "oxfmt",
      })
    end,
  },
  -- compatibility with null-ls and mason (wrapper around cli tools without lsp)
  -- biome have lsp
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
  --   end,
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
          "typescript",
          "javascript",
          "astro",
          "vue",
          "tsx",
          "jsdoc",
          "html",
          "css",
          "scss",
          "styled",
        })
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "js" })
    end,
  },
}
