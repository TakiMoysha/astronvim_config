-- Customize Mason plugins
-- https://github.com/mason-org/mason-registry
-- https://mason-registry.dev/registry/list

--   "williamboman/mason-lspconfig.nvim",
--   "jay-babu/mason-null-ls.nvim",
--   "jay-babu/mason-nvim-dap.nvim",

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        -- # rust
        "tombi",
        "prettierd",
        -- # lua
        "lua-language-server",
        "stylua",
        -- #
        "biome", -- TODO: migrate to biome, https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#biome
        "prettierd", -- formatter, mostly for js
        "typos-lsp", -- linting spellcheck
      },
    },
  },
}
