return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    opts.completion.menu = opts.completion.menu or {}
    opts.completion.menu.draw = opts.completion.menu.draw or {}

    opts.completion.menu.draw.columns = {
      { "kind_icon" },
      { "label",      "label_description", gap = 1 },
      { "source_name" },
    }

    opts.completion.menu.draw.components = opts.completion.menu.draw.components or {}
    opts.completion.menu.draw.components.source_name = {
      text = function(ctx) return ctx.item.source_name end,
      highlight = "BlinkCmpSource",
    }

    opts.sources = opts.sources or {}
    opts.sources.providers = opts.sources.providers or {}
    opts.sources.providers.snippets = opts.sources.providers.snippets or {}
  end,
}
