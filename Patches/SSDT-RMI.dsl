/* vim: ts=4 sw=4 et
 *
 * Config SSDT for VoodooRMI
 */

DefinitionBlock ("", "SSDT", 2, "GWYD", "RMI", 0)
{
    External (_SB.PCI0.SMBU, DeviceObj)

    Scope (\_SB.PCI0.SMBU)
    {
        Name (RCFG, Package()
        {
            "TrackpointMultiplier", 3,
        })
    }
}