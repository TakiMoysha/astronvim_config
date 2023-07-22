return {
  -- server_registration = function(server, opts)
  --   if server == "rust_analyzer" then
  --     require('rust_tools').setup({server = opts})
  --     return
  --   end
  --   require('lspconfig')[server].setup(opts)
  -- end,
  -- skip_setup = { "rust_analyzer" },
  servers = {
    "tsserver",
    "vuels",
    "rust_analyzer",
  }
}
