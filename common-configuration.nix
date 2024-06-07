# [[file:NixOSConfiguration.org::*Template][Template:1]]
    # Edit this configuration file to include configuration common between hosts
    # NOTE this was generated from the org file NixOSConfiguration.org
    { config, pkgs, flake-inputs, ... }:

    {
      imports = [ ];
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
      environment.systemPackages = let
          system = "x86_64-linux";
          doom-emacs = flake-inputs.doom-emacs;
          my-cookies =
              # ...
              (
                  pkgs.python3Packages.buildPythonPackage rec {
                  pname = "my-cookies";
                  version = "0.1.3";
                  # src = pkgs.python3Packages.fetchPypi {
                  #     inherit pname version;
                  #     sha256 = "ddee63d0714e5d4c94a3a61550a4276dac6f014b43a114f31aa5bc1d47f3ad0f";
                  # };
                  src = pkgs.fetchurl {
                    url = "https://files.pythonhosted.org/packages/8c/3e/bcebe0f7b2d2a622fe9ea181bedcdce6dc70eed480a098e4f0b1569b1da3/my_cookies-0.1.3.tar.gz";
                    hash = "sha256-3e5j0HFOXUyUo6YVUKQnbaxvAUtDoRTzGqW8HUfzrQ8=";
                  };
                  doCheck = false;
                  propagatedBuildInputs = [
                      # Specify dependencies
                      # pkgs.python3Packages.numpy
                  ];
                  }
              );
      in with pkgs; [
        openssl
        jellyfin-ffmpeg
        jdupes
        plex-media-player
        my-cookies
        wget
        ispell
        vim
        # emacs
        # doom-emacs
        git
        imagemagick
        subversion
        chromium
        brave
        nix-index
        libva
        libva-utils
        pciutils
        arc-kde-theme
        # plasma5.kwallet-pam
        # plasma5.sddm-kcm
        # (haskell-language-server.override { supportedGhcVersions = [ "902" "924" ]; })
        # haskellPackages.Cabal-syntax
        python3Full
        python312Packages.setuptools
        # emacs26Packages.agda2-mode
        # alacritty
        libsForQt5.ark
        zip
        unzip
        unrar
        # teams
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
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        python311Packages.pygments
        ipopt
        docker
        # haskell.packages.ghc883.haskell-language-server
        glmark2
        # ripgrep
      
        (ripgrep.overrideAttrs (old: {
                      doInstallCheck = false;
              }))
        (ripgrep-all.overrideAttrs (old: {
                      doInstallCheck = false;
              }))
        # ripgrep-all
        # dropbox - we don't need this in the environment. systemd unit pulls it in
        dropbox-cli
        vlc
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
        webtorrent_desktop
        transmission-qt
        kgraphviewer
        libgtop
        # etcher
        openrgb
        poppler
        ditaa
        ltex-ls
        html-tidy
        sqlite
        clang
        clang-tools
        clangStdenv
        bear
        cmake
        silver-searcher
        gnome-icon-theme
        gnome.gnome-tweaks
        gnome.dconf-editor
        gnome.gnome-remote-desktop
        gnomeExtensions.appindicator
        # gnomeExtensions.notes
        gnomeExtensions.just-perfection
        # gnomeExtensions.gsconnect
        gnomeExtensions.another-window-session-manager
        gnomeExtensions.vitals
        # gnomeExtensions.freon
        gnomeExtensions.dash-to-panel
        gnomeExtensions.sound-output-device-chooser
        # gnomeExtensions.gtk-title-bar
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
      # boot.kernelPackages = pkgs.linuxPackages_5_15;
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
        # Nginx
        {
          from = 80;
          to = 80;
        }
        {
          from = 443;
          to = 443;
        }
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
        # remote-desktop
        {
          from = 3389;
          to = 3389;
        }
        # sonarr
        {
          from = 8989;
          to = 8989;
        }
        # radarr
        {
          from = 7878;
          to = 7878;
        }
        # sabnzbd
        {
          from = 8080;
          to = 8080;
        }
        # sabnzbd web interface
        {
          from = 8090;
          to = 8090;
        }
        # jellyfin https
        {
          from = 8920;
          to = 8920;
        }
      ];
      
      networking.firewall.allowedUDPPortRanges = [
        # Nginx
        {
          from = 80;
          to = 80;
        }
        {
          from = 443;
          to = 443;
        }
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
        # remote-desktop
        {
          from = 3389;
          to = 3389;
        }
        # sonarr
        {
          from = 8989;
          to = 8989;
        }
        # radarr
        {
          from = 7878;
          to = 7878;
        }
        # sabnzbd
        {
          from = 8080;
          to = 8080;
        }
        # sabnzbd web interface
        {
          from = 8090;
          to = 8090;
        }
        # jellyfin https
        {
          from = 8920;
          to = 8920;
        }
      ];
      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;
      
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "startplasma-x11";
      services.xrdp.openFirewall = true;
      
      services.logind.lidSwitchExternalPower = "ignore";
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
      services.emacs.enable = true;
      services.emacs.package = with pkgs; (
        (emacsPackagesFor emacs).emacsWithPackages (
          epkgs: [ epkgs.vterm ]
        )
      );
      services.emacs.defaultEditor = true;
      # security.acme.server = "https://127.0.0.1";
      # security.acme.preliminarySelfsigned = true;
      security.acme.acceptTerms = true;
      security.acme.defaults.email = "curtis.dalves@gmail.com";
      # security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      
      security.acme.certs =
        let
          sslcert = {
            dnsProvider = "duckdns";
            environmentFile = "${pkgs.writeText "duckdns-creds" ''
                       DUCKDNS_TOKEN=d399963b-9390-4938-9a0f-9d1e5fd2d7df
                       ''}";
            webroot = null;
            # webroot = "/var/www/acme/challenges-com";
            email = "curtis.dalves@gmail.com";
            group = "nginx"; };
         in {  "curtojellyfin.duckdns.org" = sslcert;
               "curtoradarr.duckdns.org" = sslcert;
               "curtosonarr.duckdns.org" = sslcert;
            };
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      
        virtualHosts = {
          "curtojellyfin.duckdns.org" = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:8096";
            };
          };
          "curtohome.duckdns.org" = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1";
            };
            locations."/radarr" = {
              proxyPass = "http://127.0.0.1:7878/radarr";
            };
            locations."/sonarr" = {
              proxyPass = "http://127.0.0.1:8989/sonarr";
            };
            locations."/prowlarr" = {
              proxyPass = "http://127.0.0.1:9696/prowlarr";
            };
            locations."/sabnzbd" = {
              proxyPass = "http://127.0.0.1:8080/sabnzbd";
            };
            locations."/bazarr" = {
              proxyPass = "http://127.0.0.1:6767/bazarr";
            };
          };
        };
      };
      services.jellyfin = {
        enable = true;
        openFirewall = true; # 8096
        user="dalvescb";
      };
      services.sonarr = {
        enable = true;
        openFirewall = true; # 8989
        user="dalvescb";
      };
      services.radarr = {
        enable = true;
        openFirewall = true; # 7878
        user="dalvescb";
      };
      services.prowlarr = {
        enable = true;
        openFirewall = true; # 9696
      };
      services.sabnzbd = {
        enable = true;
        openFirewall = true; # 8080
        user="dalvescb";
      };
      services.bazarr = {
        enable = true;
        openFirewall = true; # 6767
        user="dalvescb";
      };
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
                      "electron-19.1.9"
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
