# [[file:NixOSConfiguration.org::*Template][Template:1]]
# Edit this configuration file to include configuration common between hosts
# NOTE this was generated from the org file NixOSConfiguration.org
{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];
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
    linuxPackages_5_10.openrazer
    pciutils
    arc-kde-theme
    # plasma5.kwallet-pam
    # plasma5.sddm-kcm
    haskellPackages.stack
    (haskell-language-server.override { supportedGhcVersions = [ "884" "8106" ]; })
    haskellPackages.Agda
    haskellPackages.implicit-hie
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
    xorg.xkill
    htop
    linuxPackages_5_10.xpadneo
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
    betterlockscreen
    niv
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
  boot.kernelPackages = pkgs.linuxPackages_5_10;
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
    };
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
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;
    
    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };
  
    xserver.enable = true;
  
    xserver.displayManager.defaultSession = "none+xmonad";
  
    xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    
    xserver.layout = "us";
    xserver.xkbOptions = "ctrl:swapcaps";
  };
  
  console.useXkbConfig = true;
  systemd.services.upower.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
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
      font-awesome-ttf      # used by polybar
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
      dunst
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
    xsession = let
      extraCommands = ''
          if [ $HOSTNAME = NixMachine ] ; then
                    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --primary --mode 2560x1440 --panning 2560x1440+1440+678 --rate 144.00 --output DP-2 --mode 2560x1440 --panning 2560x1440+4000+927 --rate 144.00 --right-of DP-0 --output DP-4 --rotate right --mode 2560x1440 --rate 60.00 --left-of DP-0
          fi 
      '';
    in {
      enable = true;
      
      initExtra = extraCommands;
      
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
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = ./rofi/theme.rafi;
      # package = pkgs.rofi.override { plugins = [ pkgs.rofi-file-browser ]; };
    };
    services.polybar = let
      
      mypolybar = pkgs.polybar.override {
        alsaSupport = true;
        pulseSupport = true;
      };
      
      bluetoothScript = pkgs.callPackage ./polybar/bluetooth.nix {};
      bctl = ''
      [module/bctl]
      type = custom/script
      exec = ${bluetoothScript}/bin/bluetooth-ctl
      tail = true
      click-left = ${bluetoothScript}/bin/bluetooth-ctl --toggle &
      '';
    
      xmonad = ''
      [module/xmonad]
      type = custom/script
      exec = ${pkgs.xmonad-log}/bin/xmonad-log 
    
      tail = true
      '';
    
      primaryBar = ''
      [bar/primary]
      inherit = bar/main
      monitor = ''${env:MONITOR}
      modules-center = date
      modules-left   = ewmh
      tray-position  = right
      '';
      
      highDPIBar = ''
      [bar/highDPI]
      inherit = bar/main
      monitor = ''${env:MONITOR}
      modules-center = date
      modules-left   = ewmh
      modules-right  = battery backlight
      tray-position  = right
      dpi-x = 192
      dpi-y = 192
      tray-maxsize = 1000
      '';
      
    in {
      enable = true;
      package = mypolybar;
      config = ./polybar/polybar.ini;
      extraConfig = xmonad + bctl + primaryBar + highDPIBar;
      script = ''
      if [ $HOSTNAME = "NixBot" ] ; then
        polybar highDPI 2>/home/dalvescb/.polybar_primary_error.log &
      else 
        polybar primary 2>/home/dalvescb/.polybar_primary_error.log &
      fi
      '';
    };
    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Arc";
        # package = pkgs.gnome3.adwaita-icon-theme;
        package = pkgs.arc-icon-theme;
        size = "16x16";
      };
      settings = {
        global = {
          monitor = 0;
          geometry = "500x50-50+65";
          shrink = "yes";
          transparency = 10;
          padding = 16;
          horizontal_padding = 16;
          font = "JetBrains Mono Medium 10";
          line_height = 4;
          format = ''<b>%s</b>\n%b'';
        };
      };
    };
    services.picom = {
        enable = true;
        # package = pkgs.picom.overrideDerivation (oldAttrs: {
        #   name = "picom-v8";
        #   src = pkgs.fetchurl {
        #     url = https://github.com/yshui/picom/archive/v8.tar.gz;
        #     sha256 = "03s8236jm9wfqaqqvrfhwwxyjbygh69km5z3x9iz946ab30a6fgq";
        #   };
        #   patches = [];
        # });
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
    services.screen-locker = {
        enable = true;
        inactiveInterval = 30; # minutes
        lockCmd = "systemctl --user stop picom.service ; ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim ; systemctl --user start picom.service";
        xautolockExtraOptions = [
          "Xautolock.killer: systemctl suspend"
        ];
      };
    home.file.".config/betterlockscreenrc".source = ./betterlockscreen/betterlockscreenrc;
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita-dark";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
    };
    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscode-fhs;
    
  };
  programs.zsh.shellAliases = { 
    e = "emacsclient";
    ec ="emacsclient -c";
  };
}
# Template:1 ends here
