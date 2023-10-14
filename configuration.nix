##   \\  \\ //     
##  ==\\__\\/ //    
##    //   \\//     
## ==//     //==    
##  //\\___//       
## // /\\  \\==     
##   // \\  \\    
##
## NixOS config
## Written by: michaelScopic (https://github.com/michaelScopic)

## Edit this configuration file to define what should be installed on
## your system.  Help is available in the configuration.nix(5) man page
## and in the NixOS manual (accessible by running `nixos-help`).



{ config, pkgs, ... }:

{
  imports = [ 
      ./hardware-configuration.nix ## Include the results of the hardware scan.
    ];

  nix = {
    autoOptimizeStorage = true;
  };
  
  ## Use the GRUB 2 boot loader.
  boot = {
    loader = {
      grub = {
        enable = true;
        # efiSupport = true;
        # efiInstallAsRemovable = true;
        # efi.efiSysMountPoint = "/boot/efi";
        ## Define on which hard drive you want to install Grub.
        device = "/dev/sda"; ## or "nodev" for efi only
      };
    };
  };
  
  networking = {
    hostName = "NixOS"; ## Define your hostname.
    ## Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  ## Easiest to use and most distros use this by default.
  };
  
  ## Set your time zone.
  time.timeZone = "America/Chicago";

  ## Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true; ## use xkbOptions in tty.
  };

  

  ## Configure keymap in X11
  services.xserver.layout = "us";
  ## services.xserver.xkbOptions = "eurosign:e,caps:escape";
  
  environment.shells = with pkgs; [ 
    zsh
    bash
    dash
    sh
  ];
  
  ## Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "kvm" ]; ## Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      tree
    ];
  };
  
  nixpkgs.config = {
    allowUnfree = true;
    allowInescure= = true;
    PermittedInsecurePackages = [
    
    ];
  };
  
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    })
  ];

  ## List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    zsh
    hyprland
    lightdm
    waybar
    dunst
    libnotify
    swww
    kitty
    rofi-wayland
    neovim
    lightdm
    neofetch
    blueman
    brightnessctl
    brillo
    cargo
    cmake
    dracula-theme
    eww-wayland
    firefox-wayland
    flameshot
    fzf
    git
    glibc
    gnome.gnome-keyring
    gnumake
    go 
    gtk3
    hyprpaper
    hyprpicker
    jp2a
    libvirt
    lxappearance
    meson 
    mpv
    ninja
    networkmanagerapplet
    obs-studio
    pkg-config
    pipewire
    pavucontrol
    qemu_kvm
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    scrot
    shellcheck
    simplescreenrecorder
    tldr
    unzip
    virt-viewer
    wireplumber
    wlroots
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-utils
    xwayland
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    })
  ];
  
  
  ###################################
  # === BEGIN ENABLING PROGRAMS === #
  ###################################

  
  programs = {
    zsh = { ## ZSH
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      autosuggestions.async = true;
      syntaxHighlighting.enable = true;
      programs.nix-index.enableZshIntegration = true;
    };
    hyprland = { ## Hyprland
      enable = true;
      nvidiaPatches = true;
      xwayland.enable = true;
    };
    tmux = {  ## Tmux
      enable = true;
      clock24 = false;
      plugins = [
        pkgs.tmuxPlugins.nord
      ];
    };
    thunar = {  ## Thunar
      enable = true;
      plugins = [
        thunar-archive-plugin 
        thunar-volman
      ];
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    locate = {
      enable = true;
      locate = pkgs.mlocate;
    };
  };


  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };
  
  
  ## -- CUPS (printing) --
  # services.printing.enable = true;

  ## -- Sound --
  sound.enable = true;
  #hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  
  ## Enable other daemons
  services = {
    openssh = {
      enable = true;
      settings = [
        PermitRootLogin = "no"; ## Security focused users and servers should keep this as "no"
      ];
    };
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
    };
    displayManager.lightdm = {
      enable = true;
      autoNumLock = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    blueman = {
      enable = true;
    };
    gnome3.gnome-keyring.enable = true;
    dbus.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ]
  };

  fonts.fontDir.enable = true;
  fonts.font = with pkgs; [
    nerdfonts
    font-awesome
    google-fonts
  ];
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk 
  ];
  #################################
  # === END ENABLING PROGRAMS === #
  #################################

  ## Open ports in the firewall.
  networking.firewall = {
    enable = true;
    #allowedTCPPorts = [ ... ];
    #allowedUDPPorts = [ ... ];
  };

  system = {
    copySystemConfiguration = true;
    stateVersion = "23.05";
  };
}