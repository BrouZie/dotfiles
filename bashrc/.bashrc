# ~/.bashrc
#
export PATH="/usr/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\e[38;5;75m\]=>\[\e[0m\] \[\e[38;5;208m\]\w\[\e[0m\] \$ '

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Golang setup
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Aliases for a better life
alias nconf="cd ~/.config/nvim/ && nvim ."
alias hyprconf="cd ~/.config/hypr/ && nvim ."
alias svba="source venv/bin/activate"
alias icat="kitty +kitten icat"

# Fuzzy finding with neovim setup
# export FZF_DEFAULT_COMMAND='fd --type f --hidden \
#   --exclude .git --exclude node_modules --exclude venv --exclude .venv --strip-cwd-prefix .'
# export FZF_DEFAULT_OPTS='--height 90% --border --preview="bat --color=always {}" --preview-window=right:40%'
# alias inv='nvim $(fzf)'

# Fzf key-binds enabled
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
