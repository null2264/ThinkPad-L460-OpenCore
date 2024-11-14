/* vim: ts=4 sw=4 et
 *
 * Adding PNLF device for WhateverGreen.kext and others.
 *
 * Generated using SSDTTime (https://github.com/corpnewt/SSDTTime)
 */

DefinitionBlock ("", "SSDT", 2, "CORP", "PNLF", 0x00000000)
{
    // From SSDT-DARWIN.dsl
    External (OSDW, MethodObj) // 0 Arguments

    External (\_SB.PCI0.GFX0, DeviceObj)

    If (OSDW ())
    {
        Device (\_SB.PCI0.GFX0.PNLF)
        {
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID
            Name (_UID, 0x10)  // _UID: Unique ID
            Name (_STA, 0x0B)  // _STA: Status
        }
    }
}
