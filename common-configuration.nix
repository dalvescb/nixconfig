# [[file:NixOSConfiguration.org::*Template][Template:1]]
# Edit this configuration file to include configuration common between hosts
# NOTE this was generated from the org file NixOSConfiguration.org
{ config, pkgs, ... }:

{
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
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
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
        emacs-all-the-icons-fonts
      ];
  };
  services.xserver.xkbOptions = "ctrl:swapcaps";
  console.useXkbConfig = true;
  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  hardware.bluetooth.enable = true;
  sound.enable = true;
  hardware.pulseaudio = {
     enable = true;
  
     # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
     # Only the full build has Bluetooth support, so it must be selected here.
     package = pkgs.pulseaudioFull;
  };
  services.xserver.libinput.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    ispell
    vim
    emacs
    git
    imagemagick
    subversion
    firefox
    (chromium.override { enableVaapi = true; })
    brave
    discord
    nix-index
    libva
    libva-utils
    razergenie
    linuxPackages.openrazer
    pciutils
    arc-kde-theme
    plasma5.kwallet-pam
    plasma5.sddm-kcm
    haskellPackages.stack
    haskellPackages.haskell-language-server
    haskellPackages.Agda
    python3Full
    snapper
    python38Packages.snapperGUI
    emacs26Packages.agda2-mode
    texlive.combined.scheme-full
    alacritty
  ];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # enables auto-updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  
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
}
# Template:1 ends here
