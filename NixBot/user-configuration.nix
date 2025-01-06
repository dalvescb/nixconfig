# Edit this file to configure your user declaritively
# This can contain secrets (like hashedPassword) and should NOT be kept on GitHub
{ config, pkgs, ... }:
{

  users.users.dalvescb = {
    isNormalUser = true;
    home = "/home/dalvescb";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    # generate me with mkpasswd -m sha-512
  };

  # disable root password
}
