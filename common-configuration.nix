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
  # in [ plasma-framework-overly ];  
  in [ plasma-framework-overly ];  # use no overlays atm
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
    (haskell-language-server.override { supportedGhcVersions = [ "884" "8107" ]; })
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
    alacritty
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
    libsForQt5.kdeconnect-kde
    libsForQt5.okular
    xorg.xkill
    htop
    linuxPackages_5_15.xpadneo
    gsmartcontrol
    smartmontools
    pkg-config
    alsaLib
    xorg.xrandr
    arandr
    killall
    libnotify
    jupyter
    pandoc
    libreoffice
    rnnoise-plugin
    # noisetorch
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    python27Packages.pygments
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
    libsForQt5.knotifications
    libsForQt5.sddm-kcm
    libsForQt5.konqueror
    rnix-lsp
    spotify
    webtorrent_desktop
    transmission-qt
    kgraphviewer
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
        (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; } )
        source-code-pro
        emacs-all-the-icons-fonts
        jetbrains-mono
        font-awesome
        hack-font
        inconsolata
        inconsolata-nerdfont
      ];
  };
  environment.variables =
    {
      # In firefox in about:config I switched gfx.webrender.all to true to fix bug causing
      # lag under high gpu load. 
      # But this introduced a new bug! that is fixed by this environment variable
      MOZ_X11_EGL = "1";
      HOSTNAME = "${config.networking.hostName}";
      XDG_SESSION_TYPE="x11";
    };
  systemd.extraConfig = ''
                      DefaultTimeoutStopSec=5s
                      DefaultTimeoutStartSec=5s
                      '';
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
  ];
  services.xserver.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  services.xserver.displayManager.setupCommands = ''
  xrandr --output DP-2 --off
  xrandr --output HDMI-0 --off
  xrandr --output DP-0 --mode 2560x1440 --pos 0x0 --rotate normal
  '';
  # services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps"; # this stopped working on home-manager update. needs to be set through home.keyboard.options now?
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      };
  };
  sound.enable = true;
  hardware.pulseaudio = {
     enable = true;
     support32Bit = true;
     # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
     # Only the full build has Bluetooth support, so it must be selected here.
     package = pkgs.pulseaudioFull;
  };
  services.xserver.libinput.enable = true;
  hardware.xpadneo.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  hardware.openrazer.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;
  programs.steam.enable = true;
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
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # Binary Cache for Haskell.nix
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io" # Binary Cache for Haskell.nix
  ];
  nix.extraOptions = ''
                   keep-outputs = true
                   keep-derivations = true
                   '';
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
  environment.etc = {
    # persist /etc/nixos
    nixos.source = "/persist/etc/nixos";
    NIXOS.source = "/persist/etc/NIXOS";
    # persist NetworkManager 
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    # persist adjtime
    # adjtime.source = "/persist/etc/adjtime";
  };
  
  systemd.tmpfiles.rules = [
   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
   "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
  ];
  
  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt
  
    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/mapper/enc /mnt
  
    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root
  
    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root
  
    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  '';
  home-manager.users.dalvescb = { pkgs, config, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      gimp
      pavucontrol
      xorg.xmessage
      nitrogen
      font-awesome
      # font-awesome-ttf      # used by polybar
      material-design-icons # used by polybar
      xmonad-log
      pasystray
      blueman
      networkmanagerapplet
      networkmanager_dmenu
      dmenu
      # (pkgs.linkFarm "dmenu" [ {
      #   name = "bin/dmenu";
      #   path = "${pkgs.rofi}/bin/rofi";
      # } ])
      gnome3.adwaita-icon-theme
      # dunst
      arc-icon-theme
      steam-run
    ];
    
    programs.zsh.enable = true;
    programs.zsh.oh-my-zsh.enable = true;
    programs.zsh.oh-my-zsh.plugins = [ "git" ];
    programs.zsh.oh-my-zsh.theme = "amuse";
    
    programs.zsh.plugins = let
      zsh-syntax-highlighting = {
         name = "zsh-syntax-highlighting";
         src = pkgs.fetchFromGitHub {
           owner = "zsh-users";
           repo = "zsh-syntax-highlighting";
           rev = "0.7.1";
           sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
         };
       };
      zsh-autosuggestions = {
         name = "zsh-autosuggestions";
         src = pkgs.fetchFromGitHub {
           owner = "zsh-users";
           repo = "zsh-autosuggestions";
           rev = "v0.6.4";
           sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
         };
       };
      in [ 
          zsh-syntax-highlighting
          zsh-autosuggestions
         ];
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    xsession = {
      enable = true;
      
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: [
          hp.dbus
          hp.monad-logger
          hp.xmonad-contrib
          hp.xmobar
        ];
        config = ./xmonad/xmonad.hs;
      };
    };
    home.file.".config/plasma-workspace/env/set_window_manager.sh".text = ''
                                                                        export KDEWM=${pkgs.haskellPackages.xmonad}/bin/xmonad
                                                                        '';
    home.file.".config/plasma-workspace/env/set_window_manager.sh".executable = true;
    services.picom = {
        enable = true;
        # package = pkgs.picom.overrideAttrs(o: {
        #       src = pkgs.fetchFromGitHub {
        #         repo = "picom";
        #         owner = "ibhagwan";
        #         rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
        #         sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
        #       };
        # });
        # activeOpacity = "1.0";
        # inactiveOpacity = "1.0";
        blur = true;
        backend = "glx";
        # experimentalBackends = true;
        fade = true;
        fadeDelta = 5;
        vSync = true;
        # opacityRule = [ 
        #                 "100:class_g   *?= 'Brave-browser'"
        #                 "60:class_g    *?= 'Alacritty'"
        #               ];
        
        shadow = true;
        shadowOpacity = "0.75";
        extraOptions = ''
                     xrender-sync-fence = true;
                     detect-client-opacity = true;
                     use-ewmh-active-win = true;
                     mark-ovredir-focused = false;
        '';
        #  mark-wmwin-focused = true;
        # inactive-opacity-override = true;
    };
    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscode-fhs;
    home.keyboard = {
      layout = "us";
      options = [ "ctrl:swapcaps" ];
      };
    
  };
  programs.zsh.shellAliases = { 
    e = "emacsclient";
    ec ="emacsclient -c";
  };
}
# Template:1 ends here
