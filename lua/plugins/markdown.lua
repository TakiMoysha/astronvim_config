-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "markdown", "markdown_inline" } },
      autocmds = {
        markdown_wrap = {
          {
            event = "FileType",
            pattern = "markdown",
            callback = function() vim.opt_local.wrap = true end,
          },
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "marksman" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "marksman" })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    -- build = function() vim.fn["mkdp#util#install"]() end,
    build = "cd app && bun install",
    ft = { "markdown", "markdown.mdx" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    init = function()
      local plugin = require("lazy.core.config").spec.plugins["markdown-preview.nvim"]
      vim.g.mkdp_filetypes = require("lazy.core.plugin").values(plugin, "ft", true)
    end,
    dependencies = {
      { "AstroNvim/astroui", opts = { icons = { Markdown = "" } } },
      {
        "AstroNvim/astrocore",
        optional = true,
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>M"

          maps.n[prefix] = { desc = require("astroui").get_icon("Markdown", 1, true) .. "Markdown" }
        end,
      },
    },
  },
}
