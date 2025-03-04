{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.Kernel = {
    Add = {
      "Lilu.kext".Enabled = true;
      "AirportItlwm.kext".Enabled = true;
      "AppleALC.kext".Enabled = true;
      "BrightnessKeys.kext".Enabled = true;
      "ECEnabler.kext".Enabled = true;
      "IntelBluetoothFirmware.kext".Enabled = true;
      "IntelBluetoothInjector.kext".Enabled = true;
      "IntelBluetoothInjector.kext".MaxKernel = "20.99.9";  # Not needed for Monterey or newer, BlueToolFixup is needed instead
      "IntelBTPatcher.kext".Enabled = true;
      "SMCBatteryManager.kext".Enabled = true;
      "SMCProcessor.kext".Enabled = true;
      "USBToolBox.kext".Enabled = true;
      "USBToolBox.kext/UTBMap.kext".Enabled = true;
      "VirtualSMC.kext".Enabled = true;
      "VoodooPS2Controller.kext".Enabled = true;
      "VoodooPS2Controller.kext/VoodooPS2Keyboard.kext".Enabled = true;
      "VoodooPS2Controller.kext/VoodooPS2Trackpad.kext".Enabled = true;
      "VoodooRMI.kext".Enabled = true;
      "VoodooRMI.kext/VoodooInput.kext".Enabled = true;
      "VoodooSMBus.kext".Enabled = true;
      "VoodooRMI.kext/RMISMBus.kext".Enabled = true;
      "WhateverGreen.kext".Enabled = true;
    };
    # Just bunch of clean up
    Block = [];
    Force = [];
    Patch = [];

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
