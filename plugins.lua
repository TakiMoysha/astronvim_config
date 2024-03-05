local utils = require "astronvim.utils"
return {
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.pack.toml" },
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.pack.python-ruff" },
    { import = "astrocommunity.pack.vue" },
    { import = "astrocommunity.pack.typescript" },
    -- { import = "astrocommunity.pack.typescript-all-in-one" },
    { import = "astrocommunity.pack.astro" },
    { import = "astrocommunity.pack.docker" },
  },
  { 
    "Exafunction/codeium.vim",
    event = "User AstroFile",
    config = function()
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set("n", "<leader>;", function()
        if vim.g.codeium_enabled == true then
          vim.cmd "CodeiumDisable"
        else
          vim.cmd "CodeiumEnable"
        end
      end, { noremap = true, desc = "Toggle Codeium active" })
    end
  },
  { "EdenEast/nightfox.nvim" },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.section.header.val = {
        " .oooooo..o ooooo   ooooo       .o.       ooooo          .oooooo.   ooo        ooooo",
        "d8P'    `Y8 `888'   `888'      .888.      `888'         d8P'  `Y8b  `88.       .888'",
        "Y88bo.       888     888      .8'888.      888         888      888  888b     d'888 ",
        " `'Y8888o.   888ooooo888     .8' `888.     888         888      888  8 Y88. .P  888 ",
        "     `'Y88b  888     888    .88ooo8888.    888         888      888  8  `888'   888 ",
        "oo     .d8P  888     888   .8'     `888.   888       o `88b    d88'  8    Y     888 ",
        "8''88888P'  o888o   o888o o88o     o8888o o888ooooood8  `Y8bood8P'  o8o        o888o",
      }
      return opts
    end,
  },
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
    end
  },
  {
    "rcarriga/nvim-notify",
    opts =  {
      top_down = false,
    }
  },
}
