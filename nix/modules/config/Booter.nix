{ lib, pkgs, ... }:

{
  oceanix.opencore.settings.Booter = {
    MmioWhitelist = [];
    Patch = [];

    Quirks = {
      FixupAppleEfiImages = false;
    };
  };
}
