{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.UEFI = {
    # Load APFS driver on pre-BigSur macOS
    # REF: https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#apfs
    APFS = {
      MinDate = 20200306;
      MinVersion = 1412101001000000;
    };

    Audio = {
      AudioDevice = "PciRoot(0x0)/Pci(0x1F,0x3)";
      AudioOutMask = 5;
      AudioSupport = true;
      MinimumAudibleGain = -30;
      PlayChime = "Enabled";
    };

    ProtocolOverrides = {
      # TODO: Not sure why this is true on my Config.plist, ngl... I'm probably thinking of turning on FileVault but decided not to... but never disabled it
      HashServices = true;
    };

    Quirks = {
      ReleaseUsbOwnership = true;
    };

    ReservedMemory = [];  # Unused
  };
}
