if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- "devDependencies": {
--   "@types/node": "^24.10.1",
--   "@vitejs/plugin-vue": "^6.0.1",
--   "@vue/tsconfig": "^0.8.1",
--   "autoprefixer": "^10.4.22",
--   "eslint": "^9.39.1",
--   "eslint-config-prettier": "^10.1.8",
--   "eslint-plugin-prettier": "^5.5.4",
--   "eslint-plugin-vue": "^10.5.1",
--   "globals": "^16.5.0",
--   "postcss": "^8.5.6",
--   "prettier": "^3.6.2",
--   "typescript": "~5.9.3",
--   "typescript-eslint": "^8.46.4",
--   "vite": "^7.2.2",
--   "vue-eslint-parser": "^10.2.0",
--   "vue-tsc": "^3.1.4"
-- }

---@type LazySpec
return {

  {
    import = "astrocommunity.lsp.nvim-lsp-file-operations",
  },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type opts AstroLSPOpts
    opts = function(_, opts)
      -- if not opts.config then opts.config = {} end
      opts.config.vtsls = {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
        single_file_support = false,
        settings = {
          typescript = {
            tsserver = {
              pluginsPaths = {
                "./node_modules"
              },
              -- globalPlugins = {
              --   {
              --     name = "@vue/typescript-plugin",
              --     location = vim.fn.stdpath "data"
              --       .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
              --     languages = { "vue" },
              --     configNamespace = "typescript",
              --     enableForWorkspaceTypeScriptVersions = true,
              --   },
              -- },
            },
          },
        },
      }

      -- vue_ls для Vue-специфичных функций (template, script setup и т.д.)
      opts.config.vue_ls = {
        filetypes = { "vue" },
        root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
        single_file_support = false,
        settings = {
          vue = {
            completion = { triggerCharacters = { ".", '"', "'", "`", "<", "/" } },
            diagnostic = { enable = true },
            format = { enable = false }, -- используем prettier
          },
        },
      }

      -- eslint
      opts.config.eslint = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
        settings = {},
      }

      return opts
    end,
  },

  -- esling plugins
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = { "vue-language-server", "vtsls", "prettierd", "eslint_d" },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      vtsls = {

        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
        single_file_support = false,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath "data"
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
        },
      },
    },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },

  -- prettier for files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.formatters_by_ft then opts.formatters_by_ft = {} end
      for _, ft in ipairs {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
        "svelte",
        "astro",
      } do
        opts.formatters_by_ft[ft] = { "prettierd" } -- only prettierd
      end

      opts.format_on_save = false
      opts.timeout_ms = 2000
    end,
  },

  -- vue syntax for tree sitter
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = function(_, opts)
      if not opts.file then opts.file = {} end
      opts.file[".nvmrc"] = { glyph = "", hl = "MiniIconsGreen" }
      opts.file[".node-version"] = { glyph = "", hl = "MiniIconsGreen" }
      opts.file["package.json"] = { glyph = "", hl = "MiniIconsGreen" }
      opts.file["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" }
      opts.file["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" }
      opts.file["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" }
      for _, filename in ipairs {
        "eslint.config.js",
        ".eslintrc.js", -- deprecated (?)
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".prettierrc",
        ".prettierrc.cjs",
        ".prettierrc.cts",
        ".prettierrc.js",
        ".prettierrc.json",
        ".prettierrc.json5",
        ".prettierrc.mjs",
        ".prettierrc.mts",
        ".prettierrc.toml",
        ".prettierrc.ts",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        "prettier.config.cjs",
        "prettier.config.js",
        "prettier.config.mjs",
        "prettier.config.mts",
        "prettier.config.ts",
      } do
        opts.file[filename] = { glyph = "", hl = "MiniIconsPurple" }
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { { "nvim-neotest/neotest-jest", config = function() end } },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-jest"(require("astrocore").plugin_opts "neotest-jest"))
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
