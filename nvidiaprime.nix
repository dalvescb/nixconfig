# [[file:NixOSConfiguration.org::*Nvidia Prime][Nvidia Prime:1]]
{pkgs, ... }:

# let
#    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
#     export __NV_PRIME_RENDER_OFFLOAD=1
#     export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
#     export __GLX_VENDOR_LIBRARY_NAME=nvidia
#     export __VK_LAYER_NV_optimus=NVIDIA_only
#     exec -a "$0" "$@"
#   '';
# in
{
  # environment.systemPackages = [ nvidia-offload ]; 
  # services.xserver.videoDrivers = [ "intel" "modesetting" "nvidia" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 96;
  hardware.nvidia.prime = {
    # offload.enable = true;
    sync.enable = true;
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
  };
  hardware.opengl.driSupport32Bit = true;
}
# Nvidia Prime:1 ends here
