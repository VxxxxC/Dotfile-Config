# Greeting prologue
echo "Welcome to "(uname -a | awk '{print $1 " " $2 " " $3 " " $4 " " $12}')
uptime

alias v nvim
alias h hx
alias g git
alias python python3
alias pip pip3
alias http curlie
alias xcode "open -a Xcode"

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

# nvm
. ~/.config/fish/conf.d/nvm.fish
nvm use 23

# bun completions
[ -s "/Users/vxxxxc/.bun/_bun" ] && source "/Users/vxxxxc/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#This is oh-my-posh theme init when starting up fish shell
eval "$(oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/kushal.omp.json)"

#Ruby version manage
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

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

# Export rubygems path
export PATH="/opt/homebrew/lib/ruby/gems/2.7.0/bin:$PATH"
# or
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

# Created by `pipx` on 2025-01-08 15:26:21
set PATH $PATH /Users/vxxxxc/.local/bin

# change Python version on local project by pyenv
export PATH="/Users/vxxxxc/.pyenv/shims:$PATH"
eval "$(pyenv init --path)"

# Export variables for docker ipfs image
export ipfs_staging="/Users/vxxxxc/.ipfs/ipfs_staging/"
export ipfs_data="/Users/vxxxxc/.ipfs/ipfs_data/"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/vxxxxc/.lmstudio/bin
# End of LM Studio CLI section

# Export Solana CLI path
export PATH="/Users/vxxxxc/.local/share/solana/install/active_release/bin:$PATH"
