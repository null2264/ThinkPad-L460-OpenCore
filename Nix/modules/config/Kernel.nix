{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.Kernel = {
    # Just bunch of clean up
    Block = [];
    Force = [];
    Patch = {};

    # REF: https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#quirks-3
    Quirks = {
      AppleXcpmCfgLock = true;  # Required because we can't disable CFG-Lock from BIOS
      DisableIoMapper = true;  # Required because we can't disable VT-D from BIOS
      DisableIoMapperMapping = true;  # Required for macOS 12 or lower
      PanicNoKextDump = true;
      PowerTimeoutKernelPanic = true;
      # NOTE: Enable if you're planning to run macOS 10.x
      XhciPortLimit = false;
    };
  };
}
