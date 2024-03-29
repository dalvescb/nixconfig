# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      /home/dalvescb/nixconfig/common-configuration.nix
      /home/dalvescb/nixconfig/nvidia.nix
      ./user-configuration.nix
    ];

  networking.hostName = "NixMachine";
  nix.nixPath = [
    # "home-manager=/nix/var/nix/profiles/per-user/root/channels/home-manager"
    # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "home-manager=/home/dalvescb/home-manager"
    "nixpkgs=/home/dalvescb/nixpkgs"
    "nixos-config=/home/dalvescb/nixconfig/${config.networking.hostName}/configuration.nix"
  ];

  # set host specific env vars here
  environment.variables =
    {
      # pimary monitor
      MONITOR = "DP-0";
      # DPI
      DPI = "107";
    };

  networking.useDHCP = false;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # hardware.video.hidpi.enable = false;
  # this got deprecated in upgarde, with the suggestion to configure fonts.fontconfig manually

  services.hardware.openrgb.motherboard = "intel";
  services.hardware.openrgb.enable = true;

  # need to set this statically when using opt-in state on a btrfs root subvolume
  environment.etc."machine-id".text = "b9c71693f16c41d2990fc03ed875ac77";

  # needed to persist logging during boot
  fileSystems."/var/log".neededForBoot = true;

  # mount secondary ntfs hdd partition
  fileSystems."/mnt/HD4" =
    { device = "/dev/disk/by-uuid/444227094226FF74";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "rw" "user" "exec" "umask=000" ];
    };
  # mount secondary ext4 hdd partition
  fileSystems."/mnt/shared" =
    { device = "/dev/disk/by-uuid/9827ba47-effe-400e-8514-056925ca79db";
      fsType = "ext4";
    };
}
