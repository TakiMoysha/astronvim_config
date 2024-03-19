return {
  { "EdenEast/nightfox.nvim" },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "Exafunction/codeium.vim",
    event = "User AstroFile",
    config = function()
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("n", "<leader>;", function()
        if vim.g.codeium_enabled == true then
          vim.cmd "CodeiumDisable"
        else
          vim.cmd "CodeiumEnable"
        end
      end, { noremap = true, desc = "Toggle Codeium active" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "User AstroFile",
    cmd = { "TodoQuickFix" },
    keys = {
      { "<leader>fd", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

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
}
