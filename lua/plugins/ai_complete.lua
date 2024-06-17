-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AI autocomplete server
-- codeium: good online
-- tabby: self-hosted server

-- vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
-- vim.keymap.set("n", "<Leader>;", function()
--   if vim.g.codeium_enabled == true then
--     vim.cmd "CodeiumDisable"
--   else
--     vim.cmd "CodeiumEnable"
--   end
-- end, { noremap = true, desc = "Toggle Codeium active" })
---@type LazySpec
return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      vim.keymap.set("i", "<A-w>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<C-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("n", "<Leader>;", function()
        if vim.g.codeium_enabled == true then
          vim.cmd "CodeiumDisable"
        else
          vim.cmd "CodeiumEnable"
        end
      end, { noremap = true, desc = "Toggle Codeium active" })
    end,
  },
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "User AstroFile",
  --   config = function()
  --     vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
  --     vim.keymap.set("n", "<Leader>;", function()
  --       if vim.g.codeium_enabled == true then
  --         vim.cmd "CodeiumDisable"
  --       else
  --         vim.cmd "CodeiumEnable"
  --       end
  --     end, { noremap = true, desc = "Toggle Codeium active" })
  --   end,
  -- },

  -- {
  -- "Exafunction/codeium.nvim",
  -- "Exafunction/codeium.vim",
  -- config = function(self, opts)
  -- Change '<C-g>' here to any keycode you like.
  -- vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  -- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  -- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
  -- vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  -- end,
  -- },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   optional = true,
  --   dependencies = { "Exafunction/codeium.vim" },
  --   opts = function(_, opts)
  --     -- Inject codeium into cmp sources, with high priority
  --     table.insert(opts.sources, 1, {
  --       name = "codeium",
  --       group_index = 1,
  --       priority = 10000,
  --     })
  --   end,
  -- },

  -- {
  --   "Exafunction/codeium.nvim",
  --   lazy = false,
  --   version = "1.8.37",
  --   event = "BufEnter",
  --   opts = {
  --     enable_chat = true,
  --   },
  --   dependencies = {
  --     "AstroNvim/astrocore",
  --     ---@type AstroCoreOpts
  --     opts = {
  --       -- mappings = {
  --       --   i = {
  --       --     ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  --       --     -- ["<A-e>"] = { desc = "Accept codeium suggestion", function() require("codeium.nvim"). vim.fn "codeium#Accept" end, },
  --       --   },
  --       --   n = {
  --       --     ["<Leader>;"] = { name = "Codeium" },
  --       --     ["<Leader>;e"] = { desc = "Enable Codeium", function() vim.cmd "CodeiumEnable" end, },
  --       --     ["<Leader>;d"] = { desc = "Disable Codeium", function() vim.cmd "CodeiumDisable" end, },
  --       --   }
  --       -- }
  --     },
  --     -- mapping = {
  --     --   i = {
  --     --     ["<A-e>"] = { desc = "Accept codeium suggestion", function() require("codeium.nvim"). vim.fn "codeium#Accept" end, },
  --     --     -- ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  --     --   },
  --     -- }
  --   }
  -- },

  -- {
  --  "hrsh7th/nvim-cmp",
  --   optional = true,
  --   dependencies = { "Exafunction/codeium.nvim" },
  --   opts = function(_, opts)
  --     table.insert(opts.source, 1, { name = "codeium", group_index = 1, priority= 10000 })
  --   end,
  -- },

  -- {
  --   "TabbyML/vim-tabby",
  --   lazy = false,
  --   dependencies = {
  --     "AstroNvim/astrocore",
  --     ---@type AstroCoreOpts
  --     opts = {
  --       mappings = {},
  --     },
  --   },
  -- },
}
