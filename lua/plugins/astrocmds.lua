return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        just_as_make = {
          {
            event = "BufReadPost",
            pattern = "*",
            desc = "Set just as :make if workdir have justfile",
            callback = function()
              local justfile = vim.fn.findfile("justfile", ".;")
              if justfile ~= "" then vim.bo.makeprg = "just" end
            end,
          },
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
}
