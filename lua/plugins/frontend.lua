-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- WARN: issues: with commit
-- - don't working comments in templates

---@type LazySpec
return {
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.astro" },
  -- { import = "astrocommunity.pack.vue" },

  -- ====================================================================================================================================
  -- https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
  -- { import = "astrocommunity.pack.typescript" },
  -- ====================================================================================================================================
  -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/vue/
  -- ====================================================================================================================================
  -- migration to v5, draft
  k
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "volar", "biome" })
    end,
  },
  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vue-language-server", -- volar
        "vtsls",
        "tailwindcss-language-server",
        "prettierd",
        "eslint_d",
        "js-debug-adapter",
        "html-lsp",
        "emmet-ls",
        "biome",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
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
      }

      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        html = { init_options = { provideFormatter = false } },
        cssls = { init_options = { provideFormatter = false } },

        vtsls = {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
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
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          settings = {
            vue = {
              completion = { triggerCharacters = { ".", '"', "'", "`", "<", "/" } },
              diagnostic = { enable = true },
              format = { enable = false }, -- use prettier or biome
              server = {
                vue = {
                  template = {
                    enable = true,
                  },
                  typescript = {
                    enable = true,
                  },
                },
              },
            },
          },
          init_options = {
            hybridMode = true,
          },
          on_init = function(client)
            client.handlers["tsserver/request"] = function(_, result, context)
              local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
              if #clients == 0 then
                vim.notify(
                  "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                  vim.log.levels.ERROR
                )
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = "typescript.tsserverRequest",
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                client:notify("tsserver/response", response_data)
              end)
            end
          end,
        },

        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
          settings = {
            tailwindcss = {
              classAttributes = { "class", "className", "classList", "ngClass" },
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)"',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                  "class=[\"']([^\"']*)[\"']",
                },
              },
            },
          },
        },

        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },

        -- emmet_ls = {
        --   filetypes = { "html", "css", "scss", "javascript", "typescript", "vue" },
        --   init_options = {
        --     enable = true,
        --   },
        --   on_attach = function(client, bufnr)
        --     client.server_capabilities.documentFormattingProvider = false
        --     client.server_capabilities.documentRangeFormattingProvider = false
        --     client.server_capabilities.workspaceSymbolProvider = false
        --     client.server_capabilities.workspace = nil
        --   end,
        -- },
      })
    end,
  },

  -- formatter for files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.formatters_by_ft then opts.formatters_by_ft = {} end
      local supported_ft = {
        "astro",
        "css",
        "scss",
        "json",
        "jsonc",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "markdown",
        "markdown.mdx",
      }

      local _formatters_by_ft = {}
      for _, ft in ipairs(supported_ft) do
        _formatters_by_ft[ft] = { "biome" } -- or "prettier"
      end

      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, ..._formatters_by_ft)
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
  -- vue syntax for tree sitter
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = function(_, opts)
      opts.file = vim.tbl_deep_extend("force", opts.file or {}, {
        [".nvmrc"] = { glyph = "", hl = "MiniIconsGreen" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        ["postcss"] = { glyph = "󰌜", hl = "MiniIconsOrange" },
      })

      local config_files = {
        "eslint.config.js",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".prettierrc",
        ".prettierrc.cjs",
        ".prettierrc.json",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        "prettier.config.js",
        "prettier.config.cjs",
      }

      for _, filename in ipairs(config_files) do
        opts.file[filename] = { glyph = "", hl = "MiniIconsPurple" }
      end
    end,
  },
  -- testing
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

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {},
  },
}
