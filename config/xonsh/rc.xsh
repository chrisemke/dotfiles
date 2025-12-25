print(
	'     (o_',
	'(o_  //\\',
	'(/)_ V_/_',
	sep='\n'
)

execx($(starship init xonsh --print-full-init))

aliases['git-tree']='git log --oneline --graph --decorate --all'
aliases['cat']='bat'
aliases['venv']='source-bash .venv/bin/activate'

aliases['update-system']='sudo pacman --noconfirm -Syu; yay --noconfirm -Syu; sudo pacman -Qtdq | sudo pacman --noconfirm -Rns -; sudo pacman --noconfirm -Sc; sudo fwupdmgr refresh && sudo fwupdmgr update; flatpak update -y'
