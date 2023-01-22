/* vim: ts=4 sw=4 et
 *
 * Patch INIT
 *
 * Config.plist -> ACPI -> Patch
 * Comment: INIT: _INI to XINI in \_SB
 * Count:   1
 * Find:    5F 49 4E 49 08
 * Replace: 58 49 4E 49 08
 */

DefinitionBlock ("", "SSDT", 2, "ZIRO", "THKP", 0x00000000)
{
    // External method from SSDT-DARWIN.dsl
    External (DTGP, MethodObj) // 5 Arguments
    External (OSDW, MethodObj) // 0 Arguments

    External (_SB_.XINI, MethodObj) // 0 Arguments

    External (HPTE, FieldUnitObj)
    External (LNUX, FieldUnitObj) // Variable set with "Linux" or "FreeBSD"
    External (WNTF, FieldUnitObj) // Variable set with "Windows 2001" or "Microsoft Windows NT"
    External (OSYS, FieldUnitObj)
    External (H8DR, FieldUnitObj)

    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package (0x08)
                {
                    "kUSBSleepPowerSupply",
                    0x13EC,
                    "kUSBSleepPortCurrentLimit",
                    0x0834,
                    "kUSBWakePowerSupply",
                    0x13EC,
                    "kUSBWakePortCurrentLimit",
                    0x0834
                }
                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }

        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            XINI ()
            If (OSDW ())
            {
                Debug = "INIT: Entering _INI"
                Debug = Concatenate ("INIT: Initial OSYS is: ", \OSYS)

                // Disable HPET, not needed for most modern systems
                HPTE = Zero

                // Mute LED workaround, judging from my DSDT... doesn't seem to be useful, need further testing
                LNUX = One

                // Make the laptop think it's in Windows
                WNTF = One

                // Set OSYS to use Windows 2015's value
                OSYS = 0x07DF
                Debug = Concatenate ("INIT: OSYS is set to: ", \OSYS)

                // [TEST NEEDED] FN-key fixed for E14-15, maybe it'll work for L460 too?
                H8DR = One
                Debug = Concatenate ("INIT: H8DR is set to: ", \H8DR)
            }
        }
    }
}
