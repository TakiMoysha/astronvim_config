if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- https://github.com/jake-stewart/multicursor.nvim

---@type LazySpec
return {
  "brenton-leighton/multiple-cursors.nvim",
  cmd = {
    "MultipleCursorsAddDown",
    "MultipleCursorsAddUp",
    "MultipleCursorsMouseAddDelete",
    "MultipleCursorsAddMatches",
    "MultipleCursorsAddMatchesV",
    "MultipleCursorsAddJumpNextMatch",
    "MultipleCursorsJumpNextMatch",
    "MultipleCursorsLock",
  },
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "multiple-cursors" })
  end,
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { MultipleCursors = "󰗧" } } },
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        ---@type AstroLSPMappings
        local maps = opts.mappings
        local prefix = "<Leader>m"

        maps.n["<S-Down>"] = { "<Cmd>MultipleCursorsAddDown<CR>", desc = "Add cursor down" }
        maps.n["<S-Up>"] = { "<Cmd>MultipleCursorsAddUp<CR>", desc = "Add cursor up" }
        maps.n[prefix .. "n"] = { "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", desc = "Jump cursor to next match" }
        maps.n["<C-LeftMouse>"] = { "<Cmd>MultipleCursorsMouseAddDelete<CR>", desc = "Add cursor with mouse" }

        for lhs, map in pairs {
          [prefix] = { desc = require("astroui").get_icon("MultipleCursors", 1, true) .. "MultipleCursors" },
          [prefix .. "a"] = { "<Cmd>MultipleCursorsAddMatches<CR>", desc = "Add cursor matches" },
          [prefix .. "A"] = { "<Cmd>MultipleCursorsAddMatchesV<CR>", desc = "Add cursor matches in previous visual area" },
          [prefix .. "j"] = { "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", desc = "Add cursor and jump to next match" },
          [prefix .. "J"] = { "<Cmd>MultipleCursorsJumpNextMatch<CR>", desc = "Move cursor to next match" },
          [prefix .. "l"] = { "<Cmd>MultipleCursorsLock<CR>", desc = "Lock virtual cursors" },
        } do
          maps.n[lhs] = map
          maps.x[lhs] = map
        end
      end,
    },
  },
}
