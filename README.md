# AstroNvim V4

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
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

## Learning

##### Commands

`:'<,'>s/<old>/<new>/g` - replace all `<old>` to `<new>` from selected lines.

##### Change mode


## References

1. https://askubuntu.com/questions/1486871/how-can-i-copy-and-paste-outside-of-neovim
2. https://astronvim.lazyman.dev
