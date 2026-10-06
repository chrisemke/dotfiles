set -g fish_greeting

if status is-interactive
    type -q starship; and starship init fish | source
end

if type -q gls
    alias ls='gls --human-readable --group-directories-first --color=auto'
else
    alias ls='ls --human-readable --group-directories-first --color=auto'
end

alias git-tree='git log --oneline --graph --decorate --all'
alias venv='source .venv/bin/activate.fish'
