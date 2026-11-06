# ============================================================================
#  Dotfiles Bootstrap Makefile
#  Supports: macOS (Homebrew), Linux (apt), Windows (choco/scoop)
# ============================================================================

# --- OS Detection ---
UNAME := $(shell uname -s 2>/dev/null || echo Windows)
ifeq ($(UNAME),Darwin)
    OS := macos
else ifeq ($(UNAME),Linux)
    OS := linux
else
    # Windows (MSYS2, Git Bash, CMD, PowerShell)
    OS := windows
endif

SHELL := /bin/bash
.DEFAULT_GOAL := all

CONFIG_DIR := $(HOME)/.config
TMUX_DIR   := $(HOME)/.tmux
TPM_DIR    := $(TMUX_DIR)/plugins/tpm

# --- Versions ---
NODE_VERSION     := 24
NVIM_MIN_VERSION := 0.12

# Run a command with nvm.fish's Node on PATH (without loading config.fish).
# Windows has no fish, so Node comes from choco and commands run directly.
ifneq ($(OS),windows)
NVM_FISH = fish --no-config -c 'set -p fish_function_path $(CONFIG_DIR)/fish/functions; source $(CONFIG_DIR)/fish/conf.d/nvm.fish; nvm use --silent $(NODE_VERSION); and $$argv' --
endif

# Shell snippet: succeeds when the installed nvim >= NVIM_MIN_VERSION (sets $$v)
NVIM_VERSION_OK = v=$$(nvim --version 2>/dev/null | head -1 | sed -nE 's/^NVIM v([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/p'); \
	[ -n "$$v" ] && [ "$$(printf '%s\n' $(NVIM_MIN_VERSION) $$v | sort -V | head -1)" = "$(NVIM_MIN_VERSION)" ]

# ============================================================================
#  Main Targets
# ============================================================================

.PHONY: all help check-os install-pkg-manager symlinks \
        cli-tools fonts node \
        neovim neovim-deps neovim-plugins neovim-mason neovim-treesitter \
        tmux tmux-install tmux-plugins \
        fish fish-install fish-plugins omf \
        helix \
        macos-wm-tools sketchybar skhd yabai \
        clean

all: check-os install-pkg-manager symlinks cli-tools fonts \
     fish node neovim tmux helix \
     macos-wm-tools
	@echo ""
	@echo "============================================"
	@echo "  ✅  All done! Restart your shell."
	@echo "============================================"

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all              - Install everything (default)"
	@echo "  cli-tools        - Install shared CLI tools (git, ripgrep, fzf, lazygit, delta, wezterm...)"
	@echo "  fonts            - Install Nerd Fonts"
	@echo "  fish             - Install Fish shell + Fisher + OMF + plugins"
	@echo "  node             - Install Node.js $(NODE_VERSION) via nvm.fish + czg"
	@echo "  neovim           - Install Neovim >= $(NVIM_MIN_VERSION) + plugins + LSPs + formatters"
	@echo "  tmux             - Install tmux + TPM + plugins"
	@echo "  helix            - Install Helix editor"
	@echo "  macos-wm-tools   - Install sketchybar + skhd + yabai (macOS only)"
	@echo "  sketchybar       - Install SketchyBar + its fonts (macOS only)"
	@echo "  skhd             - Install skhd (macOS only)"
	@echo "  yabai            - Install yabai (macOS only)"
	@echo "  clean            - Remove plugin caches"
	@echo "  help             - Show this help"
	@echo ""
	@echo "Detected OS: $(OS)"

# ============================================================================
#  OS Check & Package Manager Bootstrap
# ============================================================================

check-os:
	@echo "🖥  Detected OS: $(OS)"
ifeq ($(OS),windows)
	@echo "⚠️  Windows: sketchybar, skhd, yabai are macOS-only and will be skipped."
endif
ifeq ($(OS),linux)
	@echo "⚠️  Linux: sketchybar, skhd, yabai are macOS-only and will be skipped."
endif

install-pkg-manager:
ifeq ($(OS),macos)
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "📦 Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "📦 Homebrew already installed"; \
	fi
	@brew update
else ifeq ($(OS),linux)
	@sudo apt-get update
else ifeq ($(OS),windows)
	@if ! command -v choco >/dev/null 2>&1; then \
		echo "📦 Please install Chocolatey first: https://chocolatey.org/install"; \
		echo "   Or install Scoop: https://scoop.sh"; \
		exit 1; \
	fi
	@if command -v scoop >/dev/null 2>&1; then \
		scoop bucket add extras; \
		scoop bucket add nerd-fonts; \
	fi
endif

# ============================================================================
#  Symlinks Setup
# ============================================================================

