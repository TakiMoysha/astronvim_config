return {
  lsp = {
    config = {
      denols = function(opts)
        opts.root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        return opts
      end,
      tsserver = function(opts)
        opts.root_dir = require("lspconfig.util").root_pattern("package.json")
        return opts
      end,
    },
    servers = {
      "tsserver",
      "denols",
      "vuels",
      "rust_analyzer",
    },
    ["server-settings"] = {
      denols = {
      },
      tsserver = {
      },
      rust_analyzer = {
        
      }
    }
  },
};
