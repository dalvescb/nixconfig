# Edit this file to configure your user declaritively
# This can contain secrets (like hashedPassword) and should NOT be kept on GitHub
{ config, pkgs, ... }:
{
	users.mutableUsers = false;

  users.users.dalvescb = {
    isNormalUser = true;
    home = "/home/dalvescb";
    extraGroups = [ "wheel" "networkmanager" "plugdev" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    hashedPassword = "$6$3IX8xbITZQz$AK4WoPAp7aEB/Z7cyniqjskUWJDd.sODBBkiP3HpHyjxYR/yDC6u7XW.owEG5UYnlIDN/bRly1nxIfDMfRwnm1";
    # generate me with mkpasswd -m sha-512
  };

  # disable root password
  users.users.root.hashedPassword = "*";
}
