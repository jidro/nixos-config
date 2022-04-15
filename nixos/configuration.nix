# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Network settings
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;
  # programs.nm-applet.enable = true;  # use nmcil/nmtui to manager network 

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
  	defaultLocale = "zh_CN.UTF-8";
  	supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  	inputMethod = {
  		#enabled = "ibus";
  		#ibus.engines = with pkgs.ibus-engines;[ rime ];
  		enabled = "fcitx5";
  		fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-configtool fcitx5-chinese-addons];
  	};
  };

  # Set font file
  # set console font
  console = {
    font = "DejavuSansMono";
    keyMap = "us";
  };
  # Set other fonts
  fonts.enableDefaultFonts = true;
  fonts = {
	fontconfig = {
		enable = true;
		hinting = {
			enable = true;
			autohint = false;
			# hintstyle = "hintslight(10px,12px)";
		};
	# defaultFonts.emoji = [ "Noto Color Emoji" ];
	# defaultFonts.monospace = [ "Hack" "Sarasa Mono SC" ];
	# defaultFonts.sansSerif = [ "DejaVu Sans" ];
	# defaultFonts.serif = [ "DejaVu Serif" "Source Han Serif SC" ];
	};
  fontDir.enable = true;
  enableGhostscriptFonts = true;
  # fonts = with pkgs; [
	# sarasa-gothic
	# noto-fonts
	# noto-fonts-cjk
	# noto-fonts-emoji
	# wqy_microhei
	# wqy_zenhei
	# #nerdfonts # 图标字体
	# symbola # 特殊字符
	# jetbrains-mono
	# ];
  };
  
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # services.gvfs.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # a DBus service that provides power management support to applications
  services.upower.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enabling Bluetooth support
  # hardware.bluetooth.enable = true;

  # Enable Flatpak
  # xdg.portal.enable = true;
  # services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "libvirtd" "docker" "audio" "sound" "input" "tty" "camera" "ssh" ]; # Enable ‘sudo’ for the user.
  };
  
  users.defaultUserShell = pkgs.bash;
  
  security.sudo.extraRules = [
	{
		users = [ "nix" ];
		commands = [
			{
			command = "ALL";
			# options = [ "NOPASSWD" ];
			}
		];
	}
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    gnumake
    cmake    
    feh
    picom
    upower
    acpi
    rofi
    pamixer
    man
    git
    gcc
    gdb
    clang
    clang-tools
    ninja
    xbps
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # nix.settings.auto-optimise-store = true;
  nix = {
	binaryCaches = [ 
 		"https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
		"https://mirror.sjtu.edu.cn/nix-channels/store"
		"https://berberman.cachix.org"
		"https://nixos-cn.cachix.org"
  	];
	# trusted-public-keys = [
		# "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
		# "berberman.cachix.org-1:UHGhodNXVruGzWrwJ12B1grPK/6Qnrx2c3TjKueQPds="
	# ];
	# trusted-users = [ "root" "nix" ];
    };

  # nixpkgs.config = {
	# allowUnfree = true;
	# allowUnsupportedSystem = true;
	# allowBroken = true;
  # };

  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

