# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #<home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  
  # Sleep on Lock
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    IdleAction=suspend
    IdleActionSec=1m
  '';
   programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
  };


  # Set your time zone.
  time.timeZone = "America/Chicago";

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

  # Enable HardWare Rules
  hardware.steam-hardware.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [pkgs.amdvlk];
  hardware.opengl.extraPackages32 = [pkgs.driversi686Linux.amdvlk];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.updateDbusEnvironment = true;
  services.picom.enable = true;
  services.picom.vSync = true;
  services.picom.backend = "xrender";
  services.picom.fade = true;
  services.blueman.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.gnome.gnome-keyring.enable = true;
  
  services.picom.settings = {
    xrender-sync-fence = false;

  };

  # Enable Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.slick.enable = true;
  services.xserver.displayManager.lightdm.greeters.slick.iconTheme.package = pkgs.fluent-gtk-theme;
  services.xserver.displayManager.lightdm.greeters.slick.theme.name = "Fluent-Dark-compact";
  #services.xserver.desktopManager.cinnamon.enable = true;
  
 
  # Enable Polkit
  security.polkit.enable = true;
  
  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        };
    };
  };

  # Enable Qtile Window Manager
  services.xserver.windowManager.qtile.enable = true;
  services.xserver.windowManager.qtile.extraPackages = python3Packages: with python3Packages; [qtile-extras];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
 
  # Enable CUPS to print documents.
  services.printing.enable = true;
   services.printing.drivers = with pkgs; [
    mfcl2740dwcupswrapper
    mfcl2740dwlpr
   ];

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
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lee = {
    isNormalUser = true;
    description = "lee";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "storage" "video" "audio" "docker" "kvm"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  #home-manager.users.lee = { pkgs, ... }: {
    #declard packages. 
    



  #};

  # Enable Flatpak
  services.flatpak.enable = true;
  xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    brave
    git
    fluent-gtk-theme
    fluent-icon-theme
    dunst
    dex
    vscodium
    nitrogen
    megasync
    remmina
    virt-manager      
    alacritty 
    pfetch 
    cinnamon.nemo
    cinnamon.nemo-fileroller
    lxappearance
    gnome.file-roller
    cinnamon.mint-y-icons
    rofi
    alsa-utils
    betterlockscreen
    numlockx    
    steam-run 
    appimage-run
    distrobox
    xorg.xhost
    lutris
    wineWowPackages.staging
    winetricks
    htop
    pciutils
    gnome.aisleriot
    xivlauncher
    virt-viewer
    spice spice-gtk
    spice-protocol
    win-virtio
    win-spice
    gnome.adwaita-icon-theme
    usbutils
    gnome.gnome-disk-utility
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.kdeconnect-kde
    busybox
    galculator
    sshfs
    cinnamon.xreader
    cinnamon.xviewer
    cinnamon.pix
  ];
  programs.steam.enable = true;
  programs.nano.nanorc=  
  ''  
  set autoindent
  set breaklonglines
  set constantshow
  set indicator
  set linenumbers
  '';
  
    # Enable Fonts 
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
  ubuntu_font_family
  source-code-pro
  (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "Ubuntu" ]; })
  corefonts
];

  # Virtualisation 
  programs.dconf.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = with pkgs;[ 
    OVMFFull.fd 
    ];
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "gtk2";
  
  # List services that you want to enable:
  xdg.sounds.enable = false;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
