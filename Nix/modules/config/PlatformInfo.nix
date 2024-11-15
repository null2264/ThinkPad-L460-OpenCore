{ lib, pkgs, ... }:

let
  findValue = var: if builtins.pathExists ../../include/${var} then (builtins.readFile ../../include/${var}) else "";
  mlb = findValue "mlb";
  serialNumber = findValue "serialnumber";
  systemUUID = findValue "uuid";
in {
  oceanix.opencore.settings.PlatformInfo = {
    Generic.MLB = if mlb == "" then "M0000000000000001" else mlb;
    Generic.SystemSerialNumber = if serialNumber == "" then "W00000000001" else serialNumber;
    Generic.SystemUUID = if systemUUID == "" then "00000000-0000-0000-0000-000000000000" else systemUUID;
  };
}
