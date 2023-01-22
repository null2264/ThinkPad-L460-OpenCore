/* vim: ts=4 sw=4 et
 *
 * This SSDT mainly used to debug Qxx event(s)
 *
 * Config.plist -> ACPI -> Patch
 * Comment: _Qxx: _Q14 to XQ14
 * Find:    5F 51 31 34
 * Replace: 58 51 31 34
 */

DefinitionBlock ("", "SSDT", 2, "ZIRO", "DBGQXX", 0x00000000)
{
    External (_SB_.PCI0.LPC.EC, DeviceObj)

    External (_SB_.PCI0.LPC.EC.XQ14, MethodObj) // Brightness Up (FN+F6)

    Scope (\_SB.PCI0.LPC.EC)
    {
        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query
        {
            Debug = "_Qxx: Trigger _Q14"
            
            XQ14 ()
        }
    }
}
