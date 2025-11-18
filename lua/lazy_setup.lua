require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^5", -- Remove version tracking to elect for nightly AstroNvim
    import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the `import` key
      mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
      maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
      icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
      pin_plugins = nil, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
      update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
      -- guifont = "JetBrainsMono Nerd Font:h9", -- The font used in graphical neovim applications
      -- guifont = "FiraCode Nerd Font Mono:h9", -- The font used in graphical neovim applications
      -- guifont = "Iosevka Nerd Font Regular:h10", -- The font used in graphical neovim applications
      -- guifont = "GohuFont 14 Nerd Font Mono:h9", -- The font used in graphical neovim applications
      -- guifont = "BlexMono Nerd Font:h9", -- The font used in graphical neovim applications
      -- guifont = "Terminess Nerd Font Propo:h10", -- The font used in graphical neovim applications
      -- guifont = "Source Code Pro:h12", -- The font used in graphical neovim applications
      -- guifont = "Terminess Nerd Font:h10", -- The font used in graphical neovim applications
      guifont = "Terminess Nerd Font:h10", -- The font used in graphical neovim applications
    },
  },
  { import = "community" },
  { import = "plugins" },
} --[[@as LazySpec]], {
  -- Configure any other `lazy.nvim` configuration options here
  install = { colorscheme = { "duskfox", "astrodark", "carbonfox" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]])
