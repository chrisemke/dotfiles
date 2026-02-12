(use-modules
 (gnu home)
 (gnu home services)
 (gnu home services desktop)
 (gnu home services gnupg)
 (gnu home services guix)
 (gnu home services shells)
 (gnu home services shepherd)
 (gnu home services sound)
 (gnu home services ssh)
 (gnu packages)
 (gnu packages admin) ; btop fastfetch inxi
 (gnu packages bittorrent) ; qbittorrent
 (gnu packages commencement) ; gcc-toolchain
 (gnu packages compression) ; unzip
 (gnu packages containers) ; podman podman-compose
 (gnu packages emacs) ; emacs-next
 (gnu packages fonts)
 (gnu packages games) ; steam-devices-udev-rules
 (gnu packages glib) ; glib:bin
 (gnu packages gnupg)
 (gnu packages gtk) ; appmenu-gtk-module libdbusmenu
 (gnu packages kde-graphics) ; okular
 (gnu packages kde-plasma) ; plasma-disks
 (gnu packages kde-sdk) ; kompare
 (gnu packages kde-utils) ; ark kate kcalc
 (gnu packages libreoffice) ; libreoffice
 (gnu packages linux)
 (gnu packages package-management) ; flatpak
 (gnu packages python) ; python-next python-wrapper
 (gnu packages rust-apps) ; aardvark-dns helvum lsd ripgrep uv
 (gnu packages screen) ; screen
 (gnu packages shells) ; fish
 (gnu packages shellutils) ; starship
 (gnu packages ssh) ; openssh
 (gnu packages terminals) ; alacritty
 (gnu packages version-control) ; git
 (gnu packages video) ; vlc
 (gnu packages xdisorg) ; xsettingsd
 (guix channels)
 (guix gexp)
 (nongnu packages firmware) ; fwupd-nonfree
 (nongnu packages game-client) ; steam
 (saayix packages binaries) ; zen-browser-bin
 (saayix packages fonts) ; font-nerd-opendyslexic
 )

(home-environment
 (packages
	(list
	 aardvark-dns
	 alacritty
	 appmenu-gtk-module
	 ark
	 btop
	 emacs-next
	 fastfetch
	 fish
	 flatpak
	 font-google-noto-emoji
	 font-nerd-opendyslexic
	 font-wqy-zenhei
	 fwupd-nonfree
	 gcc-toolchain
	 git
	 (list glib "bin")
	 gnupg
	 helvum
	 inxi
	 kate
	 kcalc
	 kompare
	 libreoffice
	 lsd
	 libdbusmenu
	 okular
	 openssh
	 plasma-disks
	 podman
	 podman-compose
	 python-next
	 python-wrapper
	 qbittorrent
	 ripgrep
	 screen
	 starship
	 steam
	 steam-devices-udev-rules
	 uv
	 unzip
	 vlc
	 xsettingsd
	 zen-browser-bin
	 ))

 (services
	(list
	 (service home-bash-service-type
						(home-bash-configuration
						 (aliases '())
						 (bashrc (list (local-file "/home/krisque/.bashrc" "bashrc")))
						 (bash-profile
							(list (plain-file "profile"
																(string-append
																 "\n"
																 "gsettings set org.gnome.desktop.interface gtk-theme 'Breeze'\n"
																 "gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'\n"
																 "gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'\n"
																 "gsettings set org.gnome.desktop.interface font-name 'OpenDyslexic Nerd Font'\n"))))))
	 (service home-dbus-service-type)
	 (service home-gpg-agent-service-type
						(home-gpg-agent-configuration
						 (pinentry-program
							(file-append pinentry "/bin/pinentry"))))
	 (service home-pipewire-service-type
						(home-pipewire-configuration
						 (wireplumber wireplumber-minimal)))
	 (service home-ssh-agent-service-type)
	 (let* ((socket-dir (string-append (getenv "XDG_RUNTIME_DIR") "/podman"))
					(socket (string-append "unix://" socket-dir "/podman.sock"))
					(start-gexp #~(begin
													(mkdir-p #$socket-dir)
													(make-forkexec-constructor
													 (list #$(file-append podman "/bin/podman")
																 "system" "service" "--time=0" #$socket)))))
		 (simple-service 'podman-socket
										 home-shepherd-service-type
										 (list (shepherd-service
														(provision '(podman-socket))
														(modules '((guix build utils)))
														(start start-gexp)
														(stop #~(make-kill-destructor))))))
	 (simple-service 'home-extra-channels
									 home-channels-service-type
									 (list (channel
													(name 'nonguix)
													(url "https://gitlab.com/nonguix/nonguix")
													(introduction
													 (make-channel-introduction
														"897c1a470da759236cc11798f4e0a5f7d4d59fbc"
														(openpgp-fingerprint
														 "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
												 (channel
													(name 'saayix)
													(branch "main")
													(url "https://codeberg.org/look/saayix")
													(introduction
													 (make-channel-introduction
														"12540f593092e9a177eb8a974a57bb4892327752"
														(openpgp-fingerprint
														 "3FFA 7335 973E 0A49 47FC 0A8C 38D5 96BE 07D3 34AB"))))
												 (channel
													(name 'radix)
													(url "https://codeberg.org/anemofilia/radix.git")
													(branch "main")
													(introduction
													 (make-channel-introduction
														"f9130e11e35d2c147c6764ef85542dc58dc09c4f"
														(openpgp-fingerprint
														 "F164 709E 5FC7 B32B AEC7 9F37 1F2E 76AC E3F5 31C8"))))))
	 (simple-service 'home-shell-environment-variables
									 home-environment-variables-service-type
									 `(("PATH" . "$HOME/.local/bin:$PATH")
										 ("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$XDG_DATA_DIRS")
										 ("XDG_DATA_DIRS" . "$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS"))))))