symlinks:
	@echo "🔗 Creating symlinks..."
	@ln -sf $(CONFIG_DIR)/tmux/tmux.conf $(HOME)/.tmux.conf 2>/dev/null || true
	@echo "  Symlinks created"

# ============================================================================
#  Shared CLI Tools
# ============================================================================

# NOTE: Language runtimes / SDKs (python, rust, go, java, ruby, bun, solidity...)
#       are intentionally NOT installed here — install them manually per project.
#       Node is installed separately by the `node` target (nvm.fish).
cli-tools:
	@echo "🔧 Installing CLI dependencies..."
ifeq ($(OS),macos)
	brew install git curl wget unzip \
		ripgrep fd fzf jq eza lazygit git-delta \
		curlie oh-my-posh
	brew install --cask wezterm
else ifeq ($(OS),linux)
	sudo apt-get install -y git curl wget unzip build-essential \
		ripgrep fd-find fzf jq
	# fd is fd-find on Debian/Ubuntu, create symlink
	@if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then \
		sudo ln -sf $$(which fdfind) /usr/local/bin/fd; \
	fi
	# eza / git-delta (not in default apt on older distros)
	sudo apt-get install -y eza 2>/dev/null || echo "[WARN] Install eza manually: https://github.com/eza-community/eza"
	sudo apt-get install -y git-delta 2>/dev/null || echo "[WARN] Install delta manually: https://github.com/dandavison/delta"
	# lazygit
	@if ! command -v lazygit >/dev/null 2>&1; then \
		echo "📦 Installing lazygit..."; \
		LAZYGIT_VERSION=$$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'); \
		curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; \
		tar xf /tmp/lazygit.tar.gz -C /tmp lazygit; \
		sudo install /tmp/lazygit /usr/local/bin; \
	fi
	# oh-my-posh
	@if ! command -v oh-my-posh >/dev/null 2>&1; then \
		curl -s https://ohmyposh.dev/install.sh | bash -s; \
	fi
	# curlie
	@command -v curlie >/dev/null 2>&1 || echo "[WARN] Install curlie manually: https://github.com/rs/curlie/releases"
else ifeq ($(OS),windows)
	choco install -y git curl wget unzip mingw \
		ripgrep fd fzf jq eza lazygit delta \
		wezterm
	# oh-my-posh
	@if ! command -v oh-my-posh >/dev/null 2>&1; then \
		choco install -y oh-my-posh; \
	fi
endif

# ============================================================================
#  Fonts
# ============================================================================

fonts:
	@echo "🔤 Installing Nerd Fonts..."
ifeq ($(OS),macos)
	brew install --cask font-hack-nerd-font font-symbols-only-nerd-font
else ifeq ($(OS),linux)
	@mkdir -p $(HOME)/.local/share/fonts
	@if ! fc-list | grep -qi "Hack Nerd"; then \
		echo "📦 Installing Hack Nerd Font..."; \
		curl -fLo /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip; \
		unzip -o /tmp/Hack.zip -d $(HOME)/.local/share/fonts/; \
		fc-cache -fv; \
	fi
else ifeq ($(OS),windows)
	choco install -y nerd-fonts-hack 2>/dev/null || \
		echo "[INFO] Install Nerd Fonts manually: https://www.nerdfonts.com/font-downloads"
endif

# ============================================================================
#  Node.js (nvm.fish) — needed by Mason LSPs/formatters and czg
# ============================================================================

node:
	@echo "📦 Installing Node.js $(NODE_VERSION)..."
ifeq ($(OS),windows)
	choco install -y nodejs
	npm install -g czg
else
	@command -v fish >/dev/null 2>&1 || { echo "❌ fish not found, run 'make fish' first"; exit 1; }
	@mkdir -p $(HOME)/.local/share/nvm
	fish --no-config -c 'set -p fish_function_path $(CONFIG_DIR)/fish/functions; source $(CONFIG_DIR)/fish/conf.d/nvm.fish; nvm install $(NODE_VERSION)'
	$(NVM_FISH) npm install -g czg
	@echo "ℹ️  Switch versions any time: nvm install <ver> && nvm use <ver>"
endif

# ============================================================================
#  Neovim
# ============================================================================

neovim: neovim-deps node neovim-plugins neovim-mason neovim-treesitter
	@echo "✅ Neovim setup complete"

neovim-deps:
	@echo "📦 Installing Neovim (>= $(NVIM_MIN_VERSION))..."
ifeq ($(OS),macos)
	brew install neovim luarocks
