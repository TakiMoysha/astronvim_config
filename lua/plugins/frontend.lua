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
  { import = "astrocommunity.pack.vue" },
  -- =========================================================================================

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        volar = { filetypes = { "vue" } },
      })
    end,
  },
  -- formatter for files
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
  -- testing: TODO: how to
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "nvim-neotest/neotest-jest" },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require "neotest-jest" {
          jestCommand = "bun test --",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }
      )
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
  --   "mason-org/mason-lspconfig.nvim",
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
        "oxlint",
        "oxfmt",
      })
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
