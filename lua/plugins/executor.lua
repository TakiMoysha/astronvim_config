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
  opts = function(_, opts)
    if not opts.ensure_installed then opts.ensure_installed = {} end
  end,
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
        opts.mappings.n["<Leader>ES"] = { "<Cmd>ExecutorSwapToSplit<CR>", desc = "Swap to Split" }
        opts.mappings.n["<Leader>EP"] = { "<Cmd>ExecutorSwapToPopup<CR>", desc = "Swap to Popup" }
        opts.mappings.n["<Leader>E"] = { desc = "Executor" }
      end,
    },
  },
}
