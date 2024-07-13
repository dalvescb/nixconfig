# [[file:NixOSConfiguration.org::*Nvidia][Nvidia:1]]
{pkgs, config,  ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # services.xserver.dpi = 96;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    # setLdLibraryPath = true;
    # driSupport = true;
    # driSupport32Bit = true;
  };
}
# Nvidia:1 ends here
