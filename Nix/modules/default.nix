{ config, lib, pkgs, ... }:

let
  cfg = config.oceanix;
in {
  imports = [
    ./config/ACPI.nix
    ./config/Booter.nix
    ./config/DeviceProperties.nix
    ./config/Kernel.nix
    ./config/Misc.nix
    ./config/NVRAM.nix
    ./config/PlatformInfo.nix
    ./config/UEFI.nix
  ];

  kexts.applealc = {
    enable = true;
    type = "alc";
  };

  kexts.cpufriend = {
    enable = true;
    dataProvider = ../../Include/PlugIns/CPUFriendDataProvider.kext;
  };

  kexts.intel-bluetooth-firmware = {
    enable = true;
    includeBlueToolFixup = true;
  };

  kexts.intel-mausi = {
    enable = true;
    type = "temperate";
  };

  kexts.usbtoolbox = {
    enable = true;
    mapping = ../../Include/PlugIns/UTBMap.kext;
  };

  kexts.virtualsmc = {
    enable = true;
    includedPlugins = [
      "SMCBatteryManager"
      "SMCProcessor"
    ];
  };

  kexts.yogasmc = {
    enable = true;
    type = "lilu";
  };

  oceanix.opencore = {
    validate = true;
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
      KextsFolders = [ ../../Kexts ];
      DriversFolders = [ ../../Drivers ];
      packages = [
        pkgs.oc.lilu.latest
        pkgs.oc.airportitlwm.latest-ventura
        #pkgs.oc.itlwm.latest
        pkgs.oc.applemcereporterdisabler
        pkgs.oc.brightnesskeys.latest
        pkgs.oc.cputscsync.latest
        pkgs.oc.ctlnaahciport
        pkgs.oc.debugenhancer.latest
        pkgs.oc.ecenabler.latest
        pkgs.oc.hibernationfixup.latest
        pkgs.oc.intel-bluetooth-firmware.latest
        pkgs.oc.restrictevents.latest
        pkgs.oc.voltageshift.latest
        pkgs.oc.voodoops2controller.latest
        pkgs.oc.voodoormi.latest
        pkgs.oc.whatevergreen.latest
      ];
    };
  };
}
