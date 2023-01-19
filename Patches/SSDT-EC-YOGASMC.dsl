/* vim: ts=4 sw=4 et
 *
 * EC Patch for YogaSMC, not to be confused with EC Patch by Dortania
 */
DefinitionBlock ("", "SSDT", 2, "THKP", "YGEC", 0x00000000)
{
    External (_SB_.PCI0.LPC.EC, DeviceObj)
    External (_SB_.PCI0.LPC.EC.BAT0, DeviceObj)

    /*
     * Check for conflict if you have patched battery reading
     * Taken from RehabMan's battery patch guide:
     * https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/
     */
    Scope (_SB.PCI0.LPC.EC)
    {
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE)
        }

        Method (RECB, 2, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1) {})
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }

            Return (TEMP)
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1) {})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }
    }
}

