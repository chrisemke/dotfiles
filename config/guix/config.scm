(define-module (config)
	#:autoload (gnu bootloader) (bootloader-configuration)
	#:autoload (gnu bootloader grub) (grub-efi-bootloader)
	#:autoload (gnu packages display-managers) (sddm)
	#:autoload (gnu packages games) (steam-devices-udev-rules)
	#:autoload (gnu packages shells) (fish)
	#:autoload (gnu services) (service simple-service modify-services)
	#:autoload (gnu services base) (guix-configuration
																	 guix-extension
																	 guix-service-type
																	 udev-rule udev-rules-service)
	#:autoload (gnu services containers) (rootless-podman-service-type
																				rootless-podman-configuration)
	#:autoload (gnu services desktop) (%desktop-services
																		 plasma-desktop-service-type
																		 bluetooth-service-type)
	#:autoload (gnu services linux) (zram-device-service-type
																	 zram-device-configuration)
	#:autoload (gnu services networking) (nftables-configuration
																				 nftables-service-type)
	#:autoload (gnu services pm) (power-profiles-daemon-service-type)
	#:autoload (gnu services sddm) (sddm-service-type sddm-configuration)
	#:autoload (gnu services sysctl) (sysctl-service-type)
	#:autoload (gnu services xorg) (gdm-service-type)
	#:autoload (gnu system) (%base-packages
													 %default-kernel-arguments
													 operating-system)
	#:autoload (gnu system accounts) (subid-range user-account)
	#:autoload (gnu system file-systems) (file-system %base-file-systems)
	#:autoload (gnu system keyboard) (keyboard-layout)
	#:autoload (gnu system mapped-devices) (mapped-device luks-device-mapping)
	#:autoload (gnu system shadow) (%base-user-accounts)
	#:autoload (gnu system uuid) (uuid)
	#:autoload (guix gexp) (file-append local-file plain-file)
	#:autoload (nongnu packages linux) (linux linux-firmware)
	#:autoload (nongnu system linux-initrd) (microcode-initrd)
	#:autoload (srfi srfi-1) (delete)) ;; Used for delete gdm

(define (ram-total)
	"Returns the total available ram in bytes."
	(call-with-input-file "/proc/meminfo"
		(lambda (port)
			(let ((_ (read port)))
				(* 1024 (read port))))))

(define nonguix-signing-key
	(plain-file
	 "non-guix.pub"
	 "(public-key \
		(ecc \
		 (curve Ed25519) \
		 (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))


(define krisque-system
	(operating-system
	 (locale "pt_BR.utf8")
	 (timezone "America/Sao_Paulo")
	 (keyboard-layout
		(keyboard-layout "us" "colemak" #:options '("caps:capslock")))
	 (host-name "krisque")
	 (kernel linux)
	 (initrd microcode-initrd)
	 (firmware (list linux-firmware))

	 (users (cons*
					 (user-account
						(name "krisque")
						(comment "Krisque")
						(group "users")
						(home-directory "/home/krisque")
						(shell (file-append fish "/bin/fish"))
						(supplementary-groups '("audio" "netdev" "video" "wheel")))
					 %base-user-accounts))

	 (packages (cons* %base-packages))

	 (services
		(cons*
		 (service plasma-desktop-service-type)
		 (service power-profiles-daemon-service-type)
		 (service bluetooth-service-type)
		 (service zram-device-service-type (zram-device-configuration
																				(priority 100)
																				(size (ram-total))
																				(compression-algorithm 'zstd)))
		 (simple-service 'zram-sysctl-settings sysctl-service-type
										 `(("vm.swappiness"             . "180")
											 ("vm.watermark_boost_factor" . "0")
											 ("vm.watermark_scale_factor" . "125")
											 ("vm.page-cluster"           . "0")))
		 (udev-rules-service 'steam-devices steam-devices-udev-rules)
		 (service sddm-service-type (sddm-configuration
																 (sddm sddm)
																 (theme "breeze")))
		 (service nftables-service-type
				 (nftables-configuration (ruleset (local-file "nftables.conf"))))
		 (service rootless-podman-service-type
							(rootless-podman-configuration
							 (subgids (list (subid-range (name "krisque"))))
							 (subuids (list (subid-range (name "krisque"))))))
		 (simple-service 'nonguix-substitutes guix-service-type
										 (guix-extension
											(substitute-urls (list "https://substitutes.nonguix.org"))
											(authorized-keys (list nonguix-signing-key))))
		 (modify-services %desktop-services (delete gdm-service-type))))

	 (bootloader (bootloader-configuration
								(bootloader grub-efi-bootloader)
								(targets (list "/boot/efi"))
								(keyboard-layout keyboard-layout)))
	 (mapped-devices (list (mapped-device
													(source (uuid "f480ab52-f52c-4c38-bbce-edc627728352"))
													(target "cryptroot")
													(type luks-device-mapping))))
	 (file-systems (cons* (file-system
												 (mount-point "/")
												 (device "/dev/mapper/cryptroot")
												 (type "btrfs")
												 (dependencies mapped-devices)
												 (options "compress=zstd"))
												(file-system
												 (mount-point "/boot/efi")
												 (device (uuid "6397-2D7A" 'fat32))
												 (type "vfat"))
												%base-file-systems))))

krisque-system
