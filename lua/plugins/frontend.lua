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
      local vtsls_ft = require("astrocore").list_insert_unique(
        vim.tbl_get(opts, "config", "vtsls", "filetypes")
        or { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        { "vue" }
      )
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        vtsls = {
          filetypes = vtsls_ft,
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {},
              },
            },
            -- typescript = {
            --   suggest = {
            --     autoImports = false, -- no resolve autoimports
            --     includePackageJsonAutoImports = "off", -- no scan package.json
            --     includeCompletionsForModuleExports = false, --
            --     completeFunctionCalls = false, -- no arguments
            --   },
            -- },
            -- javascript = {
            --   suggest = {
            --     autoImports = false,
            --     includePackageJsonAutoImports = "off",
            --     includeCompletionsForModuleExports = false,
            --     completeFunctionCalls = false,
            --   },
            -- },
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
              require("astrocore").list_insert_unique(
                config.settings.vtsls.tsserver.globalPlugins,
                { vue_plugin_config }
              )
            end
          end,
        },
        -- volar = {
        --   filetypes = { "vue" },
        --   on_init = function(client)
        --     client.handlers["tsserver/request"] = function(_, result, context)
        --       local ts_client = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
        --       if #ts_client == 0 then return end
        --       local param = unpack(result)
        --       local id, command, payload = unpack(param)
        --       ts_client[1]:exec_cmd({
        --         title = "vue_request_forward",
        --         command = "typescript.tsserverRequest",
        --         arguments = { command, payload },
        --       }, { bufnr = context.bufnr }, function(_, r)
        --         client:notify("tsserver/response", { { id, r.body } })
        --       end)
        --     end
        --   end,
        -- },
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
        -- "vue-language-server", -- volar
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
