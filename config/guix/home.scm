(define-module (home)
	#:use-module (gnu home)
	#:use-module (gnu home services)
	#:use-module (gnu home services desktop)
	#:use-module (gnu home services gnupg)
	#:use-module (gnu home services guix)
	#:use-module (gnu home services shells)
	#:use-module (gnu home services shepherd)
	#:use-module (gnu home services sound)
	#:use-module (gnu home services ssh)
	#:use-module (gnu home services xdg)
	#:use-module (gnu packages admin)								; btop fastfetch inxi
	#:use-module (gnu packages bittorrent)					; qbittorrent
	#:use-module (gnu packages commencement)				; gcc-toolchain
	#:use-module (gnu packages compression)					; unzip
	#:use-module (gnu packages containers)					; podman podman-compose
	#:use-module (gnu packages emacs)								; emacs-next-pgtk
	#:use-module (gnu packages fonts)								; font-dejavu font-google-noto-emoji font-liberation
	#:use-module (gnu packages glib)								; glib:bin
	#:use-module (gnu packages gnupg)								; gnupg pinentry
	#:use-module (gnu packages gtk)									; appmenu-gtk-module libdbusmenu
	#:use-module (gnu packages kde-graphics)				; okular
	#:use-module (gnu packages kde-plasma)					; plasma-disks
	#:use-module (gnu packages kde-sdk)							; kompare
	#:use-module (gnu packages kde-utils)						; ark kate kcalc
	#:use-module (gnu packages kde-xyz)							; kde-material-you-colors
	#:use-module (gnu packages libreoffice)					; libreoffice
	#:use-module (gnu packages linux)								; wireplumber-minimal
	#:use-module (gnu packages package-management)	; flatpak
	#:use-module (gnu packages pretty-print)				; source-highlight
	#:use-module (gnu packages python)							; python-wrapper
	#:use-module (gnu packages rust)								; rust
	#:use-module (gnu packages rust-apps)						; aardvark-dns helvum mise ripgrep
	#:use-module (gnu packages screen)							; screen
	#:use-module (gnu packages shells)							; fish
	#:use-module (gnu packages shellutils)					; starship
	#:use-module (gnu packages ssh)									; openssh
	#:use-module (gnu packages terminals)						; alacritty
	#:use-module (gnu packages tor-browsers)				; torbrowser
	#:use-module (gnu packages version-control)			; git
	#:use-module (gnu packages video)								; vlc
	#:use-module (gnu packages xdisorg)							; xsettingsd
	#:use-module (gnu packages xorg)								; xrdb
	#:use-module (guix channels)
	#:use-module (guix gexp)
	#:use-module (nongnu packages firmware)					; fwupd-nonfree
	#:use-module (nongnu packages game-client)			; protonup steam
	#:use-module (saayix packages binaries)					; zen-browser-bin
	#:use-module (saayix packages fonts)						; font-nerd-opendyslexic
	)

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
		 kompare
		 libreoffice
		 libdbusmenu
		 mise
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
		 rust
		 screen
		 source-highlight
		 starship
		 steam
		 torbrowser
		 unzip
		 vlc
		 xrdb
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
							 (pinentry-program (file-append pinentry "/bin/pinentry"))))
		 (service home-pipewire-service-type
							(home-pipewire-configuration
							 (wireplumber wireplumber-minimal)))
		 (service home-ssh-agent-service-type)
		 (service home-xdg-user-directories-service-type
          (home-xdg-user-directories-configuration
            (desktop     "$HOME/Desktop/")
            (documents   "$HOME/Documents/")
            (download    "$HOME/Downloads/")
            (music       "$HOME/Media/Music/")
            (pictures    "$HOME/Media/Pictures/")
            (videos      "$HOME/Media/Videos/")
						(projects    "$HOME/Projects/")
						(templates   "")
            (publicshare "")))
		 (simple-service 'podman-socket
										 home-shepherd-service-type
										 (list (shepherd-service
														(provision '(podman-socket))
														(modules '((guix build utils)))
														(start
														 #~(let* ((runtime-dir (or (getenv "XDG_RUNTIME_DIR")
																															 (string-append
																																"/run/user/"
																																(number->string (getuid)))))
																			(socket-dir (string-append runtime-dir "/podman")))
																 (mkdir-p socket-dir)
																 (make-forkexec-constructor
																	(list #$(file-append podman "/bin/podman")
																				"system" "service" "--time=0"
																				(string-append "unix://" socket-dir
																											 "/podman.sock")))))
														(stop #~(make-kill-destructor)))))
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
														(url "https://codeberg.org/look/saayix.git")
														(introduction
														 (make-channel-introduction
															"12540f593092e9a177eb8a974a57bb4892327752"
															(openpgp-fingerprint
															 "3FFA 7335 973E 0A49 47FC 0A8C 38D5 96BE 07D3 34AB"))))))
		 (simple-service 'home-shell-environment-variables
										 home-environment-variables-service-type
										 `(("PATH" . "$HOME/.local/bin:$PATH")
											 ("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS")
											 ("LESSOPEN" . "| src-hilite-lesspipe.sh %s")
											 ("LESS" . " --raw-control-chars --tabs=2 --LINE-NUMBERS ")))))))

krisque-home
