if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- https://paletton.com/#uid=10p0u0kmDjIc6uhhAoKrTeszk9j
-- https://github.com/skatromb/navigate-theme

local rust_palette = {
  keyword = "#9D5B2E",
  keyword_muted = "#73370F",
}
local palette = {
  black = "#2F3239",
  red = "#e85c51",
  green = "#7aa4a1",
  yellow = "#fda47f",
  blue = "#5a93aa",
  magenta = "#ad5c7c",
  cyan = "#a1cdd8",
  white = "#ebebeb",
  orange = "#ff8349",
  pink = "#cb7985",

  comment = "#6d7f8b",

  bg0 = "#0f1c1e", -- Dark bg (status line and float)
  bg1 = "#152528", -- Default bg
  bg2 = "#1d3337", -- Lighter bg (colorcolm folds)
  bg3 = "#254147", -- Lighter bg (cursor line)
  bg4 = "#2d4f56", -- Conceal, border fg

  fg0 = "#eaeeee", -- Lighter fg
  fg1 = "#e6eaea", -- Default fg
  fg2 = "#cbd9d8", -- Darker fg (status line)
  fg3 = "#587b7b", -- Darker fg (line numbers, fold colums)

  sel0 = "#293e40", -- Popup bg, visual selection bg
  sel1 = "#425e5e", -- Popup sel bg, search bg
}

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "pustota",
    highlights = {

      init = {
        Normal = { bg = palette.bg0 }, -- редактор
        NormalNC = { bg = palette.bg0 }, -- неактивные окна
        NormalFloat = { bg = palette.bg1 }, -- поп-апы/LSP/which-key
        FloatBorder = { bg = palette.bg1, fg = palette.sel0 },
        MsgArea = { bg = "#08090C" }, -- строка команд (тема красит в bottom)
        Visual = { bg = "#24485F" },
        VisualNOS = { bg = "#24485F" },
        CursorLine = { bg = "#131820" },
      },

      pustota = {
        -- for rust specific
        ["@keyword.rust"] = { fg = rust_palette.keyword },
        -- ["@keyword.type"] = { fg = SecondaryColor }, -- struct/trait/enum
        ["@keyword.function"] = { fg = rust_palette.keyword_muted }, -- fn
        ["@keyword.import.rust"] = { fg = rust_palette.keyword }, -- mod/use
        -- ["@keyword.modifier"] = { fg = PrimeColor }, -- pub/mut/const
        -- ["@keyword.return"] = { fg = PrimeColor },
        -- ["@keyword.coroutine"] = { fg = PrimeColor },
        -- ["@keyword.exception"] = { fg = PrimeColor }, -- try
        -- ["@keyword.modifier.rust"] = { fg = PrimeColor }, -- мёртвая группа из master-ветки, но пусть

        ---------------------------------------------------------------
        -- ["@function"] = { fg = "#FFB499" }, -- fn qux
        -- ["@type.definition"] = { link = "Type" }, -- struct Foo / trait Bar / impl
        -- ["@type"] = { fg = "#59C2FF" },
        -- ["@module"] = { fg = "#59C2FF" }, -- mod mymod (и use-пути)      },

        ---------------------------------------------------------------
        -- ["@function.macro"] = { fg = "#B3B1AD" },
        -- ["@function.debug"] = { fg = PrimeColor },
      },
    },
  },
}
