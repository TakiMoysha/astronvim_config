# AstroNvim V4

## Cheatsheet - about configuration

`<C>` - CTRL; `<M>` - ALT; `<S>` - SHIFT

### Nvim-Surround

`add` - `ys{motion}{char}`
`delete` - `ds{char}`
`change` - `cs{target}{replacement}`

| Old Text                | Command   | New Text              |
| ----------------------- | --------- | --------------------- |
| (surround_words)        | ysiw)     | (surround_words)      |
| make strings            | ys"       | "make strings"        |
| [delete around me!]     | ds]       | delete around me!     |
| remove <b>HTML tags</b> | dst       | remove HTML tags      |
| 'change quot*es'        | cs'"      | "change quotes"       |
| <b>or tag* types</b>    | csth1<CR> | <h1>or tag types</h1> |
| delete(functi*on calls) | dsf       | function calls        |

### How `opts` overriding works?

> [!note] https://docs.astronvim.com/configuration/customizing_plugins/

При конфигурации плагинов в lazy.nvim основной способ настройки — это поле opts, которое модифицирует параметры setup() плагина. Оно автоматически объединяется с предыдущими настройками через vim.tbl_deep_extend.

#### Первый способ - простой, через table

Пишется как `opts = { option = true, keymap = { ... } }`, подходит для базовых настроек.

Из минусов:

- таблица вычисляется сразу, что может вызвать ошибки, например при ленивой загрузке модулей;
- при слиянии могут потеряться ключи (массивы заменяются целиком).

#### Второй способ - через function

```lua
opts = function(_, opts)
  -- можно безопасно использовать require(...)
  -- можно вручную модифицировать списки
  return opts
end
```

Исполняется только когда плагин загружается → безопасен для `require(...)`.
Позволяет вручную управлять слиянием, безопасно обновлять списки.

# Install

Required software:

- `ripgrep` - for telescope
- `xlip` / `wl-clipboard` - clipboard for x11/wayland
- `fd` - for virtual env

_Fonts_:

- WDXLLubrifont SC
- FiraCode Nerd Font
- BlexMono Nerd Font
- Gohu Nerd Font
- Terminess Nerd Font
- Iosevka Nerd Font
- JetBrains Nerd Font

> venv-selector don't find default poetry venvs (~/.cache/pypoetry/virtualenvs). So, i set `poetry config virtualenvs.in-project true`

## Command

- `:Telescope notify` - telescope find session notifications
- `:Notification` - show session notifications
- `:TodoQuickFix` - show todo quickfix
- `:ConformInfo` - show what used for buffer formatting.

## Learning

- `:'<,'>s/<old>/<new>/g` - replace all `<old>` to `<new>` from selected lines.
- `J` - join next line to current, also can be combined with count (`3J`).

- `CTRL-\_CTRL-N` - переключение в normal mode из terminal mode.

### Plugins

**Plugin manager**: `lazy.nvim`.

- `astrocore` - оркестратор: автокоманды, маппинги, опции, управление сессиями (`treesitter` + `textobjects`);
- `astrolsp` - (`vim.lsp.config`) абстракция над lsp: настраивает lsp, formatting, inlay hints;
- `astroui` - иконки и gui, (ex: get_icon);

- `mason.nvim` + `mason-lspconfig` + `mason-tool-installer` - lsp installation;
- `nvim-lspconfig` - lsp configuration;
- `blink.cmp` (`blink.compat`, `luasnip`, `friendly-snippets`, `mini.snippets`) - autocompletion/snippets;
- `lazydev.nvim` - advanced lua api neovim & astronvim;
- `none-ls.nvim` + `mason-null-ls` - non-lsp linters&formatters;
- `nvim-treesitter` - download parsers (use embedded neovim parser);

- `snacks.nvim` - custom windows, ex: dashboards, picker, notifier, zen, etc. Может быть конфликт хоткеей, т.к. snacks перехватывает их.
- `neo-tree` - file explorer;
- `heirline` - statuline/winbar;
- `which-key` - mapping helper;
- `gitsigns` - git integration (diff);
- `nvim-dap` + `nvim-dap-ui` + `cmp-dap` - debugger;
- `toggleterm` - terminal
- [?] `termopen` - для работы с терминалом.
- `resession` - sessions;
- `nvim-window-picker`, `smart-splits` - window navigation;

- `codesettings.nvim` - более детальная настройка, например подключать плагин `mrcjkb/rustaceanvim` только на тяжелый проектах.

#### LSP

- [?] `after/lsp/<lsp_name>.lua` - custom config for lsp, prefix `after` required due to override default config;

#### Snippets

For snippets add file to `snippets` folder with language name. I use `mini.snippets` [astrocommunity.snippet.mini-snippets](lua/community.lua), whick disable the `luasnip`:

- `global.json`: snippets for all files;
- `from_lang()`: find by pattern `snippets/<lang>.json`;
- `.vscode/<project>.code-snippets` - for specific project;

## Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bakg
mv ~/.cache/nvim ~/.cache/nvim.bak
```

## References

1. https://askubuntu.com/questions/1486871/how-can-i-copy-and-paste-outside-of-neovim
2. https://astronvim.lazyman.dev
3. https://github.com/mhinz/vim-galore
4. https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins
