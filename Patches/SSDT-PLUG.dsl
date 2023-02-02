/* vim: ts=4 sw=4 et
 *
 * Power Management SSDT, technically a cleaned up version of SSDT-PLUG-DRTNIA
 */

DefinitionBlock ("", "SSDT", 2, "ZIRO", "PLUG", 0x00000000)
{
    // From SSDT-DARWIN.dsl
    External (DTGP, MethodObj) // 5 Arguments

    // L460's first 'Processor()' ACPI path
    External (_PR.CPU0, ProcessorObj)

    // Ref: https://github.com/khronokernel/DarwinDumped/blob/ed4ff5bb9abadde12d448a6da158ae556637efe2/MacBookPro/MacBookPro14%2C1/ACPI%20Tables/DSL/SSDT-10.dsl#L345~L367
    Scope (\_PR.CPU0)
    {
        Method (_DSM, 4, NotSerialized)
        {
            Debug = "PLUG: Writing plugin-type to Registry!"
            Local0 = Package (0x02)
                {
                    "plugin-type", 
                    One
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}
