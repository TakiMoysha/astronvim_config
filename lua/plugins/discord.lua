if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "vyfor/cord.nvim",
    branch = "master",
    build = ":Cord update",
    event = "VeryLazy",
    enabled = true,
    config = function()
      require("cord").setup {
        timestamp = {
          enabled = true,
          reset_on_idle = false,
          reset_on_change = false,
        },
        editor = {
          client = "astronvim",
        },
        idle = {
          unidle_on_focus = false,
          ignore_focus = true,
          tooltip = "💤",
        },
        text = {
          viewing = "Viewing {}",
          editing = function(opts)
            if opts.filetype == "rust" then return "🦀 Rusting..." end
            return "Editing " .. opts.filename
          end,
          lsp = "LSP:{}",
          dashboard = "Dashboard:Home",
        },
        buttons = {
          {
            label = function(opts) return opts.repo_url and "Repository" or "Website" end,
            url = function(opts) return opts.repo_url or "https://github.com/takimoysha" end,
          },
        },
      }
    end,
  },
}
