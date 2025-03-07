{ lib, pkgs, ... }:

with lib.oc.plist;

let
  # NOTE: Use GenSMBIOS to get values for MLB, Serial Number and UUID
  findValue = var: if builtins.pathExists ../../include/${var} then (builtins.readFile ../../include/${var}) else "";
  mlb = findValue "mlb";
  serialNumber = findValue "serialnumber";
  systemUUID = findValue "uuid";
in {
  oceanix.opencore.settings.PlatformInfo = {
    Generic = {
      MLB = if mlb == "" then "M0000000000000001" else mlb;
      SystemSerialNumber = if serialNumber == "" then "W00000000001" else serialNumber;
      SystemUUID = if systemUUID == "" then "00000000-0000-0000-0000-000000000000" else systemUUID;
      ROM = mkData "VOGtP43i";  # NOTE: Recommended to be changed to your own MAC Address
      # Change this to MacBookPro16,3 for Sonoma support
      SystemProductName = "MacBookPro14,2";
    };
  };
}
