# Greeting prologue
echo "Welcome to "(uname -a | awk '{print $1 " " $2 " " $3 " " $4 " " $12}')
uptime

# nvm
. ~/.config/fish/conf.d/nvm.fish
nvm use 18

# Change prompt
# functions -c fish_prompt _old_fish_prompt
# function fish_prompt
#     if set -q VIRTUAL_ENV
#         echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
#     end
#     _old_fish_prompt
# end

#This is oh-my-posh theme init when starting up fish shell
eval "$(oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/kushal.omp.json)"

#Ruby version manage
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

#Andorid Studio SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Add rubygems to the path
export PATH="/opt/homebrew/lib/ruby/gems/2.7.0/bin:$PATH"
# or
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

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

alias v nvim
alias g git
alias python python3
alias pip pip3

if type -q fzf
    alias fzf "fzf --preview 'cat {}' --margin 5% --padding 5% --border"
end

# Created by `pipx` on 2025-01-08 15:26:21
set PATH $PATH /Users/vxxxxc/.local/bin

# change Python version on local project by pyenv
export PATH="/Users/vxxxxc/.pyenv/shims:$PATH"
eval "$(pyenv init --path)"
