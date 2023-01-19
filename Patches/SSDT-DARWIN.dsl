/* vim: ts=4 sw=4 et
 *
 * Helper SSDT
 */
DefinitionBlock ("", "SSDT", 2, "ZIRO", "_DW", 0x00000000)
{
    Scope (\)
    {
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
