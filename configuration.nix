# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-22f76988-ed41-44c6-97ba-5b6c86ce3688".device = "/dev/disk/by-uuid/22f76988-ed41-44c6-97ba-5b6c86ce3688";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # NVIDIA drivers
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # xorg/wayland load
  services.xserver.videoDrivers = ["nvidia"];
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = pkgs.lib.mkDefault true;
#  services.xserver.displayManager.defaultSession = pkgs.lib.mkForce "gnome";
  programs.ssh.askPassword = pkgs.lib.mkForce "/nix/store/barkcvy2wy7lx6hcfybx7s1llkdwjl8v-seahorse-43.0/libexec/seahorse/ssh-askpass";
  programs.dconf.enable = true;


  # nvidia config
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alien = {
    isNormalUser = true;
    description = "alien";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      kate
    #  thunderbird
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.alien.useDefaultShell = true;
  home-manager.users.alien = {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtraBeforeCompInit = ''
	eval "$(starship init zsh)"
      '';
      initExtra = ''
      sudo cpupower frequency-set -g "powersave"
      source ~/Programming/mainenv/bin/activate
      '';
      oh-my-zsh = {
        enable = true;
	plugins = [
	  "git"
	  "sudo"
	  "z"
	];
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-syntax-highlighting"; } # Simple plugin installation
        ];
      };

      shellAliases = {
        sl = "exa";
        ls = "exa";
        l = "exa -l";
        la = "exa -la";
        ip = "ip --color=auto";
	econf = "sudo nvim /etc/nixos/configuration.nix";
#	doom = "~/.config/emacs/bin/doom";
      };

    };

    programs.neovim = {
      enable = true;
    };

    home.stateVersion = "23.11"; # Did you read the comment?
  };

  services.emacs = {
    enable = true;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vscodium
    emacs
    gcc13
    tmux
    ncdu
    gcc-unwrapped
    file
    lunarvim
    unzip
    wget
    rustup
    xclip
    linuxKernel.packages.linux_6_1.cpupower
    hyfetch
    jdk17
    nodejs_21
    libsForQt5.qtstyleplugin-kvantum
    catppuccin-kvantum
    ayu-theme-gtk
    qt6Packages.qtstyleplugin-kvantum
    themechanger
    alacritty
    corectrl
    python3
    starship
    git
    neovim
    neofetch
    gnome.adwaita-icon-theme
    eza
    btop
    zlib
    nvtop
    flameshot
    htop
    fd
    fzf
  ];

  # fonts

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "ComicShannsMono" "Iosevka" "IosevkaTerm" "IosevkaTermSlab" "JetBrainsMono" "ProggyClean" ]; })
  ];


  # flatpak
  services.flatpak.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
