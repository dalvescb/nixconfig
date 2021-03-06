# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      /home/dalvescb/nixconfig/common-configuration.nix
      /home/dalvescb/nixconfig/nvidiaprime.nix
      ./user-configuration.nix
    ];

  networking.hostName = "NixBot";
  nix.nixPath = [
    "home-manager=/home/dalvescb/home-manager"
    # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "nixpkgs=/home/dalvescb/nixpkgs"
    "nixos-config=/home/dalvescb/nixconfig/${config.networking.hostName}/configuration.nix"
  ];

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp82s0.useDHCP = true;

  # set host specific env vars here
  environment.variables =
    {
      # pimary monitor
      MONITOR = "eDP-1-1";
      # DPI
      DPI = "192";
    };
  # need to set this statically when using opt-in state on a btrfs root subvolume
  environment.etc."machine-id".text = "b7665d1914cd41dc93406d8488004eb0";

  # needed to persist logging during boot
  fileSystems."/var/log".neededForBoot = true;
}
