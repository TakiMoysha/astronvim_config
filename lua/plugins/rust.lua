-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  { import = "astrocommunity.pack.toml" },
  -- { import = "astrocommunity.pack.rust" },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      if not opts.config then opts.config = {} end

      opts.handlers.rust_analyzer = false -- rustaceanvim handles this

      opts.config.rust_analyzer = {
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
              extraArgs = {
                "--no-deps",
              },
            },
          },
        },
      }

      return opts
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "codelldb", "rust-analyzer" })
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
        completion = true, -- !TODO: error
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
        ---@type AstroLSPOpts
        opts = {
          handlers = { rust_analyzer = false }, -- disable setup of `rust_analyzer`
        },
      },
    },
    opts = function()
      local adapter
      local codelldb_installed = pcall(function() return require("mason-registry").get_package "codelldb" end)
      local cfg = require "rustaceanvim.config"
      if codelldb_installed then
        local codelldb_path = vim.fn.exepath "codelldb"
        local this_os = vim.uv.os_uname().sysname

        local liblldb_path = vim.fn.expand "$MASON/share/lldb"
        -- The path in windows is different
        if this_os:find "Windows" then
          liblldb_path = liblldb_path .. "\\bin\\lldb.dll"
        else
          -- The liblldb extension is .so for linux and .dylib for macOS
          liblldb_path = liblldb_path .. "/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")
        end
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
      else
        adapter = cfg.get_codelldb_adapter(nil, nil)
      end

      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      local astrolsp_opts = (astrolsp_avail and astrolsp.lsp_opts "rust_analyzer") or {}
      local server = {
        ---@type table | (fun(project_root:string|nil, default_settings: table|nil):table) -- The rust-analyzer settings or a function that creates them.
        settings = function(project_root, default_settings)
          local astrolsp_settings = astrolsp_opts.settings or {}

          local merge_table = require("astrocore").extend_tbl(default_settings or {}, astrolsp_settings)
          local ra = require "rustaceanvim.config.server"
          -- load_rust_analyzer_settings merges any found settings with the passed in default settings table and then returns that table
          return ra.load_rust_analyzer_settings(project_root, {
            settings_file_pattern = "rust-analyzer.json",
            default_settings = merge_table,
          })
        end,
      }
      local final_server = require("astrocore").extend_tbl(astrolsp_opts, server)
      return {
        server = final_server,
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
          -- crates = { name = "crates", module = "crates_nvim.cmp" },
          lazydev = { modele = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },
}
