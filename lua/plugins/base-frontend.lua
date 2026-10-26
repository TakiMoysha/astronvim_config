-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  { import = "astrocommunity.pack.html-css" },

  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      -- здесь имена lspconfig (не Mason): "tailwindcss" (Mason: tailwindcss-language-server),
      -- "html" (Mason: html-lsp), "cssls" (Mason: css-lsp)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed or {},
        { "tailwindcss", "html", "cssls" }
      )
      -- исключаем emmet (оба имени: старое emmet_ls и новое emmet_language_server).
      -- фильтр ensure_installed не запрещает запуск уже установленного сервера,
      -- реальное отключение — через handlers в astrolsp ниже.
      local disabled = { emmet_ls = true, emmet_language_server = true }
      opts.ensure_installed =
        vim.tbl_filter(function(server) return not disabled[server] end, opts.ensure_installed)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    -- исключаем emmet (оба Mason-имени: старое emmet-ls и новое emmet-language-server)
    opts = function(_, opts)
      local disabled = { ["emmet-ls"] = true, ["emmet-language-server"] = true }
      opts.ensure_installed =
        vim.tbl_filter(function(tool) return not disabled[tool] end, opts.ensure_installed or {})
    end,
  },
  -- NOTE: оставлен только nvim-highlight-colors (с tailwind-поддержкой).
  -- NvChad/nvim-colorizer.lua отключен во избежание двойной подсветки и просадок perf.
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   optional = true,
  --   opts = {
  --     user_default_options = {
  --       names = true,
  --       tailwind = true,
  --     },
  --   },
  -- },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      opts.handlers = vim.tbl_deep_extend("force", opts.handlers or {}, {
        emmet_ls = false,
        emmet_language_server = false,
      })
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        html = { init_options = { provideFormatter = false } },
        cssls = {
          filetypes = { "css", "scss", "less" },
          init_options = {
            provideFormatter = false, -- using lsp (prettier, biome, ox)
          },
          settings = {
            css = {
              validate = true, -- disable built-in validation for prevent conflicts (ex: vue = windcss)
              lint = {
                unknownAtRules = "ignore", -- if validate is true, disable warnings for @apply, @reference, etc.
              },
              completion = {
                triggerPropertyValueCompletion = true,
                completePropertyWIthSemicolon = true,
              },
              hover = {
                documentation = true,
                references = true,
              },
            },
          },
        },
        tailwindcss = {
          init_options = {
            userLanguages = {
              rust = "html",
              ["vue"] = "html",
            },
          },
          filetypes = {
            "html",
            "css",
            "scss",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
          settings = {
            tailwindcss = {
              validate = true,
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
                -- только tw()-паттерны: generic class=["']... уже покрыт classAttributes выше,
                -- а его включение сюда включает tailwind на любом проекте (шум + perf)
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)"',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                },
              },
            },
          },
        },
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
}
