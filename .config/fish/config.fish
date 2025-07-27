if status is-interactive
    starship init fish | source

    function fish_greeting
        echo "     (o_"
        echo "(o_  //\\"
        echo "(/)_ V_/_"
    end

end

function emacs
    set emacspath (which emacs)
    if contains -- --no-window-system $argv; or contains -- -nw $argv
        $emacspath $argv
    else
        $emacspath $argv &
    end
end

alias git-tree='git log --oneline --graph --decorate --all'
alias cat=bat
alias venv='source .venv/bin/activate.fish'

alias update-system='sudo pacman --noconfirm -Syu; yay --noconfirm -Syu; sudo pacman -Qtdq | sudo pacman --noconfirm -Rns -; sudo pacman --noconfirm -Sc; sudo fwupdmgr refresh && sudo fwupdmgr update; flatpak update -y'

# uv
fish_add_path "/home/krisque/.local/bin"
