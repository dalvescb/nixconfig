# [[file:NixOSConfiguration.org::*Home Manager][Home Manager:1]]
{ config, pkgs, ... }:
{
  home.username = "dalvescb";
  home.homeDirectory = "/home/dalvescb";
  home.stateVersion = "20.09";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gimp
    pavucontrol
    xorg.xmessage
    nitrogen
    font-awesome
    # font-awesome-ttf      # used by polybar
    material-design-icons # used by polybar
    xmonad-log
    pasystray
    blueman
    networkmanagerapplet
    networkmanager_dmenu
    dmenu
    # (pkgs.linkFarm "dmenu" [ {
    #   name = "bin/dmenu";
    #   path = "${pkgs.rofi}/bin/rofi";
    # } ])
    gnome.adwaita-icon-theme
    # dunst
    arc-icon-theme
    steam-run
    dconf2nix
    alacritty
  ];

  programs.zsh.enable = true;
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "git" ];
  programs.zsh.oh-my-zsh.theme = "amuse";
  
  programs.zsh.plugins = let
    zsh-syntax-highlighting = {
       name = "zsh-syntax-highlighting";
       src = pkgs.fetchFromGitHub {
         owner = "zsh-users";
         repo = "zsh-syntax-highlighting";
         rev = "0.7.1";
         sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
       };
     };
    zsh-autosuggestions = {
       name = "zsh-autosuggestions";
       src = pkgs.fetchFromGitHub {
         owner = "zsh-users";
         repo = "zsh-autosuggestions";
         rev = "v0.6.4";
         sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
       };
     };
    in [ 
        zsh-syntax-highlighting
        zsh-autosuggestions
       ];
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 1.0;
    font.normal = {
      family = "Source Code Pro";
      style = "Regular";
    };
    font.bold = {
      family = "Source Code Pro";
      style = "Bold";
    };
    font.italic = {
      family = "Source Code Pro";
      style = "Italic";
    };
    font.bold_italic = {
      family = "Source Code Pro";
      style = "Bold Italic";
    };
    font.size = 14.0;
    import = [ "~/nixconfig/alacritty/dracula.yml" ];
    key_bindings = [
      {
        key = "N";
        mods = "Control|Shift";
        action = "SpawnNewInstance";
      }
    ];
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # dconf.settings = {
  
  #   "desktop/wm/keybindings" = { 
  #       "close"= "['<Shift><Super>c']";
  #       "cycle-windows"= "['<Super>o']";
  #       "cycle-windows-backward"= "['<Shift><Super>o']";
  #       "maximize"="@as []";
  #       "minimize"="@as []";
  #       "move-to-monitor-left"= "['<Shift><Super>j']";
  #       "move-to-monitor-right"= "['<Shift><Super>k']";
  #       "move-to-workspace-1"= "['<Shift><Super>exclam']";
  #       "move-to-workspace-2"= "['<Shift><Super>at']";
  #       "move-to-workspace-3"= "['<Shift><Super>numbersign']";
  #       "move-to-workspace-4"= "['<Shift><Super>dollar']";
  #       "move-to-workspace-left"= "['<Shift><Super>h']";
  #       "move-to-workspace-right"= "['<Shift><Super>l']";
  #       "switch-input-source"= "@as []";
  #       "switch-input-source-backward"= "@as []";
  #       "switch-to-workspace-1"= "['<Super>1']";
  #       "switch-to-workspace-2"= "['<Super>2']";
  #       "switch-to-workspace-3"= "['<Super>3']";
  #       "switch-to-workspace-4"= "['<Super>4']";
  #       "switch-to-workspace-left"= "['<Super>h']";
  #       "switch-to-workspace-right"= "['<Super>l']";
  #       "toggle-fullscreen"= "['<Shift><Super>space']";
  #       "toggle-maximized"= "['<Super>i']";
  #     };
    
  #     "mutter/keybindings" = {
  #       "switch-monitor" = "['XF86Display']";
  #       "toggle-tiled-left" = "['<Super>j']";
  #       "toggle-tiled-right" = "['<Super>k']";
  #     };
    
  #     "settings-daemon/plugins/media-keys" = {
  #       "screensaver" = "@as []";
  #       "search" = "['<Super>p']";
  #     };
  #   };
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;
  home.keyboard = {
    layout = "us";
    options = [ "ctrl:swapcaps" ];
    };

}
# Home Manager:1 ends here
