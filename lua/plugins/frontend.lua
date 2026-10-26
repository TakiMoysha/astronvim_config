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
          -- hybrid mode: vue_ls отвечает за template/css, vtsls (с @vue/typescript-plugin) — за script.
          -- NOTE: on_init-форвардинг tsserver/request НЕ переопределяем: стоковый nvim-lspconfig/lsp/vue_ls.lua
          -- уже содержит его, причем с retry (10x100мс пока vtsls аттачится) и nil-safe `r and r.body`.
          -- Кастомный on_init без retry ломал подсказки в .vue, если vue_ls стартовал раньше vtsls.
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
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = false },
                  propertyDeclarationTypes = { enabled = false },
                  variableTypes = { enabled = true },
                },
                suggest = {
                  autoImports = true,
                  completeFunctionCalls = false,
                },
                preferences = {
                  -- "off" убивает подсказки символов из node_modules (watch, defineModel из 'vue',
                  -- Nuxt-автоимпорты) пока нет ручного import. Для perf не отключать, дефолт tsserver — "auto".
                  includePackageJsonAutoImports = "auto",
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
                  -- см. коммент выше: "off" ломает auto-import подсказки из node_modules
                  includePackageJsonAutoImports = "auto",
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
                  -- путь через mason-registry уважает кастомный install_root_dir,
                  -- в отличие от vim.fn.expand "$MASON/..." (зависит от порядка mason.setup())
                  location = registry.get_package("vue-language-server"):get_install_path()
                    .. "/node_modules/@vue/language-server",
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
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "html",
        "json",
        "jsonc",
      } do
        opts.formatters_by_ft[ft] = { "oxfmt" }
      end
      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, {
        lsp_format = "never",
        timeout_ms = 1500,
      })
      -- Автоформат на :w выключен. Форматируешь вручную:
      -- <Leader>lf / :Format (через conform → oxfmt, LSP-формат отключен) или require("conform").format()
      opts.format_on_save = false
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
  -- имена здесь — Mason-имена (registry), не lspconfig-имена:
  -- "vue-language-server" (Mason) == "vue_ls" (lspconfig/mason-lspconfig)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- only ensure if it installed (not setup)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
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
  -- NOTE: mason-null-ls удален: none-ls.nvim отключен (lua/plugins/none-ls.lua),
  -- oxlint работает как нативный LSP (см. mason-lspconfig выше).
}
