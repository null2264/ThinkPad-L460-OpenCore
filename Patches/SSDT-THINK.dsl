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
    External (OSDW, MethodObj) // 0 Arguments
    External (_SB_.XINI, MethodObj) // 0 Arguments

    External (HPTE, FieldUnitObj)
    External (LNUX, FieldUnitObj) // Variable set with "Linux" or "FreeBSD"
    External (WNTF, FieldUnitObj) // Variable set with "Windows 2001" or "Microsoft Windows NT"
    External (OSYS, FieldUnitObj)
    External (H8DR, FieldUnitObj)

    Scope (\_SB)
    {
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            XINI ()
            If (OSDW ())
            {
                Debug = "INIT: Entering _INI"
                Debug = Concatenate ("INIT: Initial OSYS is: ", \OSYS)

                // Disable HPTE, not needed for most modern systems
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
                Debug = "INIT: Force set H8DR to 0x01"
            }
        }
    }
}
