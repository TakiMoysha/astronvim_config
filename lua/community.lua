-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.indent.snacks-indent-hlchunk" }, -- scope indent highlight

  { import = "astrocommunity.motion.nvim-surround" },         -- https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/motion/nvim-surround
  { import = "astrocommunity.snippet.mini-snippets" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.night-owl-nvim" },

  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.typst" },
  { import = "astrocommunity.pack.just" },

  { import = "astrocommunity.test.neotest" },

  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" },

  { import = "astrocommunity.utility.live-preview" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" }, -- ?

  -- { import = "astrocommunity.media.pets-nvim" },
}
