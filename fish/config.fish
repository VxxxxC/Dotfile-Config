# Greeting prologue
echo "Welcome to "(uname -a | awk '{print $1 " " $2 " " $3 " " $4 " " $12}')
uptime

#This is oh-my-posh theme init when starting up fish shell
eval "$(oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/kushal.omp.json)"

# map alias for cli
alias v nvim
alias e emacs
alias h hx
alias g git
alias commit czg
alias python python3
alias pip pip3
alias http curlie
alias xcode "open -a Xcode"
alias ports='lsof -n -i4TCP | grep LISTEN'

# below is fish-exa shortcut command
if type -q ll
    alias ll lli
    alias lla llai
end
if type -q l
    alias l li
    alias la lai
    alias l-tree lt
end

if type -q fzf
    alias fzf "fzf --preview 'cat {}' --margin 5% --padding 5% --border"
end

# emacs
export PATH="/Users/vxxxxc/.config/emacs/bin:$PATH"

# LLVM - C++ / RUST compiler,debugger
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# nvm
. ~/.config/fish/conf.d/nvm.fish
nvm use 23

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# cre
export CRE_INSTALL="$HOME/.cre"
export PATH="$CRE_INSTALL/bin:$PATH"

#Ruby version manage
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

# Export rubygems path
export PATH="/opt/homebrew/lib/ruby/gems/2.7.0/bin:$PATH"
# or
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

#Andorid Studio SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Yazi shell wrapper
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Export variables for docker ipfs image
export ipfs_staging="/Users/vxxxxc/.ipfs/ipfs_staging/"
export ipfs_data="/Users/vxxxxc/.ipfs/ipfs_data/"

# Export Solana CLI path
export PATH="/Users/vxxxxc/.local/share/solana/install/active_release/bin:$PATH"

# Added by Antigravity
export PATH="/Users/vxxxxc/.antigravity/antigravity/bin:$PATH"

# change Python version on local project by pyenv
export PATH="/Users/vxxxxc/.pyenv/shims:$PATH"
eval "$(pyenv init --path)"

# Created by `pipx` on 2025-01-08 15:26:21
set PATH $PATH /Users/vxxxxc/.local/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/vxxxxc/.anaconda3/bin/conda
    eval /Users/vxxxxc/.anaconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f /Users/vxxxxc/.anaconda3/etc/fish/conf.d/conda.fish
        . /Users/vxxxxc/.anaconda3/etc/fish/conf.d/conda.fish
    else
        set -x PATH /Users/vxxxxc/.anaconda3/bin:$PATH
    end
end
# <<< conda initialize <<<
eval conda deactivate

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vxxxxc/google-cloud-sdk/path.fish.inc' ]; . '/Users/vxxxxc/google-cloud-sdk/path.fish.inc'; end
