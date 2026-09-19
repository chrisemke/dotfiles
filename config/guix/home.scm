(define-module (home)
	#:autoload (gnu home) (home-environment)
	#:autoload (gnu home services) (home-environment-variables-service-type
																	service
																	simple-service)
	#:autoload (gnu home services desktop) (home-dbus-service-type)
	#:autoload (gnu home services gnupg) (home-gpg-agent-configuration
																				home-gpg-agent-service-type)
	#:autoload (gnu home services guix) (home-channels-service-type)
	#:autoload (gnu home services shepherd) (home-shepherd-service-type
																					 shepherd-service)
	#:autoload (gnu home services sound) (home-pipewire-configuration
																				home-pipewire-service-type)
	#:autoload (gnu home services ssh) (home-ssh-agent-service-type)
	#:autoload (gnu home services xdg) (home-xdg-user-directories-configuration
																			home-xdg-user-directories-service-type)
	#:autoload (gnu packages admin) (btop fastfetch inxi)
	#:autoload (gnu packages bittorrent) (qbittorrent)
	#:autoload (gnu packages commencement) (gcc-toolchain)
	#:autoload (gnu packages compression) (unzip)
	#:autoload (gnu packages containers) (podman podman-compose)
	#:autoload (gnu packages emacs) (emacs-next-pgtk)
	#:autoload (gnu packages fonts) (font-dejavu
																	 font-google-noto-emoji
																	 font-liberation
																	 font-nerd-opendyslexic
																	 font-wqy-zenhei)
	#:autoload (gnu packages glib) (glib)
	#:autoload (gnu packages gnupg) (gnupg pinentry)
	#:autoload (gnu packages gtk) (appmenu-gtk-module libdbusmenu)
	#:autoload (gnu packages kde-graphics) (okular)
	#:autoload (gnu packages kde-plasma) (plasma-disks)
	#:autoload (gnu packages kde-internet) (kdeconnect)
	#:autoload (gnu packages kde-utils) (ark kate kcalc)
	#:autoload (gnu packages kde-xyz) (kde-material-you-colors)
	#:autoload (gnu packages libreoffice) (libreoffice)
	#:autoload (gnu packages linux) (wireplumber-minimal)
	#:autoload (gnu packages package-management) (flatpak)
	#:autoload (gnu packages pretty-print) (source-highlight)
	#:autoload (gnu packages python) (python-wrapper)
	#:autoload (gnu packages rust-apps) (aardvark-dns helvum ripgrep)
	#:autoload (gnu packages screen) (screen)
	#:autoload (gnu packages shells) (fish fish-foreign-env)
	#:autoload (gnu packages shellutils) (starship)
	#:autoload (gnu packages ssh) (openssh)
	#:autoload (gnu packages terminals) (alacritty)
	#:autoload (gnu packages tor-browsers) (torbrowser)
	#:autoload (gnu packages version-control) (git)
	#:autoload (gnu packages video) (vlc)
	#:autoload (gnu packages xdisorg) (xsettingsd)
	#:autoload (gnu packages xorg) (xrdb)
	#:autoload (guix channels) (channel
															make-channel-introduction
															openpgp-fingerprint)
	#:autoload (guix gexp) (file-append gexp)
	#:autoload (nongnu packages firmware) (fwupd-nonfree)
	#:autoload (nongnu packages game-client) (protonup steam)
	#:autoload (saayix packages binaries) (zen-browser-bin))

(define krisque-home
	(home-environment
	 (packages
		(list
		 aardvark-dns
		 alacritty
		 appmenu-gtk-module
		 ark
		 btop
		 emacs-next-pgtk
		 fastfetch
		 fish
		 fish-foreign-env
		 flatpak
		 font-dejavu
		 font-google-noto-emoji
		 font-liberation
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
		 kdeconnect
		 libdbusmenu
		 libreoffice
		 okular
		 openssh
		 plasma-disks
		 podman
		 podman-compose
		 protonup
		 kde-material-you-colors
		 python-wrapper
		 qbittorrent
		 ripgrep
		 screen
		 source-highlight
		 starship
		 steam
		 torbrowser
		 unzip
		 vlc
		 xrdb
		 xsettingsd
		 zen-browser-bin))

	 (services
		(list
		 (service home-dbus-service-type)
		 (service home-gpg-agent-service-type
							(home-gpg-agent-configuration
							 (pinentry-program (file-append pinentry "/bin/pinentry"))))
		 (service home-pipewire-service-type
							(home-pipewire-configuration
							 (wireplumber wireplumber-minimal)))
		 (service home-ssh-agent-service-type)
		 (service home-xdg-user-directories-service-type
							(home-xdg-user-directories-configuration
							 (music				"$HOME/Media/Music/")
							 (pictures		"$HOME/Media/Pictures/")
							 (videos			"$HOME/Media/Videos/")
							 (templates		"$HOME")
							 (publicshare "$HOME")))
		 (simple-service
			'podman-socket home-shepherd-service-type
			(list (shepherd-service
						 (provision '(podman-socket))
						 (documentation "Rootless Podman REST API service.")
						 (start #~(make-systemd-constructor
											 (list #$(file-append podman "/bin/podman")
														 "system"
														 "service"
														 "--time=0")
											 (list (endpoint
															(make-socket-address
															 AF_UNIX
															 (string-append (getenv "XDG_RUNTIME_DIR")
																							"/podman/podman.sock"))))))
						 (stop #~(make-systemd-destructor)))))
		 (simple-service
			'home-extra-channels home-channels-service-type
			(list
			 (channel
				(name 'nonguix)
				(url
				 "https://gitlab.com/nonguix/nonguix.git")
				(introduction
				 (make-channel-introduction
					"897c1a470da759236cc11798f4e0a5f7d4d59fbc"
					(openpgp-fingerprint
					 "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
			 (channel
				(name 'saayix)
				(branch "main")
				(url "https://codeberg.org/look/saayix.git")
				(introduction
				 (make-channel-introduction
					"12540f593092e9a177eb8a974a57bb4892327752"
					(openpgp-fingerprint
					 "3FFA 7335 973E 0A49 47FC 0A8C 38D5 96BE 07D3 34AB"))))))
		 (simple-service
			'home-shell-environment-variables
			home-environment-variables-service-type
			`(("PATH" . "$HOME/.local/bin:$PATH")
				("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS")
				("XDG_PROJECTS_DIR" . "$HOME/Projects")
				("LESSOPEN" . "| src-hilite-lesspipe.sh %s")
				("LESS" . " --raw-control-chars --tabs=2 --LINE-NUMBERS ")))))))

krisque-home
