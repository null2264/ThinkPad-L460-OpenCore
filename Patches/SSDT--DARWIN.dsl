/* vim: ts=4 sw=4 et
 *
 * Helper SSDT, implements native Mac stuff. Should be loaded first!
 */

DefinitionBlock ("", "SSDT", 2, "ZIRO", "_DW", 0x00000000)
{
    Scope (\)
    {
        // Ref: https://github.com/khronokernel/DarwinDumped/blob/ed4ff5bb9abadde12d448a6da158ae556637efe2/MacBookPro/MacBookPro14%2C1/ACPI%20Tables/DSL/SSDT-10.dsl#L316~L343
        Method (DTGP, 5, NotSerialized)
        {
            If (Arg2 == Zero)
            {
                Arg4 = Buffer (One)
                    {
                         0x03                                             // .
                    }
                Return (One)
            }

            Return (One)
        }

        Method (OSDW, 0, NotSerialized)
        {
            If (CondRefOf (\_OSI))
            {
                If (_OSI ("Darwin"))
                {
                    Return (One) // is Darwin
                }
            }
            Return (Zero)
        }
    }
}
