-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- TODO: inspect
---@module "rust"
---@class plugins.rust.config: AstroLSPOpts

---@type LazyPluginSpec[]
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "toml", "rust" } },
    },
  },

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
                  "sources",
                  "references",
                },
              },
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              inlayHints = {
                typeHints = { enable = true },
                parameterHints = { enable = true },
                closingBraceHints = { enable = true },
                maxLength = 28,
              },
            },
          },
        },
      })

      return opts
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "taplo" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "tombi",
        "taplo",
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
    -- version = "^6", -- stable
    version = "^9",
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
    dependencies = { "mrjones2014/codesettings.nvim" },
    init = function() vim.g.rustaceanvim = {} end,
    config = function(_, opts) vim.g.rustaceanvim = require("astrocore").extend_tbl(opts, vim.g.rustaceanvim) end,
    opts = function()
      local codelldb_avail, _ = pcall(function() return require("mason-registry").get_package "codelldb" end)
      local cfg = require "rustaceanvim.config"

      local adapter

      if codelldb_avail then
        local codelldb_path = vim.fn.exepath "codelldb"
        local this_os = vim.uv.os_uname().sysname

        local liblldb_path = vim.fn.expand "$MASON/share/lldb"
        if this_os:find "Windows" then
          -- TODO: for windows
          liblldb_path = liblldb_path .. "\\bin\\lidb.dll"
        else
          liblldb_path = liblldb_path .. "/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")
        end
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
      else
        ---@diagnostic disable-next-line: missing-parameter
        adapter = cfg.get_codelldb_adapter()
      end

      local astrolsp_opts = vim.lsp.config["rust_analyzer"] or {}

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
  },

  {
    "saghen/blink.cmp",
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
