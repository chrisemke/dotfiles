(define-module (config)
	#:use-module ((gnu bootloader)								#:select (bootloader-configuration))
	#:use-module ((gnu bootloader grub)						#:select (grub-efi-bootloader))
	#:use-module ((gnu packages display-managers) #:select (sddm))
	#:use-module ((gnu packages games)						#:select (steam-devices-udev-rules))
	#:use-module ((gnu packages shells)						#:select (fish))
	#:use-module ((gnu services)									#:select (service simple-service modify-services))
	#:use-module ((gnu services base)							#:select (guix-configuration guix-extension guix-service-type udev-rules-service))
	#:use-module ((gnu services containers)				#:select (rootless-podman-service-type rootless-podman-configuration))
	#:use-module ((gnu services desktop)					#:select (%desktop-services plasma-desktop-service-type bluetooth-service-type))
	#:use-module ((gnu services linux)						#:select (zram-device-service-type zram-device-configuration))
	#:use-module ((gnu services networking)				#:select (nftables-service-type))
	#:use-module ((gnu services pm)								#:select (power-profiles-daemon-service-type))
	#:use-module ((gnu services sddm)							#:select (sddm-service-type sddm-configuration))
	#:use-module ((gnu services sysctl)						#:select (sysctl-service-type))
	#:use-module ((gnu services xorg)             #:select (gdm-service-type))
	#:use-module ((gnu system)										#:select (%base-packages %default-kernel-arguments operating-system))
	#:use-module ((gnu system accounts)						#:select (subid-range user-account))
	#:use-module ((gnu system file-systems)				#:select (file-system %base-file-systems))
	#:use-module ((gnu system keyboard)						#:select (keyboard-layout))
	#:use-module ((gnu system mapped-devices)			#:select (mapped-device luks-device-mapping))
	#:use-module ((gnu system shadow)							#:select (%base-user-accounts))
	#:use-module ((gnu system uuid)								#:select (uuid))
	#:use-module ((guix gexp)											#:select (file-append local-file plain-file))
	#:use-module ((nongnu packages linux)					#:select (linux linux-firmware))
	#:use-module ((nongnu system linux-initrd)		#:select (microcode-initrd))
	#:use-module ((srfi srfi-1)										#:select (delete)) ;; Used for delete gdm
	)

(define (ram-total)
  "Returns the total available ram in bytes."
  (call-with-input-file "/proc/meminfo"
    (lambda (port)
      (let ((_ (read port)))
        (* 1000 (read port))))))

(define krisque-system
	(operating-system
	 (locale "pt_BR.utf8")
	 (timezone "America/Sao_Paulo")
	 (keyboard-layout (keyboard-layout "us" "colemak" #:options '("caps:capslock")))
	 (host-name "krisque")
	 (kernel linux)
	 (kernel-arguments (cons* "quiet" %default-kernel-arguments))
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
		 (simple-service 'nonguix-substitutes guix-service-type
										 (guix-extension
											(substitute-urls (list "https://substitutes.nonguix.org"))
											(authorized-keys (list (plain-file "non-guix.pub"
																												 "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")))))
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
												%base-file-systems))
	 ))

krisque-system
