-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- https://docs.astronvim.com/recipes/advanced_lsp/
--

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true,      -- auto formatting on start
      codelens = true,        -- codelens refresh on start (reference and implementation count, code actions, rename)
      inlay_hints = true,     -- inlay hints on start (type hints,)
      semantic_tokens = true, -- semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false,    -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "ruff",
      -- "basedpyright",
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {},
    handlers = {},
    autocmds = {
      -- WIP: not verified
      -- fugitive = {
      --   {
      --     event = { "BufReadPost" },
      --     pattern = { "fugiive:///*//0/*"},
      --     desc = "Avoid modifying fugitive diff buffers",
      --     callback = function()
      --       vim.opt_local.modifiable = false
      --       vim.opt_local.readonly = true
      --     end
      --   }
      -- },

      -- WIP: not verified
      -- no_expandtab = {
      --   {
      --     event = "FileType",
      --     pattern = "go",
      --     desc = "Disable expandtab for .go",
      --     callback = function() vim.opt.expandtab = false end,
      --   }
      -- },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      if client.name == "tsserver" or client.name == "typescript" or client.name == "vtsls" then
        client.server_capabilities.inlayHintProvider = nil
      end
    end,
  },
}
