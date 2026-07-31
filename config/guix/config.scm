(define-module (config)
	#:use-module (gnu bootloader)                 ; bootloader-configuration
	#:use-module (gnu bootloader grub)            ; grub-efi-bootloader
	#:use-module (gnu packages display-managers)  ; sddm
	#:use-module (gnu packages games)             ; steam-devices-udev-rules
	#:use-module (gnu packages shells)            ; fish
	#:use-module (gnu system accounts)            ; user-account, %base-user-accounts
	#:use-module (gnu services)                   ; service, simple-service, modify-services, udev-rules-service, %default-substitute-urls, %default-authorized-guix-keys
	#:use-module (gnu services base)              ; guix-service-type, guix-configuration
	#:use-module (gnu services containers)        ; rootless-podman-service-type, rootless-podman-configuration, subid-range
	#:use-module (gnu services desktop)           ; %desktop-services, plasma-desktop-service-type, bluetooth-service-type
	#:use-module (gnu services linux)             ; zram-device-service-type, zram-device-configuration
	#:use-module (gnu services networking)        ; nftables-service-type
	#:use-module (gnu services pm)                ; power-profiles-daemon-service-type
	#:use-module (gnu services sddm)              ; sddm-service-type, sddm-configuration
	#:use-module (gnu services sysctl)            ; sysctl-service-type
	#:use-module (gnu services xorg)              ; gdm-service-type
	#:use-module (gnu system)                     ; operating-system, %default-kernel-arguments
	#:use-module (gnu system file-systems)        ; file-system, %base-file-systems
	#:use-module (gnu system keyboard)            ; keyboard-layout
	#:use-module (gnu system mapped-devices)      ; mapped-device, luks-device-mapping
	#:use-module (gnu system shadow)              ; %base-packages (re-exports from (gnu packages base) in some Guix versions — safe to keep)
	#:use-module (gnu system uuid)                ; uuid
	#:use-module (guix gexp)                      ; file-append, local-file
	#:use-module (nongnu packages linux)          ; linux, linux-firmware, %base-firmware
	#:use-module (nongnu system linux-initrd)     ; microcode-initrd
	#:use-module (radix system monitoring)        ; ram-total
	)

(define krisque-system
	(operating-system
	 (locale "pt_BR.utf8")
	  (timezone "America/Sao_Paulo")
	(keyboard-layout (keyboard-layout "us" "colemak" #:options '("caps:capslock")))
	(host-name "krisque")
	(kernel linux)
	(kernel-arguments (cons* "quiet" %default-kernel-arguments))
	(initrd microcode-initrd)
	(firmware (cons* linux-firmware %base-firmware))

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
		(service zram-device-service-type
						 (zram-device-configuration
							(priority 100)
							(size (ram-total))
							(compression-algorithm 'zstd)))
		(simple-service 'zram-sysctl-settings
										sysctl-service-type
										`(("vm.swappiness"             . "180")
											("vm.watermark_boost_factor" . "0")
											("vm.watermark_scale_factor" . "125")
											("vm.page-cluster"           . "0")))
		(udev-rules-service 'steam-devices steam-devices-udev-rules)
		(service sddm-service-type
						 (sddm-configuration
							(sddm sddm)
							(theme "breeze")))
		(service nftables-service-type)
		(service rootless-podman-service-type
						 (rootless-podman-configuration
							(subgids (list (subid-range (name "krisque"))))
							(subuids (list (subid-range (name "krisque"))))))
		(modify-services %desktop-services
										 (delete gdm-service-type)
										 (guix-service-type
											config => (guix-configuration
																 (inherit config)
																 (substitute-urls
																	(append (list "https://cache-cdn.guix.moe"
																								"https://substitutes.nonguix.org")
																					%default-substitute-urls))
																 (authorized-keys
																	(append (list (local-file "./guix-moe.pub")
																								(local-file "./nonguix.pub"))
																					%default-authorized-guix-keys)))))))

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
											 %base-file-systems))
	))

krisque-system
