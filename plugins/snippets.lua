return {
  { 
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "plugins.configs.luasnip"(plugin, opts)
      require("luasnip.loaders.from_vscode").lazy_load() {
        path = {"./lua/user/snippets"}
      }
    end,
  }
}
