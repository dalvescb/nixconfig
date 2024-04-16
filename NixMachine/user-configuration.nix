# Edit this file to configure your user declaritively
# This can contain secrets (like hashedPassword) and should NOT be kept in GitHub
{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.dalvescb = {
    isNormalUser = true;
    home = "/home/dalvescb";
    extraGroups = [ "wheel" "networkmanager" "plugdev" "audio" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$5xohALmPq$PRsYaQ.XCP8FwwMZ6D15jwddZoH/joy1X8yt4VbTyrEaHW5B7IaVxMk5mtl5aMnn98m3qLy6LYZwtmU86jm6g1";
    openssh.authorizedKeys.keyFiles = [ ./cdalves.pub ];
    # generate me with mkpasswd -m sha-512
  };

  # disable root password
  users.users.root.hashedPassword = "*";
}
