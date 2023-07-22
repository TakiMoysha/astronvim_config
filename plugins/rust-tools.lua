return {
  { 
    'simrat39/rust-tools.nvim',
    -- after = { "nvim-lspconfig", "mason-lspconfig" },
    -- config = function()
    --   require("rust-tools").setup {
    --     server = astronvim.lsp.server_settings "rust_analyzer"
    --   }
    -- end,
    ft = "rust",
    -- cmd = { "RustRunnables", "RustEnableInlayHints", "RustDisableInlayHints", "RustSetInlayHints", "RustUnsetInlayHints" },
    opts = function(_, opts)
      local rt = require("rust-tools")
      rt.setup({
      -- rt.setup({
      --   server = {
      --     on_attach = function(_, bufnr)
      --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, {buffer = bufnr})
      --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr})
      --     end,
      --   }
      })
      -- require("rust-tools.inlay_hints").set_inlay_hints()
    end
  }
}

