# [[file:NixOSConfiguration.org::*Template][Template:1]]
# Edit this configuration file to include configuration common between hosts
# NOTE this was generated from the org file NixOSConfiguration.org
{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];
  nixpkgs.overlays = let
    # this overlay is just a tmp fix for a steam update issue, track here https://github.com/ValveSoftware/steam-runtime/issues/462
    # remove me when the issue is fixed
    steam-overlay =(self: super: { steam = super.steam.override { extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ]; }; } ) ;
    plasma-framework-overly = (final: prev:
      let
        libsForQt5 = prev.libsForQt5.overrideScope' (
          finalx: prevx:
          let
            kdeFrameworks = prevx.kdeFrameworks.overrideScope' (
              finaly: prevy: {
                plasma-framework = prevy.plasma-framework.overrideAttrs (oldAttrs:
                  rec {
                    # NOTE update me as nixpkgs gets updated, see
                    # nixpkgs/pkgs/development/libraries/kde-frameworks/srcs.nix to see current version
                    # and apply fixes in https://github.com/xmonad/xmonad/issues/174
                    src = pkgs.fetchurl {
                      url = "https://github.com/dalvescb/plasma-framework/archive/refs/tags/xmonad-5.90.tar.gz";
                      sha256 = "sha256-8EoNNnSW6nxwyc5h/vR6BnF71c3J2WlZL1ivHfcGsWI=";
                      name = "plasma-framework-5.90.0.tar.gz";
                    };
                  });
              });
            plasma5 = prevx.plasma5;
            kdeGear = prevx.kdeGear;
            all = kdeFrameworks // plasma5 // plasma5.thirdParty // kdeGear;
            libsForQt5 = all // {
              inherit kdeFrameworks plasma5 kdeGear;
              kdeApplications = kdeGear;
            };
          in libsForQt5 // {
            inherit libsForQt5;
          });
      in { inherit libsForQt5;
            inherit (libsForQt5) plasma-desktop;
            plasma5Packages = libsForQt5;
          }
    );
    hls-overlay = (self: super:
      let
        disableCabalFlag = super.haskell.lib.disableCabalFlag;
  
        hslWithoutPlugins = super.haskellPackages.haskell-language-server.override  {
          hls-fourmolu-plugin = null;
          hls-ormolu-plugin = null;
          # supportedGhcVersions = [ "884" "8107" "90" ];
        };
        withoutFourmoluFlag = disableCabalFlag hslWithoutPlugins "fourmolu";
        hls = disableCabalFlag withoutFourmoluFlag "ormolu";
      in { haskell-language-server = hls;  } );
  # in [ plasma-framework-overly ];
  in [ ];  # use no overlays atm
  environment.systemPackages = with pkgs; [
    wget
    ispell
    vim
    emacs
    git
    imagemagick
    subversion
    firefox-bin
    chromium
    brave
    discord
    nix-index
    libva
    libva-utils
    razergenie
    linuxPackages_5_15.openrazer
    pciutils
    arc-kde-theme
    # plasma5.kwallet-pam
    # plasma5.sddm-kcm
    haskellPackages.stack
    # (haskell-language-server.override { supportedGhcVersions = [ "902" "924" ]; })
    haskell-language-server
    haskellPackages.Cabal-syntax
    haskellPackages.Agda
    haskellPackages.implicit-hie
    cabal-install
    ghc
    python3Full
    snapper
    python38Packages.setuptools
    # emacs26Packages.agda2-mode
    agda
    agda-pkg
    texlive.combined.scheme-full
    # alacritty
    libsForQt5.ark
    zip
    unzip
    unrar
    mattermost-desktop
    slack
    teams
    zoom-us
    snapper
    # steam
    # steam-run
    chntpw
    ntfs3g
    libsForQt5.plasma-integration
    libsForQt5.plasma-browser-integration
    # libsForQt5.kdeconnect-kde
    libsForQt5.okular
    xorg.xkill
    htop
    linuxPackages_5_15.xpadneo
    gsmartcontrol
    smartmontools
    pkg-config
    alsa-lib
    xorg.xrandr
    arandr
    killall
    libnotify
    jupyter
    pandoc
    libreoffice
    rnnoise-plugin
    noisetorch
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    python311Packages.pygments
    ipopt
    docker
    # haskell.packages.ghc883.haskell-language-server
    glmark2
    ripgrep
    ripgrep-all
    # dropbox - we don't need this in the environment. systemd unit pulls it in
    dropbox-cli
    nodePackages.mermaid-cli
    graphviz
    xdot
    haskellPackages.graphmod
    obs-studio
    vlc
    haruna
    mkvtoolnix
    niv
    shotcut
    gnome.nautilus
    gnome.sushi
    scrot
    btop
    lm_sensors
    xsensors
    hddtemp
    kde-gtk-config
    arc-theme
    materia-theme
    orchis-theme
    libsForQt5.knotifications
    libsForQt5.sddm-kcm
    libsForQt5.konqueror
    rnix-lsp
    spotify
    webtorrent_desktop
    transmission-qt
    kgraphviewer
    libgtop
    etcher
    openrgb
    poppler
    ditaa
    texlab
    ltex-ls
    html-tidy
    dolphin-emu
    sqlite
    elmPackages.elm
    elmPackages.nodejs
    elmPackages.elm-language-server
    elmPackages.elm-test
    elmPackages.elm-format
    elmPackages.elm-json
    elmPackages.elm-review
    elmPackages.elm-live
    elm2nix
    thunderbird
    gnome-icon-theme
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.gsconnect
    gnomeExtensions.another-window-session-manager
    gnomeExtensions.vitals
    # gnomeExtensions.freon
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.gtk-title-bar
  ];
  # Use the GRUB 2 boot loader (with EFI support)
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
  hardware.enableAllFirmware = true;
  boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = pkgs.lib.mkForce "sun12x22";
    keyMap = pkgs.lib.mkForce "us";
  };
  nixpkgs.config.allowUnfree = true;
  fonts = {
    fonts = with pkgs; [
        dejavu_fonts
        # (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; } )
        nerdfonts
        source-code-pro
        emacs-all-the-icons-fonts
        jetbrains-mono
        font-awesome
        hack-font
        inconsolata
        inconsolata-nerdfont
      ];
  };
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps"; # this stopped working on home-manager update. needs to be set through home.keyboard.options now?
  environment.variables =
    {
      # In firefox in about:config I switched gfx.webrender.all to true to fix bug causing
      # lag under high gpu load. 
      # But this introduced a new bug! that is fixed by this environment variable
      MOZ_X11_EGL = "1";
      HOSTNAME = "${config.networking.hostName}";
      XDG_SESSION_TYPE="x11";
      # needed to fix bug https://github.com/NixOS/nixpkgs/issues/48424
      WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    };
  systemd.extraConfig = ''
                      DefaultTimeoutStopSec=5s
                      DefaultTimeoutStartSec=5s
                      '';
  services.cron = {
    enable = true;
    systemCronJobs = [
        # updates ip for duckdns
        "*/5 * * * * root /home/dalvescb/duckdns/duck.sh >/dev/null 2>&1"
      ];
  };
  services.openssh.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    {
      from = 1714;
      to = 1764;
    }
    # Dropbox
    {
      from = 17500;
      to = 17500;
    }
    # SSH
    {
      from = 22;
      to = 22;
    } 
  ];
  
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    {
      from = 1714;
      to = 1764;
    }
    # Dropbox
    {
      from = 17500;
      to = 17500;
    }
    # SSH
    {
      from = 22;
      to = 22;
    }
  ];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.dbus.packages = [ pkgs.dconf ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      };
  };
  sound.enable = true;
  # hardware.pulseaudio = {
  #    enable = true;
  #    support32Bit = true;
  #    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
  #    # Only the full build has Bluetooth support, so it must be selected here.
  #    package = pkgs.pulseaudioFull;
  # };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
   enable = true;
   alsa.enable = true;
   alsa.support32Bit = true;
   pulse.enable = true;
   # If you want to use JACK applications, uncomment this
   #jack.enable = true;
  };
  services.xserver.libinput.enable = true;
  hardware.xpadneo.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  hardware.openrazer.enable = true;
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  systemd.user.services.dropbox = {
      description = "Dropbox";
      wantedBy = [ "graphical-session.target" ];
      environment = {
        QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
        QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
      };
      serviceConfig = {
        ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
        ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
        KillMode = "control-group"; # upstream recommends process
        Restart = "on-failure";
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;
      };
    };
  programs.noisetorch.enable = true;
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # Binary Cache for Haskell.nix
  ];
  
  nix.settings.substituters = [
    "https://cache.iog.io" # Binary Cache for Haskell.nix
  ];
  
  #  this was added to fix the following error when using buildStackProject
  # error: derivation '/nix/store/5sdvfa4fg9rsrqnl120ji9gnn6fa15gc-Coconut-env.drv' has '__noChroot' set, but that's not allowed when 'sandbox' is 'true'
  nix.settings.sandbox = false;
  nix.extraOptions = ''
                   keep-outputs = true
                   keep-derivations = true
                   '';
  nixpkgs.config.permittedInsecurePackages = [
                  "electron-12.2.3"
                ];
  # enables auto-updating
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  programs.zsh.shellAliases = { 
    e = "emacsclient";
    ec ="emacsclient -c";
  };
}
# Template:1 ends here
