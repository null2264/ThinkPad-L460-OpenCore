{ lib, pkgs, ... }:

with lib.oc.plist;

let
  itlwmRegion = "ID";
  verbose = false;
  debug = "${if verbose then "-v " else ""}keepsyms=1 debug=0x100";
in {
  oceanix.opencore.settings.NVRAM = {
    Add = {
      "7C436110-AB2A-4BBB-A880-FE41995C9F82" = {
        SystemAudioVolume = mkData "Iw==";
        # >> Bluetooth Workaround for Ventura 13.4+
        # REF: https://www.facebook.com/share/p/1DFnfQABsP/ (Eddie A. Brunson)
        bluetoothExternalDongleFailed = mkData "AA==";
        bluetoothInternalControllerInfo = mkData "AAAAAAAAAAAAAAAAAAA=";
        # << Bluetooth Workaround
        boot-args = "${debug} igfxonln=1 igfxrpsc=1 itlwm_cc=${itlwmRegion} acpi_layer=0x08 acpi_level=0x02 vm_compressor=2 unfairgva=4";
        csr-active-config = mkData "BgAAAA==";  # Partially disable SIP for TotalFinder
        "prev-lang:kbd" = "en-US:0";
      };
      "E09B9297-7928-4440-9AAB-D1F8536FBF0A" = {
        # REF: https://github.com/acidanthera/HibernationFixup
        hbfx-dump-nvram = true;
        # EnableAutoHibernation = 1
        # WhenExternalPowerIsDisconnected = 4
        # WhenBatteryAtCriticalLevel = 32
        # RemainCapacityBit2 = 512 (2% Batter)
        # RemainCapacityBit4 = 2048 (8% Battery)
        # 2048 + 512 + 32 + 4 + 1 = 2597
        hbfx-ahbm = 2597;
      };
    };

    Delete = {
      "7C436110-AB2A-4BBB-A880-FE41995C9F82" = [
        "boot-args"
        "ForceDisplayRotationInEFI"
        "csr-active-config"
      ];
      "E09B9297-7928-4440-9AAB-D1F8536FBF0A" = [
        "hbfx-dump-nvram"
        "hbfx-ahbm"
      ];
    };
  };
}
