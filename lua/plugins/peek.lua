-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "toppair/peek.nvim",
    -- url = "https://github.com/TakiMoysha/peek.nvim",
    dir = "~/workspace/projects/peek.nvim",
    dev = false,
    -- version = '5820d93',
    lazy = false,
    build = "bun install && bun run build",
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        commands = {
          MarkdownOpen = { function() require("peek").open() end, desc = "Open preview window" },
          MarkdownClose = { function() require("peek").close() end, desc = "Close preview window" },
        },
      },
    },
    opts = {
      app = "webview",
    },
  },
}
