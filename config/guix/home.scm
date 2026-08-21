(define-module (home)
	#:use-module ((gnu home)												#:select (home-environment))
	#:use-module ((gnu home services)								#:select (home-environment-variables-service-type service simple-service))
	#:use-module ((gnu home services desktop)				#:select (home-dbus-service-type))
	#:use-module ((gnu home services gnupg)					#:select (home-gpg-agent-configuration home-gpg-agent-service-type))
	#:use-module ((gnu home services guix)					#:select (home-channels-service-type))
	#:use-module ((gnu home services shells)				#:select (home-bash-configuration home-bash-service-type))
	#:use-module ((gnu home services shepherd)			#:select (home-shepherd-service-type shepherd-service))
	#:use-module ((gnu home services sound)					#:select (home-pipewire-configuration home-pipewire-service-type))
	#:use-module ((gnu home services ssh)						#:select (home-ssh-agent-service-type))
	#:use-module ((gnu home services xdg)						#:select (home-xdg-user-directories-configuration home-xdg-user-directories-service-type))
	#:use-module ((gnu packages admin)							#:select (btop fastfetch inxi))
	#:use-module ((gnu packages bittorrent)					#:select (qbittorrent))
	#:use-module ((gnu packages commencement)				#:select (gcc-toolchain))
	#:use-module ((gnu packages compression)				#:select (unzip))
	#:use-module ((gnu packages containers)					#:select (podman podman-compose))
	#:use-module ((gnu packages emacs)							#:select (emacs-next-pgtk))
	#:use-module ((gnu packages fonts)							#:select (font-dejavu font-google-noto-emoji font-liberation font-wqy-zenhei))
	#:use-module ((gnu packages glib)								#:select (glib))
	#:use-module ((gnu packages gnupg)							#:select (gnupg pinentry))
	#:use-module ((gnu packages gtk)								#:select (appmenu-gtk-module libdbusmenu))
	#:use-module ((gnu packages kde-graphics)				#:select (okular))
	#:use-module ((gnu packages kde-plasma)					#:select (plasma-disks))
	#:use-module ((gnu packages kde-utils)					#:select (ark kate kcalc))
	#:use-module ((gnu packages kde-xyz)						#:select (kde-material-you-colors))
	#:use-module ((gnu packages libreoffice)				#:select (libreoffice))
	#:use-module ((gnu packages linux)							#:select (wireplumber-minimal))
	#:use-module ((gnu packages package-management) #:select (flatpak))
	#:use-module ((gnu packages pretty-print)				#:select (source-highlight))
	#:use-module ((gnu packages python)							#:select (python-wrapper))
	#:use-module ((gnu packages rust-apps)					#:select (aardvark-dns helvum ripgrep))
	#:use-module ((gnu packages screen)							#:select (screen))
	#:use-module ((gnu packages shells)							#:select (fish))
	#:use-module ((gnu packages shellutils)					#:select (starship))
	#:use-module ((gnu packages ssh)								#:select (openssh))
	#:use-module ((gnu packages terminals)					#:select (alacritty))
	#:use-module ((gnu packages tor-browsers)				#:select (torbrowser))
	#:use-module ((gnu packages version-control)		#:select (git))
	#:use-module ((gnu packages video)							#:select (vlc))
	#:use-module ((gnu packages xdisorg)						#:select (xsettingsd))
	#:use-module ((gnu packages xorg)								#:select (xrdb))
	#:use-module ((guix channels)										#:select (channel make-channel-introduction openpgp-fingerprint))
	#:use-module ((guix gexp)												#:select (file-append gexp local-file plain-file))
	#:use-module ((nongnu packages firmware)				#:select (fwupd-nonfree))
	#:use-module ((nongnu packages game-client)			#:select (protonup steam))
	#:use-module ((saayix packages binaries)				#:select (zen-browser-bin))
	#:use-module ((saayix packages fonts)						#:select (font-nerd-opendyslexic))
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
							 (music       "$HOME/Media/Music/")
							 (pictures    "$HOME/Media/Pictures/")
							 (videos      "$HOME/Media/Videos/")
							 (templates   "$HOME")
							 (publicshare "$HOME")))
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
														(url "https://gitlab.com/nonguix/nonguix.git")
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
