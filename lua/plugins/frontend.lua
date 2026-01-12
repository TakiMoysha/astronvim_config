-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- WARN: issues
-- - don't working comments in templates
-- - https://github.com/vuejs/language-tools/wiki/Neovim

---@type LazySpec
return {
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },
  --
  { import = "astrocommunity.pack.json" },
  -- =========================================================================================
  -- https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
  { import = "astrocommunity.pack.typescript" },
  -- =========================================================================================
  { import = "astrocommunity.pack.vue" },
  -- =========================================================================================
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/vue/
  -- =========================================================================================
  -- migration to v5, draft
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    dependencies = {
      { "AstroNvim/astrolsp", opts = {} },
    },
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "volar", "astro", "biome" })
    end,
  },
  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vtsls",
        "tailwindcss-language-server",
        "astro-language-server",
        "prettierd",
        "vue-language-server", -- volar
        "js-debug-adapter",
        "html-lsp",
        "biome",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
          "astro",
          "vue",
          "typescript",
          "javascript",
          "tsx",
          "jsdoc",
          "html",
          "css",
          "scss",
          "styled",
        })
      end
    end,
  },

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      filetypes = {
        extension = {
          pcss = "postcss",
          postcss = "postcss",
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vim.fn.stdpath "data" .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }

      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        biome = {
          filetypes = { "css", "scss" },
        },

        vtsls = {
          filetypes = tsserver_filetypes,
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  vue_plugin,
                },
              },
            },
          },
        },

        volar = {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
          settings = {
            vue = {
              --   completion = { triggerCharacters = { ".", '"', "'", "`", "<", "/" } },
              diagnostic = { enable = true },
              format = { enable = false }, -- use prettier or biome
              --   server = {
              --     vue = {
              --       template = {
              --         enable = true,
              --       },
              --       typescript = {
              --         enable = true,
              --       },
              --     },
              --   },
            },
          },
          init_options = {
            hybridMode = true,
          },

          -- on_init = function(client)
          --   client.handlers["tsserver/request"] = function(_, result, context)
          --     local vtsls_clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
          --
          --     if #vtsls_clients == 0 then
          --       vim.notify(
          --         "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
          --         vim.log.levels.ERROR
          --       )
          --       return
          --     end
          --     local ts_client = vtsls_clients[1]
          --
          --     local param = unpack(result)
          --     local id, command, payload = unpack(param)
          --     ts_client:exec_cmd({
          --       title = "vue_request_forward", -- command name in the UI, `:h Client:exec_cmd`
          --       command = "typescript.tsserverRequest",
          --       arguments = {
          --         command,
          --         payload,
          --       },
          --     }, { bufnr = context.bufnr }, function(_, r)
          --       local response_data = { { id, r and r.body } }
          --       client:notify("tsserver/response", response_data)
          --     end)
          --   end
          -- end,
        },
      })
    end,
  },

  -- formatter for files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local formatter = "prettier" -- biome or prettier
      local biome_formatter = "biome"
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { formatter },
        javascriptreact = { formatter },
        typescript = { formatter },
        typescriptreact = { formatter },
        astro = { formatter },
        vue = { formatter },
        css = { biome_formatter },
        scss = { biome_formatter },
        html = { biome_formatter },
        json = { formatter },
        jsonc = { formatter },
        yaml = { formatter },
        graphql = { formatter },
        markdown = { biome_formatter },
        markdownx = { biome_formatter },
        mdx = { biome_formatter },
      })
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    optional = true,
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
  -- testing: TODO: how to
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "nvim-neotest/neotest-jest" },
      { "nvim-neotest/neotest-vue" },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require "neotest-jest" {
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function(path) return vim.fn.getcwd() end,
        }
      )
      table.insert(opts.adapters, require "neotest-vue")
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "js" })
    end,
  },

  -- =========================================================================================
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  -- {
  --   "dmmulroy/tsc.nvim",
  --   cmd = "TSC",
  --   opts = {},
  -- },
}
