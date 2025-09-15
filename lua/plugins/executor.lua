-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  "google/executor.nvim",
  cmd = {
    "ExecutorRun",
    "ExecutorSetCommand",
    "ExecutorShowDetail",
    "ExecutorHideDetail",
    "ExecutorToggleDetail",
    "ExecutorSwapToSplit",
    "ExecutorSwapToPopup",
    "ExecutorToggleDetail",
    "ExecutorReset",
  },
  opts = {
    use_split = true,
    popup = {
      -- Sets the width of the popup to 3/5ths of the screen's width.
      width = math.floor(vim.o.columns * 6 / 10),
      -- Sets the height to almost full height, allowing for some padding.
      height = vim.o.lines - 20,
      -- Border styles
      border = {
        padding = {
          top = 1,
          bottom = 1,
          left = 0,
          right = 0,
        },
        style = "rounded",
      },
    },
  },
  dependencies = {
    { "MunifTanjim/nui.nvim" },
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        ---@type AstroLSPOpts
        local opts = opts
        opts.mappings.n["<F2>"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" }
        opts.mappings.n["<Leader>Ee"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" }
        opts.mappings.n["<Leader>Es"] = { "<Cmd>ExecutorSetCommand<CR>", desc = "Set command" }
        opts.mappings.n["<Leader>Et"] = { "<Cmd>ExecutorToggleDetail<CR>", desc = "Toggle Detail" }
        opts.mappings.n["<F8>"] = { "<Cmd>ExecutorToggleDetail<CR>", desc = "Toggle Detail" }
        opts.mappings.n["<Leader>ES"] = { "<Cmd>ExecutorSwapToSplit<CR>", desc = "Swap to Split" }
        opts.mappings.n["<Leader>EP"] = { "<Cmd>ExecutorSwapToPopup<CR>", desc = "Swap to Popup" }
        opts.mappings.n["<Leader>Eh"] = { "<Cmd>ExecutorShowHistory<CR>", desc = "Show history" }
        opts.mappings.n["<Leader>Er"] = { "<Cmd>ExecutorReset<CR>", desc = "Clear the stored commands and output" }
        opts.mappings.n["<Leader>E"] = { desc = "Executor" }
      end,
    },
  },
}
