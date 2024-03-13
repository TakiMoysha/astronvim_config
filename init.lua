local utils = require "astronvim.utils"

return {
  colorscheme = "duskfox",

  diagnostics = {
    underline = true,
    virtual_text = true,
  },

  lsp = {
    tsserver = {
      setup = function(opts)
        opts.plugins = {
          {
            name = "@vue/typescript-plugin",
            languages = { "javascript", "typescript", "vue" },
          },
        }
      end,
    },
  },

  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "tohtml",
          "gzip",
          "matchit",
          "zipPlugin",
          "netrwPlugin",
          "tarPlugin",
        },
      },
    },
  },

  polish = function() end,
}
