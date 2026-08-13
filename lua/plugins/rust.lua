-- TODO: inspect
---@module "rust"
---@class plugins.rust.config: AstroLSPOpts

---@type LazySpec
return {
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/rust/init.lua
  { import = "astrocommunity.pack.rust" },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "tombi",
        "taplo",
        "codelldb",
        "rust-analyzer",
      })
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    keys = {
      { "<Leader>C", desc = "Crates" },
      { "<Leader>Cr", function() require("crates").reload() end, desc = "Reload crates" },
      { "<Leader>Cu", function() require("crates").update_crate() end, desc = "Update crate" },
      { "<Leader>CU", function() require("crates").upgrade_crate() end, desc = "Upgrade crate" },
      { "<Leader>CH", function() require("crates").show_versions_popup() end, desc = "Show crate versions" },
      { "<Leader>Cc", function() require("crates").show_features_popup() end, desc = "Show crate features" },
      { "<Leader>Cd", function() require("crates").show_dependencies_popup() end, desc = "Show crate dependencies" },
    },
  },
}
