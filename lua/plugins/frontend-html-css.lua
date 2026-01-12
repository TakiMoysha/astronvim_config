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
        "emmet_ls",
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
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "less", "xml", "xsl", "xslt", "xsd", "xhtml", "jsx", "tsx", "vue", "svelte" },
    config = function()
      vim.g.user_emmet_mode = "inv" -- enable in insert, visual and normal mode
      -- vim.g.user_emmet_leader_key = "<C-Z>"
      vim.g.user_emmet_settings = {
        html = {
          default_attributes = {
            option = { value = "v" },
            textarea = { id = "i", name = "n", cols = "30", rows = "10" },
          },
          snippets = {
            ["html:5"] = "<!DOCTYPE html>\n"
              .. '<html lang="${lang}">\n'
              .. "<head>\n"
              .. '\t<meta charset="${charset}">\n'
              .. '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
              .. "\t<title>${title}</title>\n"
              .. "</head>\n"
              .. "<body>\n"
              .. "\t${child}|\n"
              .. "</body>\n"
              .. "</html>",
          },
        },
        css = {
          filters = "fc",
          snippets = {
            ["@media"] = "@media screen and (max-width: ${1:768px}) {\n\t${0}\n}",
            ["@keyframes"] = "@keyframes ${1:name} {\n\t0% { ${2} }\n\t100% { ${3} }\n}",
          },
        },
      }
    end,
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
}
