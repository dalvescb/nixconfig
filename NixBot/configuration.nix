# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./user-configuration.nix
      /home/dalvescb/nixconfig/common-configuration.nix
    ];

  networking.hostName = "NixBot";
  nix.nixPath = [
    "nixos-config=/home/dalvescb/nixconfig/${config.networking.hostName}/configuration.nix"
  ];


  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp82s0.useDHCP = true;
}
