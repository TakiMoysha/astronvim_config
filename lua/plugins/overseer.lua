if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction ",
    "OverseerClearCache",
  },
  ---@param opts overseer.Config
  opts = function(_, opts)
    local astrocore = require "astrocore"
    if astrocore.is_available "toggleterm.nvim" then opts.strategy = "toggleterm" end
    opts.task_list = {
      bindings = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        q = "<Cmd>close<CR>",
        K = "IncreaseDetail",
        J = "DecreaseDetail",
        ["<C-p>"] = "ScrollOutputUp",
        ["<C-n>"] = "ScrollOutputDown",
      },
    }
  end,
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { Overseer = "" } } },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroLSPMappings
      opts = function(_, opts)
        local prefix = "<leader>O"
        opts.mappings.n[prefix] = { desc = require("astroui").get_icon("Overseer", 1, true) .. "Overseer" }

        opts.mappings.n[prefix .. "t"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer" }
        opts.mappings.n[prefix .. "c"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Run Command" }
        opts.mappings.n[prefix .. "r"] = { "<Cmd>OverseerRun<CR>", desc = "Run Task" }
        opts.mappings.n[prefix .. "q"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
        opts.mappings.n[prefix .. "a"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Action" }
        opts.mappings.n[prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Overseer Info" }

        opts.mappings.n["<F2>"] = { "<Cmd>OverseerRun<CR>", desc = "Run Task" }
        opts.mappings.n["<F3>"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
        opts.mappings.n["<F8>"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer" }
      end,
    },
  },
  specs = {
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { overseer = true } },
    },
  },
}
