-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "markdown", "markdown_inline" } },
      filetypes = {
        extension = {
          mdx = "markdown.mdx",
        },
      },
      autocmds = {
        markdown_wrap = {
          {
            event = "FileType",
            pattern = { "markdown", "markdown.mdx" },
            desc = "Enable wrap for markdown",
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
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "marksman", "mdx_analyzer" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "marksman" })
    end,
  },
}
