return {
  colorscheme = "duskfox",
  diagnostics = {
    -- underline = true,
    virtual_text = true,
  },
 
 --   ["heirline"] = function(config)
  --     return {
  --       -- Status line:
  --       {
  --         hl = { fg = "fg", bg = "bg" },
  --         astronvim.status.component.mode(),
  --         astronvim.status.component.git_branch(),
  --         astronvim.status.component.fill(),
  --         astronvim.status.component.lsp(),
  --         astronvim.status.component.treesitter(),
  --         astronvim.status.component.nav { scrollbar = false, percentage = false, padding = { left = 1 } },
  --         astronvim.status.component.mode { surround = { separator = "right" } },
  --       },
  --       -- Winbar:
  --       {
  --         hl = { fg = "fg", bg = "bg" },
  --         astronvim.status.component.file_info {
  --           filename = { modify = ":p:." },
  --           padding = { left = 1, right = 1 },
  --         },
  --         { provider = "::" },
  --         astronvim.status.component.breadcrumbs { icon = { hl = true }, padding = { left = 1 } },
  --         astronvim.status.component.fill(),
  --         astronvim.status.component.git_diff(),
  --         astronvim.status.component.diagnostics(),
  --       },
  --     }
  --   end,
  -- },
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "tohtml",
          "gzip",
          "matchit",
          "zipPlugin",
          "netrwPlugin",
          "tarPlugin",
        }
      }
    }
  }
};
