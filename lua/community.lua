-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.snippet.nvim-snippets" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.toml" },
  -- { import = "astrocommunity.pack.python-ruff" }, -- -> plugins/python.lua
  { import = "astrocommunity.pack.rust" },
  -- { import = "astrocommunity.pack.typescript-all-in-one" }, -- -> plugins/javascript.lua
  -- { import = "astrocommunity.pack.vue" }, -- -> plugins/javascript.lua
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.just" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.editing-support.multicursors-nvim" },
  -- { import = "astrocommunity.completion.codeium-vim" }, -- -> plugins/codeium.lua
}
