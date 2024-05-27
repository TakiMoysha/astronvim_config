---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    opts.defaults.file_ignore_patterns = {
      "node_modules",
      "package%-lock.json",
      "yarn.lock",
      ".git",
      ".cache",
    }
    return opts
  end,
}
