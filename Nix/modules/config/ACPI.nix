{ lib, pkgs, ... }:

with lib.oc.plist;

let
  mkPatch =
    {
      Comment,
      Find,
      Replace,

      Base ? "",
      BaseSkip ? 0,
      Count ? 0,
      Enabled ? false,
      Limit ? 0,
      Mask ? mkData "",
      OemTableId ? mkData "",
      ReplaceMask ? mkData "",
      Skip ? 0,
      TableLength ? 0,
      TableSignature ? mkData "",
    }: { inherit Base BaseSkip Comment Count Enabled Find Limit Mask OemTableId Replace ReplaceMask Skip TableLength TableSignature; };
in {
  oceanix.opencore.settings.ACPI = {
    Add = {
      "SSDT-DARWIN.aml".Priority = 0;  # This patch should always be loaded first!
    };

    Delete = [];

    Patch = [
      (mkPatch {
        Enabled = true;
        Comment = "Change EC.HWAK to EC.XWAK";
        Find = mkData "RUNfX0hXQUs=";
        Replace = mkData "RUNfX1hXQUs=";
      })
      (mkPatch {
        Enabled = true;
        Comment = "Change _PTS to ZPTS";
        Find = mkData "X1BUUwE=";
        Replace = mkData "WlBUUwE=";
      })
      (mkPatch {
        Enabled = true;
        Comment = "Change _WAK to ZWAK";
        Find = mkData "X1dBSwE=";
        Replace = mkData "WldBSwE=";
      })
      (mkPatch {
        Enabled = true;
        Comment = "INIT: _INI to XINI in \\_SB";
        Find = mkData "X0lOSQ==";
        Replace = mkData "WElOSQ==";
        Count = 1;
      })
      (mkPatch {
        Enabled = true;
        Comment = "BATX: Nofify(BAT0, xx) to BATX";
        Find = mkData "hkJBVDA=";
        Replace = mkData "hkJBVFg=";
        TableSignature = mkData "RFNEVA==";
      })
      (mkPatch {
        Enabled = true;
        Comment = "BATX: Nofify(BAT1, xx) to BATX";
        Find = mkData "hkJBVDE=";
        Replace = mkData "hkJBVFg=";
        TableSignature = mkData "RFNEVA==";
      })
    ];
  };
}
