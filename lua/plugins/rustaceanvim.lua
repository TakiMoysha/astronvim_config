-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize RustaceanVim
-- TODO: after update nvim to ^0.10: up version ^3 -> ^4 and remove other

---@type LazySpec
return {
  'mrcjkb/rustaceanvim',
  version = '^3', -- Recommended
  dependencies = {
    -- "nvim-lua/plenary.nvim",
    -- "mfussenegger/nvim-dap",
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {}
    },
  },
  ft = { "rust", },
  config = function()
    vim.g.rustaceanvim = {
      -- inlay_hints = {
        -- highlight = "NonText",
      -- },
      -- tools = {
      --   hover_actions = {
      --     auto_focus = true,
      --   },
      -- },
      server = {
        on_attach = function(client, bufnr)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end
      }
    }
  end
}
