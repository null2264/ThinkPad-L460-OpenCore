{ lib, pkgs, ... }:

with lib.oc.plist;

{
  oceanix.opencore.settings.DeviceProperties = {
    Add = {
      "PciRoot(0x0)/Pci(0x1F,0x3)" = {
        layout-id = mkData "HQAAAA==";
      };
      "PciRoot(0x0)/Pci(0x1b,0x0)" = {
        layout-id = mkData "AQAAAA==";
      };
      "PciRoot(0x0)/Pci(0x2,0x0)" = {
        # << Spoofing SKL to KBL
        # Fix glitches after spoofing SKL to KBL
        # REF: https://github.com/acidanthera/bugtracker/issues/2088#issuecomment-1381357651
        "AAPL,GfxYTile" = mkData "AQAAAA==";
        "AAPL,ig-platform-id" = mkData "AAAWWQ==";
        "device-id" = mkData "FlkAAA==";
        # >> Spoofing SKL to KBL

        framebuffer-con1-enable = mkData "AQAAAA==";
        framebuffer-con1-type = mkData "AAQAAA==";
        framebuffer-con2-enable = mkData "AQAAAA==";
        framebuffer-con2-type = mkData "AAQAAA==";
        framebuffer-fbmem = mkData "AACQAA==";
        framebuffer-patch-enable = mkData "AQAAAA==";
        framebuffer-stolenmem = mkData "AABAAQ==";
      };
    };

    Delete = {};
  };
}
