return {
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.typescript-deno" },
  { import = "astrocommunity.pack.vue" },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = {
      config = {
        denols = {
          -- adjust deno ls root directory detection
          root_dir = function(...) return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(...) end,
        },
        ts_ls = {
          root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
          single_file_support = false,
        },
        vtsls = {
          root_dir = function(...) return require("lspconfig.util").root_pattern "package.json"(...) end,
          single_file_support = false,
        },
      },
    },
  },
}
