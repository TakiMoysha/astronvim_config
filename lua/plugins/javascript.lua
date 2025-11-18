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
    opts = {
      config = {
        ts_ls = {
          root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
          single_file_support = false,
        },
        -- VOLAR
        volar = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
          single_file_support = false,
          settings = {
            -- config
            vue = {
              completion = { triggerCharacters = { ".", '"', "'", "`", "<", "/" } },
              diagnostic = { enable = true },
              format = { enable = false }, -- only prettier
            },
          },
        },
        -- vtsls = {
        --   filetypes = { "vue", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        --   root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
        --   -- single_file_support = true,
        --   settings = {
        --     vtsls = {
        --       tsserver = {
        --         globalPlugins = {},
        --       }
        --     },
        --   },
        --   before_init = function (_, config)
        --       local registry_ok, registry = pcall(require, "mason-registry")
        --       if not registry_ok then return end
        --
        --       if registry.is_installed "vue-language-server" then
        --         local vue_plugin_config = {
        --           name = "@vue/typescript-plugin",
        --           location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
        --           languages = { "vue" },
        --           configNamespace = "typescript",
        --           enableForWorkspaceTypeScriptVersions = true,
        --         }
        --
        --         require("astrocore").list_insert_unique(config.settings.vtsls.tsserver.globalPlugins, { vue_plugin_config })
        --       end
        --   end
        -- },
        -- ESLINT as LSP
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
          settings = {
            -- esling and plugins
            -- workingDirectory = { mode = "local" }, # for local eslint
          },
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed or {},
        { "volar", "eslint" } -- install for js projects
      )
    end,
  },

  -- esling plugins
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed or {},
        { "volar", "eslint" } --
      )
    end,
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
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { { "nvim-neotest/neotest-jest", config = function() end } },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-jest"(require("astrocore").plugin_opts "neotest-jest"))
    end,
  },
}
