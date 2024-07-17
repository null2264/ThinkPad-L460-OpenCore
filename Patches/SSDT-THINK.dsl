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

    External (LNUX, FieldUnitObj) // Variable set with "Linux" or "FreeBSD"
    External (WNTF, FieldUnitObj) // Variable set with "Windows 2001" or "Microsoft Windows NT"
    External (WIN8, FieldUnitObj) // Variable set with "Windows 8", "Windows 8.1", or "Windows 10"
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
                Debug = Concatenate ("INIT: Initial H8DR is: ", \H8DR)

                // Set OS type to Linux for mute LED workaround.
                // May be combined with MuteLEDFixup in prefpane.
                LNUX = One

                // Set OS type to Windows 2001
                WNTF = One

                // Set OS type to Windows 2015
                WIN8 = One
                OSYS = 0x07DF
                Debug = Concatenate ("INIT: OSYS is set to: ", \OSYS)

                // Set H8DR to One
                H8DR = One
                Debug = Concatenate ("INIT: H8DR is set to: ", \H8DR)
            }
        }
    }
}
