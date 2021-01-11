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
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "nixos-config=/home/dalvescb/nixconfig/${config.networking.hostName}/configuration.nix"
  ];

  networking.useDHCP = false;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # need to set this statically when using opt-in state on a btrfs root subvolume
  environment.etc."machine-id".text = "679ae74c4f5b4adc9a3b5377595392f4";

  # needed to persist logging during boot
  fileSystems."/var/log".neededForBoot = true;

  # mount secondary ntfs hdd
  fileSystems."/mnt/HD4" =
    { device = "/dev/disk/by-uuid/444227094226FF74";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" ];
    };
}
