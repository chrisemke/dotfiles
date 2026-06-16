starship init fish | source

set -g fish_greeting

function emacs
	set emacspath (which emacs)
	if contains -- --help $argv; or contains -- --no-window-system $argv; or contains -- -nw $argv
		$emacspath $argv >/dev/null 2>&1
	else
		$emacspath $argv >/dev/null 2>&1 &
	end
end

alias git-tree='git log --oneline --graph --decorate --all'
alias ls='ls --human-readable --group-directories-first --color=auto'
alias venv='source .venv/bin/activate.fish'
