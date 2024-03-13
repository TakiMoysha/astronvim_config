return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.file_ignore_patterns = {
        "node_modules",
        "package%-lock.json",
        "yarn.lock",
        ".git",
        ".cache",
      }
      return opts
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = { top_down = false },
  },
  -- {
    -- "neovim/nvim-lspconfig",
    -- lazy = false,
    -- config = function()
    --   require("lspconfig").tsserver.setup {
    --     init_options = {
    --       plugins = {
    --         {
    --           name = "@vue/typescript-plugin",
    --           location = "/usr/lib/node_modules/@vue/typescript-plugin",
    --           languages = { "typescript", "javascript", "vue" },
    --         },
    --       },
    --     },
    --     filetypes = {
    --       "typescript",
    --       "javascript",
    --       "vue",
    --     }
    --   }
    -- end,
  -- },
}
