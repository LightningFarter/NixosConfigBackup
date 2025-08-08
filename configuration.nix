# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  services.displayManager.sddm.wayland.enable = true;

  programs.hyprland.enable = true;

  xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.keyd = {
    enable = true;

    keyboards.default = {
      settings = {
        "main.combo shift+meta+f23" = "leftmeta";
      };
    };
  };
  
  fileSystems."/ubuntu" = {
    device = "/dev/disk/by-uuid/75931f3e-6345-434b-9684-5d8ab6b2f621";
    fsType = "btrfs";
    options = [ "defaults" ];
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = false;
  };

security.rtkit.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      jetbrains-mono
      dejavu_fonts
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "DejaVu Sans" "Noto Sans CJK SC" ];
        monospace = [ "JetBrainsMono" "Noto Sans Mono CJK SC" ];
      };
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-chinese-addons
    fcitx5-table-extra
    fcitx5-chewing
    fcitx5-gtk
    fcitx5-configtool
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.chromium.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # text editor, never use nano
    neovim # better vim
    vscode # i code here

    wget # for downloading
    curl # good downloading

    git # git source control

    hyprland # life
    hyprpaper # wallpaper
    rofi # menu manager
    dunst # notification daemon
    xdg-utils # utils
    xwayland # support wayland fallback
    xorg.xrdb # xwayland configuration
    waybar # status bar
    swayidle # hold hyprlock
    hyprlock # lockscreen
    wl-clipboard # for waybar

    networkmanager # network
    networkmanagerapplet # applet for network
    
    kitty # terminal
    zsh # good shell
    neofetch # display status on shell

    google-chrome # not a good browser but i got kidnapped
    brave # good browser

    discord-ptb # discord
    webcord # fixed discord for hyprland

    # tools make life better
    tree # list the files
    htop # see my cpu status
    bottom # better htop
    bat # better cat
    fd # better find
    fzf # fuzzy finder
    ripgrep # better grep
    lsof # list opened files
    ncdu # disk space usage
    unzip # to unzip
    zip # to zip
    jq # sed for json
    rsync # sync files
    file # show file types

    # coding
    gcc # c and cpp
    uv # package manager
    python3 # better shell script

    # input methods
    fcitx5-configtool

    brightnessctl # brightness control

    # file manager
    nautilus

    # video viewer
    imv

    # audio controler
    pavucontrol # pause audio volume control
    playerctl # media player remote interface

    # pdf viewer
    evince # gnome pdf viewer
  ];

  security.pam.services.hyprlock = {
    text = ''
      auth include login
      account include login
      password include login
      session include login
    '';
  };

  environment.sessionVariables = {
    GDK_DPI_SCALE = "1";
    QT_SCALE_FACTOR = "1";
    XCURSOR_SIZE = "32";
    
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
  };

  users.users.jason = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

