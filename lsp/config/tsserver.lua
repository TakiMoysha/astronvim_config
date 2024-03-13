return {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/lib/node_modules/@vue/typescript-plugin",
        languages = { "typescript", "javascript", "vue" },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "vue",
  },
}
