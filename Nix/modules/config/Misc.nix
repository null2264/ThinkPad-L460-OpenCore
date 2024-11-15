{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.Misc = {
    # REF: https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#misc
    Boot = {
      # << Cosmetic
      PickerMode = "External";
      PickerVariant = "Acidanthera\\GoldenGate";
      # >> Cosmetic
      HideAuxiliary = true;  # Press space to show
    };

    Debug = {
      AppleDebug = false;
      ApplePanic = true;
      DisableWatchDog = true;
      # REF: https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/debug.html
      Target = 3;  # NOTE: Change to 67 for debugging
    };

    Security = {
      # Allow `CTRL+Enter` and `CTRL+Index` to set default boot device in the picker
      AllowSetDefault = true;
      BlacklistAppleUpdate = true;
      ScanPolicy = 0;
      SecureBootModel = "j223";  # NOTE: Set to 'disabled' if there's a problem when booting macOS
      Vault = "Optional";
    };

    # Unused
    # REF: https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf
    Entries = [];
  };
}
