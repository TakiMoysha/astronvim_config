-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  { import = "astrocommunity.pack.toml" },
  -- { import = "astrocommunity.pack.rust" },

  -- TODO: not working
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     {
  --       "AstroNvim/astrolsp",
  --       opts = {
  --         filetypes = {
  --           extension = {
  --             ron = "ron",
  --           },
  --           filetypes = {
  --             [".ron"] = "ron",
  --           },
  --         },
  --       },
  --     },
  --   },
  --   opts = function()
  --     vim.lsp.config("ron-lsp", {
  --       cmd = "ron-lsp",
  --       filetypes = { "ron" },
  --       root_dir = function(fname)
  --         return require("lspconfig.util").root_pattern("Cargo.toml", ".git")(fname) or vim.loop.cwd()
  --       end,
  --     })
  --   end,
  -- },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      if not opts.config then opts.config = {} end

      opts.handlers.rust_analyzer = false

      opts.config = vim.tbl_deep_extend("force", opts.config, {
        ---@diagnostic disable: missing-fields
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  "target",
                },
              },
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
      })

      return opts
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "codelldb",
        "rust-analyzer",
      })
    end,
  },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
        cmp = { enabled = true },
      },
      lsp = {
        enabled = true,
        on_attach = function(...) require("astrolsp").on_attach(...) end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      local rustaceanvim_avail, rustaceanvim = pcall(require, "rustaceanvim.neotest")
      if rustaceanvim_avail then table.insert(opts.adapters, rustaceanvim) end
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = "rust",
    specs = {
      {
        "AstroNvim/astrolsp",
        optional = true,
        opts = {
          handlers = { rust_analyzer = false },
        },
      },
    },
    opts = function()
      local codelldb_avail, _ = pcall(function() return require("mason-registry").get_package "codelldb" end)
      local cfg = require "rustaceanvim.config"
      local adapter =
        codelldb_avail and cfg.get_codelldb_adapter(vim.fn.exepath "codelldb"), (function()
          local this_os = vim.uv.os_uname().sysname
          local liblldb_path = vim.fn.expand "$MASON/share/lldb"
          if this_os:find "Windows" then return liblldb_path .. "\\bin\\lldb.dll" end
          return liblldb_path .. "/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")
        end)() or cfg.get_codelldb_adapter()

      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      local astrolsp_opts = (astrolsp_avail and astrolsp.lsp_opts "rust_analyzer") or {}

      local server = {
        settings = function(project_root, default_settings)
          local astrolsp_settings = (astrolsp_opts.settings or {})
          local merge_table = require("astrocore").extend_tbl(default_settings or {}, astrolsp_settings)
          local ra = require "rustaceanvim.config.server"
          return ra.load_rust_analyzer_settings(project_root, {
            settings_file_pattern = "rust-analyzer.json",
            default_settings = merge_table,
          })
        end,
      }

      return {
        server = require("astrocore").extend_tbl(astrolsp_opts, server),
        dap = { adapter = adapter, load_rust_types = true },
        tools = { enable_clippy = false },
      }
    end,
    config = function(_, opts) vim.g.rustaceanvim = require("astrocore").extend_tbl(opts, vim.g.rustaceanvim) end,
  },

  {
    "Saghen/blink.cmp",
    event = "VimEnter",
    opts = {
      keymap = { preset = "enter" },
      completion = {
        list = { selection = { preselect = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },
}
