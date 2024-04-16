{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dalvescb = {
     isNormalUser = true;
     home = "/home/dalvescb";
     extraGroups = [ "wheel" "networkmanager" "plugdev" "audio" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
     hashedPassword = "$6$gIQj7x0Xap5HKEG0$xjpe2XjL9/d1Gr7R4D27NS0TC3ZXWm9QMrTWPKai1NQ1uiil6ydt53QKvqDRDOISjTB8gJ57qVWleErHSbbAw1";
  };
}
