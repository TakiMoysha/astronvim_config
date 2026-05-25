-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- TODO: inspect
---@module "rust"
---@class plugins.rust.config: AstroLSPOpts

---@type LazySpec
return {
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/rust/init.lua
  { import = "astrocommunity.pack.rust" },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    ---@diagnostic disable: missing-fields
    opts = {
      config = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = { ".direnv", ".git", "target" },
              },
              check = { command = "clippy", extraArgs = { "--no-deps" } },
              inlayHints = {
                maxLength = 24,
                closureReturnTypeHints = { enable = "with_block" },
                typeHints = { enable = true, hideClosureInitialization = true },
                expressionAdjustmentHints = { enable = "reborrow", hideOutsideUnsafe = true },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              },
              runnables = {},
              lens = {
                enable = true,
                run = { enable = false },
                debug = { enable = false },
                updateTest = { enable = true },
                references = false,
                implementations = { enable = false },
              },
              completion = { postfix = { enable = true } },
              imports = {
                granularity = { enforce = true },
                prefix = "self",
              },
              procMacro = { enable = true },
              rustfmt = { extraArgs = { "+nightly" } },
              workspace = {
                symbol = { search = { kind = "all_symbols", limit = 512 } },
              },
            },
          },
        },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "tombi",
        "taplo",
        "codelldb",
        "rust-analyzer",
      })
    end,
  },
}
