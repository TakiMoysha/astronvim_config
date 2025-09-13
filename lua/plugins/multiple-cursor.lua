-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

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
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { MultipleCursors = "󰗧" } } },
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        ---@type AstroLSPOpts
        local maps = opts
        maps.mappings.n["<S-j>"] = { "<Cmd>MultipleCursorsAddDown<CR>", desc = "Add cursor down" }
        maps.mappings.i["<S-j>"] = { "<Cmd>MultipleCursorsAddDown<CR>", desc = "Add cursor down" }

        maps.mappings.n["<S-k>"] = { "<Cmd>MultipleCursorsAddUp<CR>", desc = "Add cursor up" }
        maps.mappings.i["<S-k>"] = { "<Cmd>MultipleCursorsAddUp<CR>", desc = "Add cursor up" }

        maps.mappings.n["<C-LeftMouse>"] = { "<Cmd>MultipleCursorsMouseAddDelete<CR>", desc = "Add cursor with mouse" }
        maps.mappings.i["<C-LeftMouse>"] = { "<Cmd>MultipleCursorsMouseAddDelete<CR>", desc = "Add cursor with mouse" }

        local prefix = "<Leader>m"

        for lhs, map in pairs {
          [prefix] = { desc = require("astroui").get_icon("MultipleCursors", 1, true) .. "MultipleCursors" },
          [prefix .. "a"] = { "<Cmd>MultipleCursorsAddMatches<CR>", desc = "Add cursor matches" },
          [prefix .. "A"] = { "<Cmd>MultipleCursorsAddMatchesV<CR>", desc = "Add cursor matches in previous visual area" },
          [prefix .. "j"] = { "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", desc = "Add cursor and jump to next match" },
          [prefix .. "J"] = { "<Cmd>MultipleCursorsJumpNextMatch<CR>", desc = "Move cursor to next match" },
          [prefix .. "l"] = { "<Cmd>MultipleCursorsLock<CR>", desc = "Lock virtual cursors" },
        } do
          maps.mappings.n[lhs] = map
          maps.mappings.x[lhs] = map
        end
      end,
    },
  },
}
