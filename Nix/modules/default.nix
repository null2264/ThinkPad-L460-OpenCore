{ config, lib, pkgs, ... }:

let
  cfg = config.oceanix;
in {
  imports = [
    ./config/ACPI.nix
    ./config/Booter.nix
    ./config/DeviceProperties.nix
    ./config/Kernel.nix
    ./config/PlatformInfo.nix
  ];

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

  kexts.usbtoolbox = {
    enable = true;
    mapping = ../include/kexts/UTBMap.kext;
  };

  oceanix.opencore = {
    validate = false;
    package =
      let
        driversToKeep = [
          "AudioDxe.efi"
          "OpenCanopy.efi"
          "OpenRuntime.efi"
          "Ps2KeyboardDxe.efi"
          "ResetNvramEntry.efi"
        ];
        toolsToKeep = [
          "OpenControl.efi"
          "OpenShell.efi"
        ];
      in pkgs.oc.opencore.latest.overrideAttrs (old: {
        installPhase = ''
          find ./${cfg.opencore.arch}/EFI/OC/Drivers -type f -iname "*.efi" \! \( -iname ${builtins.concatStringsSep " -o -iname " driversToKeep} \) -exec rm -r \{\} +
          find ./${cfg.opencore.arch}/EFI/OC/Tools -type f -iname "*.efi" \! \( -iname ${builtins.concatStringsSep " -o -iname " toolsToKeep} \) -exec rm -r \{\} +

          ${old.installPhase or ""}
        '';
      });
    # We already filter out the unnecessary drivers and tools, so just auto enable them all
    autoEnableDrivers = true;
    autoEnableTools = true;
    # All the included ACPI patches included in 'Patches/' dir are used so let's just auto enable them
    autoEnableACPI = true;
    resources = {
      ACPIFolders = [ ../../Patches ];
      # KextsFolders = [ ../../Kexts ];
      DriversFolders = [ ../../Drivers ];
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
      ];
    };
  };
}
