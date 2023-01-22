/* vim: ts=4 sw=4 et
 *
 * SMBus compatibility table.
 */

DefinitionBlock ("", "SSDT", 2, "ACDT", "MCHCSBUS", 0x00000000)
{
    // From SSDT-DARWIN.dsl
    External (OSDW, MethodObj) // 0 Arguments

    External (\_SB.PCI0, DeviceObj)
    External (\_SB.PCI0.SMBU, DeviceObj)

    Scope (\_SB.PCI0)
    {
        // Ref: https://github.com/khronokernel/DarwinDumped/blob/ed4ff5b/MacBookPro/MacBookPro13%2C3/ACPI%20Tables/DSL/DSDT.dsl#L2625~L2628
        Device (MCHC)
        {
            Name (_ADR, Zero)  // _ADR: Address
 
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }

    Device (\_SB.PCI0.SMBU)
    {
        // Ref: https://github.com/khronokernel/DarwinDumped/blob/ed4ff5b/MacBookPro/MacBookPro13%2C3/ACPI%20Tables/DSL/DSDT.dsl#L6327~L6337
        Device (BUS0) {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }

        Device (BUS1) {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, One)  // _ADR: Address

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }
}
