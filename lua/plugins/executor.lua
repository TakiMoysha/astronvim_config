-- {
--   {
--     "google/executor.nvim",
--     dependencies = {
--       "MunifTanjim/nui.nvim",
--     },
--   },
-- }
-- https://github.com/google/executor.nvim

---@type LazySpec
return {
  "google/executor.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  opts = {
    -- TODO: not working, why?
    -- mappings = {
    --   ["<Leader>Ex"] = { "<Cmd>ExecutorRun<CR>", desc = "Run" },
    --   ["<Leader>E"] = { desc = "Executor" },
    -- },
  },
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
}
