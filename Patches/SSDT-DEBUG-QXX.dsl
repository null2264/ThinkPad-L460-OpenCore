/* vim: ts=4 sw=4 et
 *
 * This SSDT mainly used to debug Qxx event(s)
 */
DefinitionBlock ("", "SSDT", 2, "ZIRO", "DBGQXX", 0x00000000)
{
    External (_SB_.PCI0.LPC_.EC__, DeviceObj)

    Scope (\_SB.PCI0.LPC.EC)
    {
        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (\_SB.PCI0.LPC.EC.HKEY.MHKK (0x8000))
            {
                \_SB.PCI0.LPC.EC.HKEY.MHKQ (0x1010)
                Debug = "_Q14: Trigger 0x1010"
            }

            If (\VIGD)
            {
                Notify (\_SB.PCI0.GFX0.DD1F, 0x86)
            }
        }
    }
}
