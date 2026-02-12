(use-modules
 (gnu)
 (gnu packages shells) ; fish
 (gnu system accounts)
 (nongnu packages linux)
 (nongnu system linux-initrd)
 (radix system monitoring) ; ram-total
 )

(use-service-modules containers cups desktop linux networking pm sddm ssh sysctl xorg)

(operating-system
 (locale "pt_BR.utf8")
 (timezone "America/Sao_Paulo")
 (keyboard-layout (keyboard-layout "us" "colemak"))
 (host-name "krisque")
 (kernel linux-6.18)
 (kernel-arguments '("quiet"))
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
									 `(("vm.swappiness" . "180")
										 ("vm.watermark_boost_factor" . "0")
										 ("vm.watermark_scale_factor" . "125")
										 ("vm.page-cluster" . "0")))
	 (service sddm-service-type
						(sddm-configuration (theme "breeze")))
	 (service iptables-service-type)
	 (service nftables-service-type)
	 (service rootless-podman-service-type
						(rootless-podman-configuration
						 (subgids
							(list (subid-range (name "krisque"))))
						 (subuids
							(list (subid-range (name "krisque"))))))
	 (modify-services %desktop-services
										(delete gdm-service-type)
										(guix-service-type config => (guix-configuration
																									(inherit config)
																									(substitute-urls
																									 (append (list "https://substitutes.nonguix.org")
																													 %default-substitute-urls))
																									(authorized-keys
																									 (append (list (local-file "./signing-key.pub"))
																													 %default-authorized-guix-keys)))))))

 (bootloader (bootloader-configuration
							(bootloader grub-efi-bootloader)
							(targets (list "/boot/efi"))
							(keyboard-layout keyboard-layout)))
 (mapped-devices (list (mapped-device
												(source (uuid
																 "ac6943e6-5a0c-46fd-b6a1-7a322f3e54f6"))
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
											 (device (uuid "6046-A74B"
																		 'fat32))
											 (type "vfat")) %base-file-systems)))
