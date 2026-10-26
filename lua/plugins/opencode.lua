-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE


-- WARN: monkey patch (`--port flag`)
local opencode_cmd = 'opencode'
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
    end,
  },
}
---@type LazySpec
return {
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/ai/opencode-nvim/init.lua

  {
    "NickvanDyke/opencode.nvim",
    version = ">=0.14",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = { input = { enabled = true }, picker = { enabled = true }, terminal = { enabled = true } },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local maps = assert(opts.mappings)

          -- with space in the end  - APPEND (added to current session), otherwise SUBMIT (immidiatly ask)
          local prefix = "<Leader>a"
          maps.n[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "AI" }
          maps.n[prefix .. "a"] = {
            function() require("opencode").ask "[@this]" end,
            desc = "Ask about this",
          }
          maps.n[prefix .. "+"] = {
            function() require("opencode").prompt "@buffer " end,
            desc = "Add buffer to prompt",
          }
          maps.n[prefix .. "e"] = {
            function() require("opencode").prompt "Explain @this and how fix/improve, " end,
            desc = "Explain and how fix/improve",
          }
          maps.n[prefix .. "n"] = {
            function() require("opencode").command "session.new" end,
            desc = "New session",
          }
          maps.n[prefix .. "s"] = {
            function() require("opencode").select() end,
            desc = "Select prompt",
          }
          maps.n[prefix .. "S"] = {
            function() require("opencode").command "session.select" end,
            desc = "Select session",
          }
          maps.n["<S-C-u>"] = {
            function() require("opencode").command "session.half.page.up" end,
            desc = "Messages half page up",
          }
          maps.n["<S-C-d>"] = {
            function() require("opencode").command "session.half.page.down" end,
            desc = "Messages half page down",
          }

          maps.v[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" }
          maps.v[prefix .. "a"] = {
            function() require("opencode").ask "[@this]" end,
            desc = "Ask about selection",
          }
          maps.v[prefix .. "+"] = {
            function() require("opencode").prompt "[@this] " end,
            desc = "Add selection to prompt",
          }
          maps.v[prefix .. "s"] = {
            function() require("opencode").select() end,
            desc = "Select prompt",
          }
        end,
      },
      { "AstroNvim/astroui", opts = { icons = { OpenCode = "" } } },
    },
  },
}
