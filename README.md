
> ⚠️ **Warning:** Don't blindly use my settings unless you know what that entails. Use at your own risk!

## Contents

- **Neovim** — main editor, LazyVim-based config
- **Tmux** — terminal multiplexer + TPM plugins
- **Fish Shell**] — shell + Fisher + Oh My Fish
- **SketchyBar** — macOS status bar _(macOS only)_
- **yabai + skhd** — tiling window manager + hotkey daemon _(macOS only)_
- **Yazi** — terminal file manager
- [Installation](#installation) — one-command bootstrap via `Makefile`

## Installation

Clone this repo to `~/.config`, then run:

```sh
# Install everything (auto-detects macOS / Linux / Windows)
make install

# Or install individual components:
make neovim        # Neovim + lazy.nvim + Mason + Treesitter + formatters
make tmux          # tmux + TPM + plugins
make fish          # Fish + Fisher + OMF + plugins
make sketchybar    # SketchyBar (macOS only)
make yabai         # yabai (macOS only)
make skhd          # skhd (macOS only)
make yazi          # yazi + plugins
make cli-tools     # ripgrep, fd, fzf, lazygit, eza, node, bun, pyenv...
make fonts         # Nerd Fonts

# Show all targets:
make help
```

> **Windows:** sketchybar / yabai / skhd are automatically skipped.  
> Fish shell on Windows requires WSL or MSYS2.

---

## Directory Structure

```
~/.config/
├── nvim/               # Neovim (lazy.nvim)
│   ├── init.lua
│   └── lua/
│       ├── config/     # keymaps, autocmds, lazy bootstrap, theme
│       └── plugins/    # one file per plugin
├── tmux/               # Tmux + TPM
├── fish/               # Fish shell + Fisher plugins
├── sketchybar/         # SketchyBar items & plugins (macOS)
├── skhd/               # skhd hotkey config (macOS)
├── yabai/              # yabai tiling WM (macOS)
├── yazi/               # Yazi file manager
├── helix/              # Helix editor
└── Makefile            # Bootstrap installer
```
