# [[file:NixOSConfiguration.org::*Nvidia][Nvidia:1]]
{pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.dpi = 96;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    setLdLibraryPath = true;
    driSupport32Bit = true;
  };
}
# Nvidia:1 ends here
