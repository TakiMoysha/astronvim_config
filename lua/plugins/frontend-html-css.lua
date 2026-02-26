-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- WARN: issues:

---@type LazySpec
return {
  { import = "astrocommunity.pack.html-css" },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "tailwindcss",
        "html",
        "cssls",
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "tailwindcss-language-server" })
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
            provideFormatter = false, -- prettier or biome
          },
          settings = {
            css = {
              validate = false, -- disable built-in validation for prevent conflicts
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

        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
              },
            },
          },
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
            "astro",
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
              validate = true,
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
            init_options = {
              userLanguages = {
                rust = "html",
                ["vue"] = "html",
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
