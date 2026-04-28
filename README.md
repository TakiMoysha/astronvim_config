# AstroNvim V4

## Cheatsheet - about configuration

- `<C>` - CTRL
- `<M>` - ALT
- `<S>` - SHIFT

### **How `opts` overriding works?**

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

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bakg
mv ~/.cache/nvim ~/.cache/nvim.bak
```

# Install

Required software:

- `ripgrep` - for telescope
- `xlip` / `wl-clipboard` - clipboard for x11/wayland
- `fd` - for virtual env

_Fonts_:

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

- `termopen` - для работы с терминалом.
- `snacks.nvim` - для других окон, например pickle, opencode, etc. Может быть конфликт хоткеей, т.к. snacks перехватывает их.
- `codesettings.nvim` - более детальная настройка, например подключать плагин `mrcjkb/rustaceanvim` только на тяжелый проектах.

## References

1. https://askubuntu.com/questions/1486871/how-can-i-copy-and-paste-outside-of-neovim
2. https://astronvim.lazyman.dev
3. https://github.com/mhinz/vim-galore
4. https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins
