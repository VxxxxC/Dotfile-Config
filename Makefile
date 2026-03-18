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

# --- Package Manager Commands ---
ifeq ($(OS),macos)
    INSTALL      := brew install
    CASK_INSTALL := brew install --cask
    TAP          := brew tap
    PKG_UPDATE   := brew update
    HAS_PKG      := command -v brew >/dev/null 2>&1
    FONT_INSTALL := brew install --cask font-sf-pro font-hack-nerd-font font-symbols-only-nerd-font
else ifeq ($(OS),linux)
    INSTALL      := sudo apt-get install -y
    PKG_UPDATE   := sudo apt-get update
    HAS_PKG      := command -v apt-get >/dev/null 2>&1
    FONT_INSTALL := @echo "[INFO] Install Nerd Fonts manually: https://www.nerdfonts.com/font-downloads"
else ifeq ($(OS),windows)
    INSTALL      := choco install -y
    PKG_UPDATE   := @echo "[INFO] Update packages via choco/scoop manually"
    HAS_PKG      := command -v choco >/dev/null 2>&1
    FONT_INSTALL := choco install -y nerd-fonts-hack
endif

SHELL := /bin/bash
.DEFAULT_GOAL := all

CONFIG_DIR := $(HOME)/.config
TMUX_DIR   := $(HOME)/.tmux
TPM_DIR    := $(TMUX_DIR)/plugins/tpm

# ============================================================================
#  Main Targets
# ============================================================================

.PHONY: all check-os install-pkg-manager \
        symlinks \
        neovim neovim-deps neovim-plugins neovim-mason neovim-treesitter \
        tmux tmux-plugins \
        fish fish-plugins omf \
        sketchybar skhd yabai \
        yazi yazi-plugins \
        fonts cli-tools formatters \
        clean help

all: check-os install-pkg-manager cli-tools fonts \
     neovim tmux fish yazi \
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
	@echo "  neovim           - Install Neovim + plugins + LSPs + formatters"
	@echo "  tmux             - Install tmux + TPM + plugins"
	@echo "  fish             - Install Fish shell + Fisher + OMF + plugins"
	@echo "  yazi             - Install yazi + plugins"
	@echo "  sketchybar       - Install SketchyBar (macOS only)"
	@echo "  skhd             - Install skhd (macOS only)"
	@echo "  yabai            - Install yabai (macOS only)"
	@echo "  cli-tools        - Install shared CLI dependencies"
	@echo "  fonts            - Install required fonts"
	@echo "  formatters       - Install code formatters for Neovim"
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
#  Shared CLI Tools
# ============================================================================

cli-tools:
	@echo "🔧 Installing CLI dependencies..."
ifeq ($(OS),macos)
	brew install git curl wget unzip gcc make cmake \
		ripgrep fd fzf jq eza lazygit \
		node python3 pyenv rbenv \
		curlie pipx oh-my-posh \
		luarocks go rust
	# bun
	@if ! command -v bun >/dev/null 2>&1; then \
		curl -fsSL https://bun.sh/install | bash; \
	fi
else ifeq ($(OS),linux)
	sudo apt-get install -y git curl wget unzip build-essential cmake \
		ripgrep fd-find fzf jq \
		python3 python3-pip python3-venv \
		luarocks golang cargo
	# fd is fd-find on Debian/Ubuntu, create symlink
	@if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then \
		sudo ln -sf $$(which fdfind) /usr/local/bin/fd; \
	fi
	# eza (not in default apt on older distros)
	@if ! command -v eza >/dev/null 2>&1; then \
		echo "📦 Installing eza..."; \
		cargo install eza 2>/dev/null || echo "[WARN] Install eza manually: https://github.com/eza-community/eza"; \
	fi
	# lazygit
	@if ! command -v lazygit >/dev/null 2>&1; then \
		echo "📦 Installing lazygit..."; \
		LAZYGIT_VERSION=$$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'); \
		curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; \
		tar xf /tmp/lazygit.tar.gz -C /tmp lazygit; \
		sudo install /tmp/lazygit /usr/local/bin; \
	fi
	# Node.js via nvm
	@if ! command -v node >/dev/null 2>&1; then \
		echo "📦 Installing Node.js via nvm..."; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; \
		export NVM_DIR="$$HOME/.nvm"; \
		[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
		nvm install 23; \
	fi
	# oh-my-posh
	@if ! command -v oh-my-posh >/dev/null 2>&1; then \
		curl -s https://ohmyposh.dev/install.sh | bash -s; \
	fi
	# pipx
	@if ! command -v pipx >/dev/null 2>&1; then \
		python3 -m pip install --user pipx; \
		python3 -m pipx ensurepath; \
	fi
	# bun
	@if ! command -v bun >/dev/null 2>&1; then \
		curl -fsSL https://bun.sh/install | bash; \
	fi
	# curlie
	@if ! command -v curlie >/dev/null 2>&1; then \
		go install github.com/rs/curlie@latest 2>/dev/null || echo "[WARN] Install curlie manually"; \
	fi
	# pyenv
	@if ! command -v pyenv >/dev/null 2>&1; then \
		curl https://pyenv.run | bash; \
	fi
	# rbenv
	@if ! command -v rbenv >/dev/null 2>&1; then \
		curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash; \
	fi
else ifeq ($(OS),windows)
	choco install -y git curl wget unzip mingw cmake \
		ripgrep fd fzf jq eza lazygit \
		nodejs python3 golang rust \
		luarocks
	# bun
	@if ! command -v bun >/dev/null 2>&1; then \
		powershell -c "irm bun.sh/install.ps1 | iex" 2>/dev/null || echo "[WARN] Install bun manually: https://bun.sh"; \
	fi
	# oh-my-posh
	@if ! command -v oh-my-posh >/dev/null 2>&1; then \
		choco install -y oh-my-posh; \
	fi
endif

# ============================================================================
#  Fonts
# ============================================================================

fonts:
	@echo "🔤 Installing fonts..."
ifeq ($(OS),macos)
	brew tap homebrew/cask-fonts 2>/dev/null || true
	brew install --cask font-hack-nerd-font font-symbols-only-nerd-font 2>/dev/null || true
	# sketchybar-app-font
	@if [ ! -f "$(HOME)/Library/Fonts/sketchybar-app-font.ttf" ]; then \
		echo "📦 Installing sketchybar-app-font..."; \
		curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf \
			-o "$(HOME)/Library/Fonts/sketchybar-app-font.ttf" 2>/dev/null || true; \
	fi
	# SF Pro (from Apple, only available via macOS)
	@echo "ℹ️  SF Pro: Install from https://developer.apple.com/fonts/ if not already present"
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
#  Neovim
# ============================================================================

neovim: neovim-deps neovim-plugins neovim-mason neovim-treesitter formatters
	@echo "✅ Neovim setup complete"

neovim-deps:
	@echo "📦 Installing Neovim..."
ifeq ($(OS),macos)
	brew install neovim luarocks
else ifeq ($(OS),linux)
	@# Install latest Neovim (apt version is often outdated)
	@if ! command -v nvim >/dev/null 2>&1 || [ "$$(nvim --version | head -1 | grep -oP '\d+\.\d+')" \< "0.10" ]; then \
		echo "📦 Installing latest Neovim from GitHub releases..."; \
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; \
		sudo rm -rf /opt/nvim; \
		sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz; \
		sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim; \
		rm -f nvim-linux-x86_64.tar.gz; \
	fi
	sudo apt-get install -y luarocks
else ifeq ($(OS),windows)
	choco install -y neovim luarocks
endif

neovim-plugins:
	@echo "📦 Bootstrapping lazy.nvim plugins (headless)..."
	nvim --headless "+Lazy! sync" +qa 2>/dev/null || \
		nvim --headless -c "lua require('config.lazy')" -c "sleep 30" -c "qa" 2>/dev/null || true
	@echo "  lazy.nvim plugins synced"

neovim-mason:
	@echo "📦 Installing Mason LSP servers, DAPs, and tools..."
	@# Mason ensure_installed LSP servers
	nvim --headless -c "MasonInstall \
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
	@# Mason DAP adapters
	nvim --headless -c "MasonInstall \
		bash-debug-adapter \
		js-debug-adapter \
		codelldb" \
		-c "sleep 30" -c "qa" 2>/dev/null || true
	@echo "  Mason tools installed"

neovim-treesitter:
	@echo "📦 Installing Treesitter parsers..."
	nvim --headless -c "TSInstallSync \
		bash c cpp fish gitcommit graphql html java javascript \
		json json5 jsonc lua markdown markdown_inline python \
		query rasi regex rust scss toml tsx typescript vim vimdoc yaml solidity" \
		-c "qa" 2>/dev/null || \
	nvim --headless -c "TSUpdate" -c "sleep 20" -c "qa" 2>/dev/null || true
	@echo "  Treesitter parsers installed"

# ============================================================================
#  Formatters & Linters (for conform.nvim)
# ============================================================================

formatters:
	@echo "📦 Installing formatters for Neovim (conform.nvim)..."
ifeq ($(OS),macos)
	brew install stylua shfmt yamlfmt taplo dprint
	npm install -g @fsouza/prettierd 2>/dev/null || npm install -g prettierd
	@# Foundry (forge_fmt for Solidity)
	@if ! command -v forge >/dev/null 2>&1; then \
		curl -L https://foundry.paradigm.xyz | bash; \
		foundryup 2>/dev/null || true; \
	fi
else ifeq ($(OS),linux)
	npm install -g @fsouza/prettierd 2>/dev/null || npm install -g prettierd
	npm install -g dprint
	@# stylua
	@if ! command -v stylua >/dev/null 2>&1; then \
		cargo install stylua; \
	fi
	@# shfmt
	@if ! command -v shfmt >/dev/null 2>&1; then \
		go install mvdan.cc/sh/v3/cmd/shfmt@latest; \
	fi
	@# yamlfmt
	@if ! command -v yamlfmt >/dev/null 2>&1; then \
		go install github.com/google/yamlfmt/cmd/yamlfmt@latest; \
	fi
	@# taplo
	@if ! command -v taplo >/dev/null 2>&1; then \
		cargo install taplo-cli; \
	fi
	@# Foundry
	@if ! command -v forge >/dev/null 2>&1; then \
		curl -L https://foundry.paradigm.xyz | bash; \
		foundryup 2>/dev/null || true; \
	fi
else ifeq ($(OS),windows)
	npm install -g @fsouza/prettierd dprint
	choco install -y stylua shfmt
	@# yamlfmt
	go install github.com/google/yamlfmt/cmd/yamlfmt@latest 2>/dev/null || true
	@# taplo
	cargo install taplo-cli 2>/dev/null || true
	@# Foundry
	@if ! command -v forge >/dev/null 2>&1; then \
		echo "[INFO] Install Foundry: https://book.getfoundry.sh/getting-started/installation"; \
	fi
endif

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
		echo "📦 Installing Fisher plugins..."; \
		fish -c "fisher install jorgebucaran/fisher" 2>/dev/null || true; \
		fish -c "fisher install andreiborisov/sponge" 2>/dev/null || true; \
		fish -c "fisher install jorgebucaran/autopair.fish" 2>/dev/null || true; \
		fish -c "fisher install jorgebucaran/nvm.fish" 2>/dev/null || true; \
		fish -c "fisher install gazorby/fish-exa" 2>/dev/null || true; \
		fish -c "fisher install jethrokuan/z" 2>/dev/null || true; \
		fish -c "fisher install berk-karaal/loadenv.fish" 2>/dev/null || true; \
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
	brew install sketchybar
	brew install jq
	brew install --cask sf-symbols 2>/dev/null || true
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
#  Yazi
# ============================================================================

yazi: yazi-install yazi-plugins
	@echo "✅ Yazi setup complete"

yazi-install:
	@echo "📦 Installing yazi..."
ifeq ($(OS),macos)
	brew install yazi ffmpeg mediainfo
else ifeq ($(OS),linux)
	@# yazi from cargo if not in apt
	@if ! command -v yazi >/dev/null 2>&1; then \
		cargo install --locked yazi-fm yazi-cli 2>/dev/null || \
		echo "[WARN] Install yazi manually: https://yazi-rs.github.io/docs/installation"; \
	fi
	sudo apt-get install -y ffmpeg mediainfo 2>/dev/null || true
else ifeq ($(OS),windows)
	choco install -y ffmpeg mediainfo
	@# yazi
	@if ! command -v yazi >/dev/null 2>&1; then \
		cargo install --locked yazi-fm yazi-cli 2>/dev/null || \
		echo "[WARN] Install yazi: https://yazi-rs.github.io/docs/installation"; \
	fi
endif

yazi-plugins:
	@echo "📦 Installing yazi plugins via ya pack..."
	@if command -v ya >/dev/null 2>&1; then \
		ya pack -i 2>/dev/null || true; \
	elif command -v yazi >/dev/null 2>&1; then \
		echo "[INFO] Run 'ya pack -i' after yazi is available in PATH"; \
	else \
		echo "[WARN] yazi not found, skipping plugin install"; \
	fi

# ============================================================================
#  Helix (referenced in fish alias)
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
#  Clean Caches
# ============================================================================

clean:
	@echo "🧹 Cleaning plugin caches..."
	rm -rf $(HOME)/.local/share/nvim/lazy 2>/dev/null || true
	rm -rf $(HOME)/.local/state/nvim 2>/dev/null || true
	rm -rf $(TMUX_DIR)/plugins 2>/dev/null || true
	@echo "  Cleaned nvim and tmux plugin caches"
	@echo "  (Fish plugins managed by Fisher — use 'fisher list' and 'fisher remove')"
