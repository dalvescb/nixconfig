# [[file:NixOSConfiguration.org::*Nvidia][Nvidia:1]]
{pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  # services.xserver.dpi = 96;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    setLdLibraryPath = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
# Nvidia:1 ends here
