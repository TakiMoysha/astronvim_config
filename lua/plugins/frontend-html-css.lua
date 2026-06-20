-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  { import = "astrocommunity.pack.html-css" },

  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      -- нужные сервера
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "tailwindcss-language-server", "html-lsp", "css-lsp" }
      )
      -- исключаем emmet_ls
      opts.ensure_installed = vim.tbl_filter(function(server) return server ~= "emmet_ls" end, opts.ensure_installed)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    -- исключаем emmet_ls
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool) return tool ~= "emmet-ls" end, opts.ensure_installed or {})
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    optional = true,
    opts = {
      user_default_options = {
        names = true,
        tailwind = true,
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        html = { init_options = { provideFormatter = false } },
        cssls = {
          filetypes = { "css", "scss", "less" },
          init_options = {
            provideFormatter = false, -- using lsp (prettier, biome, ox)
          },
          settings = {
            css = {
              validate = true,             -- disable built-in validation for prevent conflicts (ex: vue = windcss)
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
