-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      -- large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- -- ranger
        -- ["<Leader>tr"] = {
        --   function() require("astrocore").toggle_term_cmd { cmd = "ranger", direction = "float" } end,
        --   desc = "ToggleTerm ranger",
        -- },
        -- yazi
        ["<Leader>ty"] = {
          function() require("astrocore").toggle_term_cmd { cmd = "yazi", direction = "float" } end,
          desc = "ToggleTerm Yazi",
        },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- #Executor
        ["<F2>"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" },
        ["<Leader>Ee"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" },
        ["<Leader>Es"] = { "<Cmd>ExecutorSetCommand<CR>", desc = "Set command" },
        ["<Leader>Et"] = { "<Cmd>ExecutorToggleDetail<CR>", desc = "Toggle Detail" },
        ["<Leader>ES"] = { "<Cmd>ExecutorSwapToSplit<CR>", desc = "Swap to Split" },
        ["<Leader>EP"] = { "<Cmd>ExecutorSwapToPopup<CR>", desc = "Swap to Popup" },
        ["<Leader>E"] = { desc = "Executor" },
      },
    },
  },
}
