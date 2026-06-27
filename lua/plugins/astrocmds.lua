return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      commands = {
        Just = {
          desc = "Run just and populate quickfix like :make",
          nargs = "*",
          function(opts)
            local args = opts.args:gsub("'", "'\\''")
            vim.cmd("cexpr system('just " .. args .. "')")
            vim.cmd "copen"
          end,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      automcds = {},
    },
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        just_abbrev = {
          {
            event = "VimEnter",
            desc = "Abbreviate :just to :Just",
            callback = function()
              vim.cmd "cnoreabbrev <expr> just getcmdtype() == ':' && getcmdline() == 'just' ? 'Just' : 'just'"
            end,
          },
        },
      },
    },
  },
}
