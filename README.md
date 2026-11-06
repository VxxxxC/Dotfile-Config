
> ⚠️ **Warning:** Don't blindly use my settings unless you know what that entails. Use at your own risk!

## Contents

- **Neovim** (>= 0.12) — main editor, LazyVim-based config
- **Tmux** — terminal multiplexer + TPM plugins
- **Fish Shell** — shell + Fisher + Oh My Fish
- **Node.js** — managed by [nvm.fish](https://github.com/jorgebucaran/nvm.fish) (needed by Mason LSPs/formatters and `czg`)
- **Helix** — secondary editor
- **SketchyBar** — macOS status bar _(macOS only)_
- **yabai + skhd** — tiling window manager + hotkey daemon _(macOS only)_
- [Installation](#installation) — one-command bootstrap via `Makefile`

## Installation

Clone this repo to `~/.config`, then run:

```sh
# Install everything (auto-detects macOS / Linux / Windows)
make            # same as: make all

# Or install individual components:
make cli-tools       # git, ripgrep, fd, fzf, jq, eza, lazygit, delta, curlie, oh-my-posh, WezTerm
make fonts           # Nerd Fonts (Hack + Symbols Only)
make fish            # Fish + Fisher + OMF + plugins
make node            # Node.js 24 via nvm.fish + czg (requires fish)
make neovim          # Neovim >= 0.12 + lazy.nvim + Mason (LSPs/DAPs/formatters) + Treesitter
make tmux            # tmux + TPM + plugins
make helix           # Helix editor
make macos-wm-tools  # sketchybar + skhd + yabai (macOS only)
make sketchybar      # SketchyBar + SF Pro / SF Symbols / sketchybar-app-font (macOS only)
make yabai           # yabai (macOS only)
make skhd            # skhd (macOS only)

# Show all targets:
make help
```

> **Order:** `make all` installs fish before node, and node before Neovim's Mason tools.  
> **Node versions:** switch any time with `nvm install <ver>` / `nvm use <ver>`.  
> **Windows:** sketchybar / yabai / skhd are automatically skipped; Node comes from choco (no fish).  
> Fish shell on Windows requires WSL or MSYS2.

### Manual installs (not handled by the Makefile)

- **Language runtimes / SDKs** — Python (pyenv / venv / Anaconda / pipx), Rust, Go, Java (SDKMAN), Ruby (rbenv), Bun, Foundry, LLVM.  
  `fish/config.fish` skips their init lines when they are not installed.
- **Karabiner-Elements** — download from https://karabiner-elements.pqrs.org/
- **Doom Emacs** — follow https://github.com/doomemacs/doomemacs#install

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
├── fish/               # Fish shell + Fisher plugins (incl. nvm.fish)
├── sketchybar/         # SketchyBar items & plugins (macOS)
├── skhd/               # skhd hotkey config (macOS)
├── yabai/              # yabai tiling WM (macOS)
├── helix/              # Helix editor
├── lazygit/            # lazygit (delta pager)
├── karabiner/          # Karabiner-Elements (manual install)
├── doom/               # Doom Emacs (manual install)
└── Makefile            # Bootstrap installer
```