else ifeq ($(OS),linux)
	@# apt's Neovim is usually too old — install the latest GitHub release instead
	@if ! { $(NVIM_VERSION_OK); }; then \
		echo "📦 Installing latest Neovim from GitHub releases..."; \
		curl -fLo /tmp/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; \
		sudo rm -rf /opt/nvim-linux-x86_64; \
		sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz; \
		sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim; \
		rm -f /tmp/nvim-linux-x86_64.tar.gz; \
	fi
	sudo apt-get install -y luarocks
else ifeq ($(OS),windows)
	choco install -y neovim luarocks
endif
	@if $(NVIM_VERSION_OK); then \
		echo "  Neovim $$v ✔ (>= $(NVIM_MIN_VERSION))"; \
	else \
		echo "❌ Neovim >= $(NVIM_MIN_VERSION) required, found: $$(nvim --version 2>/dev/null | head -1)"; \
		exit 1; \
	fi

neovim-plugins:
	@echo "📦 Bootstrapping lazy.nvim plugins (headless)..."
	$(NVM_FISH) nvim --headless "+Lazy! sync" +qa 2>/dev/null || \
		$(NVM_FISH) nvim --headless -c "lua require('config.lazy')" -c "sleep 30" -c "qa" 2>/dev/null || true
	@echo "  lazy.nvim plugins synced"

neovim-mason:
	@echo "📦 Installing Mason LSP servers, DAPs, and tools..."
	@# Mason ensure_installed LSP servers
	$(NVM_FISH) nvim --headless -c "MasonInstall \
		bash-language-server \
		lua-language-server \
		typescript-language-server \
		eslint-lsp \
		tailwindcss-language-server \
		css-lsp \
		html-lsp \
		yaml-language-server \
		rust-analyzer \
		solidity-ls" \
		-c "sleep 30" -c "qa" 2>/dev/null || true
	@# Mason formatters (for conform.nvim)
	$(NVM_FISH) nvim --headless -c "MasonInstall \
		stylua \
		shfmt \
		prettierd \
		yamlfmt \
		taplo" \
		-c "sleep 30" -c "qa" 2>/dev/null || true
	@# Mason DAP adapters
	$(NVM_FISH) nvim --headless -c "MasonInstall \
		bash-debug-adapter \
		js-debug-adapter \
		codelldb" \
		-c "sleep 30" -c "qa" 2>/dev/null || true
	@echo "  Mason tools installed"

neovim-treesitter:
	@echo "📦 Installing Treesitter parsers..."
	nvim --headless -c "TSInstallSync \
		bash c cpp fish gitcommit go graphql html java javascript \
		json json5 jsonc lua markdown markdown_inline python \
		query rasi regex rust scss toml tsx typescript vim vimdoc yaml solidity" \
		-c "qa" 2>/dev/null || \
	nvim --headless -c "TSUpdate" -c "sleep 20" -c "qa" 2>/dev/null || true
	@echo "  Treesitter parsers installed"

# ============================================================================
#  Tmux
# ============================================================================

tmux: tmux-install tmux-plugins
	@echo "✅ Tmux setup complete"

tmux-install:
	@echo "📦 Installing tmux..."
ifeq ($(OS),macos)
	brew install tmux reattach-to-user-namespace
else ifeq ($(OS),linux)
	sudo apt-get install -y tmux xclip
else ifeq ($(OS),windows)
	@echo "⚠️  Tmux on Windows: use WSL or MSYS2"
	@echo "   If using MSYS2: pacman -S tmux"
endif

tmux-plugins:
	@echo "📦 Installing TPM (Tmux Plugin Manager)..."
	@if [ ! -d "$(TPM_DIR)" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	else \
		echo "  TPM already installed"; \
	fi
	@echo "📦 Installing tmux plugins via TPM..."
	@# TPM install all plugins defined in tmux.conf
	$(TPM_DIR)/bin/install_plugins 2>/dev/null || \
		bash $(TPM_DIR)/bin/install_plugins 2>/dev/null || \
		echo "[WARN] Run 'prefix + I' inside tmux to install plugins"

# ============================================================================
#  Fish Shell
# ============================================================================

fish: fish-install fish-plugins omf
	@echo "✅ Fish shell setup complete"

fish-install:
	@echo "📦 Installing Fish shell..."
ifeq ($(OS),macos)
	brew install fish
	@# Add fish to valid shells if not already
	@if ! grep -q "$$(which fish)" /etc/shells; then \
		echo "$$(which fish)" | sudo tee -a /etc/shells; \
	fi
	@echo "ℹ️  To set fish as default: chsh -s $$(which fish)"
else ifeq ($(OS),linux)
	@# Use fish PPA for latest version
	@if ! command -v fish >/dev/null 2>&1; then \
		sudo apt-add-repository -y ppa:fish-shell/release-3 2>/dev/null || true; \
		sudo apt-get update; \
		sudo apt-get install -y fish; \
	fi
	@if ! grep -q "$$(which fish)" /etc/shells; then \
		echo "$$(which fish)" | sudo tee -a /etc/shells; \
	fi
	@echo "ℹ️  To set fish as default: chsh -s $$(which fish)"
else ifeq ($(OS),windows)
	@echo "⚠️  Fish shell is not natively supported on Windows."
	@echo "   Use WSL or MSYS2 for Fish."
endif

fish-plugins:
	@echo "📦 Installing Fisher (Fish plugin manager)..."
	@if command -v fish >/dev/null 2>&1; then \
		fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>/dev/null || true; \
		echo "📦 Installing Fisher plugins via fisher update..."; \
		fish -c "fisher update" 2>/dev/null || true; \
	else \
		echo "[WARN] Fish not found, skipping Fisher plugins"; \
	fi

omf:
	@echo "📦 Installing Oh My Fish..."
	@if command -v fish >/dev/null 2>&1; then \
		if ! fish -c "type -q omf" 2>/dev/null; then \
			fish -c "curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish" 2>/dev/null || \
			curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > /tmp/omf-install.fish && \
			fish /tmp/omf-install.fish --noninteractive 2>/dev/null || true; \
		else \
			echo "  Oh My Fish already installed"; \
		fi; \
	else \
		echo "[WARN] Fish not found, skipping OMF"; \
	fi

# ============================================================================
#  Helix (fish alias: h)
# ============================================================================

helix:
	@echo "📦 Installing Helix editor..."
ifeq ($(OS),macos)
	brew install helix
else ifeq ($(OS),linux)
	@if ! command -v hx >/dev/null 2>&1; then \
		sudo add-apt-repository -y ppa:maveonair/helix-editor 2>/dev/null || true; \
		sudo apt-get update; \
		sudo apt-get install -y helix; \
	fi
else ifeq ($(OS),windows)
	choco install -y helix
endif

# ============================================================================
#  macOS Window Management (sketchybar + skhd + yabai)
# ============================================================================

macos-wm-tools:
ifeq ($(OS),macos)
	$(MAKE) sketchybar skhd yabai
else
	@echo "⏭  Skipping macOS-only tools (sketchybar, skhd, yabai)"
endif

sketchybar:
ifneq ($(OS),macos)
	@echo "⏭  SketchyBar is macOS-only, skipping"
else
	@echo "📦 Installing SketchyBar..."
	brew tap FelixKratz/formulae
	brew install sketchybar jq
	@# Fonts used by sketchybarrc: SF Pro, SF Symbols, sketchybar-app-font
	brew install --cask sf-symbols font-sf-pro
	@# sketchybar-app-font is pinned to the version matching plugins/icon_map_fn.sh
	@if [ ! -f "$(HOME)/Library/Fonts/sketchybar-app-font.ttf" ]; then \
		echo "📦 Installing sketchybar-app-font..."; \
		curl -fL https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf \
			-o "$(HOME)/Library/Fonts/sketchybar-app-font.ttf"; \
	fi
	@# Ensure sketchybar config scripts are executable
	chmod +x $(CONFIG_DIR)/sketchybar/sketchybarrc 2>/dev/null || true
	find $(CONFIG_DIR)/sketchybar -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
	@echo "ℹ️  Start SketchyBar: brew services start sketchybar"
	@echo "✅ SketchyBar setup complete"
endif

skhd:
ifneq ($(OS),macos)
	@echo "⏭  skhd is macOS-only, skipping"
else
	@echo "📦 Installing skhd..."
	brew install koekeishiya/formulae/skhd
	@echo "ℹ️  Start skhd: skhd --start-service"
	@echo "✅ skhd setup complete"
endif

yabai:
ifneq ($(OS),macos)
	@echo "⏭  yabai is macOS-only, skipping"
else
	@echo "📦 Installing yabai..."
	brew install koekeishiya/formulae/yabai
	chmod +x $(CONFIG_DIR)/yabai/yabairc 2>/dev/null || true
	@echo "ℹ️  Start yabai: yabai --start-service"
	@echo "ℹ️  Note: yabai requires accessibility permissions and SIP config for full features"
	@echo "✅ yabai setup complete"
endif

# ============================================================================
#  Clean Caches
# ============================================================================

clean:
	@echo "🧹 Cleaning plugin caches..."
	rm -rf $(HOME)/.local/share/nvim/lazy 2>/dev/null || true
	rm -rf $(HOME)/.local/state/nvim 2>/dev/null || true
	rm -rf $(TMUX_DIR)/plugins 2>/dev/null || true
	@echo "  Cleaned nvim and tmux plugin caches"
	@echo "  (Fish plugins managed by Fisher — use 'fisher list' and 'fisher remove')"
