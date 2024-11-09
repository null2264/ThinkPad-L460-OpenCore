{ lib, pkgs, ... }:

{
  config.oceanix.opencore.resources = {
    # ACPIFolders = [ ../../Patches ];
    # KextsFolders = [ ../../Kexts ];
    # DriversFolders = [ ../../Drivers ];
    packages = [
      # pkgs.airportitlwm-latest-ventura
      pkgs.oc.itlwm.v2_1_0
      # pkgs.applealc-latest-release
      # pkgs.brightnesskeys-latest-release
      # pkgs.ecenabler-latest-release
      # pkgs.intel-bluetooth-firmware-latest
      # pkgs.brcmpatchram-latest-release
      # pkgs.nvmefix-latest-release
      # pkgs.virtualsmc-latest-release
      # pkgs.whatevergreen-latest-release
      # pkgs.lilu-latest-release
      # pkgs.voodooi2c-latest
      # pkgs.voodoops2controller-latest-release
      # pkgs.rtcmemoryfixup-latest-release
      # pkgs.intel-mausi-latest-release
      # pkgs.usbtoolbox-latest-release
    ];
  };
}
