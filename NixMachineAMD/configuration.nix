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

  networking.hostName = "NixMachineAMD";
  nix.nixPath = [
    # "home-manager=/nix/var/nix/profiles/per-user/root/channels/home-manager"
    # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "home-manager=/home/dalvescb/home-manager"
    "nixpkgs=/home/dalvescb/nixpkgs"
    "nixos-config=/home/dalvescb/nixconfig/${config.networking.hostName}/configuration.nix"
  ];

}
