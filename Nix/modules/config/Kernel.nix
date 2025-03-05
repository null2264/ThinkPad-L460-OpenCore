{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.Kernel = {
    Add = {
      "Lilu.kext".Enabled = true;
      "AirportItlwm.kext".Enabled = true;
      "AppleALC.kext".Enabled = true;
      # Only needed for Monterey or newer.
      "AppleMCEReporterDisabler.kext" = {
        Enabled = true;
        MinKernel = "21.0.0";
      };
      # Only needed for Monterey or newer.
      # NOTE: You should disable this during update! It may break the update otherwise, even if RestrictEvents is enabled.
      "BlueToolFixup.kext" = {
        Enabled = true;
        MinKernel = "21.0.0";
      };
      "BrightnessKeys.kext".Enabled = true;
      "CPUFriend.kext".Enabled = true;
      "CPUFriendDataProvider.kext".Enabled = true;
      "CpuTscSync.kext".Enabled = true;  # Not sure if this kext is needed
      "CtlnaAHCIPort.kext" = {
        Enabled = true;
        MinKernel = "20.0.0";
      };
      "DebugEnhancer.kext".Enabled = true;
      "ECEnabler.kext".Enabled = true;
      "HibernationFixup.kext".Enabled = true;
      #"HoRNDIS.kext".Enabled = true;  # (Android) USB Tethering support
      "IntelBluetoothFirmware.kext".Enabled = true;
      # Not needed for Monterey or newer, BlueToolFixup is needed instead
      "IntelBluetoothInjector.kext" = {
        Enabled = true;
        MaxKernel = "20.99.9";
      };
      # Recommended by the docs, but apparently not actually required? REF: https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html#intelbtpatcher
      "IntelBTPatcher.kext".Enabled = true;
      "RestrictEvents.kext".Enabled = true;  # Prevent some issue caused by macOS events, especially for updates
      "SMCBatteryManager.kext".Enabled = true;
      "SMCProcessor.kext".Enabled = true;
      "USBToolBox.kext".Enabled = true;
      "UTBMap.kext".Enabled = true;
      "VirtualSMC.kext".Enabled = true;
      "VoltageShift.kext".Enabled = true;  # For undervolting
      "VoodooPS2Controller.kext".Enabled = true;
      "VoodooRMI.kext".Enabled = true;
      "VoodooRMI.kext/VoodooInput.kext".after = ["com.1Revenger1.VoodooRMI"];
      "VoodooRMI.kext/VoodooInput.kext".before = ["de.leo-labs.VoodooSMBus" "com.alexandred.VoodooI2C"];
      "VoodooSMBus.kext".Enabled = true;
      "WhateverGreen.kext".Enabled = true;
      "YogaSMC.kext".Enabled = true;  # ThinkPad hotkeys, battery settings, fan settings, etc.

      # Explicitly disable these kexts because "enable plugin recursively" is enabled
      "VoodooPS2Controller.kext/VoodooInput.kext".Enabled = false;  # We'll be using VoodooRMI's VoodooInput instead.
      "VoodooPS2Controller.kext/VoodooPS2Mouse.kext".Enabled = false;  # Probably useful? Not sure, will test it later
      "VoodooRMI.kext/RMII2C.kext".Enabled = false;  # L460 uses SMBus trackpad
    };

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

    # Just bunch of clean up
    Block = [];
    Force = [];
    Patch = [];
  };
}
