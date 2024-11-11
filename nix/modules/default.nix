{ lib, pkgs, ... }:

{
  kexts.applealc = {
    enable = true;
    type = "alc";
  };

  kexts.virtualsmc = {
    enable = true;
    includedPlugins = [
      "SMCBatteryManager"
      "SMCProcessor"
    ];
  };

  oceanix.opencore = {
    validate = false;
    resources = {
      # ACPIFolders = [ ../../Patches ];
      KextsFolders = [ ../../Kexts ];
      # DriversFolders = [ ../../Drivers ];
      packages = [
        pkgs.oc.airportitlwm.latest-ventura
        # pkgs.oc.itlwm.latest
        # pkgs.oc.brightnesskeys.latest
        # pkgs.oc.ecenabler.latest
        # pkgs.oc.intel-bluetooth-firmware.latest
        # pkgs.oc.brcmpatchram.latest
        # pkgs.oc.nvmefix.latest
        # pkgs.oc.whatevergreen.latest
        # pkgs.oc.lilu.latest
        # pkgs.oc.voodooi2c.latest
        # pkgs.oc.voodoops2controller.latest
        # pkgs.oc.rtcmemoryfixup.latest
        # pkgs.oc.intel-mausi.latest
        # pkgs.oc.usbtoolbox.latest
      ];
    };
  };
}
